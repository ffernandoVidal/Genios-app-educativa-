import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genios_app/app/app.dart';
import 'package:genios_app/core/red/excepcion_api.dart';
import 'package:genios_app/core/sesion/sesion_app.dart';
import 'package:genios_app/features/acceso/presentacion/bienvenida_pantalla.dart';
import 'package:genios_app/features/catalogo/dominio/modelos_catalogo.dart';
import 'package:go_router/go_router.dart';

import '../soporte/repositorios_falsos.dart';

Future<SesionApp> abrir(
  WidgetTester t, {
  FalsoAcceso? acceso,
  FalsoCatalogo? catalogo,
  FalsoPartida? partida,
  FalsoProgreso? progreso,
  SesionApp? sesion,
}) async {
  final s = sesion ?? SesionApp();
  await t.pumpWidget(
    AppGenios(
      sesion: s,
      repositorioAcceso: acceso ?? FalsoAcceso(),
      repositorioCatalogo:
          catalogo ?? FalsoCatalogo(mapas: {1: mapaDeMatematicas()}),
      repositorioPartida: partida ?? FalsoPartida(),
      repositorioProgreso: progreso ?? FalsoProgreso(),
    ),
  );
  await t.pumpAndSettle();
  return s;
}

Future<void> entrarComoInvitado(WidgetTester t) async {
  await t.tap(find.text('Jugar como invitado'));
  await t.pumpAndSettle();
}

void main() {
  group('acceso', () {
    testWidgets(
      'la bienvenida ofrece jugar como invitado e ingresar con usuario',
      (t) async {
        await abrir(t);

        expect(find.text('GENIOS'), findsOneWidget);
        expect(find.text('Jugar como invitado'), findsOneWidget);
        expect(find.text('Ya tengo mi usuario'), findsOneWidget);
      },
    );

    testWidgets(
      'jugar como invitado abre el universo con las cuatro materias',
      (t) async {
        final acceso = FalsoAcceso();
        await abrir(t, acceso: acceso);

        await entrarComoInvitado(t);

        expect(acceso.sesionesInvitado, 1);
        expect(find.text('Tu universo'), findsOneWidget);
        for (final nombre in [
          'Matemáticas',
          'Comunicación y Lenguaje',
          'Ciencias Sociales',
          'Ciencias Naturales',
        ]) {
          expect(find.text(nombre), findsOneWidget, reason: nombre);
        }
      },
    );

    testWidgets(
      'si falla la sesión de invitado se muestra el error y se queda en la bienvenida',
      (t) async {
        final acceso = FalsoAcceso()
          ..errorInvitado = const ExcepcionApi.sinConexion();
        final sesion = await abrir(t, acceso: acceso);

        await entrarComoInvitado(t);

        expect(find.textContaining('No pudimos conectarnos'), findsOneWidget);
        expect(find.text('Jugar como invitado'), findsOneWidget);
        expect(sesion.activa, isFalse);
      },
    );

    testWidgets('credenciales incorrectas muestran un mensaje claro', (
      t,
    ) async {
      final acceso = FalsoAcceso()
        ..errorInicioSesion = const ExcepcionApi(
          'x',
          estado: 401,
          codigo: 'credenciales_invalidas',
        );
      await abrir(t, acceso: acceso);

      await t.tap(find.text('Ya tengo mi usuario'));
      await t.pumpAndSettle();
      await t.enterText(find.byType(TextField).first, 'ana');
      await t.enterText(find.byType(TextField).last, 'mala');
      await t.tap(find.widgetWithText(FilledButton, 'Entrar'));
      await t.pumpAndSettle();

      expect(find.text('Usuario o contraseña incorrectos.'), findsOneWidget);
      expect(find.text('Tu universo'), findsNothing);
    });

    testWidgets(
      'campos vacíos piden completar los datos sin llamar al servidor',
      (t) async {
        final acceso = FalsoAcceso();
        await abrir(t, acceso: acceso);

        await t.tap(find.text('Ya tengo mi usuario'));
        await t.pumpAndSettle();
        await t.tap(find.widgetWithText(FilledButton, 'Entrar'));
        await t.pumpAndSettle();

        expect(
          find.text('Escribe tu usuario y tu contraseña.'),
          findsOneWidget,
        );
        expect(acceso.ultimoUsuario, isNull);
      },
    );

    testWidgets(
      'un inicio de sesión correcto lleva al universo como estudiante',
      (t) async {
        final acceso = FalsoAcceso();
        final sesion = await abrir(t, acceso: acceso);

        await t.tap(find.text('Ya tengo mi usuario'));
        await t.pumpAndSettle();
        await t.enterText(find.byType(TextField).first, '  ana.luz ');
        await t.enterText(find.byType(TextField).last, 'clave123');
        await t.tap(find.widgetWithText(FilledButton, 'Entrar'));
        await t.pumpAndSettle();

        expect(acceso.ultimoUsuario, 'ana.luz'); // se recorta el usuario
        expect(find.text('Tu universo'), findsOneWidget);
        expect(sesion.modo, ModoSesion.estudiante);
      },
    );

    testWidgets('salir devuelve a la bienvenida', (t) async {
      final acceso = FalsoAcceso();
      final sesion = await abrir(t, acceso: acceso);
      await entrarComoInvitado(t);

      await t.tap(find.byTooltip('Salir'));
      await t.pumpAndSettle();

      expect(find.text('Jugar como invitado'), findsOneWidget);
      expect(sesion.activa, isFalse);
    });

    testWidgets('sin sesión no se puede entrar a una pantalla privada', (
      t,
    ) async {
      await abrir(t);

      GoRouter.of(t.element(find.byType(BienvenidaPantalla))).go('/universo');
      await t.pumpAndSettle();

      expect(find.byType(BienvenidaPantalla), findsOneWidget);
      expect(find.text('Tu universo'), findsNothing);
    });
  });

  group('catálogo', () {
    testWidgets('un error de red en el universo permite reintentar', (t) async {
      final catalogo = FalsoCatalogo(error: const ExcepcionApi.sinConexion());
      await abrir(t, catalogo: catalogo);
      await entrarComoInvitado(t);

      expect(find.textContaining('No pudimos conectarnos'), findsOneWidget);
      expect(find.text('Reintentar'), findsOneWidget);

      catalogo.error = null; // vuelve la conexión
      await t.tap(find.text('Reintentar'));
      await t.pumpAndSettle();

      expect(find.text('Matemáticas'), findsOneWidget);
    });

    testWidgets(
      'el mapa muestra los cuatro estados con texto y el requisito de desbloqueo',
      (t) async {
        await abrir(t);
        await entrarComoInvitado(t);

        await t.tap(find.text('Matemáticas'));
        await t.pumpAndSettle();

        expect(find.text('1. Sumas'), findsOneWidget);
        expect(find.text('Completada'), findsOneWidget);
        expect(find.text('En progreso'), findsOneWidget);
        expect(find.text('Bloqueada'), findsOneWidget);
        expect(find.text('Disponible'), findsOneWidget);
        expect(find.text('Completa «Restas»'), findsOneWidget);
      },
    );

    testWidgets(
      'una materia sin misiones muestra un mensaje en lugar de una pantalla vacía',
      (t) async {
        final catalogo = FalsoCatalogo(
          mapas: {
            2: const MapaMateria(
              asignatura: Asignatura(
                id: 2,
                codigo: 'LENGUAJE',
                nombre: 'Lenguaje',
              ),
              niveles: [],
            ),
          },
        );
        await abrir(t, catalogo: catalogo);
        await entrarComoInvitado(t);

        await t.tap(find.text('Comunicación y Lenguaje'));
        await t.pumpAndSettle();

        expect(
          find.textContaining('todavía no tiene misiones'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'los planetas y las misiones tienen etiquetas para lectores de pantalla',
      (t) async {
        final semantica = t.ensureSemantics();
        await abrir(t);
        await entrarComoInvitado(t);

        expect(
          find.bySemanticsLabel(RegExp('Planeta Matemáticas')),
          findsOneWidget,
        );

        await t.tap(find.text('Matemáticas'));
        await t.pumpAndSettle();
        expect(
          find.bySemanticsLabel(
            RegExp('Misión 3: Multiplicaciones. Bloqueada'),
          ),
          findsOneWidget,
        );
        semantica.dispose();
      },
    );
  });

  group('diseño adaptable', () {
    for (final (nombre, tamano) in [
      ('móvil', const Size(360, 640)),
      ('tableta', const Size(820, 1180)),
      ('escritorio', const Size(1440, 900)),
    ]) {
      testWidgets('las pantallas no se desbordan en $nombre', (t) async {
        t.view.devicePixelRatio = 1.0;
        t.view.physicalSize = tamano;
        addTearDown(t.view.reset);

        await abrir(t); // un desbordamiento haría fallar la prueba
        await entrarComoInvitado(t);
        expect(find.text('Matemáticas'), findsOneWidget);

        await t.tap(find.text('Matemáticas'));
        await t.pumpAndSettle();
        expect(find.text('1. Sumas'), findsOneWidget);
        expect(t.takeException(), isNull);
      });
    }
  });
}
