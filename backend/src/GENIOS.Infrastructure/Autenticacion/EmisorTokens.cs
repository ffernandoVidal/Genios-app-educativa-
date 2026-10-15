using System.Security.Claims;
using System.Security.Cryptography;
using System.Text;
using GENIOS.Domain.Exceptions;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.JsonWebTokens;
using Microsoft.IdentityModel.Tokens;

namespace GENIOS.Infrastructure.Autenticacion;

public class EmisorTokens(IOptions<OpcionesAutenticacion> opciones)
{
    private readonly OpcionesAutenticacion _opciones = opciones.Value;

    public int SegundosAcceso => _opciones.MinutosAcceso * 60;

    public string CrearTokenAcceso(Guid usuarioId, IEnumerable<string> roles)
    {
        var claims = new List<Claim> { new("sub", usuarioId.ToString()) };
        claims.AddRange(roles.Select(rol => new Claim("role", rol)));

        var descriptor = new SecurityTokenDescriptor
        {
            Subject = new ClaimsIdentity(claims),
            Issuer = _opciones.Emisor,
            Audience = _opciones.Audiencia,
            Expires = DateTime.UtcNow.AddMinutes(_opciones.MinutosAcceso),
            SigningCredentials = new SigningCredentials(CrearClave(_opciones), SecurityAlgorithms.HmacSha256)
        };
        return new JsonWebTokenHandler().CreateToken(descriptor);
    }

    /// <summary>Token aleatorio para el cliente y su hash, que es lo único que se guarda.</summary>
    public (string Token, string Hash) CrearTokenRenovacion()
    {
        var token = Base64UrlEncoder.Encode(RandomNumberGenerator.GetBytes(32));
        return (token, CalcularHash(token));
    }

    public string CalcularHash(string valor) =>
        Convert.ToHexString(SHA256.HashData(Encoding.UTF8.GetBytes(valor)));

    public static TokenValidationParameters ParametrosValidacion(OpcionesAutenticacion opciones) => new()
    {
        ValidIssuer = opciones.Emisor,
        ValidAudience = opciones.Audiencia,
        // Sin clave configurada ningún token valida (401); el error solo aparece al emitir tokens.
        IssuerSigningKey = opciones.Clave.Length >= 32 ? CrearClave(opciones) : null,
        NameClaimType = "sub",
        RoleClaimType = "role",
        ClockSkew = TimeSpan.FromSeconds(30)
    };

    private static SymmetricSecurityKey CrearClave(OpcionesAutenticacion opciones)
    {
        if (opciones.Clave.Length < 32)
            throw new ExcepcionNegocio(TipoError.NoDisponible, "autenticacion_no_configurada",
                "La autenticación no está configurada.");
        return new SymmetricSecurityKey(Encoding.UTF8.GetBytes(opciones.Clave));
    }
}
