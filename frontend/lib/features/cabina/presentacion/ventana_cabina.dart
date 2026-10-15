import 'dart:math';

import 'package:flutter/material.dart';

import '../../../diseno/tokens/colores.dart';

/// Ventana redonda de la cabina con vista al espacio. Es decoración: va detrás del astronauta.
class VentanaCabina extends StatelessWidget {
  const VentanaCabina({super.key, required this.diametro});

  final double diametro;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: CustomPaint(
        size: Size.square(diametro),
        painter: _PintorVentana(),
      ),
    );
  }
}

class _PintorVentana extends CustomPainter {
  @override
  void paint(Canvas lienzo, Size s) {
    final centro = s.center(Offset.zero);
    final radio = s.width / 2;

    // Marco metálico.
    lienzo.drawCircle(
      centro,
      radio,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            ColoresGenios.blancoLunar,
            Color(0xFF8FA8AF),
            ColoresGenios.azulPetroleo,
          ],
        ).createShader(Rect.fromCircle(center: centro, radius: radio)),
    );

    // Vidrio con el espacio profundo.
    final vidrio = radio * 0.86;
    lienzo.save();
    lienzo.clipPath(
      Path()..addOval(Rect.fromCircle(center: centro, radius: vidrio)),
    );
    lienzo.drawRect(
      Rect.fromCircle(center: centro, radius: vidrio),
      Paint()
        ..shader = const RadialGradient(
          colors: [Color(0xFF14506B), ColoresGenios.espacioProfundo],
        ).createShader(Rect.fromCircle(center: centro, radius: vidrio)),
    );
    final azar = Random(5);
    final estrella = Paint();
    for (var i = 0; i < 40; i++) {
      estrella.color = ColoresGenios.blancoLunar.withValues(
        alpha: 0.3 + azar.nextDouble() * 0.6,
      );
      lienzo.drawCircle(
        centro +
            Offset(
              (azar.nextDouble() - 0.5) * vidrio * 2,
              (azar.nextDouble() - 0.5) * vidrio * 2,
            ),
        0.6 + azar.nextDouble() * 1.4,
        estrella,
      );
    }
    // Planeta turquesa asomando.
    lienzo.drawCircle(
      centro + Offset(vidrio * 0.45, -vidrio * 0.4),
      vidrio * 0.22,
      Paint()..color = ColoresGenios.turquesa.withValues(alpha: 0.75),
    );
    lienzo.restore();

    // Aro interior y tornillos.
    lienzo.drawCircle(
      centro,
      vidrio,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = radio * 0.05
        ..color = ColoresGenios.turquesa,
    );
    for (var i = 0; i < 8; i++) {
      final angulo = i * pi / 4 + pi / 8;
      lienzo.drawCircle(
        centro + Offset(cos(angulo), sin(angulo)) * (radio * 0.93),
        radio * 0.025,
        Paint()..color = const Color(0xFF4F6C78),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter anterior) => false;
}
