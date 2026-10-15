import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genios_app/app/app.dart';
import 'package:genios_app/core/red/excepcion_api.dart';
import 'package:genios_app/core/sesion/sesion_app.dart';
import 'package:genios_app/features/progreso/dominio/modelos_progreso.dart';

import '../soporte/repositorios_falsos.dart';

/// Abre la app, entra como invitado y llega al mapa de Matemáticas (pantalla grande: todos los nodos visibles).
Future<
  ({
    SesionApp sesion,
    FalsoPartida partida,
    FalsoCatalogo catalogo,
    FalsoAcceso acceso,
  })
>
irAlMapa(
  WidgetTester t, {
  FalsoPartida? partida,
  FalsoProgreso? progreso,
  FalsoAcceso? acceso,
}) async {
  t.view.devicePixelRatio = 1.0;
  t.view.physicalSize = const Size(1000, 1800);
  addTearDown(t.view.reset);

  final sesion = SesionApp();
  final catalogo = FalsoCatalogo(mapas: {1: mapaDeMatematicas()});
  final partidaFalsa = partida ?? FalsoPartida();
  final accesoFalso = acceso ?? FalsoAcceso();
  await t.pumpWidget(
    AppGenios(
      sesion: sesion,
      repositorioAcceso: accesoFalso,
      repositorioCatalogo: catalogo,
      repositorioPartida: partidaFalsa,
      repositorioProgreso: progreso ?? FalsoProgreso(),
    ),
  );
  await t.pumpAndSettle();
  await t.tap(find.text('Jugar como invitado'));
  await t.pumpAndSettle();
  await t.tap(find.text('Matemáticas'));
  await t.pumpAndSettle();
  return (
    sesion: sesion,
    partida: partidaFalsa,
    catalogo: catalogo,
    acceso: accesoFalso,
  );
}

Future<void> abrirMision(WidgetTester t) async {
  await t.tap(
    find.text('4. Divisiones'),
  ); // la única "disponible" del mapa de prueba
  await t.pumpAndSettle();
}

void main() {
  group('mapa de misiones', () {
    testWidgets('muestra el progreso del planeta y las insignias del jugador', (
      t,
    ) async {
      await irAlMapa(t);

      expect(find.text('Matemáticas'), findsWidgets);
      expect(find.text('1 de 4 misiones completadas'), findsOneWidget);
      expect(
        find.text('Invitado 1/3'),
        findsOneWidget,
      ); // insignia de invitado (cifras del servidor)
    });

    testWidgets(
      'tocar una misión bloqueada explica qué falta para desbloquearla',
      (t) async {
        await irAlMapa(t);

        await t.tap(find.text('3. Multiplicaciones'));
        await t.pumpAndSettle();

        expect(find.text('Misión bloqueada'), findsOneWidget);
        expect(
          find.text('Completa «Restas» para desbloquearla.'),
          findsOneWidget,
        );
        await t.tap(find.text('Entendido'));
        await t.pumpAndSettle();
        expect(find.text('Misión bloqueada'), findsNothing);
      },
    );
  });

  group('partida', () {
    testWidgets(
      'recorrido completo: preguntas, retroalimentación del servidor y resultado',
      (t) async {
        final ctx = await irAlMapa(t);

        await abrirMision(t);
        expect(find.text('Pregunta 1 de 2'), findsOneWidget);
        expect(find.text('¿Cuánto es 2 + 2?'), findsOneWidget);
        expect(ctx.partida.creadas, 1);

        await t.tap(find.text('Cuatro'));
        await t.pumpAndSettle();
        expect(find.text('¡Correcto!'), findsOneWidget);
        expect(find.text('+10 puntos'), findsOneWidget);
        expect(
          find.byIcon(Icons.check_circle_rounded),
          findsOneWidget,
        ); // el acierto no depende solo del color

        await t.tap(find.text('Siguiente pregunta'));
        await t.pumpAndSettle();
        expect(find.text('Pregunta 2 de 2'), findsOneWidget);

        await t.tap(find.text('Cuatro'));
        await t.pumpAndSettle();
        await t.tap(find.text('Ver mi resultado'));
        await t.pumpAndSettle();

        expect(find.text('¡Misión completada!'), findsOneWidget);
        expect(find.text('+40'), findsOneWidget);
        expect(find.text('2 de 2  (100 %)'), findsOneWidget);

        final consultasAntes = ctx.catalogo.consultas;
        await t.tap(find.text('Volver al mapa'));
        await t.pumpAndSettle();
        expect(find.text('1 de 4 misiones completadas'), findsOneWidget);
        expect(
          ctx.catalogo.consultas,
          greaterThan(consultasAntes),
        ); // el mapa se recarga al volver
      },
    );

    testWidgets(
      'una respuesta incorrecta muestra aliento con icono y deja reintentar',
      (t) async {
        await irAlMapa(t);
        await abrirMision(t);

        await t.tap(find.text('Cinco'));
        await t.pumpAndSettle();

        expect(find.text('Casi… ¡inténtalo otra vez!'), findsOneWidget);
        expect(find.byIcon(Icons.cancel_rounded), findsOneWidget);
        expect(find.text('+10 puntos'), findsNothing);

        await t.tap(find.text('Intentar de nuevo'));
        await t.pumpAndSettle();
        expect(find.text('Pregunta 1 de 2'), findsOneWidget);
      },
    );

    testWidgets(
      'al tercer error aparece la mecha y, si el servidor la da por vencida, termina la partida',
      (t) async {
        final ctx = await irAlMapa(t);
        await abrirMision(t);

        for (var i = 0; i < 3; i++) {
          await t.tap(find.text('Cinco'));
          await t.pumpAndSettle();
          await t.tap(find.text('Intentar de nuevo'));
          await t.pumpAndSettle();
        }
        expect(find.textContaining('La mecha se acaba en 5 s'), findsOneWidget);

        await t.pump(const Duration(seconds: 2));
        expect(find.textContaining('La mecha se acaba en 3 s'), findsOneWidget);

        ctx.partida.vencerMecha();
        await t.pump(const Duration(seconds: 3));
        await t.pumpAndSettle();

        expect(find.text('¡Boom! Se acabó el tiempo'), findsOneWidget);
        expect(find.text('Jugar otra vez'), findsOneWidget);
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
        await irAlMapa(t, partida: partida);

        await abrirMision(t);

        expect(find.textContaining('Vuelve mañana'), findsOneWidget);
        expect(find.text('Reintentar'), findsNothing);
        expect(find.text('Volver al mapa'), findsOneWidget);
      },
    );

    testWidgets(
      'un fallo de red al responder avisa y permite volver a tocar la opción',
      (t) async {
        final partida = FalsoPartida()..fallosDeRed = 1;
        await irAlMapa(t, partida: partida);
        await abrirMision(t);

        await t.tap(find.text('Cuatro'));
        await t.pumpAndSettle();
        expect(find.textContaining('No pudimos conectarnos'), findsOneWidget);

        await t.tap(find.text('Cuatro'));
        await t.pumpAndSettle();
        expect(find.text('¡Correcto!'), findsOneWidget);
        expect(partida.clavesRecibidas.length, 1);
      },
    );

    testWidgets('salir de la misión pide confirmación y abandona la partida', (
      t,
    ) async {
      final ctx = await irAlMapa(t);
      await abrirMision(t);

      await t.tap(find.byTooltip('Salir de la misión'));
      await t.pumpAndSettle();
      expect(find.text('¿Salir de la misión?'), findsOneWidget);

      await t.tap(find.text('Seguir jugando'));
      await t.pumpAndSettle();
      expect(ctx.partida.abandonadas, 0);

      await t.tap(find.byTooltip('Salir de la misión'));
      await t.pumpAndSettle();
      await t.tap(find.text('Salir'));
      await t.pumpAndSettle();

      expect(ctx.partida.abandonadas, 1);
      expect(find.text('1 de 4 misiones completadas'), findsOneWidget);
    });

    testWidgets(
      'las opciones y la mecha tienen etiquetas para lectores de pantalla',
      (t) async {
        final semantica = t.ensureSemantics();
        await irAlMapa(t);
        await abrirMision(t);

        expect(find.bySemanticsLabel('Cuatro'), findsOneWidget);
        expect(find.bySemanticsLabel('Pregunta 1 de 2'), findsOneWidget);
        semantica.dispose();
      },
    );
  });

  group('progreso y registro', () {
    testWidgets(
      'el estudiante ve puntos, aciertos a la primera (aparte de los reintentos) y sus planetas',
      (t) async {
        final sesion = SesionApp();
        t.view.devicePixelRatio = 1.0;
        t.view.physicalSize = const Size(1000, 1800);
        addTearDown(t.view.reset);
        await t.pumpWidget(
          AppGenios(
            sesion: sesion,
            repositorioAcceso: FalsoAcceso(),
            repositorioCatalogo: FalsoCatalogo(),
            repositorioPartida: FalsoPartida(),
            repositorioProgreso: FalsoProgreso(),
          ),
        );
        await t.pumpAndSettle();
        await t.tap(find.text('Ya tengo mi usuario'));
        await t.pumpAndSettle();
        await t.enterText(find.byType(TextField).first, 'ana');
        await t.enterText(find.byType(TextField).last, 'clave123');
        await t.tap(find.widgetWithText(FilledButton, 'Entrar'));
        await t.pumpAndSettle();

        expect(
          find.text('120 puntos'),
          findsOneWidget,
        ); // insignias del estudiante
        expect(find.text('85 min hoy'), findsOneWidget);

        await t.tap(find.byTooltip('Mi progreso'));
        await t.pumpAndSettle();

        expect(find.text('140'), findsOneWidget);
        expect(find.text('70 %'), findsOneWidget);
        expect(find.textContaining('corregiste 3 preguntas'), findsOneWidget);
        expect(
          find.textContaining('1 partidas quedaron sin terminar'),
          findsOneWidget,
        );
        expect(find.text('Matemáticas'), findsOneWidget);
        expect(find.text('Comunicación y Lenguaje'), findsOneWidget);
        expect(find.text('Todavía no tiene misiones.'), findsOneWidget);
        expect(find.text('Sumas · Matemáticas'), findsOneWidget);
      },
    );

    testWidgets('al llegar al límite diario la insignia lo dice', (t) async {
      final progreso = FalsoProgreso(
        resumenEstudiante: const ResumenJugador(
          esInvitado: false,
          puntos: 50,
          minutosRestantes: 0,
          limiteAlcanzado: true,
        ),
      );
      final sesion = SesionApp()
        ..iniciarCuenta(tokenAcceso: 'T', roles: ['estudiante']);
      await t.pumpWidget(
        AppGenios(
          sesion: sesion,
          repositorioAcceso: FalsoAcceso(),
          repositorioCatalogo: FalsoCatalogo(),
          repositorioPartida: FalsoPartida(),
          repositorioProgreso: progreso,
        ),
      );
      await t.pumpAndSettle();

      expect(find.text('Tiempo de hoy completo'), findsOneWidget);
    });

    testWidgets(
      'el invitado ve cuánto falta y, al lograrlo, se le invita a crear su cuenta',
      (t) async {
        final progreso = FalsoProgreso();
        await irAlMapa(t, progreso: progreso);
        await t.tap(find.text('Invitado 1/3'));
        await t.pumpAndSettle();

        expect(find.text('Estás jugando como invitado'), findsOneWidget);
        expect(
          find.textContaining('Te faltan 2 partidas buenas'),
          findsOneWidget,
        );
        expect(find.text('Crear mi cuenta'), findsNothing);
        expect(find.textContaining('no se guardará'), findsOneWidget);
      },
    );

    testWidgets(
      'con tres partidas buenas aparece la invitación y lleva al registro',
      (t) async {
        final progreso = FalsoProgreso(
          progresoInvitado: const ProgresoInvitado(
            partidasValidas: 4,
            partidasQueCuentan: 3,
            partidasRequeridas: 3,
            invitarARegistrarse: true,
            aviso: 'Si no te registras, tu progreso como invitado no se guardará en una cuenta.',
          ),
        );
        await irAlMapa(t, progreso: progreso);
        await t.tap(find.text('Invitado 3/3'));
        await t.pumpAndSettle();

        expect(
          find.textContaining('Ya puedes crear tu cuenta'),
          findsOneWidget,
        );
        await t.tap(find.widgetWithText(FilledButton, 'Crear mi cuenta'));
        await t.pumpAndSettle();

        expect(
          find.text('Pídele a tu docente el código de tu aula.'),
          findsOneWidget,
        );
        expect(find.textContaining('no se pasa a ella'), findsOneWidget);
      },
    );

    testWidgets(
      'el registro muestra un mensaje claro si el código de aula no existe',
      (t) async {
        final acceso = FalsoAcceso()
          ..errorRegistro = const ExcepcionApi(
            'x',
            estado: 404,
            codigo: 'aula_no_encontrada',
          );
        final sesion = SesionApp();
        await t.pumpWidget(
          AppGenios(
            sesion: sesion,
            repositorioAcceso: acceso,
            repositorioCatalogo: FalsoCatalogo(),
            repositorioPartida: FalsoPartida(),
            repositorioProgreso: FalsoProgreso(),
          ),
        );
        await t.pumpAndSettle();
        await t.tap(find.text('Tengo un código de aula'));
        await t.pumpAndSettle();

        await t.tap(find.widgetWithText(FilledButton, 'Crear mi cuenta'));
        await t.pumpAndSettle();
        expect(find.text('Completa todos los datos.'), findsOneWidget);

        final campos = find.byType(TextField);
        await t.enterText(campos.at(0), 'k0000');
        await t.enterText(campos.at(1), 'Ana');
        await t.enterText(campos.at(2), 'ana.luz');
        await t.enterText(campos.at(3), 'clave123');
        await t.tap(find.widgetWithText(FilledButton, 'Crear mi cuenta'));
        await t.pumpAndSettle();

        expect(
          find.textContaining('No encontramos ese código de aula'),
          findsOneWidget,
        );
        expect(sesion.activa, isFalse);
      },
    );

    testWidgets('un registro correcto entra al universo como estudiante', (
      t,
    ) async {
      final acceso = FalsoAcceso();
      final sesion = SesionApp();
      await t.pumpWidget(
        AppGenios(
          sesion: sesion,
          repositorioAcceso: acceso,
          repositorioCatalogo: FalsoCatalogo(),
          repositorioPartida: FalsoPartida(),
          repositorioProgreso: FalsoProgreso(),
        ),
      );
      await t.pumpAndSettle();
      await t.tap(find.text('Tengo un código de aula'));
      await t.pumpAndSettle();

      final campos = find.byType(TextField);
      await t.enterText(campos.at(0), ' k4821 ');
      await t.enterText(campos.at(1), 'Ana');
      await t.enterText(campos.at(2), 'ana.luz');
      await t.enterText(campos.at(3), 'clave123');
      await t.tap(find.widgetWithText(FilledButton, 'Crear mi cuenta'));
      await t.pumpAndSettle();

      expect(
        acceso.ultimoCodigoAula,
        'k4821',
      ); // el servidor normaliza mayúsculas y espacios
      expect(find.text('Tu universo'), findsOneWidget);
      expect(sesion.modo, ModoSesion.estudiante);
    });
  });
}
