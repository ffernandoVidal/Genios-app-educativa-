using GENIOS.Application.Partidas;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace GENIOS.Api.Controllers;

[Route("api/v1/partidas")]
[Authorize(AuthenticationSchemes = EsquemasJuego, Roles = RolesJuego)]
public class PartidasController(IServicioPartidas servicio) : ControladorBase
{
    [HttpPost]
    public async Task<ActionResult<PartidaDto>> Crear(SolicitudCrearPartida solicitud, CancellationToken ct) =>
        await servicio.CrearAsync(Propietario, solicitud, ct);

    [HttpGet("{partidaId:guid}")]
    public async Task<ActionResult<PartidaDto>> Obtener(Guid partidaId, CancellationToken ct) =>
        await servicio.ObtenerAsync(Propietario, partidaId, ct);

    [HttpGet("{partidaId:guid}/pregunta-actual")]
    public async Task<ActionResult<PreguntaDto>> ObtenerPreguntaActual(Guid partidaId, CancellationToken ct) =>
        await servicio.ObtenerPreguntaActualAsync(Propietario, partidaId, ct);

    [HttpPost("{partidaId:guid}/respuestas")]
    public async Task<ActionResult<RespuestaDto>> Responder(Guid partidaId, SolicitudResponder solicitud, CancellationToken ct) =>
        await servicio.ResponderAsync(Propietario, partidaId, solicitud, ct);

    [HttpPost("{partidaId:guid}/reanudar")]
    public async Task<ActionResult<PartidaDto>> Reanudar(Guid partidaId, CancellationToken ct) =>
        await servicio.ReanudarAsync(Propietario, partidaId, ct);

    [HttpPost("{partidaId:guid}/finalizar")]
    public async Task<ActionResult<ResultadoPartidaDto>> Finalizar(Guid partidaId, CancellationToken ct) =>
        await servicio.FinalizarAsync(Propietario, partidaId, ct);

    [HttpPost("{partidaId:guid}/abandonar")]
    public async Task<IActionResult> Abandonar(Guid partidaId, CancellationToken ct)
    {
        await servicio.AbandonarAsync(Propietario, partidaId, ct);
        return NoContent();
    }

    [HttpGet("{partidaId:guid}/resultado")]
    public async Task<ActionResult<ResultadoPartidaDto>> ObtenerResultado(Guid partidaId, CancellationToken ct) =>
        await servicio.ObtenerResultadoAsync(Propietario, partidaId, ct);
}
