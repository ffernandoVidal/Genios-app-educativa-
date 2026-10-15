namespace GENIOS.Infrastructure.Autenticacion;

/// <summary>Sección "Autenticacion" de la configuración. La clave se entrega por variable de entorno.</summary>
public class OpcionesAutenticacion
{
    public const string Seccion = "Autenticacion";

    public string Clave { get; set; } = "";
    public string Emisor { get; set; } = "GENIOS";
    public string Audiencia { get; set; } = "GENIOS.Clientes";
    public int MinutosAcceso { get; set; } = 15;
    public int DiasRenovacion { get; set; } = 7;
    public string GoogleClientId { get; set; } = "";

    /// <summary>Cookie del token de renovación. En desarrollo local (http) se desactiva la marca Secure.</summary>
    public bool CookieSegura { get; set; } = true;
    public string CookieSameSite { get; set; } = "Lax";

    /// <summary>Dominios de correo cuyos docentes se verifican solos. Vacío = ninguno.</summary>
    public string[] DominiosDocentes { get; set; } = [];
}
