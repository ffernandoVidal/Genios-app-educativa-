using System.Text.Json;
using GENIOS.Domain.Exceptions;
using GENIOS.Domain.Rules;
using GENIOS.Infrastructure.Persistence.Context;
using GENIOS.Infrastructure.Persistence.Entities;
using Microsoft.EntityFrameworkCore;

namespace GENIOS.Infrastructure.Juego;

/// <summary>
/// Arma las preguntas de una partida: primero las del banco y, si faltan, las generadas por reglas.
/// Cada pregunta queda como instantánea; la respuesta correcta se guarda aparte y nunca se envía al cliente.
/// </summary>
public class GeneradorPreguntas(GeniosDbContext bd)
{
    private static readonly JsonSerializerOptions Json = new(JsonSerializerDefaults.Web);
    private static readonly string[] TiposSoportados = ["opcion_multiple", "verdadero_falso"];

    public async Task<List<(PreguntasPartida Pregunta, RespuestasCorrectasPartida Clave)>> CrearAsync(
        Guid partidaId, long categoriaId, int cantidad, CancellationToken ct)
    {
        var azar = Random.Shared;

        var banco = (await bd.Preguntas.AsNoTracking()
                .Include(p => p.OpcionesPregunta).Include(p => p.ClavesRespuesta)
                .Where(p => p.CategoriaId == categoriaId && p.Activa && TiposSoportados.Contains(p.TipoPregunta)
                            && p.ClavesRespuesta != null)
                .ToListAsync(ct))
            .OrderBy(_ => azar.Next()).Take(cantidad).ToList();

        // Si hay varias versiones de una regla, se usa la más reciente.
        var reglas = (await bd.ReglasGeneracionPreguntas.AsNoTracking()
                .Where(r => r.CategoriaId == categoriaId && r.Activa).ToListAsync(ct))
            .GroupBy(r => r.Codigo).Select(g => g.OrderByDescending(r => r.Version).First()).ToList();

        if (banco.Count < cantidad && reglas.Count == 0)
            throw new ExcepcionNegocio(TipoError.NoDisponible, "categoria_sin_contenido",
                "La categoría todavía no tiene preguntas suficientes.");

        var resultado = new List<(PreguntasPartida, RespuestasCorrectasPartida)>();
        for (var posicion = 1; posicion <= cantidad; posicion++)
        {
            resultado.Add(posicion <= banco.Count
                ? DesdeBanco(partidaId, posicion, banco[posicion - 1], azar)
                : Generada(partidaId, posicion, reglas[azar.Next(reglas.Count)], azar));
        }
        return resultado;
    }

    private static (PreguntasPartida, RespuestasCorrectasPartida) DesdeBanco(Guid partidaId, int posicion, Preguntas pregunta, Random azar)
    {
        var opciones = pregunta.OpcionesPregunta.Where(o => o.Activa)
            .OrderBy(_ => azar.Next())
            .Select(o => (OrigenId: o.Id, Presentada: Guid.NewGuid(), Texto: o.TextoOpcion)).ToList();

        var idCorrecto = JsonDocument.Parse(pregunta.ClavesRespuesta!.RespuestaCorrecta).RootElement.GetProperty("opcionId").GetInt64();
        var correcta = opciones.Single(o => o.OrigenId == idCorrecto);

        return Armar(partidaId, posicion, "banco", pregunta.Id, null, pregunta.Enunciado,
            opciones.Select(o => new { id = o.Presentada, texto = o.Texto }), correcta.Presentada, "{}", pregunta.Dificultad);
    }

    private static (PreguntasPartida, RespuestasCorrectasPartida) Generada(Guid partidaId, int posicion, ReglasGeneracionPreguntas regla, Random azar)
    {
        using var parametros = JsonDocument.Parse(regla.Parametros);
        var raiz = parametros.RootElement;
        var operacion = raiz.GetProperty("operacion").GetString()!;
        var minimo = raiz.GetProperty("minimo").GetInt32();
        var maximo = raiz.GetProperty("maximo").GetInt32();

        var generada = GeneradorOperaciones.Generar(operacion, minimo, maximo, azar);
        var opciones = generada.Opciones.Select(valor => (Presentada: Guid.NewGuid(), Valor: valor)).ToList();
        var correcta = opciones.Single(o => o.Valor == generada.Respuesta);

        // Se guarda con qué regla y rangos se generó, para poder reconstruir la evaluación.
        var datos = JsonSerializer.Serialize(new
        {
            regla = regla.Codigo, version = regla.Version, operacion, minimo, maximo, respuesta = generada.Respuesta
        }, Json);

        return Armar(partidaId, posicion, "generada", null, regla.Id, generada.Enunciado,
            opciones.Select(o => new { id = o.Presentada, texto = o.Valor.ToString() }), correcta.Presentada, datos, regla.Dificultad);
    }

    private static (PreguntasPartida, RespuestasCorrectasPartida) Armar(
        Guid partidaId, int posicion, string origen, long? preguntaId, long? reglaId, string enunciado,
        IEnumerable<object> opciones, Guid opcionCorrecta, string datosGeneracion, string dificultad)
    {
        var id = Guid.NewGuid();
        var pregunta = new PreguntasPartida
        {
            Id = id,
            PartidaId = partidaId,
            PreguntaId = preguntaId,
            TipoOrigen = origen,
            ReglaGeneracionId = reglaId,
            Posicion = (short)posicion,
            EnunciadoInstantanea = enunciado,
            OpcionesInstantanea = JsonSerializer.Serialize(opciones, Json),
            DatosGeneracion = datosGeneracion,
            Dificultad = dificultad
        };
        var clave = new RespuestasCorrectasPartida
        {
            PreguntaPartidaId = id,
            RespuestaCorrecta = JsonSerializer.Serialize(new { opcionId = opcionCorrecta }, Json),
            ReglasValidacion = "{}"
        };
        return (pregunta, clave);
    }
}
