using GENIOS.Application.Comun;

namespace GENIOS.Application.Autenticacion;

public interface IServicioAutenticacion
{
    Task<ResultadoSesion> RegistrarEstudianteAsync(SolicitudRegistroEstudiante solicitud, ContextoSolicitud contexto, CancellationToken ct);
    Task<ResultadoSesion> IniciarSesionEstudianteAsync(SolicitudInicioSesionEstudiante solicitud, ContextoSolicitud contexto, CancellationToken ct);
    Task<ResultadoSesion> IniciarSesionGoogleAsync(SolicitudGoogle solicitud, ContextoSolicitud contexto, CancellationToken ct);
    Task<ResultadoSesion> RenovarAsync(string tokenRenovacion, ContextoSolicitud contexto, CancellationToken ct);
    Task CerrarSesionAsync(string tokenRenovacion, CancellationToken ct);
    Task<UsuarioDto> ObtenerUsuarioAsync(Guid usuarioId, CancellationToken ct);

    /// <summary>El docente emite un código temporal de un solo uso para un estudiante de su aula.</summary>
    Task<CodigoRestablecimientoDto> EmitirCodigoRestablecimientoAsync(Guid docenteId, Guid aulaId, Guid estudianteId, ContextoSolicitud contexto, CancellationToken ct);
    Task ConfirmarRestablecimientoAsync(SolicitudConfirmarRestablecimiento solicitud, ContextoSolicitud contexto, CancellationToken ct);
}
