using GENIOS.Api.Configuration;
using GENIOS.Application.Autenticacion;
using GENIOS.Domain.Rules;
using GENIOS.Application.Comun;
using GENIOS.Domain.Exceptions;
using GENIOS.Infrastructure.Autenticacion;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Options;

namespace GENIOS.Api.Controllers;

[ApiController]
public abstract class ControladorBase : ControllerBase
{
    private const string NombreCookie = "genios_renovacion";
    private const string RutaCookie = "/api/v1/autenticacion";
    private const string CabeceraAnticsrf = "X-GENIOS-CSRF";

    /// <summary>Identificador del usuario autenticado, tomado del token y nunca de la solicitud.</summary>
    protected Guid UsuarioId => Guid.Parse(User.FindFirst("sub")!.Value);

    protected ContextoSolicitud Contexto =>
        new(HttpContext.Connection.RemoteIpAddress?.ToString(), Request.Headers.UserAgent.ToString());

    /// <summary>Esquemas y roles con los que se puede jugar: estudiante con cuenta o sesión de invitado.</summary>
    protected const string EsquemasJuego = "Bearer," + ManejadorAutenticacionInvitado.Esquema;
    protected const string RolesJuego = CodigosRol.Estudiante + "," + CodigosRol.Invitado;

    /// <summary>Quién juega. Un estudiante con cuenta tiene prioridad sobre una cookie de invitado.</summary>
    protected Propietario Propietario => User.IsInRole(CodigosRol.Estudiante)
        ? Propietario.DeUsuario(UsuarioId)
        : Propietario.DeInvitado(Guid.Parse(User.FindFirst("sid")!.Value));

    /// <summary>Guarda la sesión de invitado en una cookie HttpOnly. El token no viaja en el cuerpo.</summary>
    protected void GuardarCookieInvitado(string token, DateTime expira) =>
        Response.Cookies.Append(ManejadorAutenticacionInvitado.NombreCookie, token, new CookieOptions
        {
            HttpOnly = true,
            Secure = Opciones.CookieSegura,
            SameSite = Enum.Parse<SameSiteMode>(Opciones.CookieSameSite, ignoreCase: true),
            Expires = expira,
            Path = "/"
        });

    private OpcionesAutenticacion Opciones =>
        HttpContext.RequestServices.GetRequiredService<IOptions<OpcionesAutenticacion>>().Value;

    /// <summary>Guarda el token de renovación en una cookie HttpOnly y devuelve solo el token de acceso.</summary>
    protected ActionResult<RespuestaAutenticacion> ResponderSesion(ResultadoSesion resultado)
    {
        Response.Cookies.Append(NombreCookie, resultado.TokenRenovacion, new CookieOptions
        {
            HttpOnly = true,
            Secure = Opciones.CookieSegura,
            SameSite = Enum.Parse<SameSiteMode>(Opciones.CookieSameSite, ignoreCase: true),
            Expires = resultado.ExpiraTokenRenovacion,
            Path = RutaCookie
        });
        return Ok(resultado.Respuesta);
    }

    /// <summary>Lee la cookie de renovación. Exige una cabecera propia, que un sitio ajeno no puede enviar sin permiso de CORS.</summary>
    protected string LeerCookieRenovacion()
    {
        if (!Request.Headers.ContainsKey(CabeceraAnticsrf))
            throw new ExcepcionNegocio(TipoError.Prohibido, "cabecera_requerida", "Solicitud no permitida.");
        return Request.Cookies[NombreCookie]
            ?? throw new ExcepcionNegocio(TipoError.NoAutenticado, "sesion_invalida", "Inicia sesión de nuevo.");
    }

    protected void BorrarCookieRenovacion() => Response.Cookies.Delete(NombreCookie, new CookieOptions { Path = RutaCookie });
}
