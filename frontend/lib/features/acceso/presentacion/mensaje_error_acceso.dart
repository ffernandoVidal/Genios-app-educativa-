import 'package:flutter/material.dart';

import '../../../diseno/tokens/colores.dart';
import '../../../diseno/tokens/medidas.dart';
import '../../../diseno/tokens/tipografia.dart';

/// Mensaje de error de los formularios de acceso: visible, con icono y anunciado a los lectores de pantalla.
class MensajeErrorAcceso extends StatelessWidget {
  const MensajeErrorAcceso({super.key, required this.mensaje});

  final String? mensaje;

  @override
  Widget build(BuildContext context) {
    if (mensaje == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: Espaciado.l),
      child: Semantics(
        liveRegion: true,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline_rounded, color: ColoresGenios.error),
            const SizedBox(width: Espaciado.s),
            Flexible(
              child: Text(
                mensaje!,
                style: Tipografia.texto(
                  18,
                  peso: 800,
                  color: ColoresGenios.error,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
