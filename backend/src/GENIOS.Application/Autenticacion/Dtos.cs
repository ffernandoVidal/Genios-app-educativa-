namespace GENIOS.Application.Autenticacion;

public record SolicitudRegistroEstudiante(string? CodigoAula, string NombreUsuario, string Contrasena, string NombreMostrar);

public record SolicitudInicioSesionEstudiante(string NombreUsuario, string Contrasena);

public record SolicitudGoogle(string IdToken);

public record SolicitudConfirmarRestablecimiento(string NombreUsuario, string Codigo, string ContrasenaNueva);

public record UsuarioDto(Guid Id, string NombreMostrar, string? NombreUsuario, string? Correo, IReadOnlyList<string> Roles);

/// <summary>Lo que recibe el cliente. El token de renovación viaja aparte, en una cookie HttpOnly.</summary>
public record RespuestaAutenticacion(string TokenAcceso, int ExpiraEnSegundos, UsuarioDto Usuario);

public record ResultadoSesion(RespuestaAutenticacion Respuesta, string TokenRenovacion, DateTime ExpiraTokenRenovacion);

public record CodigoRestablecimientoDto(string Codigo, DateTime ExpiraEn);

/// <summary>El docente da de alta a un estudiante en su aula. La contraseña la elige el propio estudiante con un código temporal.</summary>
public record SolicitudCrearEstudianteEnAula(string NombreMostrar, string NombreUsuario);

public record EstudianteCreadoDto(Guid Id, string NombreMostrar, string NombreUsuario, string CodigoActivacion, DateTime ExpiraEn);
