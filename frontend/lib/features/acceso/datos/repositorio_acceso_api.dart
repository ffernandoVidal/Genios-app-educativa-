import '../../../core/red/cliente_api.dart';
import '../dominio/repositorio_acceso.dart';

class RepositorioAccesoApi implements RepositorioAcceso {
  RepositorioAccesoApi(this._api);

  final ClienteApi _api;

  @override
  Future<void> crearSesionInvitado() => _api.enviar('/sesiones-juego');

  @override
  Future<ResultadoAcceso> iniciarSesionEstudiante(
    String nombreUsuario,
    String contrasena,
  ) async {
    final datos = await _api.enviar(
      '/autenticacion/estudiante/iniciar-sesion',
      {'nombreUsuario': nombreUsuario, 'contrasena': contrasena},
    ) as Map<String, dynamic>;

    final usuario = datos['usuario'] as Map<String, dynamic>;
    return ResultadoAcceso(
      tokenAcceso: datos['tokenAcceso'] as String,
      roles: (usuario['roles'] as List<dynamic>).cast<String>(),
    );
  }

  @override
  Future<void> cerrarSesion() => _api.enviar('/autenticacion/cerrar-sesion');
}
