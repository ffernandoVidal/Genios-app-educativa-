import 'package:flutter/foundation.dart';

enum ModoSesion { ninguna, invitado, estudiante, docente }

/// Estado de la sesión en memoria. El token de acceso NO se guarda en el almacenamiento del navegador:
/// al recargar, la sesión se recupera con la cookie HttpOnly que gestiona el servidor.
class SesionApp extends ChangeNotifier {
  ModoSesion _modo = ModoSesion.ninguna;
  String? _tokenAcceso;

  ModoSesion get modo => _modo;
  String? get tokenAcceso => _tokenAcceso;
  bool get activa => _modo != ModoSesion.ninguna;
  bool get tieneCuenta => _tokenAcceso != null;

  void iniciarInvitado() {
    _modo = ModoSesion.invitado;
    _tokenAcceso = null;
    notifyListeners();
  }

  void iniciarCuenta({
    required String tokenAcceso,
    required List<String> roles,
  }) {
    _modo = roles.contains('docente')
        ? ModoSesion.docente
        : ModoSesion.estudiante;
    _tokenAcceso = tokenAcceso;
    notifyListeners();
  }

  /// El servidor entregó un token de acceso nuevo (renovación automática).
  void actualizarToken(String tokenAcceso) => _tokenAcceso = tokenAcceso;

  /// Cierre voluntario o sesión vencida: se vuelve a la bienvenida.
  void cerrar() {
    if (_modo == ModoSesion.ninguna) return;
    _modo = ModoSesion.ninguna;
    _tokenAcceso = null;
    notifyListeners();
  }
}
