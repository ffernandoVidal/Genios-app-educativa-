import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/estado/estado_carga.dart';
import '../../../diseno/componentes/vistas_estado.dart';
import '../../../diseno/tokens/colores.dart';
import '../../../diseno/tokens/medidas.dart';
import '../../../diseno/tokens/tipografia.dart';
import '../dominio/repositorio_docente.dart';
import 'componentes/componentes_docente.dart';
import 'componentes/fila_estudiante.dart';
import 'cubits_docente.dart';

/// Listado de alumnos autorizados con búsqueda, filtros, orden y paginación. Todo se resuelve en el servidor.
class AlumnosDocentePantalla extends StatelessWidget {
  const AlumnosDocentePantalla({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (c) => AlumnosCubit(c.read<RepositorioDocente>())..cargar(),
      child: const _Vista(),
    );
  }
}

class _Vista extends StatefulWidget {
  const _Vista();

  @override
  State<_Vista> createState() => _VistaState();
}

class _VistaState extends State<_Vista> {
  final _busqueda = TextEditingController();

  @override
  void dispose() {
    _busqueda.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final aulas = context.watch<AulasDocenteCubit>().state;
    final listaAulas = aulas is Cargado<List<AulaDocente>>
        ? aulas.datos
        : <AulaDocente>[];
    final cubit = context.read<AlumnosCubit>();

    return SingleChildScrollView(
      child: BlocBuilder<AlumnosCubit, EstadoAlumnos>(
        builder: (context, e) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Alumnos', style: Tipografia.titulo(30, peso: 800)),
            const SizedBox(height: Espaciado.l),
            Bloque(
              titulo: 'Buscar y filtrar',
              hijo: Wrap(
                spacing: Espaciado.m,
                runSpacing: Espaciado.m,
                children: [
                  SizedBox(
                    width: 280,
                    child: TextField(
                      controller: _busqueda,
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration(
                        labelText: 'Buscar por nombre',
                        prefixIcon: const Icon(Icons.search_rounded),
                        suffixIcon: IconButton(
                          tooltip: 'Buscar',
                          icon: const Icon(Icons.arrow_forward_rounded),
                          onPressed: () =>
                              cubit.filtrar(busqueda: _busqueda.text),
                        ),
                      ),
                      onSubmitted: (v) => cubit.filtrar(busqueda: v),
                    ),
                  ),
                  _Filtro<String?>(
                    etiqueta: 'Aula',
                    valor: e.aulaId,
                    opciones: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('Todas las aulas'),
                      ),
                      for (final a in listaAulas)
                        DropdownMenuItem(value: a.id, child: Text(a.nombre)),
                    ],
                    alCambiar: (v) =>
                        cubit.filtrar(aulaId: v, limpiarAula: v == null),
                  ),
                  _Filtro<int?>(
                    etiqueta: 'Grado',
                    valor: e.grado,
                    opciones: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('Todos los grados'),
                      ),
                      for (var g = 1; g <= 6; g++)
                        DropdownMenuItem(value: g, child: Text('$g.º grado')),
                    ],
                    alCambiar: (v) =>
                        cubit.filtrar(grado: v, limpiarGrado: v == null),
                  ),
                  _Filtro<Rendimiento?>(
                    etiqueta: 'Rendimiento',
                    valor: e.rendimiento,
                    opciones: [
                      const DropdownMenuItem(value: null, child: Text('Todos')),
                      for (final r in Rendimiento.values)
                        DropdownMenuItem(value: r, child: Text(r.etiqueta)),
                    ],
                    alCambiar: (v) => cubit.filtrar(
                      rendimiento: v,
                      limpiarRendimiento: v == null,
                    ),
                  ),
                  _Filtro<String>(
                    etiqueta: 'Ordenar por',
                    valor: e.orden,
                    opciones: const [
                      DropdownMenuItem(value: 'nombre', child: Text('Nombre')),
                      DropdownMenuItem(
                        value: 'actividad',
                        child: Text('Última actividad'),
                      ),
                      DropdownMenuItem(
                        value: 'rendimiento',
                        child: Text('Rendimiento'),
                      ),
                    ],
                    alCambiar: (v) => cubit.filtrar(orden: v),
                  ),
                ],
              ),
            ),
            const SizedBox(height: Espaciado.l),
            Bloque(
              titulo: e.pagina == null
                  ? 'Estudiantes'
                  : 'Estudiantes (${e.pagina!.total})',
              hijo: _lista(context, e),
            ),
          ],
        ),
      ),
    );
  }

  Widget _lista(BuildContext context, EstadoAlumnos e) {
    if (e.cargando && e.pagina == null) {
      return const SizedBox(
        height: 120,
        child: VistaCarga(mensaje: 'Cargando alumnos…'),
      );
    }
    if (e.error != null) {
      return SizedBox(
        height: 240,
        child: VistaError(
          mensaje: e.error!,
          alReintentar: context.read<AlumnosCubit>().cargar,
        ),
      );
    }
    final pagina = e.pagina!;
    if (pagina.filas.isEmpty) {
      return Text(
        e.busqueda.isNotEmpty ||
                e.aulaId != null ||
                e.grado != null ||
                e.rendimiento != null
            ? 'Ningún estudiante coincide con estos filtros.'
            : 'Todavía no tienes estudiantes asignados. Comparte el código de tu clase o crea alumnos desde «Crear alumno».',
        style: Tipografia.texto(18, color: ColoresGenios.textoSuave),
      );
    }
    return Column(
      children: [
        for (final f in pagina.filas) FilaEstudianteTarjeta(estudiante: f),
        const SizedBox(height: Espaciado.m),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              tooltip: 'Página anterior',
              onPressed: pagina.pagina > 1
                  ? () => context.read<AlumnosCubit>().irAPagina(
                      pagina.pagina - 1,
                    )
                  : null,
              icon: const Icon(Icons.chevron_left_rounded),
            ),
            Text(
              'Página ${pagina.pagina} de ${pagina.paginas}',
              style: Tipografia.texto(16, peso: 700),
            ),
            IconButton(
              tooltip: 'Página siguiente',
              onPressed: pagina.pagina < pagina.paginas
                  ? () => context.read<AlumnosCubit>().irAPagina(
                      pagina.pagina + 1,
                    )
                  : null,
              icon: const Icon(Icons.chevron_right_rounded),
            ),
          ],
        ),
      ],
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
      constraints: const BoxConstraints(minWidth: 180, maxWidth: 260),
      child: Semantics(
        label: 'Filtrar: $etiqueta',
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
