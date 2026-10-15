namespace GENIOS.Application.Aulas;

public record SolicitudCrearAula(string Nombre, string? Descripcion, short? Grado = null, string? Seccion = null);

/// <summary>Edición parcial: lo que no se envía no cambia. El código de acceso nunca se regenera.</summary>
public record SolicitudEditarAula(string? Nombre, string? Descripcion, short? Grado, string? Seccion);

public record SolicitudCodigoAula(string CodigoAula);

/// <summary>El código de acceso solo se muestra al docente dueño del aula.</summary>
public record AulaDto(
    Guid Id, string Nombre, string Estado, string? CodigoAcceso, short? Grado = null, string? Seccion = null,
    string? Descripcion = null, int TotalEstudiantes = 0);

public record CodigoAulaValidoDto(string NombreAula);

public record EstudianteAulaDto(Guid Id, string NombreMostrar, string? NombreUsuario, DateTime UnidoEn);
