using System.Security.Claims;
using System.Text.Encodings.Web;
using GENIOS.Application.Invitados;
using GENIOS.Domain.Rules;
using Microsoft.AspNetCore.Authentication;
using Microsoft.Extensions.Options;

namespace GENIOS.Api.Configuration;

/// <summary>Autentica sesiones de invitado a partir de la cookie HttpOnly. Genera el claim "sid" y el rol "invitado".</summary>
public class ManejadorAutenticacionInvitado(
    IOptionsMonitor<AuthenticationSchemeOptions> opciones,
    ILoggerFactory registro,
    UrlEncoder codificador,
    IServicioInvitados invitados) : AuthenticationHandler<AuthenticationSchemeOptions>(opciones, registro, codificador)
{
    public const string Esquema = "Invitado";
    public const string NombreCookie = "genios_invitado";
    public const string CabeceraAnticsrf = "X-GENIOS-CSRF";

    private static readonly string[] MetodosSeguros = ["GET", "HEAD", "OPTIONS"];

    protected override async Task<AuthenticateResult> HandleAuthenticateAsync()
    {
        if (!Request.Cookies.TryGetValue(NombreCookie, out var token) || string.IsNullOrWhiteSpace(token))
            return AuthenticateResult.NoResult();

        // Una cookie se envía sola desde cualquier sitio; la cabecera propia solo la puede enviar nuestro cliente.
        if (!MetodosSeguros.Contains(Request.Method) && !Request.Headers.ContainsKey(CabeceraAnticsrf))
            return AuthenticateResult.Fail("Falta la cabecera anti-CSRF.");

        var sesionId = await invitados.ValidarTokenAsync(token, Context.RequestAborted);
        if (sesionId is null) return AuthenticateResult.Fail("Sesión de invitado inválida o expirada.");

        var identidad = new ClaimsIdentity(
            [new Claim("sid", sesionId.Value.ToString()), new Claim("role", CodigosRol.Invitado)],
            Scheme.Name, nameType: "sid", roleType: "role");
        return AuthenticateResult.Success(new AuthenticationTicket(new ClaimsPrincipal(identidad), Scheme.Name));
    }
}
