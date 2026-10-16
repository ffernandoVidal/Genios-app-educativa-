import '../../../core/red/cliente_api.dart';
import '../../../core/red/excepcion_api.dart';
import '../dominio/repositorio_acceso.dart';

class RepositorioAccesoApi implements RepositorioAcceso {
  RepositorioAccesoApi(this._api);

  final ClienteApi _api;

  @override
  Future<ResultadoAcceso?> renovarSesion() async {
    try {
      return _resultado(
        await _api.consultarSinRenovar('POST', '/autenticacion/renovar'),
      );
    } on ExcepcionApi catch (e) {
      if (e.estado == 401 || e.estado == 403) return null;
      rethrow;
    }
  }

  @override
  Future<PerfilUsuario> obtenerPerfil() async {
    final datos = await _api.consultarSinRenovar(
      'GET',
      '/usuarios/yo',
    ) as Map<String, dynamic>;
    return PerfilUsuario(
      roles: (datos['roles'] as List<dynamic>).cast<String>(),
      nombreMostrar: datos['nombreMostrar'] as String,
    );
  }

  @override
  Future<bool> hayInvitadoVigente() async {
    try {
      await _api.consultarSinRenovar('GET', '/sesiones-juego/yo');
      return true;
    } on ExcepcionApi catch (e) {
      if (e.estado == 401 || e.estado == 403) return false;
      rethrow;
    }
  }

  @override
  Future<ResultadoAcceso> elegirRol(String rol) async =>
      _resultado(await _api.enviar('/autenticacion/rol', {'rol': rol}));

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
      await _api.enviar('/autenticacion/google', {'idToken': idToken}),
    );
  }

  @override
  Future<void> activarCuenta({
    required String nombreUsuario,
    required String codigo,
    required String contrasenaNueva,
  }) => _api.enviar('/estudiantes/restablecimiento-confirmar', {
    'nombreUsuario': nombreUsuario,
    'codigo': codigo,
    'contrasenaNueva': contrasenaNueva,
  });

  @override
  Future<void> cerrarSesion() => _api.enviar('/autenticacion/cerrar-sesion');
}
