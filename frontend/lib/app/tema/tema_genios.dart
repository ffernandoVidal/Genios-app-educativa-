import 'package:flutter/material.dart';

/// Paleta y tema del universo GENIOS. Fondo oscuro con colores vivos y alto contraste.
class ColoresGenios {
  const ColoresGenios._();

  static const Color espacioProfundo = Color(0xFF0B1033);
  static const Color espacioMedio = Color(0xFF1B1F5E);
  static const Color nebulosa = Color(0xFF3B2A7A);
  static const Color texto = Color(0xFFF5F6FF);
  static const Color textoSuave = Color(0xFFC9CCF2);
  static const Color acento = Color(0xFFFFC53D);
  static const Color exito = Color(0xFF4ADE80);
  static const Color aviso = Color(0xFFFFB84D);
  static const Color error = Color(0xFFFF8A8A);
  static const Color tarjeta = Color(0xFF22276F);
}

class TemaGenios {
  const TemaGenios._();

  static ThemeData construir() {
    final esquema =
        ColorScheme.fromSeed(
          seedColor: ColoresGenios.acento,
          brightness: Brightness.dark,
          surface: ColoresGenios.tarjeta,
        ).copyWith(
          primary: ColoresGenios.acento,
          onPrimary: ColoresGenios.espacioProfundo,
          error: ColoresGenios.error,
        );

    return ThemeData(
      useMaterial3: true,
      colorScheme: esquema,
      scaffoldBackgroundColor: ColoresGenios.espacioProfundo,
      textTheme: Typography.whiteMountainView.apply(
        bodyColor: ColoresGenios.texto,
        displayColor: ColoresGenios.texto,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(64, 56), // objetivo táctil amplio
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(64, 56),
          foregroundColor: ColoresGenios.texto,
          side: const BorderSide(color: ColoresGenios.textoSuave, width: 2),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ColoresGenios.tarjeta,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        labelStyle: const TextStyle(
          color: ColoresGenios.textoSuave,
          fontSize: 16,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
    );
  }
}
