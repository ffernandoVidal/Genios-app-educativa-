import 'package:go_router/go_router.dart';

import '../core/sesion/sesion_app.dart';
import '../features/acceso/dominio/restaurador_sesion.dart';
import '../features/acceso/presentacion/acceso_pantalla.dart';
import '../features/acceso/presentacion/activar_pantalla.dart';
import '../features/acceso/presentacion/genio_pantalla.dart';
import '../features/acceso/presentacion/elegir_rol_pantalla.dart';
import '../features/acceso/presentacion/restaurando_pantalla.dart';
import '../features/acceso/presentacion/bienvenida_pantalla.dart';
import '../features/acceso/presentacion/docente_pantalla.dart';
import '../features/acceso/presentacion/ingresar_pantalla.dart';
import '../features/acceso/presentacion/jugar_pantalla.dart';
import '../features/acceso/presentacion/registro_pantalla.dart';
import '../features/ajustes/presentacion/ajustes_pantalla.dart';
import '../features/cabina/presentacion/cabina_pantalla.dart';
import '../features/catalogo/presentacion/materias_pantalla.dart';
import '../features/catalogo/presentacion/misiones_pantalla.dart';
import '../features/docente/presentacion/ajustes_docente_pantalla.dart';
import '../features/docente/presentacion/alumnos_docente_pantalla.dart';
import '../features/docente/presentacion/clases_docente_pantalla.dart';
import '../features/docente/presentacion/crear_alumno_pantalla.dart';
import '../features/docente/presentacion/estadisticas_docente_pantalla.dart';
import '../features/docente/presentacion/ficha_estudiante_pantalla.dart';
import '../features/docente/presentacion/inicio_docente_pantalla.dart';
import '../features/docente/presentacion/marco_docente.dart';
import '../features/partida/dominio/argumentos_mision.dart';
import '../features/partida/presentacion/partida_pantalla.dart';
import '../features/progreso/presentacion/perfil_pantalla.dart';
import '../features/salon/presentacion/salon_pantalla.dart';

/// Recorrido aprobado: Bienvenida → Cabina → JUGAR → Materias → Misiones → Partida → Resultados.
/// Las pantallas privadas exigen una sesión; si vence, se vuelve a la bienvenida.
/// Esto solo ordena la navegación: la autorización real la hace siempre la API.
GoRouter crearEnrutador(
  SesionApp sesion, {
  String googleClientId = '',
  required RestauradorSesion restaurador,
}) {
  const soloSinSesion = {'/', '/jugar', '/acceso', '/genio', '/ingresar'};
  const publicas = {
    '/',
    '/jugar',
    '/acceso',
    '/genio',
    '/ingresar',
    '/registro',
    '/docente',
    '/activar',
  };

  return GoRouter(
    refreshListenable: sesion,
    redirect: (context, estado) {
      final ruta = estado.uri.path;
      final esRutaDocente = ruta.startsWith('/docente/');

      // Al abrir la app todavía no se sabe quién es el usuario: nada de pantallas de estudiante o docente.
      if (sesion.restauracion != EstadoRestauracion.lista) {
        if (ruta == '/cargando') return null;
        return Uri(
          path: '/cargando',
          queryParameters: {'desde': estado.uri.toString()},
        ).toString();
      }
      if (ruta == '/cargando') {
        final desde = estado.uri.queryParameters['desde'];
        return (desde == null || desde.startsWith('/cargando')) ? '/' : desde;
      }

      // Identidad de Google sin rol: solo puede elegir su rol (o salir).
      if (sesion.modo == ModoSesion.rolPendiente) {
        return ruta == '/elegir-rol' ? null : '/elegir-rol';
      }
      if (ruta == '/elegir-rol') {
        if (!sesion.activa) return '/';
        return sesion.modo == ModoSesion.docente
            ? '/docente/inicio'
            : '/cabina';
      }
      // Sin sesión: el Centro de Control pide el acceso docente; el resto vuelve a la bienvenida.
      if (!sesion.activa && esRutaDocente) return '/docente';
      if (!sesion.activa && !publicas.contains(ruta)) return '/';
      // El docente solo tiene su Centro de Control: la experiencia infantil es para estudiantes e invitados.
      if (sesion.modo == ModoSesion.docente && !esRutaDocente) {
        return '/docente/inicio';
      }
      if (sesion.activa && soloSinSesion.contains(ruta)) return '/cabina';
      // Un estudiante o invitado con sesión no tiene nada que hacer en el acceso docente.
      if (sesion.activa &&
          sesion.modo != ModoSesion.docente &&
          (ruta == '/docente' || esRutaDocente)) {
        return '/cabina';
      }
      // El registro también se permite a un invitado (es la invitación a crear su cuenta).
      if (ruta == '/registro' &&
          sesion.activa &&
          sesion.modo != ModoSesion.invitado) {
        return '/cabina';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/cargando',
        builder: (_, _) =>
            RestaurandoPantalla(sesion: sesion, restaurador: restaurador),
      ),
      GoRoute(path: '/', builder: (_, _) => const BienvenidaPantalla()),
      GoRoute(
        path: '/elegir-rol',
        builder: (_, _) => const ElegirRolPantalla(),
      ),
      GoRoute(path: '/jugar', builder: (_, _) => const JugarPantalla()),
      GoRoute(path: '/acceso', builder: (_, _) => const AccesoPantalla()),
      GoRoute(
        path: '/genio',
        builder: (_, _) => GenioPantalla(googleClientId: googleClientId),
      ),
      GoRoute(path: '/ingresar', builder: (_, _) => const IngresarPantalla()),
      GoRoute(path: '/activar', builder: (_, _) => const ActivarPantalla()),
      GoRoute(path: '/registro', builder: (_, _) => const RegistroPantalla()),
      GoRoute(
        path: '/docente',
        builder: (_, _) => DocentePantalla(googleClientId: googleClientId),
      ),
      GoRoute(path: '/cabina', builder: (_, _) => const CabinaPantalla()),
      GoRoute(path: '/materias', builder: (_, _) => const MateriasPantalla()),
      GoRoute(path: '/perfil', builder: (_, _) => const PerfilPantalla()),
      GoRoute(path: '/salon', builder: (_, _) => const SalonPantalla()),
      GoRoute(path: '/ajustes', builder: (_, _) => const AjustesPantalla()),
      ShellRoute(
        builder: (context, estado, hijo) =>
            MarcoDocente(ubicacion: estado.uri.path, hijo: hijo),
        routes: [
          GoRoute(
            path: '/docente/inicio',
            builder: (_, _) => const InicioDocentePantalla(),
          ),
          GoRoute(
            path: '/docente/clases',
            builder: (_, _) => const ClasesDocentePantalla(),
          ),
          GoRoute(
            path: '/docente/clases/nueva',
            builder: (_, _) => const CrearClasePantalla(),
          ),
          GoRoute(
            path: '/docente/clases/:id',
            builder: (_, estado) =>
                DetalleClasePantalla(aulaId: estado.pathParameters['id']!),
          ),
          GoRoute(
            path: '/docente/alumnos',
            builder: (_, _) => const AlumnosDocentePantalla(),
          ),
          GoRoute(
            path: '/docente/alumnos/nuevo',
            builder: (_, _) => const CrearAlumnoPantalla(),
          ),
          GoRoute(
            path: '/docente/alumnos/:id',
            builder: (_, estado) => FichaEstudiantePantalla(
              estudianteId: estado.pathParameters['id']!,
            ),
          ),
          GoRoute(
            path: '/docente/estadisticas',
            builder: (_, _) => const EstadisticasDocentePantalla(),
          ),
          GoRoute(
            path: '/docente/ajustes',
            builder: (_, _) => const AjustesDocentePantalla(),
          ),
        ],
      ),
      GoRoute(
        path: '/materia/:id',
        builder: (_, estado) => MisionesPantalla(
          asignaturaId: int.parse(estado.pathParameters['id']!),
        ),
        redirect: (_, estado) =>
            int.tryParse(estado.pathParameters['id'] ?? '') == null
            ? '/materias'
            : null,
      ),
      GoRoute(
        path: '/mision/:categoriaId',
        builder: (_, estado) => PartidaPantalla(
          categoriaId: int.parse(estado.pathParameters['categoriaId']!),
          argumentos: estado.extra as ArgumentosMision?,
        ),
        redirect: (_, estado) =>
            int.tryParse(estado.pathParameters['categoriaId'] ?? '') == null
            ? '/materias'
            : null,
      ),
    ],
  );
}
