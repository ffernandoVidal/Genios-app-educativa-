import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/ajustes/ajustes_app.dart';
import '../tokens/colores.dart';

enum PoseAstronauta { espera, saludo, celebracion, sorpresa }

/// La mascota de GENIOS: un astronauta infantil original, dibujado como vector (cabeza grande, formas redondeadas,
/// traje blanco con detalles turquesa y azul). Flota suavemente y cambia de pose y de cara.
/// Con movimiento reducido (ajuste o sistema) se muestra quieto.
class AstronautaGenios extends StatefulWidget {
  const AstronautaGenios({
    super.key,
    this.pose = PoseAstronauta.espera,
    this.alto = 260,
  });

  final PoseAstronauta pose;
  final double alto;

  @override
  State<AstronautaGenios> createState() => _AstronautaGeniosState();
}

class _AstronautaGeniosState extends State<AstronautaGenios>
    with SingleTickerProviderStateMixin {
  late final AnimationController _reloj = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 3600),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (movimientoReducido(context)) {
      _reloj.stop();
      _reloj.value = 0.25;
    } else if (!_reloj.isAnimating) {
      _reloj.repeat();
    }
  }

  @override
  void dispose() {
    _reloj.dispose();
    super.dispose();
  }

  String get _descripcion => switch (widget.pose) {
    PoseAstronauta.saludo => 'Astronauta GENIOS saludando',
    PoseAstronauta.celebracion => 'Astronauta GENIOS celebrando',
    PoseAstronauta.sorpresa => 'Astronauta GENIOS sorprendido',
    PoseAstronauta.espera => 'Astronauta GENIOS',
  };

  @override
  Widget build(BuildContext context) {
    return Semantics(
      image: true,
      label: _descripcion,
      child: ExcludeSemantics(
        child: SizedBox(
          width: widget.alto * 0.8,
          height: widget.alto,
          child: AnimatedBuilder(
            animation: _reloj,
            builder: (_, _) => CustomPaint(
              painter: _PintorAstronauta(widget.pose, _reloj.value),
            ),
          ),
        ),
      ),
    );
  }
}

/// Dibuja en un espacio de diseño de 100 × 125 y lo escala al tamaño real.
class _PintorAstronauta extends CustomPainter {
  _PintorAstronauta(this.pose, this.t);

  final PoseAstronauta pose;
  final double t;

  static const Color _sombraBlanco = Color(0xFFCADADD);
  static const Color _mochila = Color(0xFFB5CDD3);
  static const Color _botas = Color(0xFF1BA3AE);
  static const Color _azulVisor = Color(0xFF1B6C8C);

  @override
  void paint(Canvas lienzo, Size tamano) {
    lienzo.save();
    lienzo.scale(tamano.width / 100);

    final flote = sin(t * 2 * pi) * 2.2;
    final salto = pose == PoseAstronauta.celebracion
        ? sin(t * 4 * pi).abs() * 6
        : 0.0;
    final onda = sin(t * 2 * pi * 4);

    // Sombra en el suelo: se achica cuando el astronauta sube.
    final subida = flote + salto;
    lienzo.drawOval(
      Rect.fromCenter(
        center: const Offset(50, 123),
        width: 40 - subida * 1.2,
        height: 6,
      ),
      Paint()..color = Colors.black.withValues(alpha: 0.25),
    );

    lienzo.translate(0, -(salto) + flote);

    _mochilaYCuerpo(lienzo);
    _brazos(lienzo, onda);
    _cabeza(lienzo);
    _cara(lienzo);

    lienzo.restore();
  }

  void _mochilaYCuerpo(Canvas lienzo) {
    final blanco = Paint()..color = ColoresGenios.blancoLunar;

    // Mochila detrás del cuerpo.
    lienzo.drawRRect(
      RRect.fromLTRBR(29, 58, 71, 99, const Radius.circular(11)),
      Paint()..color = _mochila,
    );

    // Piernas y botas.
    for (final x in [39.0, 52.0]) {
      lienzo.drawRRect(
        RRect.fromLTRBR(x, 92, x + 10, 113, const Radius.circular(5)),
        blanco,
      );
      lienzo.drawRRect(
        RRect.fromLTRBR(x - 2, 108, x + 13, 119, const Radius.circular(6)),
        Paint()..color = _botas,
      );
    }

    // Cuerpo con un leve sombreado lateral.
    final cuerpo = RRect.fromLTRBR(31, 58, 69, 100, const Radius.circular(18));
    lienzo.drawRRect(
      cuerpo,
      Paint()
        ..shader = const LinearGradient(
          colors: [
            ColoresGenios.blancoLunar,
            ColoresGenios.blancoLunar,
            _sombraBlanco,
          ],
          stops: [0, 0.6, 1],
        ).createShader(cuerpo.outerRect),
    );

    // Panel del pecho con luces.
    lienzo.drawRRect(
      RRect.fromLTRBR(42, 70, 58, 81, const Radius.circular(4)),
      Paint()..color = _azulVisor,
    );
    lienzo.drawCircle(
      const Offset(47, 75.5),
      2.2,
      Paint()..color = ColoresGenios.amarilloEspacial,
    );
    lienzo.drawCircle(
      const Offset(53, 75.5),
      2.2,
      Paint()..color = ColoresGenios.turquesa,
    );

    // Cuello turquesa.
    lienzo.drawOval(
      Rect.fromCenter(center: const Offset(50, 60), width: 30, height: 9),
      Paint()..color = ColoresGenios.turquesa,
    );
  }

  void _brazos(Canvas lienzo, double onda) {
    double izquierdo;
    double derecho;
    switch (pose) {
      case PoseAstronauta.saludo:
        izquierdo = pi / 2 + 0.4;
        derecho = -pi / 2 + 0.5 + onda * 0.3;
      case PoseAstronauta.celebracion:
        izquierdo = -pi / 2 - 0.5 - onda * 0.15;
        derecho = -pi / 2 + 0.5 + onda * 0.15;
      case PoseAstronauta.sorpresa:
        izquierdo = pi + 0.45;
        derecho = -0.45;
      case PoseAstronauta.espera:
        izquierdo = pi / 2 + 0.4;
        derecho = pi / 2 - 0.4;
    }
    _brazo(lienzo, const Offset(34, 67), izquierdo);
    _brazo(lienzo, const Offset(66, 67), derecho);
  }

  void _brazo(Canvas lienzo, Offset hombro, double angulo) {
    const largo = 21.0;
    final fin = hombro + Offset(cos(angulo), sin(angulo)) * largo;
    final blanco = Paint()
      ..color = ColoresGenios.blancoLunar
      ..strokeWidth = 11
      ..strokeCap = StrokeCap.round;
    lienzo.drawLine(hombro, fin, blanco);

    // Puño turquesa y guante redondeado.
    final puno = hombro + Offset(cos(angulo), sin(angulo)) * (largo * 0.78);
    lienzo.drawCircle(puno, 5.8, Paint()..color = ColoresGenios.turquesa);
    lienzo.drawCircle(fin, 6.4, Paint()..color = ColoresGenios.blancoLunar);
  }

  void _cabeza(Canvas lienzo) {
    const centro = Offset(50, 36);
    final rect = Rect.fromCircle(center: centro, radius: 30);

    // Auriculares del casco.
    for (final x in [19.0, 81.0]) {
      lienzo.drawCircle(
        Offset(x, 38),
        6,
        Paint()..color = ColoresGenios.turquesa,
      );
      lienzo.drawCircle(Offset(x, 38), 3, Paint()..color = _azulVisor);
    }

    lienzo.drawCircle(
      centro,
      30,
      Paint()
        ..shader = const RadialGradient(
          center: Alignment(-0.45, -0.5),
          colors: [
            ColoresGenios.blancoLunar,
            ColoresGenios.blancoLunar,
            _sombraBlanco,
          ],
          stops: [0, 0.55, 1],
        ).createShader(rect),
    );
    lienzo.drawCircle(
      centro,
      29,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.4
        ..color = ColoresGenios.turquesa.withValues(alpha: 0.9),
    );

    // Visor.
    final visor = RRect.fromRectAndRadius(
      Rect.fromCenter(center: const Offset(50, 38), width: 50, height: 39),
      const Radius.circular(19.5),
    );
    lienzo.drawRRect(
      visor,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_azulVisor, ColoresGenios.espacioProfundo],
        ).createShader(visor.outerRect),
    );
    lienzo.drawRRect(
      visor,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = ColoresGenios.blancoLunar.withValues(alpha: 0.85),
    );

    // Reflejo del visor.
    lienzo.save();
    lienzo.translate(37, 27);
    lienzo.rotate(-0.5);
    lienzo.drawOval(
      Rect.fromCenter(center: Offset.zero, width: 13, height: 5.5),
      Paint()..color = Colors.white.withValues(alpha: 0.45),
    );
    lienzo.restore();
  }

  void _cara(Canvas lienzo) {
    final trazo = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.3
      ..strokeCap = StrokeCap.round
      ..color = ColoresGenios.blancoLunar;
    final relleno = Paint()..color = ColoresGenios.blancoLunar;
    final pupila = Paint()..color = ColoresGenios.espacioProfundo;

    switch (pose) {
      case PoseAstronauta.celebracion:
        // Ojos felices "^ ^" y sonrisa abierta.
        for (final x in [41.0, 59.0]) {
          lienzo.drawArc(
            Rect.fromCenter(center: Offset(x, 38), width: 8, height: 7),
            pi,
            pi,
            false,
            trazo,
          );
        }
        final boca = Path()
          ..moveTo(42, 45)
          ..quadraticBezierTo(50, 56, 58, 45)
          ..close();
        lienzo.drawPath(boca, Paint()..color = const Color(0xFFFF8FA3));
        lienzo.drawPath(boca, trazo..strokeWidth = 1.8);
      case PoseAstronauta.sorpresa:
        for (final x in [41.0, 59.0]) {
          lienzo.drawOval(
            Rect.fromCenter(center: Offset(x, 36), width: 8.5, height: 11),
            relleno,
          );
          lienzo.drawCircle(Offset(x, 37), 2.4, pupila);
        }
        lienzo.drawOval(
          Rect.fromCenter(center: const Offset(50, 48), width: 6, height: 8),
          trazo,
        );
      case PoseAstronauta.saludo:
      case PoseAstronauta.espera:
        for (final x in [41.0, 59.0]) {
          lienzo.drawOval(
            Rect.fromCenter(center: Offset(x, 37), width: 7, height: 9.5),
            relleno,
          );
          lienzo.drawCircle(Offset(x + 0.6, 38), 2.2, pupila);
        }
        final ancho = pose == PoseAstronauta.saludo ? 15.0 : 10.0;
        lienzo.drawArc(
          Rect.fromCenter(
            center: const Offset(50, 45),
            width: ancho,
            height: 8,
          ),
          0.25,
          pi - 0.5,
          false,
          trazo,
        );
    }
  }

  @override
  bool shouldRepaint(covariant _PintorAstronauta anterior) =>
      anterior.t != t || anterior.pose != pose;
}
