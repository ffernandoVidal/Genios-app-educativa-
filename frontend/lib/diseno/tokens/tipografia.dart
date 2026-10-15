import 'package:flutter/material.dart';

import 'colores.dart';

/// Tipografías de GENIOS: Baloo 2 (redondeada, infantil) para títulos y botones;
/// Nunito (muy legible) para preguntas, formularios y texto corrido. Ambas con licencia SIL OFL 1.1.
class Tipografia {
  const Tipografia._();

  static const String familiaTitulos = 'Baloo2';
  static const String familiaTexto = 'Nunito';

  static FontWeight _aFontWeight(double peso) =>
      FontWeight.values[((peso / 100).round().clamp(1, 9)) - 1];

  /// Títulos, botones e insignias.
  static TextStyle titulo(
    double tamano, {
    double peso = 700,
    Color color = ColoresGenios.texto,
  }) => TextStyle(
    fontFamily: familiaTitulos,
    fontSize: tamano,
    fontWeight: _aFontWeight(peso),
    fontVariations: [FontVariation('wght', peso.clamp(400, 800))],
    color: color,
    height: 1.1,
  );

  /// Preguntas, formularios y explicaciones.
  static TextStyle texto(
    double tamano, {
    double peso = 600,
    Color color = ColoresGenios.texto,
  }) => TextStyle(
    fontFamily: familiaTexto,
    fontSize: tamano,
    fontWeight: _aFontWeight(peso),
    fontVariations: [FontVariation('wght', peso.clamp(200, 1000))],
    color: color,
    height: 1.3,
  );

  static TextTheme tema() => TextTheme(
    displayLarge: titulo(56, peso: 800),
    displayMedium: titulo(44, peso: 800),
    displaySmall: titulo(36, peso: 800),
    headlineLarge: titulo(32, peso: 800),
    headlineMedium: titulo(28, peso: 700),
    headlineSmall: titulo(24, peso: 700),
    titleLarge: titulo(22, peso: 700),
    titleMedium: texto(18, peso: 800),
    titleSmall: texto(16, peso: 800),
    bodyLarge: texto(18),
    bodyMedium: texto(16),
    bodySmall: texto(14),
    labelLarge: titulo(18, peso: 700),
    labelMedium: texto(14, peso: 800),
    labelSmall: texto(12, peso: 800),
  );
}
