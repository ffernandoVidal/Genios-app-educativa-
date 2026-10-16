import 'package:flutter/foundation.dart';

/// `rolPendiente`: identidad de Google sin rol todavía; debe elegir si es estudiante o docente (permanente).
enum ModoSesion { ninguna, invitado, estudiante, docente, rolPendiente }

/// Al abrir la app se intenta recuperar la sesión: mientras tanto no se sabe quién es el usuario.
enum EstadoRestauracion { restaurando, error, lista }

/// Estado de la sesión en memoria. El token de acceso NO se guarda en el almacenamiento del navegador:
/// al recargar, la sesión se recupera con la cookie HttpOnly que gestiona el servidor.
///
/// El nombre es solo para mostrar. En un invitado es el apodo que escribió (el servidor no lo guarda);
/// nunca es una credencial: la identidad de la sesión la da la cookie que genera el servidor.
class SesionApp extends ChangeNotifier {
  ModoSesion _modo = ModoSesion.ninguna;
  String? _tokenAcceso;
  String _nombre = '';
  bool _invitacionDescartada = false;
  EstadoRestauracion _restauracion = EstadoRestauracion.lista;
  String? _avisoCierre;

  EstadoRestauracion get restauracion => _restauracion;

  /// Por qué se cerró la sesión sin que el usuario lo pidiera (se muestra una vez en la bienvenida).
  String? get avisoCierre => _avisoCierre;

  ModoSesion get modo => _modo;
  String? get tokenAcceso => _tokenAcceso;
  String get nombre => _nombre;
  bool get activa => _modo != ModoSesion.ninguna;
  bool get tieneCuenta => _tokenAcceso != null;

  /// Si ya se le mostró (y rechazó) la invitación a registrarse en esta sesión.
  bool get invitacionDescartada => _invitacionDescartada;

  void iniciarInvitado({required String nombre}) {
    _modo = ModoSesion.invitado;
    _tokenAcceso = null;
    _nombre = nombre;
    _invitacionDescartada = false;
    _avisoCierre = null;
    notifyListeners();
  }

  void iniciarCuenta({
    required String tokenAcceso,
    required List<String> roles,
    required String nombre,
  }) {
    _modo = roles.contains('docente')
        ? ModoSesion.docente
        : roles.isEmpty
        ? ModoSesion.rolPendiente
        : ModoSesion.estudiante;
    _tokenAcceso = tokenAcceso;
    _nombre = nombre;
    _invitacionDescartada = false;
    _avisoCierre = null;
    notifyListeners();
  }

  /// El servidor entregó un token de acceso nuevo (renovación automática).
  void actualizarToken(String tokenAcceso) => _tokenAcceso = tokenAcceso;

  void descartarInvitacion() => _invitacionDescartada = true;

  void marcarRestaurando() {
    _restauracion = EstadoRestauracion.restaurando;
    notifyListeners();
  }

  /// No se pudo saber si hay sesión (red o servidor): se puede reintentar sin perder nada.
  void marcarErrorRestauracion() {
    _restauracion = EstadoRestauracion.error;
    notifyListeners();
  }

  void marcarRestauracionLista() {
    _restauracion = EstadoRestauracion.lista;
    notifyListeners();
  }

  /// Cierre voluntario o sesión vencida: se vuelve a la bienvenida. [aviso] explica un cierre involuntario.
  void cerrar({String? aviso}) {
    _avisoCierre = aviso;
    if (_modo == ModoSesion.ninguna) {
      if (aviso != null) notifyListeners();
      return;
    }
    _modo = ModoSesion.ninguna;
    _tokenAcceso = null;
    _nombre = '';
    notifyListeners();
  }

  void consumirAviso() => _avisoCierre = null;
}

/// Vista de la sesión para inyectar en los Cubits sin exponer el `ChangeNotifier`.
class FuenteModoSesion {
  const FuenteModoSesion(this._sesion);

  final SesionApp _sesion;

  ModoSesion get modo => _sesion.modo;
  String get nombre => _sesion.nombre;
  bool get invitacionDescartada => _sesion.invitacionDescartada;
  String? get avisoCierre => _sesion.avisoCierre;

  void consumirAviso() => _sesion.consumirAviso();

  void descartarInvitacion() => _sesion.descartarInvitacion();
}
