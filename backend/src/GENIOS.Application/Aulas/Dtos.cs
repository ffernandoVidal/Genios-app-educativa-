namespace GENIOS.Application.Aulas;

public record SolicitudCrearAula(string Nombre, string? Descripcion);

public record SolicitudCodigoAula(string CodigoAula);

/// <summary>El código de acceso solo se muestra al docente dueño del aula.</summary>
public record AulaDto(Guid Id, string Nombre, string Estado, string? CodigoAcceso);

public record CodigoAulaValidoDto(string NombreAula);

public record EstudianteAulaDto(Guid Id, string NombreMostrar, string? NombreUsuario, DateTime UnidoEn);
