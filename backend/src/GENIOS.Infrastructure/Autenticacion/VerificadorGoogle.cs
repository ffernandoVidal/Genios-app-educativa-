using GENIOS.Domain.Exceptions;
using Google.Apis.Auth;
using Microsoft.Extensions.Options;

namespace GENIOS.Infrastructure.Autenticacion;

public record DatosGoogle(string Sub, string Correo, string Nombre);

public class VerificadorGoogle(IOptions<OpcionesAutenticacion> opciones)
{
    /// <summary>Valida firma, vencimiento y audiencia del idToken con las claves públicas de Google.</summary>
    public async Task<DatosGoogle> ValidarAsync(string idToken)
    {
        var clientId = opciones.Value.GoogleClientId;
        if (string.IsNullOrWhiteSpace(clientId))
            throw new ExcepcionNegocio(TipoError.NoDisponible, "google_no_configurado",
                "El inicio de sesión con Google no está disponible.");

        GoogleJsonWebSignature.Payload datos;
        try
        {
            datos = await GoogleJsonWebSignature.ValidateAsync(idToken,
                new GoogleJsonWebSignature.ValidationSettings { Audience = [clientId] });
        }
        catch (InvalidJwtException)
        {
            throw new ExcepcionNegocio(TipoError.NoAutenticado, "google_token_invalido",
                "No se pudo validar la cuenta de Google.");
        }

        if (!datos.EmailVerified || string.IsNullOrWhiteSpace(datos.Email))
            throw new ExcepcionNegocio(TipoError.NoAutenticado, "google_correo_no_verificado",
                "El correo de Google no está verificado.");

        return new DatosGoogle(datos.Subject, datos.Email, datos.Name ?? datos.Email);
    }
}
