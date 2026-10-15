namespace GENIOS.Domain.Rules;

public static class ReglasJuego
{
    public const int PreguntasPorPartida = 10;
    public const int ErroresParaMecha = 3;
    public const int PuntosBonoCategoria = 20;

    public static int PuntosPorRespuesta(string dificultad) => dificultad switch
    {
        "intermedia" => 15,
        "avanzada" => 20,
        _ => 10 // inicial y basica
    };

    public static decimal PorcentajeAciertos(int aciertosPrimerIntento, int preguntasEvaluadas) =>
        preguntasEvaluadas == 0 ? 0 : Math.Round(aciertosPrimerIntento * 100m / preguntasEvaluadas, 1);
}
