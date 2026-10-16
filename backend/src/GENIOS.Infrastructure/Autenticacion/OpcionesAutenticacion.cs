namespace GENIOS.Infrastructure.Autenticacion;

/// <summary>Sección "Autenticacion" de la configuración. La clave se entrega por variable de entorno.</summary>
public class OpcionesAutenticacion
{
    public const string Seccion = "Autenticacion";

    public string Clave { get; set; } = "";
    public string Emisor { get; set; } = "GENIOS";
    public string Audiencia { get; set; } = "GENIOS.Clientes";
    public int MinutosAcceso { get; set; } = 15;
    /// <summary>Vigencia de cada token de renovación, que se rota en cada uso.</summary>
    public int DiasRenovacion { get; set; } = 30;

    /// <summary>Duración absoluta de una sesión desde su inicio de sesión: renovar nunca la extiende más allá de esto.</summary>
    public int DiasMaximosSesion { get; set; } = 30;
    public string GoogleClientId { get; set; } = "";

    /// <summary>Cookie del token de renovación. En desarrollo local (http) se desactiva la marca Secure.</summary>
    public bool CookieSegura { get; set; } = true;
    public string CookieSameSite { get; set; } = "Lax";


}
