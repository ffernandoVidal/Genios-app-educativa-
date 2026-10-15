import 'dart:math';

import 'package:flutter/material.dart';

import '../../../diseno/componentes/tarjeta_mision.dart';
import '../../../diseno/tokens/colores.dart';
import '../dominio/modelos_catalogo.dart';

EstadoNodo estadoDelNodo(EstadoMision estado) => switch (estado) {
  EstadoMision.bloqueada => EstadoNodo.bloqueada,
  EstadoMision.disponible => EstadoNodo.disponible,
  EstadoMision.enProgreso => EstadoNodo.enProgreso,
  EstadoMision.completada => EstadoNodo.completada,
};

/// Camino sinuoso que une los nodos de las misiones. Es solo dibujo: el desbloqueo lo decide siempre la API.
class RutaMisiones extends StatelessWidget {
  const RutaMisiones({
    super.key,
    required this.misiones,
    required this.color,
    required this.alPulsar,
  });

  final List<Mision> misiones;
  final Color color;
  final void Function(Mision) alPulsar;

  static const double _altoFila = 190;
  static const double _anchoNodo = 170;
  static const double _diametro = 88;
  static const List<double> _desvios = [0, 0.7, 0, -0.7];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, restricciones) {
        final ancho = restricciones.maxWidth;
        final margen = _anchoNodo / 2;
        final centros = [
          for (var i = 0; i < misiones.length; i++)
            Offset(
              ancho / 2 + _desvios[i % _desvios.length] * (ancho / 2 - margen),
              16 + _diametro / 2 + i * _altoFila,
            ),
        ];
        return SizedBox(
          height: _altoFila * misiones.length + 24,
          child: Stack(
            children: [
              Positioned.fill(
                child: ExcludeSemantics(
                  child: CustomPaint(painter: _PintorRuta(centros, misiones)),
                ),
              ),
              for (var i = 0; i < misiones.length; i++)
                Positioned(
                  left: centros[i].dx - _anchoNodo / 2,
                  top: centros[i].dy - _diametro / 2,
                  width: _anchoNodo,
                  child: TarjetaMision(
                    numero: misiones[i].numeroOrden,
                    nombre: misiones[i].nombre,
                    estado: estadoDelNodo(misiones[i].estado),
                    color: color,
                    requisito: misiones[i].requiereNombre,
                    diametro: _diametro,
                    alPulsar: () => alPulsar(misiones[i]),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _PintorRuta extends CustomPainter {
  _PintorRuta(this.centros, this.misiones);

  final List<Offset> centros;
  final List<Mision> misiones;

  @override
  void paint(Canvas lienzo, Size tamano) {
    for (var i = 0; i < centros.length - 1; i++) {
      final a = centros[i];
      final b = centros[i + 1];
      final dy = (b.dy - a.dy) * 0.6;
      final camino = Path()
        ..moveTo(a.dx, a.dy)
        ..cubicTo(a.dx, a.dy + dy, b.dx, b.dy - dy, b.dx, b.dy);

      final recorrido = misiones[i].estado == EstadoMision.completada;
      final pincel = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6
        ..strokeCap = StrokeCap.round
        ..color = recorrido
            ? ColoresGenios.exito
            : ColoresGenios.textoSuave.withValues(alpha: 0.5);

      if (recorrido) {
        lienzo.drawPath(camino, pincel);
      } else {
        for (final metrica in camino.computeMetrics()) {
          for (double d = 0; d < metrica.length; d += 26) {
            lienzo.drawPath(
              metrica.extractPath(d, min(d + 14, metrica.length)),
              pincel,
            );
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _PintorRuta anterior) =>
      anterior.misiones != misiones || anterior.centros != centros;
}
