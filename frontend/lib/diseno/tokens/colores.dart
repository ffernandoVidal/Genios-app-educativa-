import 'package:flutter/material.dart';

/// Paleta oficial de GENIOS. Un solo lugar para todos los colores de la app.
class ColoresGenios {
  const ColoresGenios._();

  // Paleta principal
  static const Color espacioProfundo = Color(0xFF0B2332);
  static const Color azulPetroleo = Color(0xFF103E54);
  static const Color turquesa = Color(0xFF28C7D2);
  static const Color amarilloEspacial = Color(0xFFFFD62A);
  static const Color blancoLunar = Color(0xFFF4F1E8);

  // Derivados para superficies y texto (más claros/oscuros de la paleta principal)
  static const Color superficie = Color(0xFF14506B);
  static const Color superficieOscura = Color(0xFF0E3347);
  static const Color texto = blancoLunar;
  static const Color textoSuave = Color(0xFFB9CDD3);
  static const Color textoSobreClaro = Color(0xFF0B2332);

  // Estados
  static const Color acento = amarilloEspacial;
  static const Color exito = Color(0xFF70BF35);
  static const Color aviso = Color(0xFFFFB84D);
  static const Color error = Color(0xFFFF8A8A);
  static const Color bloqueado = Color(0xFF5A7686);

  // Alias usados por pantallas existentes
  static const Color espacioMedio = azulPetroleo;
  static const Color tarjeta = superficie;
}

/// Color identificativo de cada materia, por código estable del catálogo.
class ColoresMaterias {
  const ColoresMaterias._();

  static const Color matematicas = Color(0xFF319A9B);
  static const Color lenguaje = Color(0xFFA36C35);
  static const Color cienciasNaturales = Color(0xFF70BF35);
  static const Color cienciasSociales = Color(0xFF00B8DC);

  /// Para una materia nueva que aún no tiene color propio.
  static const Color generico = Color(0xFFB794F4);
}

/// Colores del rendimiento académico (Centro de Control Docente). Nunca se usan solos: siempre con icono y texto.
class ColoresRendimiento {
  const ColoresRendimiento._();

  static const Color refuerzo = Color(0xFFEF4444);
  static const Color repaso = Color(0xFFF59E0B);
  static const Color aprobado = Color(0xFF65C947);
  static const Color sinDatos = Color(0xFF8FA6B0);
}
