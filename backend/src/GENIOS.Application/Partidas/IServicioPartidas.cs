using GENIOS.Application.Comun;

namespace GENIOS.Application.Partidas;

public interface IServicioPartidas
{
    Task<PartidaDto> CrearAsync(Propietario propietario, SolicitudCrearPartida solicitud, CancellationToken ct);
    Task<PartidaDto> ObtenerAsync(Propietario propietario, Guid partidaId, CancellationToken ct);
    Task<PreguntaDto> ObtenerPreguntaActualAsync(Propietario propietario, Guid partidaId, CancellationToken ct);
    Task<RespuestaDto> ResponderAsync(Propietario propietario, Guid partidaId, SolicitudResponder solicitud, CancellationToken ct);
    Task<PartidaDto> ReanudarAsync(Propietario propietario, Guid partidaId, CancellationToken ct);
    Task<ResultadoPartidaDto> FinalizarAsync(Propietario propietario, Guid partidaId, CancellationToken ct);
    Task AbandonarAsync(Propietario propietario, Guid partidaId, CancellationToken ct);
    Task<ResultadoPartidaDto> ObtenerResultadoAsync(Propietario propietario, Guid partidaId, CancellationToken ct);
}
