namespace GENIOS.Domain.Rules;

public enum NivelRendimiento
{
    SinDatos,
    Refuerzo,
    Repaso,
    Aprobado
}

/// <summary>
/// Única fuente de la clasificación de rendimiento (la usan todos los servicios y el cliente solo la muestra):
/// menos de 40 % = REFUERZO; de 40 % a 60 % inclusive = REPASO; más de 60 % = APROBADO; sin partidas = SIN DATOS.
/// Se clasifica con el valor exacto, sin redondear: un promedio de 60,4 % es APROBADO aunque se muestre como 60 %.
/// </summary>
public static class ReglasRendimiento
{
    public const decimal LimiteRefuerzoExclusivo = 40m;
    public const decimal LimiteRepasoInclusivo = 60m;

    /// <summary>Aciertos al primer intento mínimos para aprobar una partida de diez preguntas.</summary>
    public const int AciertosParaAprobarPartida = 7;

    public static NivelRendimiento Clasificar(decimal? porcentaje) => porcentaje switch
    {
        null => NivelRendimiento.SinDatos,
        < LimiteRefuerzoExclusivo => NivelRendimiento.Refuerzo,
        <= LimiteRepasoInclusivo => NivelRendimiento.Repaso,
        _ => NivelRendimiento.Aprobado
    };

    /// <summary>Clasifica con la proporción exacta; sin preguntas evaluadas no hay datos (no es REFUERZO).</summary>
    public static NivelRendimiento Clasificar(int aciertosPrimerIntento, int preguntasEvaluadas) =>
        preguntasEvaluadas <= 0 ? NivelRendimiento.SinDatos : Clasificar(aciertosPrimerIntento * 100m / preguntasEvaluadas);

    public static string Codigo(NivelRendimiento nivel) => nivel switch
    {
        NivelRendimiento.Refuerzo => "refuerzo",
        NivelRendimiento.Repaso => "repaso",
        NivelRendimiento.Aprobado => "aprobado",
        _ => "sin_datos"
    };
}
