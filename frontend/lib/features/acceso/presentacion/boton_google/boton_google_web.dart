import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

@JS('google.accounts.id.initialize')
external void _inicializar(JSObject configuracion);

@JS('google.accounts.id.renderButton')
external void _dibujarBoton(web.HTMLElement contenedor, JSObject opciones);

/// Botón oficial de Google Identity Services incrustado en la página.
/// Entrega el ID token (credencial) a [alCredencial]; la API es quien lo valida.
class BotonGoogle extends StatefulWidget {
  const BotonGoogle({
    super.key,
    required this.clientId,
    required this.alCredencial,
  });

  final String clientId;
  final void Function(String idToken) alCredencial;

  @override
  State<BotonGoogle> createState() => _EstadoBotonGoogle();
}

class _EstadoBotonGoogle extends State<BotonGoogle> {
  static int _contador = 0;
  late final String _tipoVista = 'boton-google-${_contador++}';
  bool _disponible = true;

  @override
  void initState() {
    super.initState();
    try {
      final configuracion = JSObject();
      configuracion['client_id'] = widget.clientId.toJS;
      configuracion['callback'] = ((JSObject respuesta) {
        final credencial = (respuesta['credential'] as JSString?)?.toDart;
        if (credencial != null && credencial.isNotEmpty) {
          widget.alCredencial(credencial);
        }
      }).toJS;
      _inicializar(configuracion);

      ui_web.platformViewRegistry.registerViewFactory(_tipoVista, (_) {
        final contenedor = web.document.createElement('div') as web.HTMLElement;
        final opciones = JSObject();
        opciones['type'] = 'standard'.toJS;
        opciones['theme'] = 'filled_blue'.toJS;
        opciones['size'] = 'large'.toJS;
        opciones['text'] = 'continue_with'.toJS;
        opciones['shape'] = 'pill'.toJS;
        opciones['locale'] = 'es'.toJS;
        opciones['width'] = 300.toJS;
        _dibujarBoton(contenedor, opciones);
        return contenedor;
      });
    } catch (_) {
      // El script de Google no cargó (sin conexión o bloqueado).
      _disponible = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_disponible) {
      return const Text(
        'No pudimos cargar Google. Revisa tu conexión e inténtalo de nuevo.',
        textAlign: TextAlign.center,
      );
    }
    return Semantics(
      label: 'Continuar con Google',
      child: SizedBox(
        width: 300,
        height: 48,
        child: HtmlElementView(viewType: _tipoVista),
      ),
    );
  }
}
