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
    return _resultado(
      await _api.enviar('/autenticacion/estudiante/iniciar-sesion', {
        'nombreUsuario': nombreUsuario,
        'contrasena': contrasena,
      }),
    );
  }

  @override
  Future<ResultadoAcceso> registrarEstudiante({
    required String codigoAula,
    required String nombreMostrar,
    required String nombreUsuario,
    required String contrasena,
  }) async {
    return _resultado(
      await _api.enviar('/estudiantes/registro', {
        if (codigoAula.isNotEmpty) 'codigoAula': codigoAula,
        'nombreMostrar': nombreMostrar,
        'nombreUsuario': nombreUsuario,
        'contrasena': contrasena,
      }),
    );
  }

  ResultadoAcceso _resultado(dynamic respuesta) {
    final datos = respuesta as Map<String, dynamic>;
    final usuario = datos['usuario'] as Map<String, dynamic>;
    return ResultadoAcceso(
      tokenAcceso: datos['tokenAcceso'] as String,
      roles: (usuario['roles'] as List<dynamic>).cast<String>(),
      nombreMostrar: usuario['nombreMostrar'] as String,
    );
  }

  @override
  Future<ResultadoAcceso> iniciarSesionGoogle(String idToken) async {
    return _resultado(
      await _api.enviar('/autenticacion/google', {
        'idToken': idToken,
        'solicitaRolDocente': true,
      }),
    );
  }

  @override
  Future<void> cerrarSesion() => _api.enviar('/autenticacion/cerrar-sesion');
}
