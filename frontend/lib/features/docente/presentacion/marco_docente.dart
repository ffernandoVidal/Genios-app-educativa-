import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/sesion/sesion_app.dart';
import '../../../diseno/tokens/colores.dart';
import '../../../diseno/tokens/medidas.dart';
import '../../../diseno/tokens/tipografia.dart';
import '../dominio/repositorio_docente.dart';
import 'colores_docente.dart';
import 'cubits_docente.dart';

class _Seccion {
  const _Seccion(this.ruta, this.titulo, this.icono);

  final String ruta;
  final String titulo;
  final IconData icono;
}

const _secciones = [
  _Seccion('/docente/inicio', 'Inicio', Icons.dashboard_rounded),
  _Seccion('/docente/clases', 'Mis clases', Icons.school_rounded),
  _Seccion('/docente/clases/nueva', 'Crear clase', Icons.add_circle_rounded),
  _Seccion(
    '/docente/alumnos/nuevo',
    'Crear alumno',
    Icons.person_add_alt_1_rounded,
  ),
  _Seccion('/docente/alumnos', 'Alumnos', Icons.groups_rounded),
  _Seccion('/docente/estadisticas', 'Estadísticas', Icons.bar_chart_rounded),
  _Seccion('/docente/ajustes', 'Ajustes', Icons.settings_rounded),
];

/// Sección del menú que corresponde a una ruta. Las rutas «nueva» y «nuevo» tienen su propia entrada.
int seccionActiva(String ruta) {
  if (ruta.startsWith('/docente/clases/nueva')) return 2;
  if (ruta.startsWith('/docente/alumnos/nuevo')) return 3;
  if (ruta.startsWith('/docente/clases')) return 1;
  if (ruta.startsWith('/docente/alumnos')) return 4;
  if (ruta.startsWith('/docente/estadisticas')) return 5;
  if (ruta.startsWith('/docente/ajustes')) return 6;
  return 0;
}

/// Marco de todas las pantallas docentes: menú lateral permanente (escritorio), compacto (tableta) o Drawer (móvil).
/// Comparte la lista de clases entre secciones. Sobrio a propósito: es una herramienta de trabajo.
class MarcoDocente extends StatelessWidget {
  const MarcoDocente({super.key, required this.ubicacion, required this.hijo});

  final String ubicacion;
  final Widget hijo;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (c) => AulasDocenteCubit(c.read<RepositorioDocente>())..cargar(),
      child: _Cuerpo(ubicacion: ubicacion, hijo: hijo),
    );
  }
}

class _Cuerpo extends StatelessWidget {
  const _Cuerpo({required this.ubicacion, required this.hijo});

  final String ubicacion;
  final Widget hijo;

  void _ir(BuildContext context, int i) {
    if (ubicacion != _secciones[i].ruta) context.go(_secciones[i].ruta);
  }

  @override
  Widget build(BuildContext context) {
    final ancho = MediaQuery.sizeOf(context).width;
    final activa = seccionActiva(ubicacion);
    final esMovil = ancho < PuntosDeQuiebre.tableta;
    final contenido = Theme(
      data: temaContenidoDocente(Theme.of(context)),
      child: Material(
        color: ColoresDocente.fondo,
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Padding(
              padding: const EdgeInsets.all(Espaciado.pantalla),
              child: hijo,
            ),
          ),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: ColoresDocente.fondo,
      appBar: AppBar(
        backgroundColor: ColoresGenios.azulPetroleo,
        title: Row(
          children: [
            const Icon(
              Icons.rocket_launch_rounded,
              color: ColoresGenios.amarilloEspacial,
            ),
            const SizedBox(width: Espaciado.s),
            Flexible(
              child: Text(
                'GENIOS · Docente',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Tipografia.titulo(22, peso: 800),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Ajustes',
            icon: const Icon(Icons.settings_rounded),
            onPressed: () => _ir(context, 6),
          ),
          const _AvatarDocente(),
          const SizedBox(width: Espaciado.s),
        ],
      ),
      drawer: esMovil
          ? Drawer(
              backgroundColor: ColoresGenios.azulPetroleo,
              child: SafeArea(
                child: ListView(
                  children: [
                    for (var i = 0; i < _secciones.length; i++)
                      ListTile(
                        selected: i == activa,
                        selectedTileColor: ColoresGenios.turquesa.withValues(
                          alpha: 0.18,
                        ),
                        selectedColor: ColoresGenios.turquesa,
                        leading: Icon(_secciones[i].icono),
                        title: Text(
                          _secciones[i].titulo,
                          style: Tipografia.texto(18, peso: 700),
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                          _ir(context, i);
                        },
                      ),
                  ],
                ),
              ),
            )
          : null,
      body: esMovil
          ? contenido
          : Row(
              children: [
                NavigationRail(
                  backgroundColor: ColoresGenios.azulPetroleo,
                  extended: ancho >= PuntosDeQuiebre.escritorio,
                  labelType: ancho >= PuntosDeQuiebre.escritorio
                      ? NavigationRailLabelType.none
                      : NavigationRailLabelType.all,
                  selectedIndex: activa,
                  onDestinationSelected: (i) => _ir(context, i),
                  indicatorColor: ColoresGenios.turquesa.withValues(
                    alpha: 0.25,
                  ),
                  selectedIconTheme: const IconThemeData(
                    color: ColoresGenios.turquesa,
                  ),
                  unselectedIconTheme: const IconThemeData(
                    color: ColoresGenios.textoSuave,
                  ),
                  selectedLabelTextStyle: Tipografia.texto(
                    14,
                    peso: 800,
                    color: ColoresGenios.turquesa,
                  ),
                  unselectedLabelTextStyle: Tipografia.texto(
                    14,
                    color: ColoresGenios.textoSuave,
                  ),
                  destinations: [
                    for (final s in _secciones)
                      NavigationRailDestination(
                        icon: Icon(s.icono),
                        label: Text(s.titulo),
                      ),
                  ],
                ),
                Expanded(child: contenido),
              ],
            ),
    );
  }
}

class _AvatarDocente extends StatelessWidget {
  const _AvatarDocente();

  @override
  Widget build(BuildContext context) {
    final nombre = context.read<FuenteModoSesion>().nombre;
    final inicial = nombre.isEmpty
        ? '?'
        : nombre.characters.first.toUpperCase();
    return Semantics(
      label: 'Docente $nombre',
      excludeSemantics: true,
      child: CircleAvatar(
        radius: 18,
        backgroundColor: ColoresGenios.turquesa,
        child: Text(
          inicial,
          style: Tipografia.titulo(
            18,
            peso: 800,
            color: ColoresGenios.textoSobreClaro,
          ),
        ),
      ),
    );
  }
}
