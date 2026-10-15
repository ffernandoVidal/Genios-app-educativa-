namespace GENIOS.Domain.Rules;

public record OperacionGenerada(string Enunciado, int Respuesta, IReadOnlyList<int> Opciones);

/// <summary>Genera operaciones con opciones múltiples. Solo usa enteros no negativos y nunca divide entre cero.</summary>
public static class GeneradorOperaciones
{
    private const int CantidadOpciones = 4;
    private const int MaximoPermitido = 1000;

    public static OperacionGenerada Generar(string operacion, int minimo, int maximo, Random azar)
    {
        if (minimo < 1 || maximo < minimo || maximo > MaximoPermitido)
            throw new ArgumentException("Rango numérico inválido para la generación de operaciones.");

        int a = azar.Next(minimo, maximo + 1);
        int b = azar.Next(minimo, maximo + 1);
        string enunciado;
        int respuesta;

        switch (operacion)
        {
            case "suma":
                enunciado = $"{a} + {b} = ?";
                respuesta = a + b;
                break;
            case "resta":
                if (a < b) (a, b) = (b, a); // el resultado nunca es negativo
                enunciado = $"{a} - {b} = ?";
                respuesta = a - b;
                break;
            case "multiplicacion":
                enunciado = $"{a} × {b} = ?";
                respuesta = a * b;
                break;
            case "division":
                // Se parte del cociente para que la división sea exacta; el divisor es >= 1.
                enunciado = $"{a * b} ÷ {b} = ?";
                respuesta = a;
                break;
            default:
                throw new ArgumentException($"Operación no soportada: {operacion}");
        }

        return new OperacionGenerada(enunciado, respuesta, CrearOpciones(respuesta, azar));
    }

    /// <summary>La respuesta correcta más tres distractores distintos y no negativos, en orden aleatorio.</summary>
    private static List<int> CrearOpciones(int respuesta, Random azar)
    {
        var candidatos = new List<int>();
        for (var distancia = 1; distancia <= 10; distancia++)
        {
            candidatos.Add(respuesta + distancia);
            if (respuesta - distancia >= 0) candidatos.Add(respuesta - distancia);
        }

        var opciones = candidatos.OrderBy(_ => azar.Next()).Take(CantidadOpciones - 1).ToList();
        opciones.Add(respuesta);
        return opciones.OrderBy(_ => azar.Next()).ToList();
    }
}
