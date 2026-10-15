namespace GENIOS.Application.Estadisticas;

// ------------------------------------------------------------------ Progreso por materia

public record CategoriaProgresoDto(
    long CategoriaId, string Nombre, string Estado, int PartidasCompletadas, decimal PorcentajeAciertos, long Puntos);

/// <summary>PorcentajeAciertos usa solo el primer intento de las partidas completadas.</summary>
public record AsignaturaProgresoDto(
    long AsignaturaId, string Nombre, int CategoriasTotales, int CategoriasCompletadas, int PartidasCompletadas,
    decimal PorcentajeAciertos, long Puntos, IReadOnlyList<CategoriaProgresoDto> Categorias);

public record ProgresoEstudianteDto(IReadOnlyList<AsignaturaProgresoDto> Asignaturas);

// ------------------------------------------------------------------ Estadísticas generales

/// <summary>Rendimiento con reintentos: se muestra aparte del porcentaje del primer intento.</summary>
public record RendimientoReintentosDto(
    int IntentosTotales, int PreguntasCorregidasConReintento, decimal PromedioIntentosPorPregunta);

public record PartidaRecienteDto(
    Guid PartidaId, string Asignatura, string Categoria, string Estado, bool EsPartidaValida,
    int AciertosPrimerIntento, int PreguntasEvaluadas, decimal PorcentajeAciertos, int PuntosObtenidos, DateTime IniciadaEn);

/// <summary>
/// Los totales y el porcentaje cuentan solo partidas completadas; las incompletas se informan aparte.
/// </summary>
public record EstadisticasEstudianteDto(
    int PartidasCompletadas, int PartidasIncompletas, int PreguntasEvaluadas, int AciertosPrimerIntento,
    decimal PorcentajePrimerIntento, RendimientoReintentosDto Reintentos, int TiempoActivoSegundos,
    IReadOnlyList<PartidaRecienteDto> PartidasRecientes);

// ------------------------------------------------------------------ Puntos

public record PuntosPorTipoDto(string Tipo, long Puntos, int Cantidad);

public record TransaccionPuntosDto(string Tipo, int Puntos, string Motivo, DateTime CreadoEn);

public record PuntosEstudianteDto(
    long PuntosTotales, IReadOnlyList<PuntosPorTipoDto> PorTipo, int CategoriasConBono,
    IReadOnlyList<TransaccionPuntosDto> Recientes);

// ------------------------------------------------------------------ Aula (docente)

public record AsignaturaResumenDto(
    string Asignatura, int PartidasCompletadas, decimal PorcentajeAciertos, long AsignaturaId = 0, long Puntos = 0);

public record EstudianteEstadisticasDto(
    Guid EstudianteId, string NombreMostrar, string? NombreUsuario, int PartidasCompletadas, int PreguntasEvaluadas,
    int AciertosPrimerIntento, decimal PorcentajeAciertos, long PuntosTotales, DateTime? UltimaActividadEn,
    IReadOnlyList<AsignaturaResumenDto> PorAsignatura);

public record EstadisticasAulaDto(
    Guid AulaId, string Nombre, int TotalEstudiantes, int PartidasCompletadas, decimal PorcentajeAciertosPromedio,
    IReadOnlyList<EstudianteEstadisticasDto> Estudiantes);

// ------------------------------------------------------------------ Ranking (docente)

/// <summary>Estudiantes con empate en puntos comparten posición. Un estudiante en varias aulas del docente aparece una vez.</summary>
public record FilaRankingDto(
    int Posicion, Guid EstudianteId, string NombreMostrar, string? NombreUsuario, IReadOnlyList<string> Aulas,
    long Puntos, int PartidasCompletadas, decimal PorcentajeAciertos);

public record RankingDto(Guid? AulaId, long? AsignaturaId, IReadOnlyList<FilaRankingDto> Filas);
