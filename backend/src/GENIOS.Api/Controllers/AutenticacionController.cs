using GENIOS.Application.Autenticacion;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.RateLimiting;

namespace GENIOS.Api.Controllers;

[Route("api/v1/autenticacion")]
public class AutenticacionController(IServicioAutenticacion servicio) : ControladorBase
{
    [HttpPost("estudiante/iniciar-sesion")]
    [EnableRateLimiting("autenticacion")]
    public async Task<ActionResult<RespuestaAutenticacion>> IniciarSesionEstudiante(SolicitudInicioSesionEstudiante solicitud, CancellationToken ct) =>
        ResponderSesion(await servicio.IniciarSesionEstudianteAsync(solicitud, Contexto, ct));

    [HttpPost("google")]
    [EnableRateLimiting("autenticacion")]
    public async Task<ActionResult<RespuestaAutenticacion>> IniciarSesionGoogle(SolicitudGoogle solicitud, CancellationToken ct) =>
        ResponderSesion(await servicio.IniciarSesionGoogleAsync(solicitud, Contexto, ct));

    [HttpPost("renovar")]
    [EnableRateLimiting("autenticacion")]
    public async Task<ActionResult<RespuestaAutenticacion>> Renovar(CancellationToken ct) =>
        ResponderSesion(await servicio.RenovarAsync(LeerCookieRenovacion(), Contexto, ct));

    [HttpPost("cerrar-sesion")]
    public async Task<IActionResult> CerrarSesion(CancellationToken ct)
    {
        await servicio.CerrarSesionAsync(LeerCookieRenovacion(), ct);
        BorrarCookieRenovacion();
        return NoContent();
    }
}
