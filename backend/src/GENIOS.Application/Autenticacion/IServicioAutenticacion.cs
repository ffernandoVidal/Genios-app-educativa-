using GENIOS.Application.Comun;

namespace GENIOS.Application.Autenticacion;

public interface IServicioAutenticacion
{
    Task<ResultadoSesion> RegistrarEstudianteAsync(SolicitudRegistroEstudiante solicitud, ContextoSolicitud contexto, CancellationToken ct);
    Task<ResultadoSesion> IniciarSesionEstudianteAsync(SolicitudInicioSesionEstudiante solicitud, ContextoSolicitud contexto, CancellationToken ct);
    Task<ResultadoSesion> IniciarSesionGoogleAsync(SolicitudGoogle solicitud, ContextoSolicitud contexto, CancellationToken ct);
    Task<ResultadoSesion> RenovarAsync(string tokenRenovacion, ContextoSolicitud contexto, CancellationToken ct);
    /// <summary>Idempotente: sin token o con un token desconocido no hace nada.</summary>
    Task CerrarSesionAsync(string? tokenRenovacion, CancellationToken ct);
    /// <summary>Una identidad nueva de Google (sin rol) elige estudiante o docente. Permanente y exclusivo.</summary>
    Task<RespuestaAutenticacion> ConfirmarRolAsync(Guid usuarioId, string rol, ContextoSolicitud contexto, CancellationToken ct);
    Task<UsuarioDto> ObtenerUsuarioAsync(Guid usuarioId, CancellationToken ct);

    /// <summary>El docente emite un código temporal de un solo uso para un estudiante de su aula.</summary>
    Task<CodigoRestablecimientoDto> EmitirCodigoRestablecimientoAsync(Guid docenteId, Guid aulaId, Guid estudianteId, ContextoSolicitud contexto, CancellationToken ct);
    /// <summary>El docente crea la cuenta de un estudiante dentro de su aula y recibe un código para que elija su contraseña.</summary>
    Task<EstudianteCreadoDto> CrearEstudianteEnAulaAsync(Guid docenteId, Guid aulaId, SolicitudCrearEstudianteEnAula solicitud, ContextoSolicitud contexto, CancellationToken ct);

    Task ConfirmarRestablecimientoAsync(SolicitudConfirmarRestablecimiento solicitud, ContextoSolicitud contexto, CancellationToken ct);
}
