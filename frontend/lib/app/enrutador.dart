import 'package:go_router/go_router.dart';

import '../core/sesion/sesion_app.dart';
import '../features/acceso/presentacion/bienvenida_pantalla.dart';
import '../features/acceso/presentacion/docente_pantalla.dart';
import '../features/acceso/presentacion/ingresar_pantalla.dart';
import '../features/acceso/presentacion/jugar_pantalla.dart';
import '../features/acceso/presentacion/registro_pantalla.dart';
import '../features/ajustes/presentacion/ajustes_pantalla.dart';
import '../features/cabina/presentacion/cabina_pantalla.dart';
import '../features/catalogo/presentacion/materias_pantalla.dart';
import '../features/catalogo/presentacion/misiones_pantalla.dart';
import '../features/partida/dominio/argumentos_mision.dart';
import '../features/partida/presentacion/partida_pantalla.dart';
import '../features/progreso/presentacion/perfil_pantalla.dart';
import '../features/salon/presentacion/salon_pantalla.dart';

/// Recorrido aprobado: Bienvenida → Cabina → JUGAR → Materias → Misiones → Partida → Resultados.
/// Las pantallas privadas exigen una sesión; si vence, se vuelve a la bienvenida.
/// Esto solo ordena la navegación: la autorización real la hace siempre la API.
GoRouter crearEnrutador(SesionApp sesion, {String googleClientId = ''}) {
  const soloSinSesion = {'/', '/jugar', '/ingresar'};
  const publicas = {'/', '/jugar', '/ingresar', '/registro', '/docente'};

  return GoRouter(
    refreshListenable: sesion,
    redirect: (context, estado) {
      final ruta = estado.uri.path;
      if (!sesion.activa && !publicas.contains(ruta)) return '/';
      // El docente solo tiene su propia pantalla: la experiencia infantil es para estudiantes e invitados.
      if (sesion.modo == ModoSesion.docente && ruta != '/docente') {
        return '/docente';
      }
      if (sesion.activa && soloSinSesion.contains(ruta)) return '/cabina';
      // El registro también se permite a un invitado (es la invitación a crear su cuenta).
      if (ruta == '/registro' &&
          sesion.activa &&
          sesion.modo != ModoSesion.invitado) {
        return '/cabina';
      }
      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (_, _) => const BienvenidaPantalla()),
      GoRoute(path: '/jugar', builder: (_, _) => const JugarPantalla()),
      GoRoute(path: '/ingresar', builder: (_, _) => const IngresarPantalla()),
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
