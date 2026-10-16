import 'dart:convert';

import 'package:http/http.dart' as http;

import '../sesion/sesion_app.dart';
import 'excepcion_api.dart';

/// Cliente de la API REST de GENIOS.
///
/// - Envía el token de acceso como `Bearer` y la cabecera anti-CSRF en las operaciones que modifican datos.
/// - Las cookies (renovación e invitado) las gestiona el navegador; el cliente HTTP debe crearse con credenciales.
/// - Ante un 401 con cuenta iniciada, intenta una sola renovación (compartida entre solicitudes simultáneas).
/// - Convierte los errores del servidor (Problem Details) y los fallos de red en [ExcepcionApi].
class ClienteApi {
  ClienteApi({
    required this._cliente,
    required this._urlBase,
    required this._sesion,
  });

  static const String cabeceraAnticsrf = 'X-GENIOS-CSRF';
  static const Duration _tiempoMaximo = Duration(seconds: 20);

  final http.Client _cliente;
  final String _urlBase;
  final SesionApp _sesion;
  Future<bool>? _renovando;

  /// Una sola consulta sin renovación ni cierre de sesión por 401: el llamador decide qué hacer (restauración al abrir).
  Future<dynamic> consultarSinRenovar(String metodo, String ruta) async {
    final respuesta = await _solicitar(metodo, ruta, null);
    return _procesar(respuesta);
  }

  Future<dynamic> obtener(String ruta) => _enviar('GET', ruta);

  Future<dynamic> enviar(String ruta, [Object? cuerpo]) =>
      _enviar('POST', ruta, cuerpo: cuerpo);

  /// Edición parcial (`PATCH`): lo que va en null no cambia.
  Future<dynamic> modificar(String ruta, Object cuerpo) =>
      _enviar('PATCH', ruta, cuerpo: cuerpo);

  Future<dynamic> _enviar(
    String metodo,
    String ruta, {
    Object? cuerpo,
    bool puedeRenovar = true,
  }) async {
    final respuesta = await _solicitar(metodo, ruta, cuerpo);

    if (respuesta.statusCode == 401 && _sesion.activa) {
      // Un fallo de red al renovar NO es una sesión vencida: la excepción sube y la sesión se conserva.
      if (puedeRenovar && _sesion.tieneCuenta && await _renovarSesion()) {
        return _enviar(metodo, ruta, cuerpo: cuerpo, puedeRenovar: false);
      }
      if (puedeRenovar &&
          _sesion.modo == ModoSesion.invitado &&
          await _reanudarInvitado()) {
        return _enviar(metodo, ruta, cuerpo: cuerpo, puedeRenovar: false);
      }
      _sesion.cerrar(aviso: _avisoSesionPerdida());
    }
    return _procesar(respuesta);
  }

  Future<http.Response> _solicitar(
    String metodo,
    String ruta,
    Object? cuerpo,
  ) async {
    final uri = Uri.parse('$_urlBase$ruta');
    final cabeceras = <String, String>{
      'Accept': 'application/json',
      if (cuerpo != null) 'Content-Type': 'application/json',
      if (_sesion.tokenAcceso != null)
        'Authorization': 'Bearer ${_sesion.tokenAcceso}',
      if (metodo != 'GET') cabeceraAnticsrf: '1',
    };
    try {
      final peticion = metodo == 'GET'
          ? _cliente.get(uri, headers: cabeceras)
          : metodo == 'PATCH'
          ? _cliente.patch(
              uri,
              headers: cabeceras,
              body: cuerpo == null ? null : jsonEncode(cuerpo),
            )
          : _cliente.post(
              uri,
              headers: cabeceras,
              body: cuerpo == null ? null : jsonEncode(cuerpo),
            );
      return await peticion.timeout(_tiempoMaximo);
    } catch (_) {
      throw const ExcepcionApi.sinConexion();
    }
  }

  Future<bool> _renovarSesion() =>
      _renovando ??= _intentarRenovar().whenComplete(() => _renovando = null);

  /// true = token nuevo; false = el servidor dice que la sesión ya no sirve (401/403).
  /// Red caída o error del servidor lanzan [ExcepcionApi]: no se confunden con una sesión vencida.
  Future<bool> _intentarRenovar() async {
    final respuesta = await _solicitar('POST', '/autenticacion/renovar', null);
    if (respuesta.statusCode == 401 || respuesta.statusCode == 403) {
      return false;
    }
    if (respuesta.statusCode != 200) _procesar(respuesta); // lanza el error
    final datos =
        jsonDecode(utf8.decode(respuesta.bodyBytes)) as Map<String, dynamic>;
    _sesion.actualizarToken(datos['tokenAcceso'] as String);
    return true;
  }

  /// Invitado con la cookie vencida o ausente: se pide una sesión nueva (o se reutiliza la vigente) y se reintenta una vez.
  Future<bool> _reanudarInvitado() async {
    final respuesta = await _solicitar('POST', '/sesiones-juego', null);
    return respuesta.statusCode == 200;
  }

  String _avisoSesionPerdida() => _sesion.modo == ModoSesion.invitado
      ? 'No pudimos mantener tu sesión. Revisa que tu navegador permita cookies e inténtalo de nuevo.'
      : 'Tu sesión venció. Inicia sesión de nuevo.';

  dynamic _procesar(http.Response respuesta) {
    final texto = utf8.decode(respuesta.bodyBytes);
    if (respuesta.statusCode >= 200 && respuesta.statusCode < 300) {
      return texto.isEmpty ? null : jsonDecode(texto);
    }

    String? codigo;
    String? titulo;
    try {
      final datos = jsonDecode(texto);
      if (datos is Map) {
        codigo = datos['codigo'] as String?;
        titulo = datos['title'] as String?;
      }
    } catch (_) {
      // Cuerpo vacío o que no es JSON (por ejemplo un 429).
    }

    final estado = respuesta.statusCode;
    final mensaje = switch (estado) {
      429 => 'Demasiados intentos. Espera un minuto e inténtalo de nuevo.',
      >= 500 when codigo == null =>
        'Algo salió mal de nuestro lado. Inténtalo de nuevo en un momento.',
      _ => titulo ?? 'No pudimos completar la acción.',
    };
    throw ExcepcionApi(mensaje, estado: estado, codigo: codigo);
  }
}
