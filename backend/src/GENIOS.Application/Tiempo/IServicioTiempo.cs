namespace GENIOS.Application.Tiempo;

public record UsoDiarioDto(int MinutosUsados, int MinutosLimite, int MinutosRestantes, bool LimiteAlcanzado);

/// <summary>DeltaMs es el tiempo que esta actividad sumó al día (máximo el umbral de inactividad).</summary>
public record ActividadRegistrada(long DeltaMs, long UsadoMs, long LimiteMs)
{
    public bool LimiteAlcanzado => UsadoMs >= LimiteMs;
}

public interface IServicioTiempo
{
    /// <summary>Suma al día el tiempo transcurrido desde la actividad anterior, con tope por inactividad.</summary>
    Task<ActividadRegistrada> RegistrarActividadAsync(Guid estudianteId, CancellationToken ct);

    Task<UsoDiarioDto> ObtenerUsoAsync(Guid estudianteId, CancellationToken ct);

    /// <summary>Señal explícita de que el estudiante sigue activo (por ejemplo, pensando una respuesta).</summary>
    Task<UsoDiarioDto> RegistrarLatidoAsync(Guid estudianteId, CancellationToken ct);
}
