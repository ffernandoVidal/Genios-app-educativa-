import '../../../core/red/excepcion_api.dart';
import '../../../core/sesion/sesion_app.dart';
import 'repositorio_acceso.dart';

/// Recupera la sesión al abrir la app: renovar con la cookie → pedir el perfil al servidor → decidir el rol.
/// Sin cuenta, mira si hay una sesión de invitado vigente. Un fallo de red NO borra nada: se puede reintentar.
class RestauradorSesion {
  RestauradorSesion(this._repositorio, this._sesion);

  final RepositorioAcceso _repositorio;
  final SesionApp _sesion;

  /// Nombre de un invitado recuperado: el servidor no guarda el apodo.
  static const String nombreInvitadoRecuperado = 'Explorador';

  bool _enCurso = false;

  Future<void> restaurar() async {
    if (_enCurso) return;
    _enCurso = true;
    _sesion.marcarRestaurando();
    try {
      final cuenta = await _repositorio.renovarSesion();
      if (cuenta != null) {
        _sesion.iniciarCuenta(
          tokenAcceso: cuenta.tokenAcceso,
          roles: cuenta.roles,
          nombre: cuenta.nombreMostrar,
        );
        // El rol definitivo lo da /usuarios/yo, con el token ya vigente.
        final perfil = await _repositorio.obtenerPerfil();
        _sesion.iniciarCuenta(
          tokenAcceso: _sesion.tokenAcceso!,
          roles: perfil.roles,
          nombre: perfil.nombreMostrar,
        );
      } else if (await _repositorio.hayInvitadoVigente()) {
        _sesion.iniciarInvitado(nombre: nombreInvitadoRecuperado);
      }
      _sesion.marcarRestauracionLista();
    } on ExcepcionApi catch (e) {
      if (e.estado == 401 || e.estado == 403) {
        // El servidor rechazó la sesión: ya no sirve, pero no es un error de conexión.
        _sesion.cerrar(aviso: 'Tu sesión venció. Inicia sesión de nuevo.');
        _sesion.marcarRestauracionLista();
      } else {
        _sesion.cerrar();
        _sesion.marcarErrorRestauracion();
      }
    } finally {
      _enCurso = false;
    }
  }
}
