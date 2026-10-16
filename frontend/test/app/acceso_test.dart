import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genios_app/core/red/excepcion_api.dart';
import 'package:genios_app/core/sesion/sesion_app.dart';
import 'package:genios_app/diseno/componentes/botones_juego.dart';
import 'package:genios_app/features/acceso/presentacion/bienvenida_pantalla.dart';
import 'package:go_router/go_router.dart';

import '../soporte/abrir_app.dart';
import '../soporte/repositorios_falsos.dart';

void main() {
  group('bienvenida', () {
    testWidgets(
      'muestra el logotipo y solo dos decisiones: JUGAR (principal) e INICIAR SESIÓN',
      (t) async {
        await abrirApp(t);

        expect(find.text('GENIOS'), findsOneWidget);
        expect(find.byType(BotonPrincipalJuego), findsOneWidget);
        expect(find.byType(BotonSecundarioJuego), findsOneWidget);
        expect(find.text('JUGAR'), findsOneWidget);
        expect(find.text('INICIAR SESIÓN'), findsOneWidget);
      },
    );

    testWidgets('sin sesión no se puede entrar a una pantalla privada', (
      t,
    ) async {
      await abrirApp(t);

      GoRouter.of(t.element(find.byType(BienvenidaPantalla))).go('/cabina');
      await t.pumpAndSettle();

      expect(find.byType(BienvenidaPantalla), findsOneWidget);
      expect(find.text('JUGAR'), findsOneWidget);
    });
  });

  group('JUGAR como invitado: solo un nombre', () {
    testWidgets(
      'pide únicamente el nombre o apodo, sin correo, contraseña ni código de aula',
      (t) async {
        await abrirApp(t);

        await t.tap(find.text('JUGAR'));
        await t.pumpAndSettle();

        expect(find.byType(TextField), findsOneWidget);
        expect(find.text('Tu nombre o apodo'), findsOneWidget);
        expect(
          find.textContaining('correo'),
          findsOneWidget,
        ); // solo en el aviso "No necesitas correo ni contraseña"
        expect(find.text('Tu contraseña'), findsNothing);
      },
    );

    testWidgets('valida el apodo antes de llamar al servidor', (t) async {
      final app = await abrirApp(t);
      await t.tap(find.text('JUGAR'));
      await t.pumpAndSettle();

      await t.tap(find.text('¡DESPEGAR!'));
      await t.pumpAndSettle();
      expect(find.text('Escribe tu nombre o un apodo.'), findsOneWidget);

      await t.enterText(find.byType(TextField), 'A');
      await t.tap(find.text('¡DESPEGAR!'));
      await t.pumpAndSettle();
      expect(find.textContaining('al menos 2 letras'), findsOneWidget);

      await t.enterText(find.byType(TextField), 'Ana <3>');
      await t.tap(find.text('¡DESPEGAR!'));
      await t.pumpAndSettle();
      expect(find.textContaining('solo letras'), findsOneWidget);

      expect(app.acceso.sesionesInvitado, 0);
      expect(app.sesion.activa, isFalse);
    });

    testWidgets(
      'con un nombre válido crea la sesión en la API y lleva a la cabina; el nombre no viaja al servidor',
      (t) async {
        final app = await abrirApp(t);

        await entrarComoInvitado(t, apodo: '  Luna  ');

        expect(app.acceso.sesionesInvitado, 1);
        expect(app.sesion.modo, ModoSesion.invitado);
        expect(app.sesion.nombre, 'Luna'); // se recorta; es solo para mostrar
        expect(find.text('Luna'), findsOneWidget);
        expect(find.text('JUGAR'), findsOneWidget);
      },
    );

    testWidgets('acepta tildes y la letra ñ', (t) async {
      final app = await abrirApp(t);

      await entrarComoInvitado(t, apodo: 'Muñoz Ángel');

      expect(app.sesion.nombre, 'Muñoz Ángel');
    });

    testWidgets('si falla la red, avisa y se queda en la pantalla del nombre', (
      t,
    ) async {
      final acceso = FalsoAcceso()
        ..errorInvitado = const ExcepcionApi.sinConexion();
      final app = await abrirApp(t, acceso: acceso);

      await entrarComoInvitado(t);

      expect(find.textContaining('No pudimos conectarnos'), findsOneWidget);
      expect(find.text('¡DESPEGAR!'), findsOneWidget);
      expect(app.sesion.activa, isFalse);
    });
  });

  group('INICIAR SESIÓN', () {
    testWidgets('credenciales incorrectas muestran un mensaje claro', (
      t,
    ) async {
      final acceso = FalsoAcceso()
        ..errorInicioSesion = const ExcepcionApi(
          'x',
          estado: 401,
          codigo: 'credenciales_invalidas',
        );
      await abrirApp(t, acceso: acceso);

      await entrarComoEstudiante(t);

      expect(find.text('Usuario o contraseña incorrectos.'), findsOneWidget);
      expect(find.text('ENTRAR'), findsOneWidget);
    });

    testWidgets(
      'campos vacíos piden completar los datos sin llamar al servidor',
      (t) async {
        final app = await abrirApp(t);
        await t.tap(find.text('INICIAR SESIÓN'));
        await t.pumpAndSettle();

        await t.tap(find.text('ENTRAR'));
        await t.pumpAndSettle();

        expect(
          find.text('Escribe tu usuario y tu contraseña.'),
          findsOneWidget,
        );
        expect(app.acceso.ultimoUsuario, isNull);
      },
    );

    testWidgets(
      'un inicio correcto lleva a la cabina como estudiante con su nombre y sus puntos',
      (t) async {
        final app = await abrirApp(t);

        await entrarComoEstudiante(t);

        expect(app.sesion.modo, ModoSesion.estudiante);
        expect(find.text('Ana'), findsOneWidget);
        expect(
          find.text('120'),
          findsOneWidget,
        ); // puntos que informa el servidor
        expect(find.text('85 min'), findsOneWidget);
      },
    );

    testWidgets(
      'la pantalla de inicio de sesión no ofrece crear cuenta ni código de docente, y tiene el botón docente',
      (t) async {
        await abrirApp(t);
        await t.tap(find.text('INICIAR SESIÓN'));
        await t.pumpAndSettle();

        expect(find.text('¡Qué bueno verte de nuevo!'), findsOneWidget);
        expect(find.text('Crear una cuenta'), findsNothing);
        expect(find.text('Tengo un código de mi docente'), findsNothing);
        expect(find.text('Soy docente'), findsNothing);
        expect(find.text('ENTRAR'), findsOneWidget);
        expect(find.byType(TextField), findsNWidgets(2));

        await t.tap(find.text('INICIAR SESIÓN GENIO'));
        await t.pumpAndSettle();
        expect(find.text('Acceso docente'), findsOneWidget);
        expect(find.text('CONTINUAR CON GOOGLE'), findsOneWidget);
      },
    );

    for (final tamano in const [
      Size(360, 640),
      Size(768, 1024),
      Size(1440, 900),
    ]) {
      testWidgets(
        'el botón «INICIAR SESIÓN GENIO» cabe sin desbordes en ${tamano.width.toInt()}x${tamano.height.toInt()}',
        (t) async {
          await abrirApp(t, tamano: tamano);
          await t.tap(find.text('INICIAR SESIÓN'));
          await t.pumpAndSettle();

          await t.ensureVisible(find.text('INICIAR SESIÓN GENIO'));
          expect(find.text('INICIAR SESIÓN GENIO'), findsOneWidget);
          expect(t.takeException(), isNull);
        },
      );
    }
  });

  group('crear cuenta con código de aula', () {
    testWidgets(
      'el código de aula no sustituye al usuario: se piden los cuatro datos y se avisa que no se transfiere el progreso',
      (t) async {
        final acceso = FalsoAcceso()
          ..errorRegistro = const ExcepcionApi(
            'x',
            estado: 404,
            codigo: 'aula_no_encontrada',
          );
        final app = await abrirApp(t, acceso: acceso);
        await t.tap(find.text('INICIAR SESIÓN'));
        await t.pumpAndSettle();
        GoRouter.of(t.element(find.byType(Scaffold).first)).go('/registro');
        await t.pumpAndSettle();
        expect(find.byType(TextField), findsNWidgets(4));
        expect(find.textContaining('no se pasa a ella'), findsOneWidget);

        await t.tap(find.text('CREAR MI CUENTA').last);
        await t.pumpAndSettle();
        expect(find.text('Completa todos los datos.'), findsOneWidget);

        final campos = find.byType(TextField);
        await t.enterText(campos.at(0), 'k0000');
        await t.enterText(campos.at(1), 'Ana');
        await t.enterText(campos.at(2), 'ana.luz');
        await t.enterText(campos.at(3), 'clave123');
        await t.tap(find.text('CREAR MI CUENTA').last);
        await t.pumpAndSettle();

        expect(
          find.textContaining('No encontramos ese código de aula'),
          findsOneWidget,
        );
        expect(app.sesion.activa, isFalse);
      },
    );

    testWidgets('un registro correcto entra a la cabina como estudiante', (
      t,
    ) async {
      final app = await abrirApp(t);
      await t.tap(find.text('INICIAR SESIÓN'));
      await t.pumpAndSettle();
      GoRouter.of(t.element(find.byType(Scaffold).first)).go('/registro');
      await t.pumpAndSettle();

      final campos = find.byType(TextField);
      await t.enterText(campos.at(0), ' k4821 ');
      await t.enterText(campos.at(1), 'Ana');
      await t.enterText(campos.at(2), 'ana.luz');
      await t.enterText(campos.at(3), 'clave123');
      await t.tap(find.text('CREAR MI CUENTA').last);
      await t.pumpAndSettle();

      expect(app.acceso.ultimoCodigoAula, 'k4821');
      expect(app.sesion.modo, ModoSesion.estudiante);
      expect(find.text('JUGAR'), findsOneWidget);
    });

    testWidgets('se puede crear la cuenta sin código de aula', (t) async {
      final app = await abrirApp(t);
      await t.tap(find.text('INICIAR SESIÓN'));
      await t.pumpAndSettle();
      GoRouter.of(t.element(find.byType(Scaffold).first)).go('/registro');
      await t.pumpAndSettle();

      final campos = find.byType(TextField);
      await t.enterText(campos.at(1), 'Ana');
      await t.enterText(campos.at(2), 'ana.luz');
      await t.enterText(campos.at(3), 'clave123');
      await t.tap(find.text('CREAR MI CUENTA').last);
      await t.pumpAndSettle();

      expect(app.acceso.ultimoCodigoAula, '');
      expect(app.sesion.modo, ModoSesion.estudiante);
      expect(find.text('JUGAR'), findsOneWidget);
    });
  });
}
