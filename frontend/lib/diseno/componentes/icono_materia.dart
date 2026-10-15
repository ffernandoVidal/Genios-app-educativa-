import 'dart:math';

import 'package:flutter/material.dart';

import '../tokens/colores.dart';
import '../tokens/tipografia.dart';

/// Identidad visual de cada materia: color e icono propios, indexados por el código estable del catálogo.
/// Un código desconocido (materia nueva) usa el estilo genérico en lugar de romper la pantalla.
class EstiloMateria {
  const EstiloMateria({required this.color, required this.tipo});

  final Color color;
  final TipoIconoMateria tipo;

  static const EstiloMateria generico = EstiloMateria(
    color: ColoresMaterias.generico,
    tipo: TipoIconoMateria.generico,
  );

  static const Map<String, EstiloMateria> _porCodigo = {
    'MATEMATICAS': EstiloMateria(
      color: ColoresMaterias.matematicas,
      tipo: TipoIconoMateria.matematicas,
    ),
    'LENGUAJE': EstiloMateria(
      color: ColoresMaterias.lenguaje,
      tipo: TipoIconoMateria.lenguaje,
    ),
    'CIENCIAS_NATURALES': EstiloMateria(
      color: ColoresMaterias.cienciasNaturales,
      tipo: TipoIconoMateria.naturales,
    ),
    'CIENCIAS_SOCIALES': EstiloMateria(
      color: ColoresMaterias.cienciasSociales,
      tipo: TipoIconoMateria.sociales,
    ),
  };

  static EstiloMateria de(String codigo) => _porCodigo[codigo] ?? generico;

  // El catálogo guarda los nombres sin tildes y la materia de Lenguaje con su nombre corto.
  // Hasta definir una migración o correspondencia formal, el nombre visible se corrige aquí.
  static const Map<String, String> _nombresVisibles = {
    'Matematicas': 'Matemáticas',
    'Lenguaje': 'Comunicación y Lenguaje',
  };

  static String nombreVisible(String nombreApi) =>
      _nombresVisibles[nombreApi] ?? nombreApi;
}

enum TipoIconoMateria { matematicas, lenguaje, naturales, sociales, generico }

/// Icono original dibujado con vectores, en blanco lunar.
class IconoMateria extends StatelessWidget {
  const IconoMateria({super.key, required this.tipo, this.tamano = 64});

  final TipoIconoMateria tipo;
  final double tamano;

  @override
  Widget build(BuildContext context) {
    if (tipo == TipoIconoMateria.lenguaje) {
      return ExcludeSemantics(
        child: SizedBox(
          width: tamano,
          height: tamano,
          child: Center(
            child: Text(
              'Aa',
              style: Tipografia.titulo(
                tamano * 0.72,
                peso: 800,
                color: ColoresGenios.blancoLunar,
              ),
            ),
          ),
        ),
      );
    }
    return ExcludeSemantics(
      child: CustomPaint(
        size: Size.square(tamano),
        painter: _PintorIcono(tipo),
      ),
    );
  }
}

class _PintorIcono extends CustomPainter {
  _PintorIcono(this.tipo);

  final TipoIconoMateria tipo;

  @override
  void paint(Canvas lienzo, Size s) {
    final trazo = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = s.width * 0.1
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = ColoresGenios.blancoLunar;
    final relleno = Paint()..color = ColoresGenios.blancoLunar;
    final c = s.center(Offset.zero);
    final u = s.width;

    switch (tipo) {
      case TipoIconoMateria.matematicas:
        // "+" y "=" : las operaciones básicas.
        lienzo.drawLine(
          Offset(u * 0.12, u * 0.3),
          Offset(u * 0.46, u * 0.3),
          trazo,
        );
        lienzo.drawLine(
          Offset(u * 0.29, u * 0.13),
          Offset(u * 0.29, u * 0.47),
          trazo,
        );
        lienzo.drawLine(
          Offset(u * 0.58, u * 0.3),
          Offset(u * 0.88, u * 0.3),
          trazo,
        );
        lienzo.drawLine(
          Offset(u * 0.15, u * 0.7),
          Offset(u * 0.85, u * 0.7),
          trazo,
        );
        lienzo.drawLine(
          Offset(u * 0.15, u * 0.88),
          Offset(u * 0.85, u * 0.88),
          trazo,
        );
      case TipoIconoMateria.naturales:
        // Brote: tallo y dos hojas.
        lienzo.drawLine(Offset(c.dx, u * 0.9), Offset(c.dx, u * 0.4), trazo);
        final izquierda = Path()
          ..moveTo(c.dx, u * 0.55)
          ..quadraticBezierTo(u * 0.1, u * 0.55, u * 0.12, u * 0.2)
          ..quadraticBezierTo(u * 0.5, u * 0.2, c.dx, u * 0.55);
        final derecha = Path()
          ..moveTo(c.dx, u * 0.42)
          ..quadraticBezierTo(u * 0.9, u * 0.42, u * 0.88, u * 0.08)
          ..quadraticBezierTo(u * 0.5, u * 0.1, c.dx, u * 0.42);
        lienzo.drawPath(izquierda, relleno);
        lienzo.drawPath(derecha, relleno);
      case TipoIconoMateria.sociales:
        // Globo terráqueo: círculo, meridiano y paralelos.
        final radio = u * 0.4;
        lienzo.drawCircle(c, radio, trazo);
        lienzo.drawOval(
          Rect.fromCenter(center: c, width: radio * 1.0, height: radio * 2),
          trazo..strokeWidth = u * 0.07,
        );
        lienzo.drawLine(
          Offset(c.dx - radio, c.dy),
          Offset(c.dx + radio, c.dy),
          trazo,
        );
        lienzo.drawArc(
          Rect.fromCenter(center: c, width: radio * 2, height: radio * 1.2),
          0.2,
          pi - 0.4,
          false,
          trazo,
        );
      case TipoIconoMateria.generico:
        lienzo.drawCircle(c, u * 0.36, trazo);
        lienzo.drawCircle(c, u * 0.1, relleno);
      case TipoIconoMateria.lenguaje:
        break; // se dibuja con texto
    }
  }

  @override
  bool shouldRepaint(covariant _PintorIcono anterior) => anterior.tipo != tipo;
}
