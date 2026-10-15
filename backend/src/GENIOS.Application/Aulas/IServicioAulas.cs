namespace GENIOS.Application.Aulas;

public interface IServicioAulas
{
    Task<AulaDto> CrearAsync(Guid docenteId, SolicitudCrearAula solicitud, CancellationToken ct);
    Task<IReadOnlyList<AulaDto>> ListarMisAulasAsync(Guid usuarioId, bool esDocente, CancellationToken ct);
    Task<AulaDto> EditarAsync(Guid docenteId, Guid aulaId, SolicitudEditarAula solicitud, CancellationToken ct);
    /// <summary>Archiva el aula (eliminación lógica): conserva miembros, partidas y estadísticas.</summary>
    Task ArchivarAsync(Guid docenteId, Guid aulaId, CancellationToken ct);
    Task<CodigoAulaValidoDto> ValidarCodigoAsync(string codigoAula, CancellationToken ct);
    Task<AulaDto> UnirseAsync(Guid estudianteId, string codigoAula, CancellationToken ct);
    Task<IReadOnlyList<EstudianteAulaDto>> ListarEstudiantesAsync(Guid docenteId, Guid aulaId, CancellationToken ct);
    Task RetirarEstudianteAsync(Guid docenteId, Guid aulaId, Guid estudianteId, CancellationToken ct);
}
