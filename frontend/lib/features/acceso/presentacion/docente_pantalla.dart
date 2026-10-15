import 'package:flutter/material.dart';

import '../../../diseno/componentes/astronauta_genios.dart';
import '../../../diseno/componentes/plantilla_pantalla.dart';
import '../../../diseno/tokens/colores.dart';
import '../../../diseno/tokens/medidas.dart';
import '../../../diseno/tokens/tipografia.dart';

/// Punto de entrada separado para docentes. El acceso con Google y el panel docente todavía no están
/// disponibles en esta versión: la pantalla lo dice con claridad en lugar de simular un inicio de sesión.
class DocentePantalla extends StatelessWidget {
  const DocentePantalla({super.key});

  @override
  Widget build(BuildContext context) {
    return PlantillaPantalla(
      titulo: 'Acceso docente',
      hijo: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const AstronautaGenios(alto: 150),
          const SizedBox(height: Espaciado.l),
          Text(
            'El acceso para docentes llegará pronto.',
            textAlign: TextAlign.center,
            style: Tipografia.titulo(26),
          ),
          const SizedBox(height: Espaciado.m),
          Text(
            'Los docentes podrán entrar con su cuenta de Google para crear aulas y consultar el progreso de sus estudiantes.',
            textAlign: TextAlign.center,
            style: Tipografia.texto(18, color: ColoresGenios.textoSuave),
          ),
        ],
      ),
    );
  }
}
