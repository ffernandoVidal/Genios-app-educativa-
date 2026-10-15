namespace GENIOS.Application.Comun;

/// <summary>Quién juega: un estudiante autenticado o una sesión de invitado. Siempre exactamente uno.</summary>
public record Propietario(Guid? UsuarioId, Guid? SesionInvitadoId)
{
    public bool EsInvitado => SesionInvitadoId is not null;

    public static Propietario DeUsuario(Guid usuarioId) => new(usuarioId, null);
    public static Propietario DeInvitado(Guid sesionInvitadoId) => new(null, sesionInvitadoId);
}
