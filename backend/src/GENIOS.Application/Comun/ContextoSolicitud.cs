namespace GENIOS.Application.Comun;

/// <summary>Datos de la solicitud HTTP que se necesitan para la auditoría.</summary>
public record ContextoSolicitud(string? Ip, string? Agente);
