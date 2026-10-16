using GENIOS.Application.Autenticacion;
using GENIOS.Domain.Rules;
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

    /// <summary>Elige estudiante o docente (identidad nueva de Google sin rol). Permanente; el servidor lo valida.</summary>
    [HttpPost("rol")]
    [Authorize]
    [EnableRateLimiting("autenticacion")]
    public async Task<ActionResult<RespuestaAutenticacion>> ElegirRol(SolicitudElegirRol solicitud, CancellationToken ct) =>
        await servicio.ConfirmarRolAsync(UsuarioId, solicitud.Rol, Contexto, ct);

    /// <summary>Compatibilidad: equivale a elegir el rol docente.</summary>
    [HttpPost("docente/confirmar")]
    [Authorize]
    [EnableRateLimiting("autenticacion")]
    public async Task<ActionResult<RespuestaAutenticacion>> ConfirmarDocente(CancellationToken ct) =>
        await servicio.ConfirmarRolAsync(UsuarioId, CodigosRol.Docente, Contexto, ct);

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
