import 'package:flutter/material.dart';

/// Aspecto de cada planeta. Es solo presentación y vive en un único lugar: el catálogo de la API aún no trae
/// color, icono ni posición. Un código desconocido (materia nueva) usa el estilo genérico, sin romper la pantalla.
class EstiloMateria {
  const EstiloMateria({required this.color, required this.icono});

  final Color color;
  final IconData icono;

  static const EstiloMateria generico = EstiloMateria(
    color: Color(0xFFB794F4),
    icono: Icons.public_rounded,
  );

  static const Map<String, EstiloMateria> _porCodigo = {
    'MATEMATICAS': EstiloMateria(
      color: Color(0xFFFF7A59),
      icono: Icons.calculate_rounded,
    ),
    'LENGUAJE': EstiloMateria(
      color: Color(0xFF4DA3FF),
      icono: Icons.menu_book_rounded,
    ),
    'CIENCIAS_SOCIALES': EstiloMateria(
      color: Color(0xFFFFC53D),
      icono: Icons.travel_explore_rounded,
    ),
    'CIENCIAS_NATURALES': EstiloMateria(
      color: Color(0xFF4ADE80),
      icono: Icons.eco_rounded,
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
