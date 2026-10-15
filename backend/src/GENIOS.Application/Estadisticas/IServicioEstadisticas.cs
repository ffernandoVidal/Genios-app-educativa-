using GENIOS.Application.Comun;

namespace GENIOS.Application.Estadisticas;

public interface IServicioEstadisticas
{
    Task<ProgresoEstudianteDto> ObtenerProgresoAsync(Guid estudianteId, CancellationToken ct);
    Task<EstadisticasEstudianteDto> ObtenerEstadisticasAsync(Guid estudianteId, CancellationToken ct);
    Task<PuntosEstudianteDto> ObtenerPuntosAsync(Guid estudianteId, CancellationToken ct);

    /// <summary>Solo el docente dueño del aula; incluye únicamente a los estudiantes activos de esa aula.</summary>
    Task<EstadisticasAulaDto> ObtenerEstadisticasAulaAsync(Guid docenteId, Guid aulaId, ContextoSolicitud contexto, CancellationToken ct);
}
