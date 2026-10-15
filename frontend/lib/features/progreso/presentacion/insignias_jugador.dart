import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../app/tema/tema_genios.dart';
import '../../../core/estado/estado_carga.dart';
import '../dominio/modelos_progreso.dart';
import 'progreso_cubits.dart';

/// Insignias de la cabecera: puntos y tiempo del día (estudiante) o avance del invitado. Al tocarlas se abre "Mi progreso".
/// Si no se pueden cargar, simplemente no se muestran: no estorban a la pantalla principal.
class InsigniasJugador extends StatelessWidget {
  const InsigniasJugador({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ResumenJugadorCubit, EstadoCarga<ResumenJugador>>(
      builder: (context, estado) {
        if (estado is! Cargado<ResumenJugador>) return const SizedBox.shrink();
        final r = estado.datos;
        final insignias = r.esInvitado
            ? [
                _Insignia(
                  icono: Icons.person_outline_rounded,
                  texto:
                      'Invitado ${r.partidasQueCuentan}/${r.partidasRequeridas}',
                  color: ColoresGenios.textoSuave,
                ),
              ]
            : [
                _Insignia(
                  icono: Icons.star_rounded,
                  texto: '${r.puntos} puntos',
                  color: ColoresGenios.acento,
                ),
                _Insignia(
                  icono: r.limiteAlcanzado
                      ? Icons.bedtime_rounded
                      : Icons.timer_rounded,
                  texto: r.limiteAlcanzado
                      ? 'Tiempo de hoy completo'
                      : '${r.minutosRestantes} min hoy',
                  color: r.limiteAlcanzado
                      ? ColoresGenios.aviso
                      : ColoresGenios.exito,
                ),
              ];
        return Semantics(
          button: true,
          label: 'Mi progreso. ${insignias.map((i) => i.texto).join('. ')}',
          excludeSemantics: true,
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: () => context.push('/progreso'),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              child: Wrap(
                spacing: 8,
                runSpacing: 4,
                alignment: WrapAlignment.end,
                children: insignias,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Insignia extends StatelessWidget {
  const _Insignia({
    required this.icono,
    required this.texto,
    required this.color,
  });

  final IconData icono;
  final String texto;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: ColoresGenios.tarjeta,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icono, size: 18, color: color),
          const SizedBox(width: 6),
          Text(
            texto,
            style: Theme.of(context).textTheme.labelLarge
                ?.copyWith(fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}
