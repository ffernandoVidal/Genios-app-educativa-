import 'package:go_router/go_router.dart';

import '../core/sesion/sesion_app.dart';
import '../features/acceso/presentacion/bienvenida_pantalla.dart';
import '../features/acceso/presentacion/ingresar_pantalla.dart';
import '../features/acceso/presentacion/registro_pantalla.dart';
import '../features/catalogo/presentacion/mapa_materia_pantalla.dart';
import '../features/catalogo/presentacion/universo_pantalla.dart';
import '../features/partida/presentacion/partida_pantalla.dart';
import '../features/progreso/presentacion/progreso_pantalla.dart';

/// Rutas de la app. Las pantallas privadas exigen una sesión; si vence, se vuelve a la bienvenida.
/// Esto solo ordena la navegación: la autorización real la hace siempre la API.
GoRouter crearEnrutador(SesionApp sesion) {
  const soloSinSesion = {'/', '/ingresar'};

  return GoRouter(
    refreshListenable: sesion,
    redirect: (context, estado) {
      final ruta = estado.uri.path;
      // El registro también se permite a un invitado (es la invitación a crear su cuenta).
      final esRegistro = ruta == '/registro';
      final esPublica = soloSinSesion.contains(ruta) || esRegistro;

      if (!sesion.activa && !esPublica) return '/';
      if (sesion.activa && soloSinSesion.contains(ruta)) return '/universo';
      if (esRegistro && sesion.activa && sesion.modo != ModoSesion.invitado) {
        return '/universo';
      }
      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (_, _) => const BienvenidaPantalla()),
      GoRoute(path: '/ingresar', builder: (_, _) => const IngresarPantalla()),
      GoRoute(path: '/registro', builder: (_, _) => const RegistroPantalla()),
      GoRoute(path: '/universo', builder: (_, _) => const UniversoPantalla()),
      GoRoute(path: '/progreso', builder: (_, _) => const ProgresoPantalla()),
      GoRoute(
        path: '/materia/:id',
        builder: (_, estado) => MapaMateriaPantalla(
          asignaturaId: int.parse(estado.pathParameters['id']!),
        ),
        redirect: (_, estado) =>
            int.tryParse(estado.pathParameters['id'] ?? '') == null
            ? '/universo'
            : null,
      ),
      GoRoute(
        path: '/mision/:categoriaId',
        builder: (_, estado) => PartidaPantalla(
          categoriaId: int.parse(estado.pathParameters['categoriaId']!),
          nombreMision: estado.extra as String?,
        ),
        redirect: (_, estado) =>
            int.tryParse(estado.pathParameters['categoriaId'] ?? '') == null
            ? '/universo'
            : null,
      ),
    ],
  );
}
