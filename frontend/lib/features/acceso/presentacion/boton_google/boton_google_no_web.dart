import 'package:flutter/material.dart';

import '../../../../diseno/componentes/botones_juego.dart';

/// Reemplazo para plataformas sin Google Identity Services (pruebas de widgets).
/// GENIOS es una app web: en producción se usa `boton_google_web.dart`.
class BotonGoogle extends StatelessWidget {
  const BotonGoogle({
    super.key,
    required this.clientId,
    required this.alCredencial,
  });

  final String clientId;
  final void Function(String idToken) alCredencial;

  @override
  Widget build(BuildContext context) => BotonSecundarioJuego(
    texto: 'CONTINUAR CON GOOGLE',
    icono: Icons.login_rounded,
    alPulsar: () => alCredencial('credencial-de-prueba'),
  );
}
