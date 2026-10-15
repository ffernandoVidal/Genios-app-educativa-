import 'dart:math';

import 'package:flutter/material.dart';

import '../tokens/colores.dart';

enum VarianteFondo {
  /// Bienvenida y cabina: suelo lunar visible y planetas lejanos.
  paisaje,

  /// Pantallas de lectura (preguntas, formularios): mismo mundo, más tenue para no distraer.
  suave,
}

/// Fondo global de GENIOS: cielo azul oscuro, estrellas, planetas lejanos y superficie lunar en primer plano.
///
/// Es un dibujo vectorial propio, así que se ve nítido en cualquier tamaño y no se deforma.
/// Si más adelante se entrega la ilustración definitiva, se puede pasar en [imagen] y se usará como capa de fondo.
class FondoEspacial extends StatelessWidget {
  const FondoEspacial({
    super.key,
    required this.hijo,
    this.variante = VarianteFondo.suave,
    this.imagen,
    this.vectorial = false,
  });

  final Widget hijo;
  final VarianteFondo variante;

  /// Ilustración opcional del paisaje. Se dibuja con `BoxFit.cover` (sin estirar) debajo del contenido.
  final ImageProvider? imagen;

  /// Ilustración oficial del paisaje lunar (735×737 px, estilo plano). Se ancla abajo para que la Luna siempre se vea.
  static const ilustracionOficial = AssetImage(
    'assets/imagenes/superficie_lunar.jpg',
  );

  /// Dibuja el paisaje vectorial propio en lugar de la ilustración.
  final bool vectorial;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [ColoresGenios.espacioProfundo, ColoresGenios.azulPetroleo],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (!vectorial || imagen != null)
            Image(
              image: imagen ?? ilustracionOficial,
              fit: BoxFit.cover,
              alignment: Alignment.bottomCenter,
              filterQuality: FilterQuality.high,
              excludeFromSemantics: true,
            )
          else
            ExcludeSemantics(
              child: CustomPaint(painter: _PintorPaisaje(variante)),
            ),
          if (variante == VarianteFondo.suave)
            ColoredBox(
              color: ColoresGenios.espacioProfundo.withValues(alpha: 0.35),
            ),
          hijo,
        ],
      ),
    );
  }
}

class _PintorPaisaje extends CustomPainter {
  const _PintorPaisaje(this.variante);

  final VarianteFondo variante;

  @override
  void paint(Canvas lienzo, Size tamano) {
    _estrellas(lienzo, tamano);
    _planetas(lienzo, tamano);
    _luna(lienzo, tamano);
  }

  void _estrellas(Canvas lienzo, Size t) {
    final azar = Random(7);
    final pincel = Paint();
    for (var i = 0; i < 120; i++) {
      pincel.color = ColoresGenios.blancoLunar.withValues(
        alpha: 0.2 + azar.nextDouble() * 0.6,
      );
      lienzo.drawCircle(
        Offset(
          azar.nextDouble() * t.width,
          azar.nextDouble() * t.height * 0.75,
        ),
        0.5 + azar.nextDouble() * 1.5,
        pincel,
      );
    }
  }

  void _planetas(Canvas lienzo, Size t) {
    final base = min(t.width, t.height);

    // Planeta grande y tenue, parcialmente fuera de la pantalla.
    _esfera(
      lienzo,
      Offset(t.width * 0.88, t.height * 0.16),
      base * 0.16,
      ColoresGenios.turquesa,
      alfa: 0.55,
    );

    // Planeta con anillo.
    final centro = Offset(t.width * 0.14, t.height * 0.22);
    final radio = base * 0.055;
    _esfera(lienzo, centro, radio, const Color(0xFFE79A4A), alfa: 0.9);
    final anillo = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = max(2, radio * 0.18)
      ..color = ColoresGenios.blancoLunar.withValues(alpha: 0.6);
    lienzo.save();
    lienzo.translate(centro.dx, centro.dy);
    lienzo.rotate(-0.35);
    lienzo.drawOval(
      Rect.fromCenter(
        center: Offset.zero,
        width: radio * 3.2,
        height: radio * 0.9,
      ),
      anillo,
    );
    lienzo.restore();

    // Luna pequeña.
    _esfera(
      lienzo,
      Offset(t.width * 0.62, t.height * 0.1),
      base * 0.022,
      ColoresGenios.blancoLunar,
      alfa: 0.8,
    );
  }

  void _esfera(
    Canvas lienzo,
    Offset centro,
    double radio,
    Color color, {
    double alfa = 1,
  }) {
    final rect = Rect.fromCircle(center: centro, radius: radio);
    final pincel = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.4, -0.4),
        colors: [
          Color.lerp(color, Colors.white, 0.35)!.withValues(alpha: alfa),
          color.withValues(alpha: alfa),
          Color.lerp(color, Colors.black, 0.5)!.withValues(alpha: alfa),
        ],
        stops: const [0, 0.55, 1],
      ).createShader(rect);
    lienzo.drawCircle(centro, radio, pincel);
  }

  void _luna(Canvas lienzo, Size t) {
    final altura = variante == VarianteFondo.paisaje ? 0.27 : 0.09;
    final yBase = t.height * (1 - altura);

    // Colina trasera (más lejana y azulada).
    final trasera = Path()
      ..moveTo(0, yBase + t.height * 0.01)
      ..cubicTo(
        t.width * 0.25,
        yBase - t.height * 0.05,
        t.width * 0.55,
        yBase + t.height * 0.03,
        t.width,
        yBase - t.height * 0.03,
      )
      ..lineTo(t.width, t.height)
      ..lineTo(0, t.height)
      ..close();
    lienzo.drawPath(
      trasera,
      Paint()
        ..shader =
            LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [const Color(0xFF6F8E99), ColoresGenios.azulPetroleo],
            ).createShader(
              Rect.fromLTWH(0, yBase - t.height * 0.05, t.width, t.height),
            ),
    );

    // Suelo en primer plano, iluminado.
    final yFrente = yBase + t.height * 0.035;
    final frente = Path()
      ..moveTo(0, yFrente)
      ..cubicTo(
        t.width * 0.3,
        yFrente - t.height * 0.04,
        t.width * 0.7,
        yFrente + t.height * 0.05,
        t.width,
        yFrente - t.height * 0.01,
      )
      ..lineTo(t.width, t.height)
      ..lineTo(0, t.height)
      ..close();
    lienzo.drawPath(
      frente,
      Paint()
        ..shader =
            LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFFD9E3E4),
                const Color(0xFF8FA8AF),
                const Color(0xFF4F6C78),
              ],
            ).createShader(
              Rect.fromLTWH(0, yFrente - t.height * 0.04, t.width, t.height),
            ),
    );

    // Cráteres: sombra interior y borde claro.
    final azar = Random(21);
    final cantidad = variante == VarianteFondo.paisaje ? 7 : 3;
    for (var i = 0; i < cantidad; i++) {
      final ancho = t.width * (0.05 + azar.nextDouble() * 0.09);
      final centro = Offset(
        t.width * (0.06 + azar.nextDouble() * 0.88),
        yFrente + (t.height - yFrente) * (0.25 + azar.nextDouble() * 0.6),
      );
      final rect = Rect.fromCenter(
        center: centro,
        width: ancho,
        height: ancho * 0.32,
      );
      lienzo.drawOval(
        rect,
        Paint()..color = const Color(0xFF4F6C78).withValues(alpha: 0.55),
      );
      lienzo.drawArc(
        rect,
        pi,
        pi,
        false,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = ColoresGenios.blancoLunar.withValues(alpha: 0.5),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _PintorPaisaje anterior) =>
      anterior.variante != variante;
}
