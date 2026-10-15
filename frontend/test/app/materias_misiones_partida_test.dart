import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genios_app/core/red/excepcion_api.dart';
import 'package:genios_app/core/sesion/sesion_app.dart';
import 'package:genios_app/features/catalogo/dominio/modelos_catalogo.dart';
import 'package:genios_app/features/progreso/dominio/modelos_progreso.dart';

import '../soporte/abrir_app.dart';
import '../soporte/repositorios_falsos.dart';

/// Mapa de Matemáticas tras completar «Sumas»: el servidor ya dejó disponible la siguiente.
MapaMateria mapaConSiguiente() => const MapaMateria(
  asignatura: Asignatura(id: 1, codigo: 'MATEMATICAS', nombre: 'Matematicas'),
  niveles: [
    NivelConMisiones(
      id: 10,
      nombre: 'Nivel 1',
      misiones: [
        Mision(
          id: 100,
          nombre: 'Sumas',
          numeroOrden: 1,
          estado: EstadoMision.disponible,
        ),
        Mision(
          id: 101,
          nombre: 'Restas',
          numeroOrden: 2,
          estado: EstadoMision.disponible,
        ),
      ],
    ),
  ],
);

Future<void> abrirDivisiones(WidgetTester t) async {
  await t.tap(find.text('4. Divisiones'));
  await t.pumpAndSettle();
}

Future<void> responderCorrecto(WidgetTester t) async {
  await t.tap(find.text('Cuatro'));
  await t.pumpAndSettle();
}

void main() {
  group('materias', () {
    testWidgets(
      'las cuatro materias vienen de la API, con su nombre visible y sin planetas como botones',
      (t) async {
        await abrirApp(t);
        await entrarComoInvitado(t);

        await irAMaterias(t);

        for (final nombre in [
          'Matemáticas',
          'Comunicación y Lenguaje',
          'Ciencias Sociales',
          'Ciencias Naturales',
        ]) {
          expect(find.text(nombre), findsOneWidget, reason: nombre);
        }
        expect(
          find.text('Lenguaje'),
          findsNothing,
        ); // el nombre corto del catálogo no se muestra
      },
    );

    testWidgets('un estudiante ve su avance en cada materia; un invitado no', (
      t,
    ) async {
      await abrirApp(t);
      await entrarComoEstudiante(t);
      await irAMaterias(t);
      expect(find.text('1 de 4 misiones'), findsOneWidget);
    });

    testWidgets('un invitado no ve indicadores de avance por materia', (
      t,
    ) async {
      await abrirApp(t);
      await entrarComoInvitado(t);
      await irAMaterias(t);
      expect(find.textContaining('misiones'), findsNothing);
    });

    testWidgets('un error de red permite reintentar', (t) async {
      final catalogo = FalsoCatalogo(error: const ExcepcionApi.sinConexion());
      await abrirApp(t, catalogo: catalogo);
      await entrarComoInvitado(t);
      await irAMaterias(t);
      expect(find.textContaining('No pudimos conectarnos'), findsOneWidget);

      catalogo.error = null;
      await t.tap(find.text('Reintentar'));
      await t.pumpAndSettle();

      expect(find.text('Matemáticas'), findsOneWidget);
    });
  });

  group('misiones', () {
    testWidgets(
      'muestra progreso, nivel y los cuatro estados con texto, y el requisito de las bloqueadas',
      (t) async {
        await abrirApp(t);
        await entrarComoInvitado(t);

        await irAMisiones(t, 'Matemáticas');

        expect(find.text('1 de 4 misiones completadas'), findsOneWidget);
        expect(find.text('Nivel 1'), findsOneWidget);
        expect(find.text('1. Sumas'), findsOneWidget);
        expect(find.text('Completada'), findsOneWidget);
        expect(find.text('En progreso'), findsOneWidget);
        expect(find.text('Bloqueada'), findsOneWidget);
        expect(find.text('Disponible'), findsOneWidget);
        expect(find.text('Completa «Restas»'), findsOneWidget);
        expect(find.byIcon(Icons.lock_rounded), findsOneWidget);
      },
    );

    testWidgets(
      'tocar una misión bloqueada explica qué falta; el cliente no la desbloquea',
      (t) async {
        final app = await abrirApp(t);
        await entrarComoInvitado(t);
        await irAMisiones(t, 'Matemáticas');

        await t.tap(find.text('3. Multiplicaciones'));
        await t.pumpAndSettle();

        expect(find.text('Misión bloqueada'), findsOneWidget);
        expect(
          find.text('Completa «Restas» para desbloquearla.'),
          findsOneWidget,
        );
        expect(app.partida.creadas, 0);
        await t.tap(find.text('Entendido'));
        await t.pumpAndSettle();
        expect(find.text('Misión bloqueada'), findsNothing);
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
        await abrirApp(t, catalogo: catalogo);
        await entrarComoInvitado(t);

        await irAMisiones(t, 'Comunicación y Lenguaje');

        expect(
          find.textContaining('todavía no tiene misiones'),
          findsOneWidget,
        );
      },
    );
  });

  group('partida', () {
    testWidgets(
      'recorrido completo: preguntas, retroalimentación del servidor y resultado',
      (t) async {
        final app = await abrirApp(t);
        await entrarComoInvitado(t);
        await irAMisiones(t, 'Matemáticas');

        await abrirDivisiones(t);
        expect(find.text('Pregunta 1 de 2'), findsOneWidget);
        expect(find.text('¿Cuánto es 2 + 2?'), findsOneWidget);
        expect(app.partida.creadas, 1);

        await responderCorrecto(t);
        expect(find.text('¡Correcto!'), findsOneWidget);
        expect(find.text('+10 puntos'), findsOneWidget);
        expect(
          find.byIcon(Icons.check_circle_rounded),
          findsWidgets,
        ); // el acierto no depende solo del color

        await t.tap(find.text('SIGUIENTE PREGUNTA'));
        await t.pumpAndSettle();
        expect(find.text('Pregunta 2 de 2'), findsOneWidget);

        await responderCorrecto(t);
        await t.tap(find.text('VER MI RESULTADO'));
        await t.pumpAndSettle();

        expect(find.text('¡Misión completada!'), findsOneWidget);
        expect(find.text('+40'), findsOneWidget);
        expect(
          find.text('2 de 2 (100 %)'),
          findsOneWidget,
        ); // aciertos a la primera
        expect(
          find.text('Resolviste 2 de 2'),
          findsOneWidget,
        ); // con reintentos
        expect(find.text('Completada'), findsOneWidget);
      },
    );

    testWidgets('volver a las misiones recarga el mapa', (t) async {
      final app = await abrirApp(t);
      await entrarComoInvitado(t);
      await irAMisiones(t, 'Matemáticas');
      await abrirDivisiones(t);
      await responderCorrecto(t);
      await t.tap(find.text('SIGUIENTE PREGUNTA'));
      await t.pumpAndSettle();
      await responderCorrecto(t);
      await t.tap(find.text('VER MI RESULTADO'));
      await t.pumpAndSettle();
      final consultas = app.catalogo.consultas;

      await t.tap(find.text('VOLVER A LAS MISIONES'));
      await t.pumpAndSettle();

      expect(find.text('1 de 4 misiones completadas'), findsOneWidget);
      expect(app.catalogo.consultas, greaterThan(consultas));
    });

    testWidgets(
      'si el servidor deja disponible otra misión, se ofrece la siguiente',
      (t) async {
        final app = await abrirApp(
          t,
          catalogo: FalsoCatalogo(mapas: {1: mapaConSiguiente()}),
        );
        await entrarComoInvitado(t);
        await irAMisiones(t, 'Matemáticas');
        await t.tap(find.text('1. Sumas'));
        await t.pumpAndSettle();
        await responderCorrecto(t);
        await t.tap(find.text('SIGUIENTE PREGUNTA'));
        await t.pumpAndSettle();
        await responderCorrecto(t);
        await t.tap(find.text('VER MI RESULTADO'));
        await t.pumpAndSettle();

        expect(find.text('SIGUIENTE: RESTAS'), findsOneWidget);
        await t.tap(find.text('SIGUIENTE: RESTAS'));
        await t.pumpAndSettle();

        expect(find.text('Pregunta 1 de 2'), findsOneWidget);
        expect(app.partida.creadas, 2);
      },
    );

    testWidgets(
      'una respuesta incorrecta anima sin castigar y deja reintentar',
      (t) async {
        await abrirApp(t);
        await entrarComoInvitado(t);
        await irAMisiones(t, 'Matemáticas');
        await abrirDivisiones(t);

        await t.tap(find.text('Cinco'));
        await t.pumpAndSettle();

        expect(find.text('Casi… ¡inténtalo otra vez!'), findsOneWidget);
        expect(find.byIcon(Icons.cancel_rounded), findsOneWidget);
        expect(find.textContaining('puntos'), findsNothing);

        await t.tap(find.text('INTENTAR DE NUEVO'));
        await t.pumpAndSettle();
        expect(find.text('Pregunta 1 de 2'), findsOneWidget);
      },
    );

    testWidgets(
      'al tercer error aparece la mecha y, si el servidor la da por vencida, termina la partida',
      (t) async {
        final app = await abrirApp(t);
        await entrarComoInvitado(t);
        await irAMisiones(t, 'Matemáticas');
        await abrirDivisiones(t);

        for (var i = 0; i < 3; i++) {
          await t.tap(find.text('Cinco'));
          await t.pumpAndSettle();
          await t.tap(find.text('INTENTAR DE NUEVO'));
          await t.pumpAndSettle();
        }
        expect(find.textContaining('La mecha se acaba en 5 s'), findsOneWidget);

        await t.pump(const Duration(seconds: 2));
        expect(find.textContaining('La mecha se acaba en 3 s'), findsOneWidget);

        app.partida.vencerMecha();
        await t.pump(const Duration(seconds: 3));
        await t.pumpAndSettle();

        expect(find.text('¡Boom! Se acabó el tiempo'), findsOneWidget);
        expect(find.text('JUGAR OTRA VEZ'), findsOneWidget);
      },
    );

    testWidgets(
      'si no queda tiempo diario se explica y no se ofrece reintentar',
      (t) async {
        final partida = FalsoPartida()
          ..errorAlCrear = const ExcepcionApi(
            'Ya alcanzaste tu tiempo de juego de hoy. ¡Vuelve mañana!',
            estado: 403,
            codigo: 'limite_diario_agotado',
          );
        await abrirApp(t, partida: partida);
        await entrarComoInvitado(t);
        await irAMisiones(t, 'Matemáticas');

        await abrirDivisiones(t);

        expect(find.textContaining('Vuelve mañana'), findsOneWidget);
        expect(find.text('Reintentar'), findsNothing);
        expect(find.text('VOLVER'), findsOneWidget);
      },
    );

    testWidgets(
      'un fallo de red al responder avisa y permite volver a tocar la opción sin duplicar',
      (t) async {
        final partida = FalsoPartida()..fallosDeRed = 1;
        await abrirApp(t, partida: partida);
        await entrarComoInvitado(t);
        await irAMisiones(t, 'Matemáticas');
        await abrirDivisiones(t);

        await t.tap(find.text('Cuatro'));
        await t.pumpAndSettle();
        expect(find.textContaining('No pudimos conectarnos'), findsOneWidget);

        await responderCorrecto(t);
        expect(find.text('¡Correcto!'), findsOneWidget);
        expect(partida.clavesRecibidas.length, 1);
      },
    );

    testWidgets('salir de la misión pide confirmación y abandona la partida', (
      t,
    ) async {
      final app = await abrirApp(t);
      await entrarComoInvitado(t);
      await irAMisiones(t, 'Matemáticas');
      await abrirDivisiones(t);

      await t.tap(find.byTooltip('Salir de la misión'));
      await t.pumpAndSettle();
      expect(find.text('¿Salir de la misión?'), findsOneWidget);
      await t.tap(find.text('Seguir jugando'));
      await t.pumpAndSettle();
      expect(app.partida.abandonadas, 0);

      await t.tap(find.byTooltip('Salir de la misión'));
      await t.pumpAndSettle();
      await t.tap(find.text('Salir'));
      await t.pumpAndSettle();

      expect(app.partida.abandonadas, 1);
      expect(find.text('1 de 4 misiones completadas'), findsOneWidget);
    });
  });

  group('invitación a registrarse', () {
    const invitacion = ProgresoInvitado(
      partidasValidas: 4,
      partidasQueCuentan: 3,
      partidasRequeridas: 3,
      invitarARegistrarse: true,
      aviso: 'Si no te registras, tu progreso como invitado no se guardará en una cuenta.',
    );

    Future<void> terminarPartida(WidgetTester t) async {
      await responderCorrecto(t);
      await t.tap(find.text('SIGUIENTE PREGUNTA'));
      await t.pumpAndSettle();
      await responderCorrecto(t);
      await t.tap(find.text('VER MI RESULTADO'));
      await t.pumpAndSettle();
    }

    testWidgets(
      'aparece un modal amistoso cuando el servidor lo indica, una sola vez por sesión',
      (t) async {
        final app = await abrirApp(
          t,
          progreso: FalsoProgreso(progresoInvitado: invitacion),
        );
        await entrarComoInvitado(t);
        await irAMisiones(t, 'Matemáticas');
        await abrirDivisiones(t);

        await terminarPartida(t);
        expect(find.text('¡Lo estás haciendo genial!'), findsOneWidget);
        expect(
          find.textContaining('no se pasa a la cuenta nueva'),
          findsOneWidget,
        );

        await t.tap(find.text('Ahora no'));
        await t.pumpAndSettle();
        expect(find.text('¡Lo estás haciendo genial!'), findsNothing);
        expect(app.sesion.invitacionDescartada, isTrue);

        // Otra partida en la misma sesión: no vuelve a insistir.
        await t.tap(find.text('JUGAR OTRA VEZ'));
        await t.pumpAndSettle();
        await terminarPartida(t);
        expect(find.text('¡Lo estás haciendo genial!'), findsNothing);
      },
    );

    testWidgets('aceptar lleva a crear la cuenta', (t) async {
      await abrirApp(t, progreso: FalsoProgreso(progresoInvitado: invitacion));
      await entrarComoInvitado(t);
      await irAMisiones(t, 'Matemáticas');
      await abrirDivisiones(t);
      await terminarPartida(t);

      await t.tap(find.text('CREAR MI CUENTA'));
      await t.pumpAndSettle();

      expect(
        find.text('Crea tu cuenta y juega. El código de aula es opcional.'),
        findsOneWidget,
      );
    });

    testWidgets('no aparece si el servidor no lo indica', (t) async {
      await abrirApp(t);
      await entrarComoInvitado(t);
      await irAMisiones(t, 'Matemáticas');
      await abrirDivisiones(t);

      await terminarPartida(t);

      expect(find.text('¡Lo estás haciendo genial!'), findsNothing);
    });

    testWidgets('nunca se muestra a un estudiante con cuenta', (t) async {
      await abrirApp(t, progreso: FalsoProgreso(progresoInvitado: invitacion));
      await entrarComoEstudiante(t);
      await irAMisiones(t, 'Matemáticas');
      await abrirDivisiones(t);

      await terminarPartida(t);

      expect(find.text('¡Lo estás haciendo genial!'), findsNothing);
    });
  });

  test('la sesión de invitado recuerda el apodo solo en memoria', () {
    final sesion = SesionApp()..iniciarInvitado(nombre: 'Luna');
    expect(sesion.nombre, 'Luna');
    sesion.cerrar();
    expect(sesion.nombre, isEmpty);
  });
}
