import 'package:flutter/material.dart';

/// Espaciados en múltiplos de 4. Evita números sueltos en las pantallas.
class Espaciado {
  const Espaciado._();

  static const double xs = 4;
  static const double s = 8;
  static const double m = 12;
  static const double l = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 48;

  /// Margen lateral estándar de una pantalla.
  static const double pantalla = 20;

  /// Tamaño táctil mínimo recomendado (Material y WCAG).
  static const double objetivoTactil = 48;
}

class Radios {
  const Radios._();

  static const double s = 12;
  static const double m = 20;
  static const double l = 28;
  static const double pildora = 999;

  static BorderRadius get tarjeta => BorderRadius.circular(l);
  static BorderRadius get boton => BorderRadius.circular(pildora);
  static BorderRadius get chip => BorderRadius.circular(m);
}

class Sombras {
  const Sombras._();

  static List<BoxShadow> elevada(Color color) => [
    BoxShadow(
      color: color.withValues(alpha: 0.45),
      blurRadius: 18,
      offset: const Offset(0, 6),
    ),
  ];

  static const List<BoxShadow> suave = [
    BoxShadow(color: Color(0x66000000), blurRadius: 14, offset: Offset(0, 6)),
  ];

  /// Resplandor para elementos activos (botón principal, misión disponible).
  static List<BoxShadow> resplandor(Color color) => [
    BoxShadow(
      color: color.withValues(alpha: 0.55),
      blurRadius: 26,
      spreadRadius: 1,
    ),
  ];
}

/// Anchos máximos del contenido para que no se estire en pantallas grandes.
class Anchos {
  const Anchos._();

  static const double formulario = 440;
  static const double contenido = 640;
  static const double cuadricula = 880;
}

/// Puntos de quiebre del diseño adaptable.
class PuntosDeQuiebre {
  const PuntosDeQuiebre._();

  static const double tableta = 600;
  static const double escritorio = 1024;
}
