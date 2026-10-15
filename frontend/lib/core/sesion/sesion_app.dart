import 'package:flutter/foundation.dart';

enum ModoSesion { ninguna, invitado, estudiante, docente }

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
    notifyListeners();
  }

  void iniciarCuenta({
    required String tokenAcceso,
    required List<String> roles,
    required String nombre,
  }) {
    _modo = roles.contains('docente')
        ? ModoSesion.docente
        : ModoSesion.estudiante;
    _tokenAcceso = tokenAcceso;
    _nombre = nombre;
    _invitacionDescartada = false;
    notifyListeners();
  }

  /// El servidor entregó un token de acceso nuevo (renovación automática).
  void actualizarToken(String tokenAcceso) => _tokenAcceso = tokenAcceso;

  void descartarInvitacion() => _invitacionDescartada = true;

  /// Cierre voluntario o sesión vencida: se vuelve a la bienvenida.
  void cerrar() {
    if (_modo == ModoSesion.ninguna) return;
    _modo = ModoSesion.ninguna;
    _tokenAcceso = null;
    _nombre = '';
    notifyListeners();
  }
}

/// Vista de la sesión para inyectar en los Cubits sin exponer el `ChangeNotifier`.
class FuenteModoSesion {
  const FuenteModoSesion(this._sesion);

  final SesionApp _sesion;

  ModoSesion get modo => _sesion.modo;
  String get nombre => _sesion.nombre;
  bool get invitacionDescartada => _sesion.invitacionDescartada;

  void descartarInvitacion() => _sesion.descartarInvitacion();
}
