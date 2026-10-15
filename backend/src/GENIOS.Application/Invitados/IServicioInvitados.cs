namespace GENIOS.Application.Invitados;

/// <summary>
/// PartidasValidas: completadas. PartidasQueCuentan: completadas con más del 61 % de aciertos al primer intento.
/// InvitarARegistrarse es verdadero cuando PartidasQueCuentan alcanza las requeridas.
/// </summary>
public record SesionInvitadoDto(
    DateTime ExpiraEn, int PartidasValidas, int PartidasQueCuentan, int PartidasRequeridas,
    bool InvitarARegistrarse, string AvisoProgreso);

/// <summary>TokenNuevo solo viene cuando se creó una sesión; el controlador lo entrega en una cookie HttpOnly.</summary>
public record ResultadoSesionInvitado(SesionInvitadoDto Estado, string? TokenNuevo, DateTime ExpiraEn);

public interface IServicioInvitados
{
    /// <summary>Reutiliza la sesión de la cookie si sigue vigente; si no, crea una nueva y vacía.</summary>
    Task<ResultadoSesionInvitado> CrearOReutilizarAsync(string? tokenActual, CancellationToken ct);

    /// <summary>Devuelve el id de la sesión si el token es válido y no expiró; null en otro caso.</summary>
    Task<Guid?> ValidarTokenAsync(string token, CancellationToken ct);

    Task<SesionInvitadoDto> ObtenerEstadoAsync(Guid sesionInvitadoId, CancellationToken ct);
}
