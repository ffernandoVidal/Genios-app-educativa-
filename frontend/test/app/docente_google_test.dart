import 'package:go_router/go_router.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genios_app/core/red/excepcion_api.dart';
import 'package:genios_app/core/sesion/sesion_app.dart';

import '../soporte/abrir_app.dart';
import '../soporte/repositorios_falsos.dart';

Future<void> abrirAccesoDocente(WidgetTester t) async {
  await t.tap(find.text('INICIAR SESIÓN'));
  await t.pumpAndSettle();
  await t.tap(find.text('DOCENTE'));
  await t.pumpAndSettle();
}

void main() {
  group('acceso docente con Google', () {
    testWidgets('con Client ID se ofrece «Continuar con Google»', (t) async {
      await abrirApp(t);
      await abrirAccesoDocente(t);
      expect(find.text('Acceso docente'), findsOneWidget);
      expect(find.text('CONTINUAR CON GOOGLE'), findsOneWidget);
    });

    testWidgets(
      'sin Client ID se explica que no está configurado, sin simular el acceso',
      (t) async {
        await abrirApp(t, googleClientId: '');
        await abrirAccesoDocente(t);
        expect(find.text('CONTINUAR CON GOOGLE'), findsNothing);
        expect(
          find.text('El acceso con Google no está configurado todavía.'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'la credencial se envía a la API y el docente queda en su pantalla, no en la cabina infantil',
      (t) async {
        final app = await abrirApp(t);
        await abrirAccesoDocente(t);

        await t.tap(find.text('CONTINUAR CON GOOGLE'));
        await t.pumpAndSettle();

        expect(app.acceso.ultimoIdToken, 'credencial-de-prueba');
        expect(app.sesion.modo, ModoSesion.docente);
        expect(find.textContaining('Profe Rosa'), findsOneWidget);
        expect(find.text('JUGAR'), findsNothing);
      },
    );

    testWidgets('un docente no puede entrar a las pantallas de estudiantes', (
      t,
    ) async {
      final app = await abrirApp(t);
      await abrirAccesoDocente(t);
      await t.tap(find.text('CONTINUAR CON GOOGLE'));
      await t.pumpAndSettle();

      final enrutador = GoRouter.of(
        t.element(find.textContaining('Profe Rosa')),
      );
      enrutador.go('/materias');
      await t.pumpAndSettle();
      expect(find.textContaining('Profe Rosa'), findsOneWidget);
      expect(app.sesion.modo, ModoSesion.docente);
    });

    testWidgets(
      'una credencial inválida muestra un mensaje amable y no inicia sesión',
      (t) async {
        final acceso = FalsoAcceso()
          ..errorGoogle = const ExcepcionApi(
            'x',
            estado: 401,
            codigo: 'google_token_invalido',
          );
        final app = await abrirApp(t, acceso: acceso);
        await abrirAccesoDocente(t);

        await t.tap(find.text('CONTINUAR CON GOOGLE'));
        await t.pumpAndSettle();

        expect(
          find.text(
            'No pudimos validar tu cuenta de Google. Inténtalo de nuevo.',
          ),
          findsOneWidget,
        );
        expect(app.sesion.activa, isFalse);
      },
    );

    testWidgets(
      'si Google no está disponible en el servidor, lo dice sin culpar al usuario',
      (t) async {
        final acceso = FalsoAcceso()
          ..errorGoogle = const ExcepcionApi(
            'x',
            estado: 503,
            codigo: 'google_no_configurado',
          );
        await abrirApp(t, acceso: acceso);
        await abrirAccesoDocente(t);

        await t.tap(find.text('CONTINUAR CON GOOGLE'));
        await t.pumpAndSettle();
        expect(
          find.text('El acceso con Google no está disponible por ahora.'),
          findsOneWidget,
        );
      },
    );

    testWidgets('el docente puede cerrar sesión', (t) async {
      final app = await abrirApp(t);
      await abrirAccesoDocente(t);
      await t.tap(find.text('CONTINUAR CON GOOGLE'));
      await t.pumpAndSettle();

      await t.tap(find.text('Ajustes').first);
      await t.pumpAndSettle();
      await t.tap(find.text('CERRAR SESIÓN'));
      await t.pumpAndSettle();
      expect(app.sesion.activa, isFalse);
      expect(find.text('JUGAR'), findsOneWidget);
    });
  });
}
