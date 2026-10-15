import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../diseno/componentes/botones_juego.dart';
import '../../../../diseno/tokens/colores.dart';
import '../../../../diseno/tokens/medidas.dart';
import '../../../../diseno/tokens/tipografia.dart';
import '../../dominio/modelos_docente.dart';
import 'componentes_docente.dart';

/// Fila de un estudiante autorizado: cifras clave, estado de rendimiento y acceso a su ficha.
class FilaEstudianteTarjeta extends StatelessWidget {
  const FilaEstudianteTarjeta({super.key, required this.estudiante});

  final FilaEstudiante estudiante;

  @override
  Widget build(BuildContext context) {
    final e = estudiante;
    final aulas = e.aulas.map((a) => a.nombre).join(', ');
    return Semantics(
      container: true,
      label:
          '${e.nombreMostrar}. ${e.rendimiento.etiqueta}. ${e.partidas} partidas. Promedio ${textoPorcentaje(e.promedioAciertos)}',
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Espaciado.s),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: Espaciado.l,
          runSpacing: Espaciado.s,
          children: [
            const Icon(
              Icons.face_rounded,
              color: ColoresGenios.turquesa,
              size: 36,
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 160, maxWidth: 320),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    e.nombreMostrar,
                    style: Tipografia.titulo(20, peso: 700),
                  ),
                  Text(
                    '${aulas.isEmpty ? 'Sin aula' : aulas}${e.grado == null ? '' : ' · ${e.grado}.º grado'}',
                    style: Tipografia.texto(
                      14,
                      color: ColoresGenios.textoSuave,
                    ),
                  ),
                  Text(
                    'Última actividad: ${textoFecha(e.ultimaActividad)}',
                    style: Tipografia.texto(
                      13,
                      color: ColoresGenios.textoSuave,
                    ),
                  ),
                ],
              ),
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 130),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${e.partidas} partidas',
                    style: Tipografia.texto(16, peso: 800),
                  ),
                  Text(
                    e.promedioAciertos == null
                        ? 'Sin actividad'
                        : '${textoPorcentaje(e.promedioAciertos)} de aciertos',
                    style: Tipografia.texto(
                      14,
                      color: ColoresGenios.textoSuave,
                    ),
                  ),
                ],
              ),
            ),
            ChipRendimiento(e.rendimiento),
            BotonSecundarioJuego(
              texto: 'VER DETALLE',
              icono: Icons.chevron_right_rounded,
              alPulsar: () => context.go('/docente/alumnos/${e.id}'),
            ),
          ],
        ),
      ),
    );
  }
}
