using GENIOS.Application.Comun;

namespace GENIOS.Application.Docente;

/// <summary>Período en días locales (America/Guatemala). Si no se indica, son los últimos 30 días.</summary>
public record PeriodoSolicitado(DateOnly? Desde, DateOnly? Hasta, int? Dias);

public record FiltroEstudiantes(
    string? Busqueda, Guid? AulaId, short? Grado, string? Rendimiento, string? Orden, int Pagina, int Tamano);

/// <summary>
/// Consultas del Centro de Control Docente. El docente solo ve a estudiantes ACTIVOS de aulas propias y activas;
/// ante un estudiante o aula ajenos la respuesta es 404 y queda un registro de auditoría.
/// </summary>
public interface IServicioDocente
{
    Task<ResumenDocenteDto> ObtenerResumenAsync(Guid docenteId, PeriodoSolicitado periodo, CancellationToken ct);
    Task<PaginaDto<FilaEstudianteDto>> ListarEstudiantesAsync(Guid docenteId, FiltroEstudiantes filtro, PeriodoSolicitado periodo, ContextoSolicitud contexto, CancellationToken ct);
    Task<FichaEstudianteDto> ObtenerFichaAsync(Guid docenteId, Guid estudianteId, PeriodoSolicitado periodo, ContextoSolicitud contexto, CancellationToken ct);
    Task<ActividadMesDto> ObtenerActividadAsync(Guid docenteId, Guid estudianteId, int anio, int mes, ContextoSolicitud contexto, CancellationToken ct);
    Task<DetalleMateriaDto> ObtenerDetalleMateriaAsync(Guid docenteId, Guid estudianteId, long asignaturaId, ContextoSolicitud contexto, CancellationToken ct);
    Task<EstadisticasClaseDto> ObtenerEstadisticasClaseAsync(Guid docenteId, Guid aulaId, PeriodoSolicitado periodo, ContextoSolicitud contexto, CancellationToken ct);
}
