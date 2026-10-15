using GENIOS.Application.Comun;
using GENIOS.Application.Docente;
using GENIOS.Domain.Exceptions;
using GENIOS.Domain.Rules;
using GENIOS.Infrastructure.Auditoria;
using GENIOS.Infrastructure.Juego;
using GENIOS.Infrastructure.Persistence.Context;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;

namespace GENIOS.Infrastructure.Docente;

/// <summary>Estadísticas docentes: todo se calcula aquí, a partir de partidas válidas y del primer intento.</summary>
public class ServicioDocente(GeniosDbContext bd, RegistradorAuditoria auditoria, IOptions<OpcionesJuego> opcionesJuego) : IServicioDocente
{
    private const int DiasPorDefecto = 30;
    private const int DiasActivoReciente = 7;
    private const int TamanoMaximo = 100;
    private const int MaximoHistorial = 20;
    private const int MaximoErrores = 5;

    private readonly TimeZoneInfo _zona = TimeZoneInfo.FindSystemTimeZoneById(opcionesJuego.Value.ZonaHoraria);

    // ---------------------------------------------------------------- Período y utilidades

    /// <summary>Período en días locales, con su equivalente UTC [inicio, fin) y el período anterior de igual duración.</summary>
    private sealed record Periodo(DateOnly Desde, DateOnly Hasta, DateTime InicioUtc, DateTime FinUtc, DateTime InicioPrevioUtc)
    {
        public int Dias => Hasta.DayNumber - Desde.DayNumber + 1;
    }

    private DateOnly HoyLocal() => DateOnly.FromDateTime(TimeZoneInfo.ConvertTimeFromUtc(DateTime.UtcNow, _zona));

    private DateTime DiaLocalAUtc(DateOnly dia) =>
        TimeZoneInfo.ConvertTimeToUtc(DateTime.SpecifyKind(dia.ToDateTime(TimeOnly.MinValue), DateTimeKind.Unspecified), _zona);

    private DateOnly AFechaLocal(DateTime utc) =>
        DateOnly.FromDateTime(TimeZoneInfo.ConvertTimeFromUtc(DateTime.SpecifyKind(utc, DateTimeKind.Utc), _zona));

    private Periodo ResolverPeriodo(PeriodoSolicitado p)
    {
        var hasta = p.Hasta ?? HoyLocal();
        var desde = p.Desde ?? hasta.AddDays(-((p.Dias is > 0 and <= 366 ? p.Dias.Value : DiasPorDefecto) - 1));
        if (desde > hasta)
            throw new ExcepcionNegocio(TipoError.Validacion, "periodo_invalido", "La fecha inicial no puede ser posterior a la final.");
        if (hasta.DayNumber - desde.DayNumber > 365)
            throw new ExcepcionNegocio(TipoError.Validacion, "periodo_invalido", "El período no puede superar un año.");
        var dias = hasta.DayNumber - desde.DayNumber + 1;
        return new Periodo(desde, hasta, DiaLocalAUtc(desde), DiaLocalAUtc(hasta.AddDays(1)), DiaLocalAUtc(desde.AddDays(-dias)));
    }

    private static decimal? Porcentaje(int aciertos, int evaluadas) => evaluadas <= 0 ? null : aciertos * 100m / evaluadas;

    private static decimal? Redondear(decimal? valor) => valor is null ? null : Math.Round(valor.Value, 1);

    private static string Rendimiento(decimal? porcentajeExacto) => ReglasRendimiento.Codigo(ReglasRendimiento.Clasificar(porcentajeExacto));

    private sealed record FilaPartida(Guid UsuarioId, long CategoriaId, long AsignaturaId, string Asignatura, int Aciertos, int Evaluadas, long TiempoMs, DateTime FinalizadaEn);

    /// <summary>Partidas válidas de los estudiantes dados, finalizadas en [inicio, fin).</summary>
    private Task<List<FilaPartida>> PartidasValidasAsync(IReadOnlyCollection<Guid> estudiantes, DateTime inicioUtc, DateTime finUtc, CancellationToken ct) =>
        bd.Partidas.AsNoTracking()
            .Where(p => p.UsuarioId != null && estudiantes.Contains(p.UsuarioId.Value) && p.EsPartidaValida
                        && p.FinalizadaEn != null && p.FinalizadaEn >= inicioUtc && p.FinalizadaEn < finUtc)
            .Select(p => new FilaPartida(p.UsuarioId!.Value, p.CategoriaId, p.Categoria.NivelEducativo.AsignaturaId,
                p.Categoria.NivelEducativo.Asignatura.Nombre, p.AciertosPrimerIntento, p.CantidadPreguntasEvaluadas,
                p.TiempoActivoMs, p.FinalizadaEn!.Value))
            .ToListAsync(ct);

    // ---------------------------------------------------------------- Autorización

    private IQueryable<Persistence.Entities.Aulas> AulasActivas(Guid docenteId) =>
        bd.Aulas.AsNoTracking().Where(a => a.DocenteId == docenteId && a.EliminadaEn == null && a.Estado == "activa");

    private sealed record Miembro(Guid EstudianteId, string NombreMostrar, string? NombreUsuario, Guid AulaId, string AulaNombre, short? Grado);

    /// <summary>Estudiantes activos de las aulas activas del docente (una fila por estudiante y aula).</summary>
    private async Task<List<Miembro>> MiembrosAutorizadosAsync(Guid docenteId, Guid? aulaId, CancellationToken ct)
    {
        var aulas = AulasActivas(docenteId);
        if (aulaId is not null) aulas = aulas.Where(a => a.Id == aulaId);
        return await bd.MiembrosAula.AsNoTracking()
            .Where(m => m.Estado == "activo" && aulas.Any(a => a.Id == m.AulaId))
            .Select(m => new Miembro(m.EstudianteId, m.Estudiante.NombreMostrar, m.Estudiante.NombreUsuario, m.AulaId, m.Aula.Nombre, m.Aula.Grado))
            .ToListAsync(ct);
    }

    private async Task<List<Miembro>> ExigirEstudianteAsync(Guid docenteId, Guid estudianteId, ContextoSolicitud contexto, CancellationToken ct)
    {
        var filas = (await MiembrosAutorizadosAsync(docenteId, null, ct)).Where(m => m.EstudianteId == estudianteId).ToList();
        if (filas.Count == 0)
        {
            await auditoria.RegistrarAsync("acceso_estudiante_no_autorizado", docenteId, contexto, new { estudianteId });
            throw new ExcepcionNegocio(TipoError.NoEncontrado, "estudiante_no_encontrado", "No se encontró el estudiante.");
        }
        return filas;
    }

    private static List<AulaBreveDto> Aulas(IEnumerable<Miembro> filas) =>
        filas.Select(f => new AulaBreveDto(f.AulaId, f.AulaNombre, f.Grado)).DistinctBy(a => a.Id).OrderBy(a => a.Nombre).ToList();

    // ---------------------------------------------------------------- Resumen (cabina)

    public async Task<ResumenDocenteDto> ObtenerResumenAsync(Guid docenteId, PeriodoSolicitado periodo, CancellationToken ct)
    {
        var p = ResolverPeriodo(periodo);
        var miembros = await MiembrosAutorizadosAsync(docenteId, null, ct);
        var ids = miembros.Select(m => m.EstudianteId).Distinct().ToList();
        var clases = await AulasActivas(docenteId).CountAsync(ct);

        var partidas = await PartidasValidasAsync(ids, p.InicioUtc, p.FinUtc, ct);
        var corte = DateTime.UtcNow.AddDays(-DiasActivoReciente);
        var activos = await bd.Partidas.AsNoTracking()
            .Where(x => x.UsuarioId != null && ids.Contains(x.UsuarioId.Value) && x.FinalizadaEn >= corte)
            .Select(x => x.UsuarioId).Distinct().CountAsync(ct);

        var promedio = Porcentaje(partidas.Sum(x => x.Aciertos), partidas.Sum(x => x.Evaluadas));
        return new ResumenDocenteDto(clases, ids.Count, activos, Redondear(promedio), Rendimiento(promedio), partidas.Count, p.Desde, p.Hasta);
    }

    // ---------------------------------------------------------------- Listado de estudiantes

    public async Task<PaginaDto<FilaEstudianteDto>> ListarEstudiantesAsync(
        Guid docenteId, FiltroEstudiantes filtro, PeriodoSolicitado periodo, ContextoSolicitud contexto, CancellationToken ct)
    {
        var p = ResolverPeriodo(periodo);
        if (filtro.AulaId is not null && !await AulasActivas(docenteId).AnyAsync(a => a.Id == filtro.AulaId, ct))
        {
            await auditoria.RegistrarAsync("acceso_aula_no_autorizado", docenteId, contexto, new { aulaId = filtro.AulaId });
            throw new ExcepcionNegocio(TipoError.NoEncontrado, "aula_no_encontrada", "No se encontró el aula.");
        }
        if (filtro.Rendimiento is not (null or "" or "refuerzo" or "repaso" or "aprobado" or "sin_datos"))
            throw new ExcepcionNegocio(TipoError.Validacion, "rendimiento_invalido", "El nivel de rendimiento no es válido.");

        var miembros = await MiembrosAutorizadosAsync(docenteId, filtro.AulaId, ct);
        var ids = miembros.Select(m => m.EstudianteId).Distinct().ToList();
        var partidas = await PartidasValidasAsync(ids, p.InicioUtc, p.FinUtc, ct);
        var ultima = await bd.Partidas.AsNoTracking()
            .Where(x => x.UsuarioId != null && ids.Contains(x.UsuarioId.Value) && x.FinalizadaEn != null)
            .GroupBy(x => x.UsuarioId!.Value).Select(g => new { Id = g.Key, Fecha = g.Max(x => x.FinalizadaEn) })
            .ToDictionaryAsync(x => x.Id, x => x.Fecha, ct);

        var filas = ids.Select(id =>
        {
            var datos = miembros.Where(m => m.EstudianteId == id).ToList();
            var propias = partidas.Where(x => x.UsuarioId == id).ToList();
            var promedio = Porcentaje(propias.Sum(x => x.Aciertos), propias.Sum(x => x.Evaluadas));
            return new FilaEstudianteDto(id, datos[0].NombreMostrar, datos[0].NombreUsuario, Aulas(datos),
                datos.Select(d => d.Grado).FirstOrDefault(g => g != null), ultima.GetValueOrDefault(id), propias.Count,
                Redondear(promedio), Rendimiento(promedio));
        }).AsEnumerable();

        if (!string.IsNullOrWhiteSpace(filtro.Busqueda))
        {
            var q = filtro.Busqueda.Trim();
            filas = filas.Where(f => f.NombreMostrar.Contains(q, StringComparison.CurrentCultureIgnoreCase)
                                     || (f.NombreUsuario?.Contains(q, StringComparison.OrdinalIgnoreCase) ?? false));
        }
        if (filtro.Grado is not null) filas = filas.Where(f => f.Aulas.Any(a => a.Grado == filtro.Grado));
        if (!string.IsNullOrEmpty(filtro.Rendimiento)) filas = filas.Where(f => f.Rendimiento == filtro.Rendimiento);

        filas = filtro.Orden switch
        {
            "actividad" => filas.OrderByDescending(f => f.UltimaActividadEn).ThenBy(f => f.NombreMostrar),
            "rendimiento" => filas.OrderByDescending(f => f.PromedioAciertos).ThenBy(f => f.NombreMostrar),
            _ => filas.OrderBy(f => f.NombreMostrar, StringComparer.CurrentCultureIgnoreCase)
        };

        var lista = filas.ToList();
        var tamano = Math.Clamp(filtro.Tamano <= 0 ? 20 : filtro.Tamano, 1, TamanoMaximo);
        var pagina = Math.Max(1, filtro.Pagina);
        return new PaginaDto<FilaEstudianteDto>(lista.Skip((pagina - 1) * tamano).Take(tamano).ToList(), pagina, tamano, lista.Count);
    }

    // ---------------------------------------------------------------- Ficha individual

    public async Task<FichaEstudianteDto> ObtenerFichaAsync(Guid docenteId, Guid estudianteId, PeriodoSolicitado periodo, ContextoSolicitud contexto, CancellationToken ct)
    {
        var filas = await ExigirEstudianteAsync(docenteId, estudianteId, contexto, ct);
        var p = ResolverPeriodo(periodo);
        var todas = await PartidasValidasAsync([estudianteId], p.InicioPrevioUtc, p.FinUtc, ct);
        var actuales = todas.Where(x => x.FinalizadaEn >= p.InicioUtc).ToList();
        var previas = todas.Where(x => x.FinalizadaEn < p.InicioUtc).ToList();

        var promedio = Porcentaje(actuales.Sum(x => x.Aciertos), actuales.Sum(x => x.Evaluadas));
        var promedioPrevio = Porcentaje(previas.Sum(x => x.Aciertos), previas.Sum(x => x.Evaluadas));

        // Promedio del grupo: solo estudiantes que este docente puede analizar (los de las aulas del estudiante).
        var idsGrupo = (await MiembrosAutorizadosAsync(docenteId, null, ct)).Select(m => m.EstudianteId).Distinct().ToList();
        var grupo = idsGrupo.Count > 1 ? await PartidasValidasAsync(idsGrupo, p.InicioUtc, p.FinUtc, ct) : [];
        var promedioGrupo = Porcentaje(grupo.Sum(x => x.Aciertos), grupo.Sum(x => x.Evaluadas));

        var materias = actuales.GroupBy(x => new { x.AsignaturaId, x.Asignatura }).OrderBy(g => g.Key.Asignatura).Select(g =>
        {
            var prom = Porcentaje(g.Sum(x => x.Aciertos), g.Sum(x => x.Evaluadas));
            var prev = previas.Where(x => x.AsignaturaId == g.Key.AsignaturaId).ToList();
            var promPrev = Porcentaje(prev.Sum(x => x.Aciertos), prev.Sum(x => x.Evaluadas));
            return new MateriaEstadisticaDto(g.Key.AsignaturaId, g.Key.Asignatura, Redondear(prom), Rendimiento(prom), g.Count(),
                Redondear(prom - promPrev)); // null si el período anterior no tiene partidas
        }).ToList();

        var porDia = actuales.GroupBy(x => AFechaLocal(x.FinalizadaEn)).OrderBy(g => g.Key)
            .Select(g => new PuntoDiaDto(g.Key, g.Count())).ToList();

        var aprobadas = actuales.Count(x => ReglasRendimiento.Clasificar(x.Aciertos, x.Evaluadas) == NivelRendimiento.Aprobado);
        var (lecciones, misiones) = await AprobacionAsync(estudianteId, null, ct);
        var ultima = await bd.Partidas.AsNoTracking()
            .Where(x => x.UsuarioId == estudianteId && x.FinalizadaEn != null).MaxAsync(x => x.FinalizadaEn, ct);

        return new FichaEstudianteDto(estudianteId, filas[0].NombreMostrar, Aulas(filas), ultima, p.Desde, p.Hasta,
            actuales.Count, aprobadas, Redondear(promedio), Rendimiento(promedio),
            actuales.Count == 0 ? null : (int)Math.Round(actuales.Average(x => x.TiempoMs) / 1000.0),
            misiones, lecciones, Redondear(promedio - promedioPrevio), Redondear(promedioGrupo), materias, porDia);
    }

    /// <summary>Lecciones (categorías) aprobadas por el estudiante, de todos los tiempos, y misiones (niveles) con todas aprobadas.</summary>
    private async Task<(int Lecciones, int Misiones)> AprobacionAsync(Guid estudianteId, long? asignaturaId, CancellationToken ct)
    {
        var aprobadas = (await bd.Partidas.AsNoTracking()
            .Where(x => x.UsuarioId == estudianteId && x.EsPartidaValida
                        && (asignaturaId == null || x.Categoria.NivelEducativo.AsignaturaId == asignaturaId))
            .Select(x => new { x.CategoriaId, x.AciertosPrimerIntento, x.CantidadPreguntasEvaluadas }).ToListAsync(ct))
            .Where(x => ReglasRendimiento.Clasificar(x.AciertosPrimerIntento, x.CantidadPreguntasEvaluadas) == NivelRendimiento.Aprobado)
            .Select(x => x.CategoriaId).ToHashSet();

        var categorias = await bd.Categorias.AsNoTracking()
            .Where(c => c.Activa && c.NivelEducativo.Activo && (asignaturaId == null || c.NivelEducativo.AsignaturaId == asignaturaId))
            .Select(c => new { c.Id, c.NivelEducativoId }).ToListAsync(ct);
        var misiones = categorias.GroupBy(c => c.NivelEducativoId).Count(g => g.All(c => aprobadas.Contains(c.Id)));
        return (categorias.Count(c => aprobadas.Contains(c.Id)), misiones);
    }

    // ---------------------------------------------------------------- Calendario

    public async Task<ActividadMesDto> ObtenerActividadAsync(Guid docenteId, Guid estudianteId, int anio, int mes, ContextoSolicitud contexto, CancellationToken ct)
    {
        await ExigirEstudianteAsync(docenteId, estudianteId, contexto, ct);
        if (anio is < 2020 or > 2100 || mes is < 1 or > 12)
            throw new ExcepcionNegocio(TipoError.Validacion, "mes_invalido", "El mes solicitado no es válido.");

        var primero = new DateOnly(anio, mes, 1);
        var inicio = DiaLocalAUtc(primero);
        var fin = DiaLocalAUtc(primero.AddMonths(1));
        var partidas = await bd.Partidas.AsNoTracking()
            .Where(x => x.UsuarioId == estudianteId && x.Estado == "completada" && x.FinalizadaEn >= inicio && x.FinalizadaEn < fin)
            .Select(x => new { Fecha = x.FinalizadaEn!.Value, x.TiempoActivoMs, Materia = x.Categoria.NivelEducativo.Asignatura.Nombre })
            .ToListAsync(ct);

        var dias = partidas.GroupBy(x => AFechaLocal(x.Fecha)).OrderBy(g => g.Key)
            .Select(g => new DiaActividadDto(g.Key, g.Count(), (int)(g.Sum(x => x.TiempoActivoMs) / 1000),
                g.Select(x => x.Materia).Distinct().OrderBy(n => n).ToList())).ToList();
        return new ActividadMesDto(anio, mes, dias);
    }

    // ---------------------------------------------------------------- Detalle de materia

    public async Task<DetalleMateriaDto> ObtenerDetalleMateriaAsync(Guid docenteId, Guid estudianteId, long asignaturaId, ContextoSolicitud contexto, CancellationToken ct)
    {
        await ExigirEstudianteAsync(docenteId, estudianteId, contexto, ct);
        var asignatura = await bd.Asignaturas.AsNoTracking().SingleOrDefaultAsync(a => a.Id == asignaturaId && a.Activa, ct)
            ?? throw new ExcepcionNegocio(TipoError.NoEncontrado, "asignatura_no_encontrada", "No se encontró la materia.");

        var partidas = await bd.Partidas.AsNoTracking()
            .Where(x => x.UsuarioId == estudianteId && x.EsPartidaValida && x.Categoria.NivelEducativo.AsignaturaId == asignaturaId)
            .OrderByDescending(x => x.FinalizadaEn)
            .Select(x => new
            {
                x.Id, x.CategoriaId, Leccion = x.Categoria.Nombre, x.AciertosPrimerIntento, Evaluadas = x.CantidadPreguntasEvaluadas,
                x.TiempoActivoMs, Fecha = x.FinalizadaEn!.Value
            }).ToListAsync(ct);

        var categorias = await bd.Categorias.AsNoTracking()
            .Where(c => c.Activa && c.NivelEducativo.Activo && c.NivelEducativo.AsignaturaId == asignaturaId)
            .OrderBy(c => c.NivelEducativo.NumeroOrden).ThenBy(c => c.NumeroOrden)
            .Select(c => new { c.Id, c.Nombre }).ToListAsync(ct);

        var lecciones = categorias.Select(c =>
        {
            var propias = partidas.Where(x => x.CategoriaId == c.Id).ToList();
            var aprobada = propias.Any(x => ReglasRendimiento.Clasificar(x.AciertosPrimerIntento, x.Evaluadas) == NivelRendimiento.Aprobado);
            return new LeccionEstadoDto(c.Id, c.Nombre, aprobada, propias.Count, propias.Count == 0 ? null : propias.Max(x => x.AciertosPrimerIntento));
        }).ToList();

        var promedio = Porcentaje(partidas.Sum(x => x.AciertosPrimerIntento), partidas.Sum(x => (int)x.Evaluadas));
        var (_, misiones) = await AprobacionAsync(estudianteId, asignaturaId, ct);
        var trabajadas = await bd.Categorias.AsNoTracking()
            .Where(c => c.NivelEducativo.AsignaturaId == asignaturaId && partidas.Select(x => x.CategoriaId).Contains(c.Id))
            .Select(c => c.NivelEducativoId).Distinct().CountAsync(ct);

        var historial = partidas.Take(MaximoHistorial).Select(x =>
        {
            var pct = Porcentaje(x.AciertosPrimerIntento, x.Evaluadas) ?? 0;
            return new EvaluacionDto(x.Fecha, x.Leccion, x.AciertosPrimerIntento, x.Evaluadas, Math.Round(pct, 1),
                Rendimiento(pct));
        }).ToList();

        // Preguntas con más errores al primer intento (solo enunciado y conteos; nunca la clave).
        var idsPartidas = partidas.Select(x => x.Id).ToList();
        var errores = (await bd.PreguntasPartida.AsNoTracking()
                .Where(q => idsPartidas.Contains(q.PartidaId) && q.PrimeraRespuestaCorrecta != null)
                .Select(q => new { q.PreguntaId, q.EnunciadoInstantanea, Fallo = q.PrimeraRespuestaCorrecta == false }).ToListAsync(ct))
            .GroupBy(q => q.PreguntaId?.ToString() ?? q.EnunciadoInstantanea)
            .Select(g => new ErrorFrecuenteDto(g.First().EnunciadoInstantanea, g.Count(x => x.Fallo), g.Count()))
            .Where(e => e.Errores > 0).OrderByDescending(e => e.Errores).ThenBy(e => e.Enunciado).Take(MaximoErrores).ToList();

        var leccionesAprobadas = lecciones.Count(l => l.Aprobada);
        return new DetalleMateriaDto(asignatura.Id, asignatura.Nombre, Redondear(promedio), Rendimiento(promedio), partidas.Count,
            partidas.Count == 0 ? null : (int)Math.Round(partidas.Average(x => x.TiempoActivoMs) / 1000.0),
            trabajadas, leccionesAprobadas, lecciones.Count - leccionesAprobadas, lecciones, historial, errores);
    }

    // ---------------------------------------------------------------- Estadísticas de clase

    public async Task<EstadisticasClaseDto> ObtenerEstadisticasClaseAsync(Guid docenteId, Guid aulaId, PeriodoSolicitado periodo, ContextoSolicitud contexto, CancellationToken ct)
    {
        var aula = await AulasActivas(docenteId).SingleOrDefaultAsync(a => a.Id == aulaId, ct);
        if (aula is null)
        {
            await auditoria.RegistrarAsync("acceso_aula_no_autorizado", docenteId, contexto, new { aulaId });
            throw new ExcepcionNegocio(TipoError.NoEncontrado, "aula_no_encontrada", "No se encontró el aula.");
        }

        var p = ResolverPeriodo(periodo);
        var ids = (await MiembrosAutorizadosAsync(docenteId, aulaId, ct)).Select(m => m.EstudianteId).Distinct().ToList();
        var partidas = await PartidasValidasAsync(ids, p.InicioUtc, p.FinUtc, ct);

        // Cada estudiante cuenta una sola vez, clasificado con sus propios datos del período.
        var niveles = ids.Select(id =>
        {
            var propias = partidas.Where(x => x.UsuarioId == id).ToList();
            return ReglasRendimiento.Clasificar(propias.Sum(x => x.Aciertos), propias.Sum(x => x.Evaluadas));
        }).ToList();
        var distribucion = new DistribucionRendimientoDto(
            niveles.Count(n => n == NivelRendimiento.Refuerzo), niveles.Count(n => n == NivelRendimiento.Repaso),
            niveles.Count(n => n == NivelRendimiento.Aprobado), niveles.Count(n => n == NivelRendimiento.SinDatos));

        var promedio = Porcentaje(partidas.Sum(x => x.Aciertos), partidas.Sum(x => x.Evaluadas));
        var materias = partidas.GroupBy(x => new { x.AsignaturaId, x.Asignatura }).Select(g =>
        {
            var prom = Porcentaje(g.Sum(x => x.Aciertos), g.Sum(x => x.Evaluadas));
            return new MateriaClaseDto(g.Key.AsignaturaId, g.Key.Asignatura, Redondear(prom), Rendimiento(prom), g.Count());
        }).OrderBy(m => m.PromedioAciertos).ThenBy(m => m.Nombre).ToList(); // la más difícil primero

        var semanas = partidas.GroupBy(x => InicioDeSemana(AFechaLocal(x.FinalizadaEn))).OrderBy(g => g.Key).Select(g =>
            new SemanaClaseDto(g.Key, g.Count(), Redondear(Porcentaje(g.Sum(x => x.Aciertos), g.Sum(x => x.Evaluadas))))).ToList();

        return new EstadisticasClaseDto(aula.Id, aula.Nombre, aula.Grado, p.Desde, p.Hasta, ids.Count,
            partidas.Select(x => x.UsuarioId).Distinct().Count(), partidas.Count, Redondear(promedio), Rendimiento(promedio),
            distribucion, materias, semanas);
    }

    private static DateOnly InicioDeSemana(DateOnly dia)
    {
        var retroceso = ((int)dia.DayOfWeek + 6) % 7; // lunes = 0
        return dia.AddDays(-retroceso);
    }
}
