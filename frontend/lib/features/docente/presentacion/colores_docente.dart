import 'package:flutter/material.dart';

import '../../../diseno/tokens/colores.dart';
import '../../../diseno/tokens/tipografia.dart';

/// Colores del contenido del panel docente: fondo blanco y texto oscuro. El menú lateral conserva la paleta de GENIOS.
class ColoresDocente {
  const ColoresDocente._();

  static const Color fondo = Color(0xFFFFFFFF);
  static const Color superficie = Color(0xFFF1F5F9);
  static const Color pista = Color(0xFFE2E8F0);
  static const Color borde = Color(0xFFCBD5E1);
  static const Color texto = Color(0xFF0B2332);
  static const Color textoSuave = Color(0xFF4B5E69);
  static const Color acento = Color(0xFF0E7C86);
  static const Color destacado = Color(0xFFB45309);
  static const Color exito = Color(0xFF2F7D32);
  static const Color error = Color(0xFFC62828);
  static const Color menu = ColoresGenios.azulPetroleo;
}

/// Misma tipografía de GENIOS con color oscuro por defecto, para el fondo blanco del panel docente.
class TipografiaDocente {
  const TipografiaDocente._();

  static TextStyle titulo(
    double tamano, {
    double peso = 700,
    Color color = ColoresDocente.texto,
  }) => Tipografia.titulo(tamano, peso: peso, color: color);

  static TextStyle texto(
    double tamano, {
    double peso = 600,
    Color color = ColoresDocente.texto,
  }) => Tipografia.texto(tamano, peso: peso, color: color);
}

/// Tema claro para el contenido del panel (iconos, campos, selectores y chips en oscuro sobre blanco).
ThemeData temaContenidoDocente(ThemeData base) {
  final esquema = ColorScheme.fromSeed(
    seedColor: ColoresDocente.acento,
    brightness: Brightness.light,
  ).copyWith(surface: ColoresDocente.fondo, onSurface: ColoresDocente.texto);
  return base.copyWith(
    brightness: Brightness.light,
    colorScheme: esquema,
    scaffoldBackgroundColor: ColoresDocente.fondo,
    canvasColor: ColoresDocente.fondo,
    iconTheme: const IconThemeData(color: ColoresDocente.texto),
    textTheme: base.textTheme.apply(
      bodyColor: ColoresDocente.texto,
      displayColor: ColoresDocente.texto,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: ColoresDocente.fondo,
      labelStyle: const TextStyle(color: ColoresDocente.textoSuave),
      hintStyle: const TextStyle(color: ColoresDocente.textoSuave),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: ColoresDocente.borde),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: ColoresDocente.borde),
      ),
    ),
    dividerColor: ColoresDocente.borde,
  );
}
