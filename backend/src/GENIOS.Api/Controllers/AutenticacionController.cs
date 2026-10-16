using GENIOS.Application.Autenticacion;
using Microsoft.AspNetCore.Authorization;
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

    /// <summary>Confirma el rol docente de una identidad nueva de Google. Permanente; el rol lo decide el servidor.</summary>
    [HttpPost("docente/confirmar")]
    [Authorize]
    [EnableRateLimiting("autenticacion")]
    public async Task<ActionResult<RespuestaAutenticacion>> ConfirmarDocente(CancellationToken ct) =>
        await servicio.ConfirmarRolDocenteAsync(UsuarioId, Contexto, ct);

    /// <summary>Idempotente: funciona igual con o sin sesión. Siempre limpia las cookies de renovación y de invitado.</summary>
    [HttpPost("cerrar-sesion")]
    public async Task<IActionResult> CerrarSesion(CancellationToken ct)
    {
        await servicio.CerrarSesionAsync(LeerCookieRenovacionOpcional(), ct);
        BorrarCookieRenovacion();
        BorrarCookieInvitado();
        return NoContent();
    }
}
