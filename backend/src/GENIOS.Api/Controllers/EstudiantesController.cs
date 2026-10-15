using GENIOS.Application.Aulas;
using GENIOS.Application.Autenticacion;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.RateLimiting;

namespace GENIOS.Api.Controllers;

[Route("api/v1/estudiantes")]
[EnableRateLimiting("autenticacion")]
public class EstudiantesController(IServicioAutenticacion autenticacion, IServicioAulas aulas) : ControladorBase
{
    [HttpPost("registro")]
    public async Task<ActionResult<RespuestaAutenticacion>> Registrar(SolicitudRegistroEstudiante solicitud, CancellationToken ct) =>
        ResponderSesion(await autenticacion.RegistrarEstudianteAsync(solicitud, Contexto, ct));

    [HttpPost("validar-codigo-aula")]
    public async Task<ActionResult<CodigoAulaValidoDto>> ValidarCodigoAula(SolicitudCodigoAula solicitud, CancellationToken ct) =>
        await aulas.ValidarCodigoAsync(solicitud.CodigoAula, ct);

    [HttpPost("restablecimiento-confirmar")]
    public async Task<IActionResult> ConfirmarRestablecimiento(SolicitudConfirmarRestablecimiento solicitud, CancellationToken ct)
    {
        await autenticacion.ConfirmarRestablecimientoAsync(solicitud, Contexto, ct);
        return NoContent();
    }
}
