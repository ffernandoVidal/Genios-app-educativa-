using System.Security.Cryptography;
using System.Text.RegularExpressions;

namespace GENIOS.Domain.Rules;

public static partial class ReglasCuenta
{
    public const int LargoMinimoContrasena = 6;
    public const int LargoMaximoContrasena = 100;
    public const int MinutosVigenciaCodigoRestablecimiento = 30;

    // Sin letras ni números que se confunden (0/O, 1/I).
    private const string AlfabetoCodigoTemporal = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789";

    [GeneratedRegex("^[a-z0-9_.]{3,30}$")]
    private static partial Regex FormatoNombreUsuario();

    [GeneratedRegex("^[A-Z][0-9]{4}$")]
    private static partial Regex FormatoCodigoAula();

    /// <summary>Minúsculas y sin espacios en los extremos. Devuelve null si el formato no es válido.</summary>
    public static string? NormalizarNombreUsuario(string? nombreUsuario)
    {
        var normalizado = (nombreUsuario ?? "").Trim().ToLowerInvariant();
        return FormatoNombreUsuario().IsMatch(normalizado) ? normalizado : null;
    }

    public static string NormalizarCorreo(string correo) => correo.Trim().ToLowerInvariant();

    public static bool EsContrasenaValida(string? contrasena) =>
        contrasena is not null
        && contrasena.Length >= LargoMinimoContrasena
        && contrasena.Length <= LargoMaximoContrasena;

    public static string? NormalizarCodigoAula(string? codigo)
    {
        var normalizado = (codigo ?? "").Trim().ToUpperInvariant();
        return FormatoCodigoAula().IsMatch(normalizado) ? normalizado : null;
    }

    /// <summary>Una letra mayúscula y cuatro dígitos, por ejemplo K4821.</summary>
    public static string GenerarCodigoAula() =>
        $"{(char)('A' + RandomNumberGenerator.GetInt32(26))}{RandomNumberGenerator.GetInt32(10000):D4}";

    public static string GenerarCodigoTemporal() =>
        RandomNumberGenerator.GetString(AlfabetoCodigoTemporal, 8);
}
