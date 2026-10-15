using GENIOS.Application.Comun;
using GENIOS.Application.Estadisticas;
using GENIOS.Domain.Exceptions;
using GENIOS.Domain.Rules;
using GENIOS.Infrastructure.Auditoria;
using GENIOS.Infrastructure.Juego;
using GENIOS.Infrastructure.Persistence.Context;
using Microsoft.EntityFrameworkCore;

namespace GENIOS.Infrastructure.Estadisticas;

/// <summary>Todas las cifras salen de registros validados por el servidor; el cliente solo las muestra.</summary>
public class ServicioEstadisticas(GeniosDbContext bd, RegistradorAuditoria auditoria) : IServicioEstadisticas
{
    private const int CantidadReciente = 10;

    // ---------------------------------------------------------------- Progreso por materia

    public async Task<ProgresoEstudianteDto> ObtenerProgresoAsync(Guid estudianteId, CancellationToken ct)
    {
        var asignaturas = await bd.Asignaturas.AsNoTracking().Where(a => a.Activa).OrderBy(a => a.OrdenVisual).ToListAsync(ct);
        var categorias = await bd.Categorias.AsNoTracking().Include(c => c.NivelEducativo)
            .Where(c => c.Activa && c.NivelEducativo.Activo).ToListAsync(ct);
        var estados = await EstadosCategorias.CalcularAsync(bd, Propietario.DeUsuario(estudianteId), categorias, ct);
        var progreso = await bd.ProgresoEstudiante.AsNoTracking().Where(p => p.UsuarioId == estudianteId)
            .ToDictionaryAsync(p => p.CategoriaId, ct);

        // Los puntos salen del libro de transacciones, atribuidos a la categoría de cada partida.
        var puntosPorCategoria = await bd.TransaccionesPuntos.AsNoTracking()
            .Where(t => t.UsuarioId == estudianteId && t.Partida != null)
            .GroupBy(t => t.Partida!.CategoriaId)
            .Select(g => new { Categoria = g.Key, Total = g.Sum(t => (long)t.Puntos) })
            .ToDictionaryAsync(x => x.Categoria, x => x.Total, ct);

        var resultado = asignaturas.Select(asignatura =>
        {
            var propias = categorias.Where(c => c.NivelEducativo.AsignaturaId == asignatura.Id)
                .OrderBy(c => c.NivelEducativo.NumeroOrden).ThenBy(c => c.NumeroOrden).ToList();

            var detalle = propias.Select(c =>
            {
                progreso.TryGetValue(c.Id, out var p);
                return new CategoriaProgresoDto(c.Id, c.Nombre, estados[c.Id].Estado, p?.PartidasCompletadas ?? 0,
                    ReglasJuego.PorcentajeAciertos(p?.AciertosPrimerIntento ?? 0, p?.PreguntasEvaluadas ?? 0),
                    puntosPorCategoria.GetValueOrDefault(c.Id));
            }).ToList();

            var filas = propias.Where(c => progreso.ContainsKey(c.Id)).Select(c => progreso[c.Id]).ToList();
            return new AsignaturaProgresoDto(asignatura.Id, asignatura.Nombre, detalle.Count,
                detalle.Count(d => d.Estado == "completada"), filas.Sum(p => p.PartidasCompletadas),
                ReglasJuego.PorcentajeAciertos(filas.Sum(p => p.AciertosPrimerIntento), filas.Sum(p => p.PreguntasEvaluadas)),
                detalle.Sum(d => d.Puntos), detalle);
        }).ToList();

        return new ProgresoEstudianteDto(resultado);
    }

    // ---------------------------------------------------------------- Estadísticas generales

    public async Task<EstadisticasEstudianteDto> ObtenerEstadisticasAsync(Guid estudianteId, CancellationToken ct)
    {
        var propias = bd.Partidas.AsNoTracking().Where(p => p.UsuarioId == estudianteId);
        var completadas = propias.Where(p => p.Estado == "completada");

        var partidasCompletadas = await completadas.CountAsync(ct);
        var evaluadas = await completadas.SumAsync(p => (int)p.CantidadPreguntasEvaluadas, ct);
        var aciertos = await completadas.SumAsync(p => (int)p.AciertosPrimerIntento, ct);
        var incompletas = await propias.CountAsync(p => p.Estado != "completada" && p.Estado != "en_curso", ct);
        var tiempoMs = await propias.SumAsync(p => p.TiempoActivoMs, ct);

        var intentos = await bd.IntentosRespuesta.AsNoTracking()
            .CountAsync(i => i.PreguntaPartida.Partida.UsuarioId == estudianteId && i.PreguntaPartida.Partida.Estado == "completada", ct);
        var corregidas = await bd.PreguntasPartida.AsNoTracking()
            .CountAsync(q => q.Partida.UsuarioId == estudianteId && q.Partida.Estado == "completada" && q.PrimeraRespuestaCorrecta == false, ct);

        var recientes = (await propias.OrderByDescending(p => p.IniciadaEn).Take(CantidadReciente)
            .Select(p => new
            {
                p.Id, Asignatura = p.Categoria.NivelEducativo.Asignatura.Nombre, Categoria = p.Categoria.Nombre,
                p.Estado, p.EsPartidaValida, p.AciertosPrimerIntento, p.CantidadPreguntasEvaluadas, p.PuntosObtenidos, p.IniciadaEn
            }).ToListAsync(ct))
            .Select(p => new PartidaRecienteDto(p.Id, p.Asignatura, p.Categoria, p.Estado, p.EsPartidaValida,
                p.AciertosPrimerIntento, p.CantidadPreguntasEvaluadas,
                ReglasJuego.PorcentajeAciertos(p.AciertosPrimerIntento, p.CantidadPreguntasEvaluadas),
                p.PuntosObtenidos, p.IniciadaEn)).ToList();

        var reintentos = new RendimientoReintentosDto(intentos, corregidas, evaluadas == 0 ? 0 : Math.Round(intentos / (decimal)evaluadas, 2));
        return new EstadisticasEstudianteDto(partidasCompletadas, incompletas, evaluadas, aciertos,
            ReglasJuego.PorcentajeAciertos(aciertos, evaluadas), reintentos, (int)(tiempoMs / 1000), recientes);
    }

    // ---------------------------------------------------------------- Puntos

    public async Task<PuntosEstudianteDto> ObtenerPuntosAsync(Guid estudianteId, CancellationToken ct)
    {
        var transacciones = bd.TransaccionesPuntos.AsNoTracking().Where(t => t.UsuarioId == estudianteId);

        var porTipo = await transacciones.GroupBy(t => t.TipoTransaccion)
            .Select(g => new { Tipo = g.Key, Puntos = g.Sum(t => (long)t.Puntos), Cantidad = g.Count() }).ToListAsync(ct);
        var recientes = await transacciones.OrderByDescending(t => t.CreadoEn).Take(CantidadReciente)
            .Select(t => new TransaccionPuntosDto(t.TipoTransaccion, t.Puntos, t.Motivo, t.CreadoEn)).ToListAsync(ct);

        return new PuntosEstudianteDto(
            porTipo.Sum(x => x.Puntos),
            porTipo.OrderBy(x => x.Tipo).Select(x => new PuntosPorTipoDto(x.Tipo, x.Puntos, x.Cantidad)).ToList(),
            porTipo.Where(x => x.Tipo == "bono_categoria").Sum(x => x.Cantidad),
            recientes);
    }

    // ---------------------------------------------------------------- Aula (docente)

    public async Task<EstadisticasAulaDto> ObtenerEstadisticasAulaAsync(Guid docenteId, Guid aulaId, ContextoSolicitud contexto, CancellationToken ct)
    {
        var aula = await bd.Aulas.AsNoTracking()
            .SingleOrDefaultAsync(a => a.Id == aulaId && a.DocenteId == docenteId && a.EliminadaEn == null, ct);
        if (aula is null)
        {
            // Aula ajena o inexistente: misma respuesta, y queda registrado el intento de acceso.
            await auditoria.RegistrarAsync("acceso_aula_no_autorizado", docenteId, contexto, new { aulaId });
            throw new ExcepcionNegocio(TipoError.NoEncontrado, "aula_no_encontrada", "No se encontró el aula.");
        }

        // Solo estudiantes activos de ESTA aula.
        var miembros = await bd.MiembrosAula.AsNoTracking().Where(m => m.AulaId == aulaId && m.Estado == "activo")
            .Select(m => new { m.EstudianteId, m.Estudiante.NombreMostrar, m.Estudiante.NombreUsuario }).ToListAsync(ct);
        var ids = miembros.Select(m => m.EstudianteId).ToList();

        var progreso = await bd.ProgresoEstudiante.AsNoTracking().Where(p => ids.Contains(p.UsuarioId))
            .Select(p => new
            {
                p.UsuarioId, Asignatura = p.Categoria.NivelEducativo.Asignatura.Nombre,
                AsignaturaId = p.Categoria.NivelEducativo.AsignaturaId,
                p.PartidasCompletadas, p.PreguntasEvaluadas, p.AciertosPrimerIntento, p.UltimaActividadEn
            }).ToListAsync(ct);
        var puntos = await bd.TransaccionesPuntos.AsNoTracking().Where(t => ids.Contains(t.UsuarioId))
            .GroupBy(t => t.UsuarioId).Select(g => new { Id = g.Key, Total = g.Sum(t => (long)t.Puntos) })
            .ToDictionaryAsync(x => x.Id, x => x.Total, ct);

        var puntosPorAsignatura = await bd.TransaccionesPuntos.AsNoTracking()
            .Where(t => ids.Contains(t.UsuarioId) && t.Partida != null)
            .GroupBy(t => new { t.UsuarioId, Asignatura = t.Partida!.Categoria.NivelEducativo.AsignaturaId })
            .Select(g => new { g.Key.UsuarioId, g.Key.Asignatura, Total = g.Sum(t => (long)t.Puntos) })
            .ToListAsync(ct);

        var estudiantes = miembros.Select(m =>
        {
            var propias = progreso.Where(p => p.UsuarioId == m.EstudianteId).ToList();
            var porAsignatura = propias.GroupBy(p => new { p.Asignatura, p.AsignaturaId }).OrderBy(g => g.Key.Asignatura)
                .Select(g => new AsignaturaResumenDto(g.Key.Asignatura, g.Sum(p => p.PartidasCompletadas),
                    ReglasJuego.PorcentajeAciertos(g.Sum(p => p.AciertosPrimerIntento), g.Sum(p => p.PreguntasEvaluadas)),
                    g.Key.AsignaturaId,
                    puntosPorAsignatura.Where(x => x.UsuarioId == m.EstudianteId && x.Asignatura == g.Key.AsignaturaId).Sum(x => x.Total))).ToList();
            var evaluadas = propias.Sum(p => p.PreguntasEvaluadas);
            var aciertos = propias.Sum(p => p.AciertosPrimerIntento);
            return new EstudianteEstadisticasDto(m.EstudianteId, m.NombreMostrar, m.NombreUsuario,
                propias.Sum(p => p.PartidasCompletadas), evaluadas, aciertos, ReglasJuego.PorcentajeAciertos(aciertos, evaluadas),
                puntos.GetValueOrDefault(m.EstudianteId), propias.Max(p => p.UltimaActividadEn), porAsignatura);
        }).OrderBy(e => e.NombreMostrar).ToList();

        return new EstadisticasAulaDto(aula.Id, aula.Nombre, estudiantes.Count, estudiantes.Sum(e => e.PartidasCompletadas),
            ReglasJuego.PorcentajeAciertos(estudiantes.Sum(e => e.AciertosPrimerIntento), estudiantes.Sum(e => e.PreguntasEvaluadas)),
            estudiantes);
    }

    // ---------------------------------------------------------------- Ranking (docente)

    private const int MaximoFilasRanking = 200;

    public async Task<RankingDto> ObtenerRankingAsync(Guid docenteId, Guid? aulaId, long? asignaturaId, ContextoSolicitud contexto, CancellationToken ct)
    {
        var aulas = bd.Aulas.AsNoTracking().Where(a => a.DocenteId == docenteId && a.EliminadaEn == null);
        if (aulaId is not null)
        {
            if (!await aulas.AnyAsync(a => a.Id == aulaId, ct))
            {
                await auditoria.RegistrarAsync("acceso_aula_no_autorizado", docenteId, contexto, new { aulaId });
                throw new ExcepcionNegocio(TipoError.NoEncontrado, "aula_no_encontrada", "No se encontró el aula.");
            }
            aulas = aulas.Where(a => a.Id == aulaId);
        }

        // Solo estudiantes activos de las aulas del propio docente.
        var miembros = await bd.MiembrosAula.AsNoTracking()
            .Where(m => m.Estado == "activo" && aulas.Any(a => a.Id == m.AulaId))
            .Select(m => new { m.EstudianteId, m.Estudiante.NombreMostrar, m.Estudiante.NombreUsuario, Aula = m.Aula.Nombre })
            .ToListAsync(ct);
        var ids = miembros.Select(m => m.EstudianteId).Distinct().ToList();

        var progresoConsulta = bd.ProgresoEstudiante.AsNoTracking().Where(p => ids.Contains(p.UsuarioId));
        if (asignaturaId is not null)
            progresoConsulta = progresoConsulta.Where(p => p.Categoria.NivelEducativo.AsignaturaId == asignaturaId);
        var progreso = await progresoConsulta
            .Select(p => new { p.UsuarioId, p.PartidasCompletadas, p.PreguntasEvaluadas, p.AciertosPrimerIntento }).ToListAsync(ct);

        var puntosConsulta = bd.TransaccionesPuntos.AsNoTracking().Where(t => ids.Contains(t.UsuarioId));
        if (asignaturaId is not null)
            puntosConsulta = puntosConsulta.Where(t => t.Partida != null && t.Partida.Categoria.NivelEducativo.AsignaturaId == asignaturaId);
        var puntos = await puntosConsulta.GroupBy(t => t.UsuarioId)
            .Select(g => new { Id = g.Key, Total = g.Sum(t => (long)t.Puntos) })
            .ToDictionaryAsync(x => x.Id, x => x.Total, ct);

        var filas = ids.Select(id =>
        {
            var datos = miembros.Where(m => m.EstudianteId == id).ToList();
            var propias = progreso.Where(p => p.UsuarioId == id).ToList();
            return new
            {
                Id = id, datos[0].NombreMostrar, datos[0].NombreUsuario,
                Aulas = (IReadOnlyList<string>)datos.Select(d => d.Aula).Distinct().OrderBy(n => n).ToList(),
                Puntos = puntos.GetValueOrDefault(id),
                Partidas = propias.Sum(p => p.PartidasCompletadas),
                Porcentaje = ReglasJuego.PorcentajeAciertos(propias.Sum(p => p.AciertosPrimerIntento), propias.Sum(p => p.PreguntasEvaluadas))
            };
        }).OrderByDescending(f => f.Puntos).ThenByDescending(f => f.Porcentaje).ThenBy(f => f.NombreMostrar).Take(MaximoFilasRanking).ToList();

        var resultado = new List<FilaRankingDto>();
        for (var i = 0; i < filas.Count; i++)
        {
            // Competición estándar: el mismo puntaje comparte posición.
            var posicion = i > 0 && filas[i].Puntos == filas[i - 1].Puntos ? resultado[i - 1].Posicion : i + 1;
            var f = filas[i];
            resultado.Add(new FilaRankingDto(posicion, f.Id, f.NombreMostrar, f.NombreUsuario, f.Aulas, f.Puntos, f.Partidas, f.Porcentaje));
        }
        return new RankingDto(aulaId, asignaturaId, resultado);
    }
}
