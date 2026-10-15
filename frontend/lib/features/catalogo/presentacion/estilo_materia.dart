import 'package:flutter/material.dart';

/// Aspecto de cada planeta. Es solo presentación: el catálogo de la API aún no trae color ni icono.
/// Un código desconocido (materia nueva) usa el estilo genérico, sin romper la pantalla.
class EstiloMateria {
  const EstiloMateria({required this.color, required this.icono, this.nombre});

  final Color color;
  final IconData icono;

  /// Nombre con tildes para mostrar; si es null se usa el que envía la API.
  final String? nombre;

  static const EstiloMateria generico = EstiloMateria(
    color: Color(0xFFB794F4),
    icono: Icons.public_rounded,
  );

  static const Map<String, EstiloMateria> _porCodigo = {
    'MATEMATICAS': EstiloMateria(
      color: Color(0xFFFF7A59),
      icono: Icons.calculate_rounded,
      nombre: 'Matemáticas',
    ),
    'LENGUAJE': EstiloMateria(
      color: Color(0xFF4DA3FF),
      icono: Icons.menu_book_rounded,
      nombre: 'Lenguaje',
    ),
    'CIENCIAS_SOCIALES': EstiloMateria(
      color: Color(0xFFFFC53D),
      icono: Icons.travel_explore_rounded,
      nombre: 'Ciencias Sociales',
    ),
    'CIENCIAS_NATURALES': EstiloMateria(
      color: Color(0xFF4ADE80),
      icono: Icons.eco_rounded,
      nombre: 'Ciencias Naturales',
    ),
  };

  static EstiloMateria de(String codigo) => _porCodigo[codigo] ?? generico;
}
