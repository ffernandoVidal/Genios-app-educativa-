import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/estado/estado_carga.dart';
import '../../../diseno/componentes/botones_juego.dart';
import '../../../diseno/componentes/icono_materia.dart';
import '../../../diseno/componentes/vistas_estado.dart';
import '../../../diseno/tokens/colores.dart';
import '../../../diseno/tokens/medidas.dart';
import '../../../diseno/tokens/tipografia.dart';
import '../../catalogo/dominio/modelos_catalogo.dart';
import '../../catalogo/dominio/repositorio_catalogo.dart';
import '../dominio/repositorio_docente.dart';
import 'componentes/componentes_docente.dart';
import 'componentes/selector_periodo.dart';
import 'cubits_docente.dart';

const _meses = [
  'ene',
  'feb',
  'mar',
  'abr',
  'may',
  'jun',
  'jul',
  'ago',
  'sep',
  'oct',
  'nov',
  'dic',
];

/// Estadísticas agregadas de una clase y ranking. No muestra comparaciones públicas entre menores:
/// es una vista privada del docente.
class EstadisticasDocentePantalla extends StatefulWidget {
  const EstadisticasDocentePantalla({super.key});

  @override
  State<EstadisticasDocentePantalla> createState() => _EstadoPantalla();
}

class _EstadoPantalla extends State<EstadisticasDocentePantalla> {
  String? _aulaId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AulasDocenteCubit, EstadoCarga<List<AulaDocente>>>(
      builder: (context, estado) => SingleChildScrollView(
        child: switch (estado) {
          Cargando() => const SizedBox(
            height: 200,
            child: VistaCarga(mensaje: 'Cargando tus clases…'),
          ),
          Fallido(:final mensaje, :final sinConexion) => SizedBox(
            height: 300,
            child: VistaError(
              mensaje: mensaje,
              sinConexion: sinConexion,
              alReintentar: context.read<AulasDocenteCubit>().cargar,
            ),
          ),
          Cargado(:final datos) => _contenido(datos),
        },
      ),
    );
  }

  Widget _contenido(List<AulaDocente> aulas) {
    if (aulas.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Estadísticas', style: Tipografia.titulo(30, peso: 800)),
          const SizedBox(height: Espaciado.l),
          Text(
            'Aún no tienes clases. Crea una para ver sus estadísticas.',
            style: Tipografia.texto(18, color: ColoresGenios.textoSuave),
          ),
          const SizedBox(height: Espaciado.l),
          Align(
            alignment: Alignment.centerLeft,
            child: BotonPrincipalJuego(
              texto: 'CREAR CLASE',
              icono: Icons.add_circle_rounded,
              alPulsar: () => context.go('/docente/clases/nueva'),
            ),
          ),
        ],
      );
    }
    final elegida = aulas.any((a) => a.id == _aulaId)
        ? _aulaId!
        : aulas.first.id;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Estadísticas', style: Tipografia.titulo(30, peso: 800)),
        const SizedBox(height: Espaciado.l),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: DropdownButtonFormField<String>(
            initialValue: elegida,
            decoration: const InputDecoration(labelText: 'Clase'),
            items: [
              for (final a in aulas)
                DropdownMenuItem(value: a.id, child: Text(a.nombre)),
            ],
            onChanged: (v) => setState(() => _aulaId = v),
          ),
        ),
        const SizedBox(height: Espaciado.l),
        PanelEstadisticasClase(
          key: ValueKey(elegida),
          aulaId: elegida,
          conSelectorPeriodo: true,
        ),
        const SizedBox(height: Espaciado.xl),
        const _SeccionRanking(),
      ],
    );
  }
}

/// Resultados agregados de una clase: distribución de rendimiento, materias con mayor dificultad y evolución semanal.
class PanelEstadisticasClase extends StatelessWidget {
  const PanelEstadisticasClase({
    super.key,
    required this.aulaId,
    this.conSelectorPeriodo = false,
  });

  final String aulaId;
  final bool conSelectorPeriodo;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (c) => ClaseCubit(c.read<RepositorioDocente>(), aulaId)..cargar(),
      child: BlocBuilder<ClaseCubit, EstadoCarga<EstadisticasClase>>(
        builder: (context, estado) => Bloque(
          titulo: 'Estadísticas de la clase',
          hijo: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (conSelectorPeriodo) ...[
                SelectorPeriodo(
                  alElegir: context.read<ClaseCubit>().cambiarPeriodo,
                ),
                const SizedBox(height: Espaciado.l),
              ],
              switch (estado) {
                Cargando() => const SizedBox(
                  height: 120,
                  child: VistaCarga(mensaje: 'Calculando…'),
                ),
                Fallido(:final mensaje, :final sinConexion) => SizedBox(
                  height: 240,
                  child: VistaError(
                    mensaje: mensaje,
                    sinConexion: sinConexion,
                    alReintentar: context.read<ClaseCubit>().cargar,
                  ),
                ),
                Cargado(:final datos) => _Resultados(d: datos),
              },
            ],
          ),
        ),
      ),
    );
  }
}

class _Resultados extends StatelessWidget {
  const _Resultados({required this.d});

  final EstadisticasClase d;

  @override
  Widget build(BuildContext context) {
    if (d.totalEstudiantes == 0) {
      return Text(
        'Esta clase todavía no tiene estudiantes.',
        style: Tipografia.texto(18, color: ColoresGenios.textoSuave),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CuadriculaAdaptable(
          anchoMinimo: 200,
          hijos: [
            TarjetaIndicador(
              icono: Icons.groups_rounded,
              titulo: 'Estudiantes',
              valor: '${d.totalEstudiantes}',
            ),
            TarjetaIndicador(
              icono: Icons.bolt_rounded,
              titulo: 'Estudiantes activos',
              valor: '${d.estudiantesActivos}',
              color: ColoresRendimiento.aprobado,
            ),
            TarjetaIndicador(
              icono: Icons.sports_esports_rounded,
              titulo: 'Partidas completadas',
              valor: '${d.partidasCompletadas}',
              color: const Color(0xFFC084FC),
            ),
            TarjetaIndicador(
              icono: Icons.percent_rounded,
              titulo: 'Promedio de aciertos',
              valor: textoPorcentaje(d.promedioAciertos),
              detalle: d.rendimiento.etiqueta,
              color: d.rendimiento.color,
            ),
          ],
        ),
        const SizedBox(height: Espaciado.l),
        Text(
          'Distribución de estudiantes por rendimiento',
          style: Tipografia.titulo(18, peso: 800),
        ),
        const SizedBox(height: Espaciado.s),
        Wrap(
          spacing: Espaciado.s,
          runSpacing: Espaciado.s,
          children: [
            _Conteo(Rendimiento.refuerzo, d.refuerzo),
            _Conteo(Rendimiento.repaso, d.repaso),
            _Conteo(Rendimiento.aprobado, d.aprobado),
            _Conteo(Rendimiento.sinDatos, d.sinDatos),
          ],
        ),
        const SizedBox(height: Espaciado.l),
        Text(
          'Materias con mayor dificultad (menor promedio primero)',
          style: Tipografia.titulo(18, peso: 800),
        ),
        const SizedBox(height: Espaciado.s),
        if (d.materias.isEmpty)
          Text(
            'Sin actividad en este período.',
            style: Tipografia.texto(16, color: ColoresGenios.textoSuave),
          ),
        for (final m in d.materias)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: Espaciado.xs),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        EstiloMateria.nombreVisible(m.nombre),
                        style: Tipografia.texto(17, peso: 700),
                      ),
                    ),
                    Text(
                      textoPorcentaje(m.promedioAciertos),
                      style: Tipografia.texto(16, peso: 800),
                    ),
                    const SizedBox(width: Espaciado.s),
                    ChipRendimiento(m.rendimiento),
                  ],
                ),
                const SizedBox(height: 4),
                BarraPorcentaje(
                  valor: m.promedioAciertos,
                  rendimiento: m.rendimiento,
                ),
              ],
            ),
          ),
        const SizedBox(height: Espaciado.l),
        Text('Evolución semanal', style: Tipografia.titulo(18, peso: 800)),
        const SizedBox(height: Espaciado.s),
        d.semanas.isEmpty
            ? Text(
                'Sin actividad en este período.',
                style: Tipografia.texto(16, color: ColoresGenios.textoSuave),
              )
            : GraficaBarras(
                unidad: 'partidas completadas por semana (la etiqueta es el lunes de cada semana)',
                datos: [
                  for (final s in d.semanas)
                    BarraDato(
                      '${s.inicio.day} ${_meses[s.inicio.month - 1]}',
                      s.partidas.toDouble(),
                    ),
                ],
              ),
      ],
    );
  }
}

class _Conteo extends StatelessWidget {
  const _Conteo(this.nivel, this.cantidad);

  final Rendimiento nivel;
  final int cantidad;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '${nivel.etiqueta}: $cantidad estudiantes',
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Espaciado.m,
          vertical: Espaciado.s,
        ),
        decoration: BoxDecoration(
          color: nivel.color.withValues(alpha: 0.18),
          borderRadius: Radios.chip,
          border: Border.all(color: nivel.color, width: 1.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(nivel.icono, color: nivel.color),
            const SizedBox(width: Espaciado.s),
            Text(
              '${nivel.etiqueta}: $cantidad',
              style: Tipografia.texto(16, peso: 800),
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------------------------------ Ranking

class _SeccionRanking extends StatelessWidget {
  const _SeccionRanking();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (c) => RankingCubit(c.read<RepositorioDocente>())..cargar(),
      child: const _CuerpoRanking(),
    );
  }
}

class _CuerpoRanking extends StatefulWidget {
  const _CuerpoRanking();

  @override
  State<_CuerpoRanking> createState() => _CuerpoRankingState();
}

class _CuerpoRankingState extends State<_CuerpoRanking> {
  List<Asignatura> _materias = const [];

  @override
  void initState() {
    super.initState();
    context
        .read<RepositorioCatalogo>()
        .asignaturas()
        .then((m) {
          if (mounted) setState(() => _materias = m);
        })
        .catchError((_) {
          // Sin materias solo se pierde el filtro por materia.
        });
  }

  @override
  Widget build(BuildContext context) {
    final aulas = context.watch<AulasDocenteCubit>().state;
    final listaAulas = aulas is Cargado<List<AulaDocente>>
        ? aulas.datos
        : <AulaDocente>[];
    final cubit = context.read<RankingCubit>();
    return BlocBuilder<RankingCubit, EstadoRanking>(
      builder: (context, e) => Bloque(
        titulo: 'Ranking de estudiantes (por puntos)',
        hijo: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              spacing: Espaciado.m,
              runSpacing: Espaciado.m,
              children: [
                _Filtro<String?>(
                  etiqueta: 'Aula',
                  valor: e.aulaId,
                  opciones: [
                    const DropdownMenuItem(
                      value: null,
                      child: Text('Todas mis aulas'),
                    ),
                    for (final a in listaAulas)
                      DropdownMenuItem(value: a.id, child: Text(a.nombre)),
                  ],
                  alCambiar: (v) =>
                      cubit.cargar(aulaId: v, materiaId: e.materiaId),
                ),
                _Filtro<int?>(
                  etiqueta: 'Materia',
                  valor: e.materiaId,
                  opciones: [
                    const DropdownMenuItem(
                      value: null,
                      child: Text('Todas las materias'),
                    ),
                    for (final m in _materias)
                      DropdownMenuItem(
                        value: m.id,
                        child: Text(EstiloMateria.nombreVisible(m.nombre)),
                      ),
                  ],
                  alCambiar: (v) =>
                      cubit.cargar(aulaId: e.aulaId, materiaId: v),
                ),
              ],
            ),
            const SizedBox(height: Espaciado.l),
            if (e.cargando)
              const SizedBox(
                height: 100,
                child: VistaCarga(mensaje: 'Calculando ranking…'),
              )
            else if (e.error != null)
              MensajeAccion(mensaje: e.error!)
            else if (e.filas.isEmpty)
              Text(
                'Todavía no hay estudiantes para mostrar con estos filtros.',
                style: Tipografia.texto(18, color: ColoresGenios.textoSuave),
              )
            else
              for (final f in e.filas) _FilaPosicion(fila: f),
          ],
        ),
      ),
    );
  }
}

class _Filtro<T> extends StatelessWidget {
  const _Filtro({
    required this.etiqueta,
    required this.valor,
    required this.opciones,
    required this.alCambiar,
  });

  final String etiqueta;
  final T valor;
  final List<DropdownMenuItem<T>> opciones;
  final ValueChanged<T?> alCambiar;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 200, maxWidth: 300),
      child: Semantics(
        label: 'Filtrar por $etiqueta',
        child: DropdownButtonFormField<T>(
          initialValue: valor,
          isExpanded: true,
          decoration: InputDecoration(labelText: etiqueta),
          items: opciones,
          onChanged: alCambiar,
        ),
      ),
    );
  }
}

class _FilaPosicion extends StatelessWidget {
  const _FilaPosicion({required this.fila});

  final FilaRanking fila;

  @override
  Widget build(BuildContext context) {
    final medalla = switch (fila.posicion) {
      1 => ColoresGenios.amarilloEspacial,
      2 => const Color(0xFFC0C8CC),
      3 => const Color(0xFFCD7F32),
      _ => null,
    };
    return Semantics(
      label:
          'Puesto ${fila.posicion}, ${fila.nombreMostrar}, ${fila.puntos} puntos',
      excludeSemantics: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: medalla ?? ColoresGenios.azulPetroleo,
              child: Text(
                '${fila.posicion}',
                style: Tipografia.titulo(
                  18,
                  peso: 800,
                  color: medalla == null
                      ? ColoresGenios.blancoLunar
                      : ColoresGenios.textoSobreClaro,
                ),
              ),
            ),
            const SizedBox(width: Espaciado.m),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fila.nombreMostrar,
                    style: Tipografia.titulo(19, peso: 700),
                  ),
                  Text(
                    '${fila.aulas.join(', ')} · ${textoPorcentaje(fila.porcentajeAciertos)} aciertos · ${fila.partidas} partidas',
                    style: Tipografia.texto(
                      14,
                      color: ColoresGenios.textoSuave,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '${fila.puntos}',
              style: Tipografia.titulo(
                24,
                peso: 800,
                color: ColoresGenios.amarilloEspacial,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.star_rounded,
              color: ColoresGenios.amarilloEspacial,
            ),
          ],
        ),
      ),
    );
  }
}
