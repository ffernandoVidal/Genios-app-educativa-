using System.Security.Cryptography;
using System.Text;
using System.Text.Json;
using GENIOS.Application.Comun;
using GENIOS.Application.Partidas;
using GENIOS.Application.Tiempo;
using GENIOS.Domain.Exceptions;
using GENIOS.Domain.Rules;
using GENIOS.Infrastructure.Persistence;
using GENIOS.Infrastructure.Persistence.Context;
using GENIOS.Infrastructure.Persistence.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Storage;
using Microsoft.Extensions.Options;

namespace GENIOS.Infrastructure.Juego;

public class ServicioPartidas(
    GeniosDbContext bd,
    IServicioTiempo tiempo,
    GeneradorPreguntas generador,
    IOptions<OpcionesJuego> opciones) : IServicioPartidas
{
    private static readonly JsonSerializerOptions Json = new(JsonSerializerDefaults.Web);
    private readonly OpcionesJuego _opciones = opciones.Value;

    // Estado interno de la partida, guardado en partidas.metadatos.
    private record MetadatosPartida(DateTime UltimaActividadEn, DateTime? MechaVenceEn);
    private record OpcionPresentada(Guid Id, string Texto);
    private record ClaveCorrecta(Guid OpcionId);

    // ---------------------------------------------------------------- Crear y consultar

    public async Task<PartidaDto> CrearAsync(Propietario propietario, SolicitudCrearPartida solicitud, CancellationToken ct)
    {
        if (solicitud.ClaveOperacion is { } clave)
        {
            var existente = await bd.Partidas.AsNoTracking().SingleOrDefaultAsync(p => p.ClaveIdempotencia == clave, ct);
            if (existente is not null)
            {
                if (!existente.EsDe(propietario)) throw ClaveEnUso();
                return await ObtenerAsync(propietario, existente.Id, ct);
            }
        }

        // El límite diario aplica a estudiantes con cuenta; la sesión de invitado no tiene tiempo registrado.
        if (propietario.UsuarioId is { } usuarioId)
        {
            var actividad = await tiempo.RegistrarActividadAsync(usuarioId, ct);
            if (actividad.LimiteAlcanzado) throw LimiteAgotado();
        }

        var categoria = await bd.Categorias.AsNoTracking()
            .SingleOrDefaultAsync(c => c.Id == solicitud.CategoriaId && c.Activa, ct)
            ?? throw Error(TipoError.NoEncontrado, "categoria_no_encontrada", "No se encontró la categoría.");
        await ExigirCategoriaDisponibleAsync(propietario, categoria, ct);

        var ahora = DateTime.UtcNow;
        await using var transaccion = await bd.Database.BeginTransactionAsync(ct);

        // Solo hay una partida en curso por jugador: iniciar otra abandona la anterior.
        await bd.Partidas.DelPropietario(propietario).Where(p => p.Estado == "en_curso")
            .ExecuteUpdateAsync(s => s.SetProperty(p => p.Estado, "abandonada")
                .SetProperty(p => p.MotivoFinalizacion, "reemplazada").SetProperty(p => p.FinalizadaEn, ahora), ct);

        var partida = new Partidas
        {
            Id = Guid.NewGuid(),
            UsuarioId = propietario.UsuarioId,
            SesionInvitadoId = propietario.SesionInvitadoId,
            CategoriaId = categoria.Id,
            Origen = "aplicacion",
            Estado = "en_curso",
            CantidadPreguntasPlanificada = ReglasJuego.PreguntasPorPartida,
            ClaveIdempotencia = solicitud.ClaveOperacion,
            IniciadaEn = ahora,
            Metadatos = Serializar(new MetadatosPartida(ahora, null))
        };
        bd.Partidas.Add(partida);
        foreach (var (pregunta, claveCorrecta) in await generador.CrearAsync(partida.Id, categoria.Id, ReglasJuego.PreguntasPorPartida, ct))
        {
            bd.PreguntasPartida.Add(pregunta);
            bd.RespuestasCorrectasPartida.Add(claveCorrecta);
        }
        bd.EventosPartida.Add(Evento(partida.Id, "partida_creada", new { categoriaId = categoria.Id }));

        try
        {
            await bd.SaveChangesAsync(ct);
            await transaccion.CommitAsync(ct);
        }
        catch (DbUpdateException e) when (e.EsViolacionUnica() && solicitud.ClaveOperacion is not null)
        {
            throw ClaveEnUso(); // dos solicitudes simultáneas con la misma clave
        }
        return await ObtenerAsync(propietario, partida.Id, ct);
    }

    /// <summary>Una categoría solo se puede jugar si la anterior de su nivel ya tiene una partida completada.</summary>
    private async Task ExigirCategoriaDisponibleAsync(Propietario propietario, Categorias categoria, CancellationToken ct)
    {
        var anteriorId = await bd.Categorias.AsNoTracking()
            .Where(c => c.NivelEducativoId == categoria.NivelEducativoId && c.Activa && c.NumeroOrden < categoria.NumeroOrden)
            .OrderByDescending(c => c.NumeroOrden).Select(c => (long?)c.Id).FirstOrDefaultAsync(ct);
        if (anteriorId is null) return;

        var completada = await bd.Partidas.AsNoTracking().DelPropietario(propietario)
            .AnyAsync(p => p.CategoriaId == anteriorId && p.Estado == "completada", ct);
        if (!completada)
            throw Error(TipoError.Prohibido, "categoria_bloqueada", "Completa la categoría anterior para desbloquear esta.");
    }

    public async Task<PartidaDto> ObtenerAsync(Propietario propietario, Guid partidaId, CancellationToken ct)
    {
        var partida = await CargarPropiaAsync(propietario, partidaId, ct);
        if (Vencimiento(partida, DateTime.UtcNow) is not null) await bd.SaveChangesAsync(ct);
        return await ConstruirPartidaAsync(partida, ct);
    }

    public async Task<PreguntaDto> ObtenerPreguntaActualAsync(Propietario propietario, Guid partidaId, CancellationToken ct)
    {
        var partida = await ObtenerAsync(propietario, partidaId, ct);
        return partida.Pregunta
            ?? throw Error(TipoError.Conflicto, "partida_no_activa", "La partida ya no está en curso.");
    }

    // ---------------------------------------------------------------- Responder

    public async Task<RespuestaDto> ResponderAsync(Propietario propietario, Guid partidaId, SolicitudResponder solicitud, CancellationToken ct)
    {
        await using var transaccion = await bd.Database.BeginTransactionAsync(ct);
        var partida = await BloquearAsync(partidaId, propietario, ct);

        // Una operación repetida devuelve lo registrado la primera vez, sin sumar nada.
        var previo = await bd.IntentosRespuesta.Include(i => i.PreguntaPartida)
            .SingleOrDefaultAsync(i => i.ClaveIdempotencia == solicitud.ClaveOperacion, ct);
        if (previo is not null)
        {
            if (previo.PreguntaPartida.PartidaId != partidaId) throw ClaveEnUso();
            return ConstruirRespuesta(partida, previo.EsCorrecta, previo.NumeroIntento, previo.PuntosOtorgados);
        }

        var ahora = DateTime.UtcNow;
        var actividad = await ExigirActivaAsync(partida, transaccion, ahora, ct);

        var preguntas = await bd.PreguntasPartida
            .Include(q => q.IntentosRespuesta).Include(q => q.RespuestasCorrectasPartida)
            .Where(q => q.PartidaId == partidaId).OrderBy(q => q.Posicion).ToListAsync(ct);
        var actual = preguntas.FirstOrDefault(q => !Resuelta(q))
            ?? throw Error(TipoError.Conflicto, "partida_no_activa", "La partida ya no está en curso.");

        if (actual.Id != solicitud.PreguntaPresentadaId)
            throw Error(TipoError.Conflicto, "pregunta_no_vigente", "Esa no es la pregunta actual.");
        if (!Leer<List<OpcionPresentada>>(actual.OpcionesInstantanea).Any(o => o.Id == solicitud.OpcionSeleccionadaId))
            throw Error(TipoError.Validacion, "opcion_invalida", "La opción no pertenece a la pregunta.");

        // La evaluación se hace aquí con la clave guardada en el servidor; el cliente nunca informa si acertó.
        var esCorrecta = Leer<ClaveCorrecta>(actual.RespuestasCorrectasPartida!.RespuestaCorrecta).OpcionId == solicitud.OpcionSeleccionadaId;
        var metadatos = Leer<MetadatosPartida>(partida.Metadatos);
        var numeroIntento = actual.IntentosRespuesta.Count + 1;
        var incorrectosPrevios = actual.IntentosRespuesta.Count(i => !i.EsCorrecta);
        var otrasResueltas = preguntas.All(q => q.Id == actual.Id || Resuelta(q));

        var intento = new IntentosRespuesta
        {
            Id = Guid.NewGuid(),
            PreguntaPartidaId = actual.Id,
            NumeroIntento = (short)numeroIntento,
            RespuestaUsuario = Serializar(new { opcionId = solicitud.OpcionSeleccionadaId }),
            EsCorrecta = esCorrecta,
            TiempoRespuestaMs = (int)Math.Clamp((ahora - metadatos.UltimaActividadEn).TotalMilliseconds, 0, int.MaxValue),
            IniciadaEn = metadatos.UltimaActividadEn < ahora ? metadatos.UltimaActividadEn : ahora,
            RespondidaEn = ahora,
            ClaveIdempotencia = solicitud.ClaveOperacion
        };

        // Solo el primer intento cuenta para el porcentaje de aciertos.
        if (numeroIntento == 1)
        {
            actual.PrimeraRespuestaCorrecta = esCorrecta;
            actual.EvaluadaEn = ahora;
            partida.CantidadPreguntasEvaluadas++;
            if (esCorrecta) partida.AciertosPrimerIntento++;
        }

        var mecha = metadatos.MechaVenceEn;
        if (esCorrecta)
        {
            intento.PuntosOtorgados = ReglasJuego.PuntosPorRespuesta(actual.Dificultad);
            partida.PuntosObtenidos += intento.PuntosOtorgados;
            mecha = null;
            // La clave de idempotencia es el id del intento: una respuesta no puede puntuar dos veces.
            // Los puntos de cuenta solo existen para estudiantes registrados.
            if (partida.UsuarioId is { } usuarioId)
                bd.TransaccionesPuntos.Add(new TransaccionesPuntos
                {
                    Id = Guid.NewGuid(), UsuarioId = usuarioId, PartidaId = partidaId, TipoTransaccion = "respuesta_correcta",
                    Puntos = intento.PuntosOtorgados, Motivo = "Respuesta correcta", ClaveIdempotencia = intento.Id
                });
        }
        else if (incorrectosPrevios + 1 >= ReglasJuego.ErroresParaMecha && mecha is null)
        {
            mecha = ahora.AddSeconds(_opciones.SegundosMecha);
            bd.EventosPartida.Add(Evento(partidaId, "mecha_activada", new { posicion = actual.Posicion, venceEn = mecha }));
        }

        bd.IntentosRespuesta.Add(intento);
        partida.TiempoActivoMs += actividad.DeltaMs;

        var completa = esCorrecta && otrasResueltas;
        if (completa)
        {
            await CompletarAsync(partida, ahora, ct);
            mecha = null;
        }
        partida.Metadatos = Serializar(new MetadatosPartida(ahora, mecha));

        await bd.SaveChangesAsync(ct);
        await transaccion.CommitAsync(ct);
        return ConstruirRespuesta(partida, esCorrecta, numeroIntento, intento.PuntosOtorgados);
    }

    /// <summary>Cierra la partida. A estudiantes con cuenta les aplica el bono de categoría (una sola vez) y el progreso.</summary>
    private async Task CompletarAsync(Partidas partida, DateTime ahora, CancellationToken ct)
    {
        partida.Estado = "completada";
        partida.MotivoFinalizacion = "completada";
        partida.FinalizadaEn = ahora;
        partida.EsPartidaValida = true;

        if (partida.UsuarioId is { } usuarioId)
        {
            var claveBono = GuidDeterminista($"bono_categoria:{usuarioId}:{partida.CategoriaId}");

            // La clave es la misma para siempre: si ya se pagó el bono de esta categoría, no se inserta otra vez.
            var insertadas = await bd.Database.ExecuteSqlInterpolatedAsync($@"
                INSERT INTO transacciones_puntos (usuario_id, partida_id, tipo_transaccion, puntos, motivo, clave_idempotencia)
                VALUES ({usuarioId}, {partida.Id}, 'bono_categoria', {ReglasJuego.PuntosBonoCategoria}, 'Categoría completada', {claveBono})
                ON CONFLICT (clave_idempotencia) DO NOTHING", ct);
            if (insertadas == 1) partida.PuntosObtenidos += ReglasJuego.PuntosBonoCategoria;

            await bd.Database.ExecuteSqlInterpolatedAsync($@"
                INSERT INTO progreso_estudiante (usuario_id, categoria_id, partidas_completadas, preguntas_evaluadas, aciertos_primer_intento, puntos_totales, ultima_actividad_en)
                VALUES ({usuarioId}, {partida.CategoriaId}, 1, {(int)partida.CantidadPreguntasEvaluadas}, {(int)partida.AciertosPrimerIntento}, {partida.PuntosObtenidos}, {ahora})
                ON CONFLICT (usuario_id, categoria_id) DO UPDATE SET
                    partidas_completadas = progreso_estudiante.partidas_completadas + 1,
                    preguntas_evaluadas = progreso_estudiante.preguntas_evaluadas + EXCLUDED.preguntas_evaluadas,
                    aciertos_primer_intento = progreso_estudiante.aciertos_primer_intento + EXCLUDED.aciertos_primer_intento,
                    puntos_totales = progreso_estudiante.puntos_totales + EXCLUDED.puntos_totales,
                    ultima_actividad_en = EXCLUDED.ultima_actividad_en,
                    actualizado_en = NOW()", ct);
        }
        bd.EventosPartida.Add(Evento(partida.Id, "partida_completada", new { puntos = partida.PuntosObtenidos }));
    }

    // ---------------------------------------------------------------- Reanudar, finalizar, abandonar, resultado

    public async Task<PartidaDto> ReanudarAsync(Propietario propietario, Guid partidaId, CancellationToken ct)
    {
        await using var transaccion = await bd.Database.BeginTransactionAsync(ct);
        var partida = await BloquearAsync(partidaId, propietario, ct);
        var ahora = DateTime.UtcNow;

        var actividad = await ExigirActivaAsync(partida, transaccion, ahora, ct);
        var metadatos = Leer<MetadatosPartida>(partida.Metadatos);
        partida.TiempoActivoMs += actividad.DeltaMs;
        partida.Metadatos = Serializar(metadatos with { UltimaActividadEn = ahora });
        bd.EventosPartida.Add(Evento(partidaId, "partida_reanudada", new { }));

        await bd.SaveChangesAsync(ct);
        await transaccion.CommitAsync(ct);
        return await ConstruirPartidaAsync(partida, ct);
    }

    public async Task<ResultadoPartidaDto> FinalizarAsync(Propietario propietario, Guid partidaId, CancellationToken ct)
    {
        var partida = await CargarPropiaAsync(propietario, partidaId, ct);
        if (Vencimiento(partida, DateTime.UtcNow) is not null) await bd.SaveChangesAsync(ct);
        if (partida.Estado == "en_curso")
            throw Error(TipoError.Conflicto, "partida_incompleta", "Aún hay preguntas sin resolver.");
        return ConstruirResultado(partida);
    }

    public async Task AbandonarAsync(Propietario propietario, Guid partidaId, CancellationToken ct)
    {
        await using var transaccion = await bd.Database.BeginTransactionAsync(ct);
        var partida = await BloquearAsync(partidaId, propietario, ct);
        if (partida.Estado == "en_curso")
        {
            Cerrar(partida, "abandonada", "abandono_usuario", DateTime.UtcNow);
            await bd.SaveChangesAsync(ct);
        }
        await transaccion.CommitAsync(ct);
    }

    public async Task<ResultadoPartidaDto> ObtenerResultadoAsync(Propietario propietario, Guid partidaId, CancellationToken ct)
    {
        var partida = await CargarPropiaAsync(propietario, partidaId, ct);
        if (Vencimiento(partida, DateTime.UtcNow) is not null) await bd.SaveChangesAsync(ct);
        if (partida.Estado == "en_curso")
            throw Error(TipoError.Conflicto, "partida_en_curso", "La partida todavía está en curso.");
        return ConstruirResultado(partida);
    }

    // ---------------------------------------------------------------- Reglas de estado

    /// <summary>
    /// Exige que la partida siga en curso. Si la mecha venció, se pasó la ventana de reanudación o se agotó
    /// el tiempo diario, la partida se cierra aquí y se rechaza la operación. Registra la actividad del día.
    /// </summary>
    private async Task<ActividadRegistrada> ExigirActivaAsync(Partidas partida, IDbContextTransaction transaccion, DateTime ahora, CancellationToken ct)
    {
        if (partida.Estado != "en_curso")
            throw partida.Estado == "tiempo_agotado" ? MechaAgotada() : Error(TipoError.Conflicto, "partida_no_activa", "La partida ya no está en curso.");

        var vencimiento = Vencimiento(partida, ahora);
        if (vencimiento is not null)
        {
            await bd.SaveChangesAsync(ct);
            await transaccion.CommitAsync(ct);
            throw vencimiento;
        }

        if (partida.UsuarioId is not { } usuarioId)
        {
            // Invitado: sin límite diario; el tiempo activo de la partida sigue el mismo tope por inactividad.
            var ultima = Leer<MetadatosPartida>(partida.Metadatos).UltimaActividadEn;
            var delta = (long)Math.Clamp((ahora - ultima).TotalMilliseconds, 0, _opciones.UmbralInactividadSegundos * 1000L);
            return new ActividadRegistrada(delta, 0, long.MaxValue);
        }

        var actividad = await tiempo.RegistrarActividadAsync(usuarioId, ct);
        if (actividad.LimiteAlcanzado)
        {
            // Los 10 minutos de reanudación no amplían el límite diario: sin tiempo, la partida en curso termina.
            Cerrar(partida, "abandonada", "limite_diario", ahora);
            await bd.SaveChangesAsync(ct);
            await transaccion.CommitAsync(ct);
            throw LimiteAgotado();
        }
        return actividad;
    }

    /// <summary>Cierra la partida si su mecha venció o pasó la ventana de reanudación. Devuelve el error a informar.</summary>
    private ExcepcionNegocio? Vencimiento(Partidas partida, DateTime ahora)
    {
        if (partida.Estado != "en_curso") return null;
        var metadatos = Leer<MetadatosPartida>(partida.Metadatos);

        if (metadatos.MechaVenceEn is { } vence && ahora > vence)
        {
            Cerrar(partida, "tiempo_agotado", "mecha", vence);
            return MechaAgotada();
        }
        if (ahora - metadatos.UltimaActividadEn > TimeSpan.FromMinutes(_opciones.VentanaReanudacionMinutos))
        {
            Cerrar(partida, "abandonada", "ventana_vencida", ahora);
            return Error(TipoError.Conflicto, "ventana_reanudacion_vencida", "Pasó demasiado tiempo y la partida ya no se puede reanudar.");
        }
        return null;
    }

    private void Cerrar(Partidas partida, string estado, string motivo, DateTime cuando)
    {
        partida.Estado = estado;
        partida.MotivoFinalizacion = motivo;
        partida.FinalizadaEn = cuando;
        bd.EventosPartida.Add(Evento(partida.Id, "partida_cerrada", new { estado, motivo }));
    }

    // ---------------------------------------------------------------- Apoyo

    private async Task<Partidas> CargarPropiaAsync(Propietario propietario, Guid partidaId, CancellationToken ct) =>
        await bd.Partidas.DelPropietario(propietario).SingleOrDefaultAsync(p => p.Id == partidaId, ct)
        ?? throw PartidaNoEncontrada();

    /// <summary>Bloquea la fila de la partida hasta terminar la transacción: las respuestas de una partida se procesan una a la vez.</summary>
    private async Task<Partidas> BloquearAsync(Guid partidaId, Propietario propietario, CancellationToken ct)
    {
        var filas = await bd.Partidas.FromSqlInterpolated($"SELECT * FROM partidas WHERE id = {partidaId} FOR UPDATE").ToListAsync(ct);
        var partida = filas.SingleOrDefault();
        if (partida is null || !partida.EsDe(propietario)) throw PartidaNoEncontrada();
        return partida;
    }

    private async Task<PartidaDto> ConstruirPartidaAsync(Partidas partida, CancellationToken ct)
    {
        var preguntas = await bd.PreguntasPartida.AsNoTracking().Include(q => q.IntentosRespuesta)
            .Where(q => q.PartidaId == partida.Id).OrderBy(q => q.Posicion).ToListAsync(ct);
        var actual = preguntas.FirstOrDefault(q => !Resuelta(q));
        var enCurso = partida.Estado == "en_curso";

        PreguntaDto? pregunta = null;
        if (enCurso && actual is not null)
        {
            var opciones = Leer<List<OpcionPresentada>>(actual.OpcionesInstantanea).Select(o => new OpcionDto(o.Id, o.Texto)).ToList();
            pregunta = new PreguntaDto(actual.Id, actual.EnunciadoInstantanea, "opcion_multiple", opciones);
        }
        return new PartidaDto(partida.Id, partida.Estado, partida.CategoriaId, actual?.Posicion ?? preguntas.Count,
            preguntas.Count, pregunta, SegundosMecha(partida));
    }

    private RespuestaDto ConstruirRespuesta(Partidas partida, bool esCorrecta, int numeroIntento, int puntos)
    {
        var accion = !esCorrecta ? "reintentar" : partida.Estado == "completada" ? "partida_completada" : "siguiente_pregunta";
        return new RespuestaDto(esCorrecta, numeroIntento, !esCorrecta, accion, puntos, SegundosMecha(partida));
    }

    private static ResultadoPartidaDto ConstruirResultado(Partidas p) => new(
        p.Id, p.Estado, p.CantidadPreguntasEvaluadas, p.AciertosPrimerIntento,
        ReglasJuego.PorcentajeAciertos(p.AciertosPrimerIntento, p.CantidadPreguntasEvaluadas),
        p.PuntosObtenidos, (int)(p.TiempoActivoMs / 1000), p.EsPartidaValida, p.Estado == "completada", p.MotivoFinalizacion);

    private int? SegundosMecha(Partidas partida)
    {
        if (partida.Estado != "en_curso" || Leer<MetadatosPartida>(partida.Metadatos).MechaVenceEn is not { } vence) return null;
        return Math.Max(0, (int)Math.Ceiling((vence - DateTime.UtcNow).TotalSeconds));
    }

    private static bool Resuelta(PreguntasPartida pregunta) => pregunta.IntentosRespuesta.Any(i => i.EsCorrecta);

    private EventosPartida Evento(Guid partidaId, string tipo, object datos) =>
        new() { PartidaId = partidaId, TipoEvento = tipo, DatosEvento = Serializar(datos), OcurridoEn = DateTime.UtcNow };

    private static Guid GuidDeterminista(string texto) => new(SHA256.HashData(Encoding.UTF8.GetBytes(texto))[..16]);

    private static string Serializar(object valor) => JsonSerializer.Serialize(valor, Json);
    private static T Leer<T>(string json) => JsonSerializer.Deserialize<T>(json, Json)!;

    private static ExcepcionNegocio Error(TipoError tipo, string codigo, string mensaje) => new(tipo, codigo, mensaje);
    private static ExcepcionNegocio PartidaNoEncontrada() => Error(TipoError.NoEncontrado, "partida_no_encontrada", "No se encontró la partida.");
    private static ExcepcionNegocio ClaveEnUso() => Error(TipoError.Conflicto, "clave_operacion_en_uso", "La clave de operación ya se usó en otra solicitud.");
    private static ExcepcionNegocio MechaAgotada() => Error(TipoError.Conflicto, "partida_terminada_por_mecha", "La mecha se agotó y la partida terminó.");
    private static ExcepcionNegocio LimiteAgotado() => Error(TipoError.Prohibido, "limite_diario_agotado", "Ya alcanzaste tu tiempo de juego de hoy. ¡Vuelve mañana!");
}
