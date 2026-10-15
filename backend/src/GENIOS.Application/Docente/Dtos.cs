namespace GENIOS.Application.Docente;

// Todas las cifras salen de partidas válidas (completadas, con 10 preguntas evaluadas) y del primer intento.
// "rendimiento" es uno de: refuerzo | repaso | aprobado | sin_datos (lo decide ReglasRendimiento en el servidor).

public record AulaBreveDto(Guid Id, string Nombre, short? Grado);

public record PaginaDto<T>(IReadOnlyList<T> Elementos, int Pagina, int Tamano, int Total);

public record ResumenDocenteDto(
    int ClasesActivas, int EstudiantesAsignados, int EstudiantesActivosRecientes, decimal? PromedioAciertos,
    string Rendimiento, int PartidasCompletadas, DateOnly Desde, DateOnly Hasta);

public record FilaEstudianteDto(
    Guid EstudianteId, string NombreMostrar, string? NombreUsuario, IReadOnlyList<AulaBreveDto> Aulas, short? Grado,
    DateTime? UltimaActividadEn, int PartidasCompletadas, decimal? PromedioAciertos, string Rendimiento);

public record MateriaEstadisticaDto(
    long AsignaturaId, string Nombre, decimal? PromedioAciertos, string Rendimiento, int Partidas,
    decimal? VariacionPuntosPorcentuales);

public record PuntoDiaDto(DateOnly Fecha, int Partidas);

public record FichaEstudianteDto(
    Guid EstudianteId, string NombreMostrar, IReadOnlyList<AulaBreveDto> Aulas, DateTime? UltimaActividadEn,
    DateOnly Desde, DateOnly Hasta, int PartidasCompletadas, int PartidasAprobadas, decimal? PromedioAciertos,
    string Rendimiento, int? TiempoMedioSegundos, int MisionesCompletadas, int LeccionesAprobadas,
    decimal? VariacionPuntosPorcentuales, decimal? PromedioGrupoAciertos,
    IReadOnlyList<MateriaEstadisticaDto> Materias, IReadOnlyList<PuntoDiaDto> PartidasPorDia);

public record DiaActividadDto(DateOnly Fecha, int Partidas, int TiempoActivoSegundos, IReadOnlyList<string> Materias);

public record ActividadMesDto(int Anio, int Mes, IReadOnlyList<DiaActividadDto> Dias);

public record LeccionEstadoDto(long CategoriaId, string Nombre, bool Aprobada, int Intentos, int? MejorAciertos);

public record EvaluacionDto(DateTime Fecha, string Leccion, int Aciertos, int Evaluadas, decimal Porcentaje, string Rendimiento);

public record ErrorFrecuenteDto(string Enunciado, int Errores, int Veces);

public record DetalleMateriaDto(
    long AsignaturaId, string Nombre, decimal? PromedioAciertos, string Rendimiento, int Partidas,
    int? TiempoMedioSegundos, int MisionesTrabajadas, int LeccionesAprobadas, int LeccionesPendientes,
    IReadOnlyList<LeccionEstadoDto> Lecciones, IReadOnlyList<EvaluacionDto> Historial,
    IReadOnlyList<ErrorFrecuenteDto> ErroresFrecuentes);

public record DistribucionRendimientoDto(int Refuerzo, int Repaso, int Aprobado, int SinDatos);

public record MateriaClaseDto(long AsignaturaId, string Nombre, decimal? PromedioAciertos, string Rendimiento, int Partidas);

public record SemanaClaseDto(DateOnly Inicio, int Partidas, decimal? PromedioAciertos);

public record EstadisticasClaseDto(
    Guid AulaId, string Nombre, short? Grado, DateOnly Desde, DateOnly Hasta, int TotalEstudiantes,
    int EstudiantesActivos, int PartidasCompletadas, decimal? PromedioAciertos, string Rendimiento,
    DistribucionRendimientoDto Distribucion, IReadOnlyList<MateriaClaseDto> MateriasPorDificultad,
    IReadOnlyList<SemanaClaseDto> EvolucionSemanal);
