namespace GENIOS.Domain.Rules;

public static class ReglasInvitado
{
    public const int PartidasRequeridas = 3;
    public const int PorcentajeMinimoExclusivo = 61;

    public const string AvisoProgresoAnonimo =
        "Si no te registras, tu progreso como invitado no se guardará en una cuenta.";

    /// <summary>La partida cuenta si supera el 61 % de aciertos al primer intento (con 10 preguntas, al menos 7).</summary>
    public static bool SuperaMinimo(int aciertosPrimerIntento, int preguntasEvaluadas) =>
        preguntasEvaluadas > 0 && aciertosPrimerIntento * 100m / preguntasEvaluadas > PorcentajeMinimoExclusivo;
}
