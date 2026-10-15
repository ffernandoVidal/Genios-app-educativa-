namespace GENIOS.Infrastructure.Juego;

/// <summary>Sección "Juego" de la configuración. Valores iniciales del MVP, sujetos a validación final.</summary>
public class OpcionesJuego
{
    public const string Seccion = "Juego";

    public int MinutosDiarios { get; set; } = 90;
    public int UmbralInactividadSegundos { get; set; } = 60;
    public string ZonaHoraria { get; set; } = "America/Guatemala";
    public int VentanaReanudacionMinutos { get; set; } = 10;
    public int SegundosMecha { get; set; } = 30;

    /// <summary>Vigencia absoluta de una sesión de invitado desde que se crea.</summary>
    public int DiasVigenciaInvitado { get; set; } = 30;
}
