using GENIOS.Api.Configuration;
using GENIOS.Application.Invitados;
using GENIOS.Domain.Rules;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.RateLimiting;

namespace GENIOS.Api.Controllers;

[Route("api/v1/sesiones-juego")]
public class SesionesJuegoController(IServicioInvitados servicio) : ControladorBase
{
    /// <summary>Crea una sesión de invitado, o reutiliza la de la cookie si sigue vigente.</summary>
    [HttpPost]
    [EnableRateLimiting("autenticacion")]
    public async Task<ActionResult<SesionInvitadoDto>> Crear(CancellationToken ct)
    {
        Request.Cookies.TryGetValue(ManejadorAutenticacionInvitado.NombreCookie, out var tokenActual);
        var resultado = await servicio.CrearOReutilizarAsync(tokenActual, ct);
        if (resultado.TokenNuevo is not null) GuardarCookieInvitado(resultado.TokenNuevo, resultado.ExpiraEn);
        return resultado.Estado;
    }

    /// <summary>Progreso hacia la invitación a registrarse.</summary>
    [HttpGet("yo")]
    [Authorize(AuthenticationSchemes = ManejadorAutenticacionInvitado.Esquema, Roles = CodigosRol.Invitado)]
    public async Task<ActionResult<SesionInvitadoDto>> ObtenerEstado(CancellationToken ct) =>
        await servicio.ObtenerEstadoAsync(Propietario.SesionInvitadoId!.Value, ct);
}
