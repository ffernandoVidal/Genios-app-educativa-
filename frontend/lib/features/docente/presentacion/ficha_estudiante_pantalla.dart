import 'colores_docente.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/estado/estado_carga.dart';
import '../../../core/red/excepcion_api.dart';
import '../../../diseno/componentes/botones_juego.dart';
import '../../../diseno/componentes/icono_materia.dart';
import '../../../diseno/componentes/vistas_estado.dart';
import '../../../diseno/tokens/colores.dart';
import '../../../diseno/tokens/medidas.dart';
import '../dominio/repositorio_docente.dart';
import 'componentes/componentes_docente.dart';
import 'componentes/selector_periodo.dart';
import 'cubits_docente.dart';

const _meses = [
  'enero',
  'febrero',
  'marzo',
  'abril',
  'mayo',
  'junio',
  'julio',
  'agosto',
  'septiembre',
  'octubre',
  'noviembre',
  'diciembre',
];
const _diasSemana = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];

/// Estadísticas individuales de un estudiante autorizado. Solo lectura: el docente no modifica calificaciones.
class FichaEstudiantePantalla extends StatelessWidget {
  const FichaEstudiantePantalla({super.key, required this.estudianteId});

  final String estudianteId;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      key: ValueKey(estudianteId),
      providers: [
        BlocProvider(
          create: (c) =>
              FichaCubit(c.read<RepositorioDocente>(), estudianteId)..cargar(),
        ),
        BlocProvider(
          create: (c) => ActividadCubit(
            c.read<RepositorioDocente>(),
            estudianteId,
            DateTime.now(),
          )..cargar(),
        ),
      ],
      child: BlocBuilder<FichaCubit, EstadoCarga<FichaEstudiante>>(
        builder: (context, estado) => switch (estado) {
          Cargando() => const VistaCarga(mensaje: 'Cargando la ficha…'),
          Fallido(:final mensaje, :final sinConexion) => VistaError(
            mensaje: mensaje,
            sinConexion: sinConexion,
            alReintentar: context.read<FichaCubit>().cargar,
          ),
          Cargado(:final datos) => _Ficha(ficha: datos),
        },
      ),
    );
  }
}

class _Ficha extends StatelessWidget {
  const _Ficha({required this.ficha});

  final FichaEstudiante ficha;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<FichaCubit>();
    final sinPartidas = ficha.partidasCompletadas == 0;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () => context.canPop()
                  ? context.pop()
                  : context.go('/docente/alumnos'),
              icon: const Icon(Icons.arrow_back_rounded),
              label: const Text('Volver'),
            ),
          ),
          Bloque(
            titulo: ficha.nombreMostrar,
            accion: ChipRendimiento(ficha.rendimiento),
            hijo: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  [
                    ficha.aulas.map((a) => a.nombre).join(', '),
                    if (ficha.aulas.any((a) => a.grado != null))
                      '${ficha.aulas.firstWhere((a) => a.grado != null).grado}.º grado',
                  ].where((t) => t.isNotEmpty).join(' · '),
                  style: TipografiaDocente.texto(17),
                ),
                Text(
                  'Última actividad: ${textoFecha(ficha.ultimaActividad)}',
                  style: TipografiaDocente.texto(
                    15,
                    color: ColoresDocente.textoSuave,
                  ),
                ),
                const SizedBox(height: Espaciado.m),
                SelectorPeriodo(alElegir: cubit.cambiarPeriodo),
                const SizedBox(height: Espaciado.m),
                Align(
                  alignment: Alignment.centerLeft,
                  child: BotonSecundarioJuego(
                    texto: 'CAMBIAR CONTRASEÑA',
                    icono: Icons.vpn_key_rounded,
                    alPulsar: ficha.aulas.isEmpty
                        ? null
                        : () => _cambiarContrasena(context, ficha),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: Espaciado.l),
          if (sinPartidas)
            Text(
              'Sin actividad en este período.',
              style: TipografiaDocente.texto(
                18,
                color: ColoresDocente.textoSuave,
              ),
            )
          else
            CuadriculaAdaptable(
              anchoMinimo: 230,
              hijos: [
                TarjetaIndicador(
                  icono: Icons.sports_esports_rounded,
                  titulo: 'Partidas completadas',
                  valor: '${ficha.partidasCompletadas}',
                ),
                TarjetaIndicador(
                  icono: Icons.verified_rounded,
                  titulo: 'Partidas aprobadas',
                  valor: '${ficha.partidasAprobadas}',
                  detalle: '7 o más aciertos de 10',
                  color: ColoresRendimiento.aprobado,
                ),
                TarjetaIndicador(
                  icono: Icons.percent_rounded,
                  titulo: 'Nota media (primer intento)',
                  valor: textoPorcentaje(ficha.promedioAciertos),
                  detalle: textoVariacion(ficha.variacion),
                  color: ficha.rendimiento.color,
                ),
                TarjetaIndicador(
                  icono: Icons.timer_rounded,
                  titulo: 'Tiempo medio por partida',
                  valor: textoDuracion(ficha.tiempoMedioSegundos),
                  color: const Color(0xFFC084FC),
                ),
                TarjetaIndicador(
                  icono: Icons.flag_rounded,
                  titulo: 'Misiones completadas',
                  valor: '${ficha.misionesCompletadas}',
                ),
                TarjetaIndicador(
                  icono: Icons.menu_book_rounded,
                  titulo: 'Lecciones aprobadas',
                  valor: '${ficha.leccionesAprobadas}',
                ),
              ],
            ),
          if (ficha.promedioGrupo != null)
            Padding(
              padding: const EdgeInsets.only(top: Espaciado.s),
              child: Text(
                'Promedio del grupo (solo tus estudiantes autorizados): ${textoPorcentaje(ficha.promedioGrupo)}',
                style: TipografiaDocente.texto(
                  15,
                  color: ColoresDocente.textoSuave,
                ),
              ),
            ),
          const SizedBox(height: Espaciado.xl),
          Bloque(
            titulo: 'Partidas completadas por día',
            hijo: ficha.partidasPorDia.isEmpty
                ? Text(
                    'Sin actividad en este período.',
                    style: TipografiaDocente.texto(
                      16,
                      color: ColoresDocente.textoSuave,
                    ),
                  )
                : GraficaBarras(
                    unidad: 'partidas completadas',
                    datos: [
                      for (final p in ficha.partidasPorDia)
                        BarraDato(
                          '${p.fecha.day}/${p.fecha.month}',
                          p.partidas.toDouble(),
                        ),
                    ],
                  ),
          ),
          const SizedBox(height: Espaciado.xl),
          Bloque(
            titulo: 'Rendimiento por materia',
            hijo: Column(
              children: [
                if (ficha.materias.isEmpty)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Sin actividad en este período.',
                      style: TipografiaDocente.texto(
                        16,
                        color: ColoresDocente.textoSuave,
                      ),
                    ),
                  ),
                for (final m in ficha.materias)
                  _FilaMateria(estudianteId: ficha.id, materia: m),
              ],
            ),
          ),
          const SizedBox(height: Espaciado.xl),
          const _Calendario(),
        ],
      ),
    );
  }

  Future<void> _cambiarContrasena(
    BuildContext context,
    FichaEstudiante ficha,
  ) async {
    final repo = context.read<RepositorioDocente>();
    try {
      final codigo = await repo.nuevoCodigo(
        ficha.aulas.first.id,
        ficha.id,
        ficha.nombreMostrar,
      );
      if (!context.mounted) return;
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Código para cambiar la contraseña'),
          content: SingleChildScrollView(
            child: TarjetaActivacion(codigo: codigo),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cerrar'),
            ),
          ],
        ),
      );
    } on ExcepcionApi catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(mensajeDeError(e))));
      }
    }
  }
}

// ------------------------------------------------------------------ Materias

class _FilaMateria extends StatelessWidget {
  const _FilaMateria({required this.estudianteId, required this.materia});

  final String estudianteId;
  final MateriaEstadistica materia;

  @override
  Widget build(BuildContext context) {
    final m = materia;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Espaciado.s),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  EstiloMateria.nombreVisible(m.nombre),
                  style: TipografiaDocente.titulo(20, peso: 700),
                ),
              ),
              ChipRendimiento(m.rendimiento),
            ],
          ),
          const SizedBox(height: Espaciado.xs),
          BarraPorcentaje(
            valor: m.promedioAciertos,
            rendimiento: m.rendimiento,
          ),
          const SizedBox(height: Espaciado.xs),
          Text(
            '${textoPorcentaje(m.promedioAciertos)} de aciertos · ${m.partidas} partidas · ${textoVariacion(m.variacion)}',
            style: TipografiaDocente.texto(
              14,
              color: ColoresDocente.textoSuave,
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () => _verDetalle(context),
              child: const Text('Ver detalle'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _verDetalle(BuildContext context) {
    final repo = context.read<RepositorioDocente>();
    return showDialog<void>(
      context: context,
      builder: (ctx) => BlocProvider(
        create: (_) =>
            DetalleMateriaCubit(repo, estudianteId, materia.asignaturaId)
              ..cargar(),
        child: const _DialogoDetalleMateria(),
      ),
    );
  }
}

class _DialogoDetalleMateria extends StatelessWidget {
  const _DialogoDetalleMateria();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Detalle de la materia'),
      content: SizedBox(
        width: 520,
        child: BlocBuilder<DetalleMateriaCubit, EstadoCarga<DetalleMateria>>(
          builder: (context, estado) => switch (estado) {
            Cargando() => const SizedBox(
              height: 120,
              child: VistaCarga(mensaje: 'Cargando…'),
            ),
            Fallido(:final mensaje) => MensajeAccion(mensaje: mensaje),
            Cargado(:final datos) => _ContenidoDetalle(d: datos),
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cerrar'),
        ),
      ],
    );
  }
}

class _ContenidoDetalle extends StatelessWidget {
  const _ContenidoDetalle({required this.d});

  final DetalleMateria d;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  EstiloMateria.nombreVisible(d.nombre),
                  style: TipografiaDocente.titulo(22, peso: 800),
                ),
              ),
              ChipRendimiento(d.rendimiento),
            ],
          ),
          const SizedBox(height: Espaciado.s),
          Text(
            'Promedio ${textoPorcentaje(d.promedioAciertos)} · ${d.partidas} partidas · tiempo medio ${textoDuracion(d.tiempoMedioSegundos)}',
            style: TipografiaDocente.texto(15),
          ),
          Text(
            '${d.misionesTrabajadas} misiones trabajadas · ${d.leccionesAprobadas} lecciones aprobadas · ${d.leccionesPendientes} pendientes',
            style: TipografiaDocente.texto(15),
          ),
          const SizedBox(height: Espaciado.m),
          Text('Lecciones', style: TipografiaDocente.titulo(18, peso: 800)),
          for (final l in d.lecciones)
            Row(
              children: [
                Icon(
                  l.aprobada
                      ? Icons.check_circle_rounded
                      : Icons.radio_button_unchecked_rounded,
                  size: 18,
                  color: l.aprobada
                      ? ColoresRendimiento.aprobado
                      : ColoresDocente.textoSuave,
                ),
                const SizedBox(width: Espaciado.s),
                Expanded(
                  child: Text(
                    '${l.nombre} · ${l.aprobada ? 'aprobada' : 'pendiente'}${l.mejorAciertos == null ? '' : ' (mejor: ${l.mejorAciertos}/10)'}',
                    style: TipografiaDocente.texto(14),
                  ),
                ),
              ],
            ),
          const SizedBox(height: Espaciado.m),
          Text(
            'Historial de evaluaciones',
            style: TipografiaDocente.titulo(18, peso: 800),
          ),
          if (d.historial.isEmpty)
            Text(
              'Sin evaluaciones.',
              style: TipografiaDocente.texto(
                14,
                color: ColoresDocente.textoSuave,
              ),
            ),
          for (final h in d.historial)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '${textoFecha(h.fecha)} · ${h.leccion} · ${h.aciertos}/${h.evaluadas}',
                      style: TipografiaDocente.texto(14),
                    ),
                  ),
                  ChipRendimiento(h.rendimiento),
                ],
              ),
            ),
          const SizedBox(height: Espaciado.m),
          Text(
            'Preguntas con más errores',
            style: TipografiaDocente.titulo(18, peso: 800),
          ),
          if (d.errores.isEmpty)
            Text(
              'Sin errores registrados.',
              style: TipografiaDocente.texto(
                14,
                color: ColoresDocente.textoSuave,
              ),
            ),
          for (final e in d.errores)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text(
                '• ${e.enunciado} (${e.errores} de ${e.veces})',
                style: TipografiaDocente.texto(14),
              ),
            ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------------ Calendario

class _Calendario extends StatelessWidget {
  const _Calendario();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActividadCubit, EstadoActividad>(
      builder: (context, e) {
        final cubit = context.read<ActividadCubit>();
        final primero = DateTime(e.anio, e.mes, 1);
        final diasMes = DateUtils.getDaysInMonth(e.anio, e.mes);
        final desfase = (primero.weekday + 6) % 7; // lunes = 0
        final porDia = {for (final d in e.dias) d.fecha.day: d};
        final elegido = e.diaElegido != null && e.diaElegido!.month == e.mes
            ? porDia[e.diaElegido!.day]
            : null;

        return Bloque(
          titulo: 'Calendario de actividad',
          hijo: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    tooltip: 'Mes anterior',
                    icon: const Icon(Icons.chevron_left_rounded),
                    onPressed: () => cubit.cambiarMes(-1),
                  ),
                  Flexible(
                    child: Text(
                      '${_meses[e.mes - 1]} ${e.anio}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TipografiaDocente.titulo(20, peso: 800),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Mes siguiente',
                    icon: const Icon(Icons.chevron_right_rounded),
                    onPressed: () => cubit.cambiarMes(1),
                  ),
                ],
              ),
              if (e.cargando)
                const SizedBox(
                  height: 120,
                  child: VistaCarga(mensaje: 'Cargando calendario…'),
                )
              else if (e.error != null)
                MensajeAccion(mensaje: e.error!)
              else ...[
                Row(
                  children: [
                    for (final d in _diasSemana)
                      Expanded(
                        child: Center(
                          child: Text(
                            d,
                            style: TipografiaDocente.texto(
                              13,
                              peso: 800,
                              color: ColoresDocente.textoSuave,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: Espaciado.xs),
                GridView.count(
                  crossAxisCount: 7,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                  children: [
                    for (var i = 0; i < desfase; i++) const SizedBox.shrink(),
                    for (var dia = 1; dia <= diasMes; dia++)
                      _Dia(
                        dia: dia,
                        actividad: porDia[dia],
                        seleccionado:
                            e.diaElegido?.month == e.mes &&
                            e.diaElegido?.day == dia,
                        alElegir: () =>
                            cubit.elegirDia(DateTime(e.anio, e.mes, dia)),
                      ),
                  ],
                ),
                const SizedBox(height: Espaciado.s),
                Text(
                  e.dias.isEmpty ? 'Sin actividad en este mes.' : 'Los días con color tuvieron partidas. Un día sin color no significa bajo rendimiento.',
                  style: TipografiaDocente.texto(
                    13,
                    color: ColoresDocente.textoSuave,
                  ),
                ),
                if (e.diaElegido != null)
                  Padding(
                    padding: const EdgeInsets.only(top: Espaciado.m),
                    child: Text(
                      elegido == null
                          ? '${e.diaElegido!.day} de ${_meses[e.mes - 1]}: sin actividad.'
                          : '${e.diaElegido!.day} de ${_meses[e.mes - 1]}: ${elegido.partidas} partidas · ${textoDuracion(elegido.tiempoActivoSegundos)} de tiempo activo · ${elegido.materias.map(EstiloMateria.nombreVisible).join(', ')}',
                      style: TipografiaDocente.texto(16, peso: 700),
                    ),
                  ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _Dia extends StatelessWidget {
  const _Dia({
    required this.dia,
    required this.actividad,
    required this.seleccionado,
    required this.alElegir,
  });

  final int dia;
  final DiaActividad? actividad;
  final bool seleccionado;
  final VoidCallback alElegir;

  @override
  Widget build(BuildContext context) {
    final activo = actividad != null;
    return Semantics(
      button: true,
      selected: seleccionado,
      label:
          'Día $dia: ${activo ? '${actividad!.partidas} partidas' : 'sin actividad'}',
      excludeSemantics: true,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: alElegir,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: activo
                ? ColoresDocente.acento.withValues(alpha: 0.3)
                : ColoresDocente.pista,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: seleccionado
                  ? ColoresDocente.destacado
                  : Colors.transparent,
              width: 2,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$dia',
                style: TipografiaDocente.texto(14, peso: activo ? 800 : 500),
              ),
              if (activo)
                Text(
                  '${actividad!.partidas}',
                  style: TipografiaDocente.texto(
                    11,
                    color: ColoresDocente.acento,
                    peso: 800,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
