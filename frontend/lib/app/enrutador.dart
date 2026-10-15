import 'package:go_router/go_router.dart';

import '../core/sesion/sesion_app.dart';
import '../features/acceso/presentacion/bienvenida_pantalla.dart';
import '../features/acceso/presentacion/ingresar_pantalla.dart';
import '../features/catalogo/presentacion/mapa_materia_pantalla.dart';
import '../features/catalogo/presentacion/universo_pantalla.dart';

/// Rutas de la app. Las pantallas privadas exigen una sesión; si vence, se vuelve a la bienvenida.
/// Esto solo ordena la navegación: la autorización real la hace siempre la API.
GoRouter crearEnrutador(SesionApp sesion) {
  const publicas = {'/', '/ingresar'};

  return GoRouter(
    refreshListenable: sesion,
    redirect: (context, estado) {
      final ruta = estado.uri.path;
      if (!sesion.activa && !publicas.contains(ruta)) return '/';
      if (sesion.activa && publicas.contains(ruta)) return '/universo';
      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (_, _) => const BienvenidaPantalla()),
      GoRoute(path: '/ingresar', builder: (_, _) => const IngresarPantalla()),
      GoRoute(path: '/universo', builder: (_, _) => const UniversoPantalla()),
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
    ],
  );
}
