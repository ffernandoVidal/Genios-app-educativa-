import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/estado/estado_carga.dart';
import '../../../core/red/excepcion_api.dart';
import '../../../diseno/componentes/botones_juego.dart';
import '../../../diseno/componentes/campo_genios.dart';
import '../../../diseno/componentes/vistas_estado.dart';
import '../../../diseno/tokens/colores.dart';
import '../../../diseno/tokens/medidas.dart';
import '../../../diseno/tokens/tipografia.dart';
import '../dominio/repositorio_docente.dart';
import 'componentes/componentes_docente.dart';
import 'componentes/fila_estudiante.dart';
import 'cubits_docente.dart';
import 'estadisticas_docente_pantalla.dart';

Widget _cargaDeClases(
  BuildContext context,
  EstadoCarga<List<AulaDocente>> estado,
  Widget Function(List<AulaDocente>) cuando,
) => switch (estado) {
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
  Cargado(:final datos) => cuando(datos),
};

// ------------------------------------------------------------------ Mis clases

class ClasesDocentePantalla extends StatelessWidget {
  const ClasesDocentePantalla({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: Espaciado.l,
            runSpacing: Espaciado.m,
            children: [
              Text('Mis clases', style: Tipografia.titulo(30, peso: 800)),
              BotonPrincipalJuego(
                texto: 'CREAR CLASE',
                icono: Icons.add_circle_rounded,
                alPulsar: () => context.go('/docente/clases/nueva'),
              ),
            ],
          ),
          const SizedBox(height: Espaciado.l),
          BlocBuilder<AulasDocenteCubit, EstadoCarga<List<AulaDocente>>>(
            builder: (context, estado) => _cargaDeClases(context, estado, (
              aulas,
            ) {
              if (aulas.isEmpty) {
                return Text(
                  'Todavía no tienes clases. Crea la primera para obtener su código.',
                  style: Tipografia.texto(18, color: ColoresGenios.textoSuave),
                );
              }
              return CuadriculaAdaptable(
                anchoMinimo: 300,
                hijos: [for (final a in aulas) _TarjetaClase(aula: a)],
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _TarjetaClase extends StatelessWidget {
  const _TarjetaClase({required this.aula});

  final AulaDocente aula;

  @override
  Widget build(BuildContext context) {
    return Bloque(
      titulo: aula.nombre,
      hijo: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (aula.detalle.isNotEmpty)
            Text(
              aula.detalle,
              style: Tipografia.texto(16, color: ColoresGenios.textoSuave),
            ),
          const SizedBox(height: Espaciado.s),
          Row(
            children: [
              Expanded(
                child: Semantics(
                  label: 'Código de la clase ${aula.codigoAcceso ?? ''}',
                  excludeSemantics: true,
                  child: SelectableText(
                    aula.codigoAcceso ?? '—',
                    style: Tipografia.titulo(
                      30,
                      peso: 800,
                      color: ColoresGenios.amarilloEspacial,
                    ),
                  ),
                ),
              ),
              if (aula.codigoAcceso != null)
                IconButton(
                  tooltip: 'Copiar código',
                  iconSize: 28,
                  constraints: const BoxConstraints(
                    minWidth: 48,
                    minHeight: 48,
                  ),
                  icon: const Icon(Icons.copy_rounded),
                  onPressed: () => copiarTexto(context, aula.codigoAcceso!),
                ),
            ],
          ),
          Text(
            '${aula.totalEstudiantes} alumnos · Activa',
            style: Tipografia.texto(16, peso: 700),
          ),
          const SizedBox(height: Espaciado.m),
          Align(
            alignment: Alignment.centerLeft,
            child: BotonSecundarioJuego(
              texto: 'ADMINISTRAR',
              icono: Icons.tune_rounded,
              alPulsar: () => context.go('/docente/clases/${aula.id}'),
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------------ Crear clase

class CrearClasePantalla extends StatefulWidget {
  const CrearClasePantalla({super.key});

  @override
  State<CrearClasePantalla> createState() => _CrearClasePantallaState();
}

class _CrearClasePantallaState extends State<CrearClasePantalla> {
  final _nombre = TextEditingController();
  final _seccion = TextEditingController();
  final _descripcion = TextEditingController();
  int? _grado;
  bool _ocupado = false;
  String? _error;
  AulaDocente? _creada;

  @override
  void dispose() {
    _nombre.dispose();
    _seccion.dispose();
    _descripcion.dispose();
    super.dispose();
  }

  Future<void> _crear() async {
    if (_nombre.text.trim().isEmpty) {
      setState(() => _error = 'Escribe el nombre de la clase.');
      return;
    }
    if (_grado == null) {
      setState(() => _error = 'Elige el grado.');
      return;
    }
    setState(() {
      _ocupado = true;
      _error = null;
    });
    try {
      final aula = await context.read<AulasDocenteCubit>().crear(
        nombre: _nombre.text.trim(),
        grado: _grado,
        seccion: _seccion.text.trim().isEmpty ? null : _seccion.text.trim(),
        descripcion: _descripcion.text.trim().isEmpty
            ? null
            : _descripcion.text.trim(),
      );
      if (mounted) setState(() => _creada = aula);
    } on ExcepcionApi catch (e) {
      if (mounted) setState(() => _error = mensajeDeError(e));
    } finally {
      if (mounted) setState(() => _ocupado = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_creada != null) return _Confirmacion(aula: _creada!);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Crear clase', style: Tipografia.titulo(30, peso: 800)),
          const SizedBox(height: Espaciado.l),
          Bloque(
            titulo: 'Datos de la clase',
            hijo: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CampoGenios(
                  controlador: _nombre,
                  etiqueta:
                      'Nombre de la clase (por ejemplo, Quinto Primaria A)',
                  icono: Icons.school_rounded,
                  habilitado: !_ocupado,
                ),
                const SizedBox(height: Espaciado.m),
                DropdownButtonFormField<int>(
                  initialValue: _grado,
                  decoration: const InputDecoration(labelText: 'Grado'),
                  items: [
                    for (var g = 1; g <= 6; g++)
                      DropdownMenuItem(value: g, child: Text('$g.º grado')),
                  ],
                  onChanged: _ocupado
                      ? null
                      : (v) => setState(() => _grado = v),
                ),
                const SizedBox(height: Espaciado.m),
                CampoGenios(
                  controlador: _seccion,
                  etiqueta: 'Sección (opcional, por ejemplo A)',
                  icono: Icons.label_rounded,
                  habilitado: !_ocupado,
                  longitudMaxima: 10,
                ),
                const SizedBox(height: Espaciado.m),
                CampoGenios(
                  controlador: _descripcion,
                  etiqueta: 'Descripción (opcional)',
                  icono: Icons.notes_rounded,
                  habilitado: !_ocupado,
                  alEnviar: _crear,
                ),
                const SizedBox(height: Espaciado.l),
                Align(
                  alignment: Alignment.centerLeft,
                  child: BotonPrincipalJuego(
                    texto: 'CREAR CLASE',
                    icono: Icons.add_circle_rounded,
                    ocupado: _ocupado,
                    alPulsar: _crear,
                  ),
                ),
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: Espaciado.l),
                    child: MensajeAccion(mensaje: _error!),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Confirmacion extends StatelessWidget {
  const _Confirmacion({required this.aula});

  final AulaDocente aula;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Bloque(
        titulo: '¡Clase creada!',
        hijo: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const MensajeAccion(
              mensaje: 'Tu clase ya está lista. Comparte este código con tus estudiantes.',
              esError: false,
            ),
            const SizedBox(height: Espaciado.l),
            Text(aula.nombre, style: Tipografia.titulo(24, peso: 800)),
            if (aula.detalle.isNotEmpty)
              Text(
                aula.detalle,
                style: Tipografia.texto(16, color: ColoresGenios.textoSuave),
              ),
            const SizedBox(height: Espaciado.m),
            Row(
              children: [
                Expanded(
                  child: SelectableText(
                    aula.codigoAcceso ?? '—',
                    style: Tipografia.titulo(
                      44,
                      peso: 800,
                      color: ColoresGenios.amarilloEspacial,
                    ),
                  ),
                ),
                if (aula.codigoAcceso != null)
                  IconButton(
                    tooltip: 'Copiar código',
                    iconSize: 30,
                    constraints: const BoxConstraints(
                      minWidth: 56,
                      minHeight: 56,
                    ),
                    icon: const Icon(Icons.copy_rounded),
                    onPressed: () => copiarTexto(context, aula.codigoAcceso!),
                  ),
              ],
            ),
            Text(
              '0 alumnos · el código es permanente',
              style: Tipografia.texto(16, color: ColoresGenios.textoSuave),
            ),
            const SizedBox(height: Espaciado.l),
            BotonPrincipalJuego(
              texto: 'ADMINISTRAR LA CLASE',
              icono: Icons.tune_rounded,
              alPulsar: () => context.go('/docente/clases/${aula.id}'),
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------------------------------ Detalle de la clase

class DetalleClasePantalla extends StatelessWidget {
  const DetalleClasePantalla({super.key, required this.aulaId});

  final String aulaId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AulasDocenteCubit, EstadoCarga<List<AulaDocente>>>(
      builder: (context, estado) => SingleChildScrollView(
        child: _cargaDeClases(context, estado, (aulas) {
          final aula = aulas.where((a) => a.id == aulaId).firstOrNull;
          if (aula == null) {
            return Column(
              children: [
                Text(
                  'No encontramos esta clase. Puede que ya esté archivada.',
                  style: Tipografia.texto(18),
                ),
                const SizedBox(height: Espaciado.l),
                BotonSecundarioJuego(
                  texto: 'VOLVER A MIS CLASES',
                  icono: Icons.arrow_back_rounded,
                  alPulsar: () => context.go('/docente/clases'),
                ),
              ],
            );
          }
          return _ContenidoClase(aula: aula);
        }),
      ),
    );
  }
}

class _ContenidoClase extends StatelessWidget {
  const _ContenidoClase({required this.aula});

  final AulaDocente aula;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          key: ValueKey('alumnos-${aula.id}'),
          create: (c) =>
              AlumnosCubit(c.read<RepositorioDocente>(), aulaInicial: aula.id)
                ..cargar(),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(aula.nombre, style: Tipografia.titulo(30, peso: 800)),
          const SizedBox(height: Espaciado.l),
          Bloque(
            titulo: 'Información general',
            hijo: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  [
                    if (aula.detalle.isNotEmpty) aula.detalle,
                    '${aula.totalEstudiantes} alumnos',
                    'Estado: activa',
                  ].join(' · '),
                  style: Tipografia.texto(17),
                ),
                if (aula.descripcion != null && aula.descripcion!.isNotEmpty)
                  Text(
                    aula.descripcion!,
                    style: Tipografia.texto(
                      16,
                      color: ColoresGenios.textoSuave,
                    ),
                  ),
                const SizedBox(height: Espaciado.m),
                Row(
                  children: [
                    Text('Código: ', style: Tipografia.texto(18, peso: 700)),
                    SelectableText(
                      aula.codigoAcceso ?? '—',
                      style: Tipografia.titulo(
                        28,
                        peso: 800,
                        color: ColoresGenios.amarilloEspacial,
                      ),
                    ),
                    if (aula.codigoAcceso != null)
                      IconButton(
                        tooltip: 'Copiar código',
                        icon: const Icon(Icons.copy_rounded),
                        onPressed: () =>
                            copiarTexto(context, aula.codigoAcceso!),
                      ),
                  ],
                ),
                const SizedBox(height: Espaciado.m),
                Wrap(
                  spacing: Espaciado.m,
                  runSpacing: Espaciado.m,
                  children: [
                    BotonSecundarioJuego(
                      texto: 'EDITAR DATOS',
                      icono: Icons.edit_rounded,
                      alPulsar: () => _editar(context, aula),
                    ),
                    BotonSecundarioJuego(
                      texto: 'ARCHIVAR CLASE',
                      icono: Icons.archive_rounded,
                      alPulsar: () => _archivar(context, aula),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: Espaciado.xl),
          Bloque(
            titulo: 'Alumnos de la clase',
            accion: TextButton.icon(
              onPressed: () => context.go('/docente/alumnos/nuevo'),
              icon: const Icon(Icons.person_add_alt_1_rounded),
              label: const Text('Agregar'),
            ),
            hijo: BlocBuilder<AlumnosCubit, EstadoAlumnos>(
              builder: (context, e) {
                if (e.cargando && e.pagina == null) {
                  return const SizedBox(
                    height: 100,
                    child: VistaCarga(mensaje: 'Cargando alumnos…'),
                  );
                }
                if (e.error != null) return MensajeAccion(mensaje: e.error!);
                final filas = e.pagina?.filas ?? [];
                if (filas.isEmpty) {
                  return Text(
                    'Aún no hay alumnos en esta clase.',
                    style: Tipografia.texto(
                      18,
                      color: ColoresGenios.textoSuave,
                    ),
                  );
                }
                return Column(
                  children: [
                    for (final f in filas) FilaEstudianteTarjeta(estudiante: f),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: Espaciado.xl),
          PanelEstadisticasClase(aulaId: aula.id),
        ],
      ),
    );
  }

  Future<void> _editar(BuildContext context, AulaDocente aula) async {
    final nombre = TextEditingController(text: aula.nombre);
    final seccion = TextEditingController(text: aula.seccion ?? '');
    final descripcion = TextEditingController(text: aula.descripcion ?? '');
    int? grado = aula.grado;
    final cubit = context.read<AulasDocenteCubit>();
    final guardar = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: const Text('Editar clase'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nombre,
                  decoration: const InputDecoration(labelText: 'Nombre'),
                ),
                const SizedBox(height: Espaciado.m),
                DropdownButtonFormField<int>(
                  initialValue: grado,
                  decoration: const InputDecoration(labelText: 'Grado'),
                  items: [
                    for (var g = 1; g <= 6; g++)
                      DropdownMenuItem(value: g, child: Text('$g.º grado')),
                  ],
                  onChanged: (v) => setState(() => grado = v),
                ),
                const SizedBox(height: Espaciado.m),
                TextField(
                  controller: seccion,
                  maxLength: 10,
                  decoration: const InputDecoration(labelText: 'Sección'),
                ),
                TextField(
                  controller: descripcion,
                  decoration: const InputDecoration(labelText: 'Descripción'),
                ),
                const SizedBox(height: Espaciado.s),
                Text(
                  'El código de la clase no cambia.',
                  style: Tipografia.texto(14, color: ColoresGenios.textoSuave),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
    if (guardar != true || nombre.text.trim().isEmpty) return;
    try {
      await cubit.editar(
        aula.id,
        nombre: nombre.text.trim(),
        grado: grado,
        seccion: seccion.text.trim(),
        descripcion: descripcion.text.trim(),
      );
    } on ExcepcionApi catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(mensajeDeError(e))));
      }
    }
  }

  Future<void> _archivar(BuildContext context, AulaDocente aula) async {
    final cubit = context.read<AulasDocenteCubit>();
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('¿Archivar esta clase?'),
        content: Text(
          '«${aula.nombre}» dejará de aparecer en tu lista. Los estudiantes y sus resultados se conservan y su código deja de funcionar.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Archivar'),
          ),
        ],
      ),
    );
    if (confirmar != true) return;
    try {
      await cubit.archivar(aula.id);
      if (context.mounted) context.go('/docente/clases');
    } on ExcepcionApi catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(mensajeDeError(e))));
      }
    }
  }
}
