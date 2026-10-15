import 'dart:math';

import 'package:flutter/material.dart';

import '../../app/tema/tema_genios.dart';

/// Fondo con degradado y estrellas fijas (siempre las mismas, para que no parpadeen al redibujar).
class FondoEspacial extends StatelessWidget {
  const FondoEspacial({super.key, required this.hijo});

  final Widget hijo;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            ColoresGenios.espacioProfundo,
            ColoresGenios.espacioMedio,
            ColoresGenios.nebulosa,
          ],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          const ExcludeSemantics(
            child: CustomPaint(painter: _PintorEstrellas()),
          ),
          hijo,
        ],
      ),
    );
  }
}

class _PintorEstrellas extends CustomPainter {
  const _PintorEstrellas();

  @override
  void paint(Canvas lienzo, Size tamano) {
    final azar = Random(42);
    final pincel = Paint();
    for (var i = 0; i < 90; i++) {
      pincel.color = Colors.white.withValues(
        alpha: 0.25 + azar.nextDouble() * 0.6,
      );
      lienzo.drawCircle(
        Offset(
          azar.nextDouble() * tamano.width,
          azar.nextDouble() * tamano.height,
        ),
        0.6 + azar.nextDouble() * 1.6,
        pincel,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter anterior) => false;
}
