import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/estado/estado_carga.dart';
import '../../../diseno/componentes/astronauta_genios.dart';
import '../../../diseno/componentes/botones_juego.dart';
import '../../../diseno/tokens/colores.dart';
import '../../../diseno/tokens/medidas.dart';
import '../../../diseno/tokens/tipografia.dart';
import '../../catalogo/dominio/modelos_catalogo.dart';
import '../../catalogo/dominio/repositorio_catalogo.dart';
import '../dominio/argumentos_mision.dart';
import '../dominio/modelos_partida.dart';
import 'invitacion_registro.dart';
import 'siguiente_mision_cubit.dart';

/// Pantalla 6: el astronauta celebra o anima, y se muestran las cifras que entregó el servidor.
/// El tono siempre es positivo, también cuando hubo errores.
class ResumenResultados extends StatelessWidget {
  const ResumenResultados({
    super.key,
    required this.resultado,
    required this.categoriaId,
    this.argumentos,
  });

  final ResultadoPartida resultado;
  final int categoriaId;
  final ArgumentosMision? argumentos;

  @override
  Widget build(BuildContext context) {
    final porMecha = resultado.terminoPorMecha;
    final completada = resultado.estado == 'completada';
    final (pose, titulo, mensaje) = porMecha
        ? (
            PoseAstronauta.sorpresa,
            '¡Boom! Se acabó el tiempo',
            'La mecha se agotó antes de acertar. ¡Puedes intentarlo otra vez!',
          )
        : completada
        ? (
            PoseAstronauta.celebracion,
            resultado.categoriaCompletada
                ? '¡Misión completada!'
                : '¡Buen trabajo!',
            resultado.porcentajeAciertos >= 90
                ? '¡Increíble! Casi todo a la primera.'
                : resultado.porcentajeAciertos >= 60
                ? '¡Muy bien! Cada intento te hace más genio.'
                : 'Practicar te hace mejor. ¡Sigue así!',
          )
        : (
            PoseAstronauta.espera,
            '¡Buen intento!',
            'La misión quedó sin terminar. ¡Vuelve cuando quieras!',
          );

    return EscuchaInvitacionRegistro(
      hijo: BlocProvider(
        create: (c) => SiguienteMisionCubit(
          c.read<RepositorioCatalogo>(),
          argumentos?.asignaturaId ?? -1,
          categoriaId,
        )..cargar(),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: Anchos.contenido),
            child: ListView(
              padding: const EdgeInsets.all(Espaciado.pantalla),
              children: [
                Center(child: AstronautaGenios(pose: pose, alto: 200)),
                const SizedBox(height: Espaciado.m),
                Semantics(
                  header: true,
                  liveRegion: true,
                  child: Text(
                    titulo,
                    textAlign: TextAlign.center,
                    style: Tipografia.titulo(
                      40,
                      peso: 800,
                      color: porMecha
                          ? ColoresGenios.error
                          : ColoresGenios.amarilloEspacial,
                    ),
                  ),
                ),
                const SizedBox(height: Espaciado.s),
                Text(
                  mensaje,
                  textAlign: TextAlign.center,
                  style: Tipografia.texto(20, color: ColoresGenios.blancoLunar),
                ),
                const SizedBox(height: Espaciado.xl),
                _Dato(
                  icono: Icons.star_rounded,
                  etiqueta: 'Puntos ganados',
                  valor: '+${resultado.puntosObtenidos}',
                  color: ColoresGenios.amarilloEspacial,
                ),
                if (completada) ...[
                  _Dato(
                    icono: Icons.bolt_rounded,
                    etiqueta: 'Aciertos a la primera',
                    valor:
                        '${resultado.aciertosPrimerIntento} de ${resultado.preguntasEvaluadas} (${resultado.porcentajeAciertos.toStringAsFixed(0)} %)',
                    color: ColoresGenios.turquesa,
                  ),
                  _Dato(
                    icono: Icons.replay_circle_filled_rounded,
                    etiqueta: 'Con reintentos',
                    valor:
                        'Resolviste ${resultado.preguntasEvaluadas} de ${resultado.preguntasEvaluadas}',
                    color: ColoresGenios.exito,
                  ),
                  _Dato(
                    icono: resultado.categoriaCompletada
                        ? Icons.check_circle_rounded
                        : Icons.flag_rounded,
                    etiqueta: 'Misión',
                    valor: resultado.categoriaCompletada
                        ? 'Completada'
                        : 'En camino',
                    color: ColoresGenios.exito,
                  ),
                ],
                const SizedBox(height: Espaciado.xl),
                const _BotonSiguienteMision(),
                const SizedBox(height: Espaciado.m),
                Center(
                  child: BotonPrincipalJuego(
                    texto: 'VOLVER A LAS MISIONES',
                    icono: Icons.map_rounded,
                    alPulsar: () => context.pop(),
                  ),
                ),
                const SizedBox(height: Espaciado.m),
                Center(
                  child: BotonSecundarioJuego(
                    texto: 'JUGAR OTRA VEZ',
                    icono: Icons.replay_rounded,
                    alPulsar: () => context.pushReplacement(
                      '/mision/$categoriaId',
                      extra: argumentos,
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: () => context.go('/cabina'),
                  icon: const Icon(Icons.home_rounded),
                  label: const Text('Ir a la cabina'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BotonSiguienteMision extends StatelessWidget {
  const _BotonSiguienteMision();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SiguienteMisionCubit, EstadoCarga<Mision?>>(
      builder: (context, estado) {
        if (estado is! Cargado<Mision?> || estado.datos == null) {
          return const SizedBox.shrink();
        }
        final siguiente = estado.datos!;
        final cubit = context.read<SiguienteMisionCubit>();
        return Center(
          child: BotonPrincipalJuego(
            texto: 'SIGUIENTE: ${siguiente.nombre.toUpperCase()}',
            icono: Icons.skip_next_rounded,
            alPulsar: () => context.pushReplacement(
              '/mision/${siguiente.id}',
              extra: ArgumentosMision(
                nombre: siguiente.nombre,
                asignaturaId: cubit.asignaturaId,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Dato extends StatelessWidget {
  const _Dato({
    required this.icono,
    required this.etiqueta,
    required this.valor,
    required this.color,
  });

  final IconData icono;
  final String etiqueta;
  final String valor;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$etiqueta: $valor',
      excludeSemantics: true,
      child: Container(
        margin: const EdgeInsets.only(bottom: Espaciado.s),
        padding: const EdgeInsets.symmetric(
          horizontal: Espaciado.l,
          vertical: Espaciado.m,
        ),
        decoration: BoxDecoration(
          color: ColoresGenios.superficie,
          borderRadius: Radios.chip,
          border: Border.all(color: color.withValues(alpha: 0.6), width: 2),
        ),
        child: Row(
          children: [
            Icon(icono, color: color, size: 34),
            const SizedBox(width: Espaciado.m),
            Expanded(
              child: Text(etiqueta, style: Tipografia.texto(18, peso: 800)),
            ),
            Flexible(
              child: Text(
                valor,
                textAlign: TextAlign.end,
                style: Tipografia.titulo(22, peso: 800),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
