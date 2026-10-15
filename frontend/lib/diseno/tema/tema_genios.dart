import 'package:flutter/material.dart';

import '../tokens/colores.dart';
import '../tokens/medidas.dart';
import '../tokens/tipografia.dart';

/// Tema global de GENIOS. Las pantallas no definen estilos propios: usan este tema y los componentes de `diseno/`.
class TemaGenios {
  const TemaGenios._();

  static ThemeData construir() {
    final esquema =
        ColorScheme.fromSeed(
          seedColor: ColoresGenios.turquesa,
          brightness: Brightness.dark,
          surface: ColoresGenios.superficie,
        ).copyWith(
          primary: ColoresGenios.amarilloEspacial,
          onPrimary: ColoresGenios.textoSobreClaro,
          secondary: ColoresGenios.turquesa,
          onSecondary: ColoresGenios.textoSobreClaro,
          error: ColoresGenios.error,
        );

    return ThemeData(
      useMaterial3: true,
      colorScheme: esquema,
      scaffoldBackgroundColor: ColoresGenios.espacioProfundo,
      textTheme: Tipografia.tema(),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(64, 60),
          textStyle: Tipografia.titulo(20, peso: 800),
          shape: RoundedRectangleBorder(borderRadius: Radios.boton),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(64, 60),
          foregroundColor: ColoresGenios.texto,
          side: const BorderSide(color: ColoresGenios.turquesa, width: 2.5),
          textStyle: Tipografia.titulo(20, peso: 800),
          shape: RoundedRectangleBorder(borderRadius: Radios.boton),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(64, Espaciado.objetivoTactil),
          foregroundColor: ColoresGenios.turquesa,
          textStyle: Tipografia.texto(16, peso: 800),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ColoresGenios.superficieOscura,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Radios.m),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Radios.m),
          borderSide: const BorderSide(
            color: ColoresGenios.superficie,
            width: 2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Radios.m),
          borderSide: const BorderSide(color: ColoresGenios.turquesa, width: 3),
        ),
        labelStyle: Tipografia.texto(16, color: ColoresGenios.textoSuave),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: ColoresGenios.azulPetroleo,
        shape: RoundedRectangleBorder(borderRadius: Radios.tarjeta),
        titleTextStyle: Tipografia.titulo(26, peso: 800),
        contentTextStyle: Tipografia.texto(18),
      ),
      drawerTheme: const DrawerThemeData(
        backgroundColor: ColoresGenios.azulPetroleo,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: Tipografia.titulo(24, peso: 800),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (e) => e.contains(WidgetState.selected)
              ? ColoresGenios.amarilloEspacial
              : ColoresGenios.textoSuave,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (e) => e.contains(WidgetState.selected)
              ? ColoresGenios.turquesa
              : ColoresGenios.superficieOscura,
        ),
      ),
    );
  }
}
