import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genios_app/core/ajustes/ajustes_app.dart';
import 'package:genios_app/core/red/excepcion_api.dart';
import 'package:genios_app/core/sesion/sesion_app.dart';
import 'package:genios_app/diseno/componentes/astronauta_genios.dart';
import 'package:genios_app/diseno/componentes/botones_juego.dart';
import 'package:genios_app/features/progreso/dominio/modelos_progreso.dart';
import 'package:genios_app/features/salon/dominio/repositorio_salon.dart';

import '../soporte/abrir_app.dart';
import '../soporte/repositorios_falsos.dart';

Future<void> abrirMenu(WidgetTester t) async {
  await t.tap(find.byTooltip('Abrir menú'));
  await t.pumpAndSettle();
}

void main() {
  group('cabina', () {
    testWidgets('el astronauta es el centro y JUGAR el único botón principal', (
      t,
    ) async {
      await abrirApp(t);
      await entrarComoInvitado(t);

      expect(find.byType(AstronautaGenios), findsOneWidget);
      expect(find.byType(BotonPrincipalJuego), findsOneWidget);
      expect(find.text('JUGAR'), findsOneWidget);
      // Sin desafíos, compras, amigos ni funciones sociales.
      for (final prohibido in ['Desafíos', 'Tienda', 'Amigos', 'Comprar']) {
        expect(find.textContaining(prohibido), findsNothing, reason: prohibido);
      }
    });

    testWidgets(
      'un invitado ve su apodo y su avance; un estudiante, sus puntos y el tiempo disponible',
      (t) async {
        await abrirApp(t);
        await entrarComoInvitado(t, apodo: 'Luna');
        expect(find.text('Luna'), findsOneWidget);
        expect(find.text('Invitado 1/3'), findsOneWidget);
      },
    );

    testWidgets(
      'si se agotó el tiempo del día, la cabina lo indica sin ocultar el resto',
      (t) async {
        final progreso = FalsoProgreso(
          resumenEstudiante: const ResumenJugador(
            esInvitado: false,
            puntos: 50,
            minutosRestantes: 0,
            limiteAlcanzado: true,
          ),
        );
        await abrirApp(t, progreso: progreso);
        await entrarComoEstudiante(t);

        expect(find.text('Hasta mañana'), findsOneWidget);
        expect(find.text('JUGAR'), findsOneWidget);
      },
    );

    testWidgets('JUGAR lleva a la selección de materias', (t) async {
      await abrirApp(t);
      await entrarComoInvitado(t);

      await irAMaterias(t);

      expect(find.text('Elige tu materia'), findsOneWidget);
    });
  });

  group('menú lateral: solo Perfil, Salón y Ajustes', () {
    testWidgets('tiene exactamente tres secciones', (t) async {
      await abrirApp(t);
      await entrarComoInvitado(t);

      await abrirMenu(t);

      expect(
        find.descendant(
          of: find.byType(Drawer),
          matching: find.byType(ListTile),
        ),
        findsNWidgets(3),
      );
      for (final opcion in ['Perfil', 'Salón', 'Ajustes']) {
        expect(find.text(opcion), findsOneWidget, reason: opcion);
      }
    });

    testWidgets(
      'Perfil de un estudiante: puntos, aciertos a la primera aparte de los reintentos, materias y partidas recientes',
      (t) async {
        await abrirApp(t);
        await entrarComoEstudiante(t);

        await abrirMenu(t);
        await t.tap(find.text('Perfil'));
        await t.pumpAndSettle();

        expect(find.text('140'), findsOneWidget);
        expect(find.text('70 %'), findsOneWidget);
        expect(
          find.text('Con reintentos corregiste 3 preguntas.'),
          findsOneWidget,
        );
        expect(
          find.textContaining('1 partidas quedaron sin terminar'),
          findsOneWidget,
        );
        expect(find.text('Comunicación y Lenguaje'), findsOneWidget);
        expect(find.text('Todavía no tiene misiones.'), findsOneWidget);
        expect(find.text('Sumas · Matemáticas'), findsOneWidget);
      },
    );

    testWidgets(
      'Perfil de un invitado: cuánto falta para poder crear una cuenta',
      (t) async {
        await abrirApp(t);
        await entrarComoInvitado(t);

        await abrirMenu(t);
        await t.tap(find.text('Perfil'));
        await t.pumpAndSettle();

        expect(find.text('Partidas buenas: 1 de 3'), findsOneWidget);
        expect(
          find.textContaining('Te faltan 2 partidas buenas'),
          findsOneWidget,
        );
        expect(find.textContaining('no se guardará'), findsOneWidget);
        expect(find.text('CREAR MI CUENTA'), findsNothing);
      },
    );

    testWidgets('Perfil: un error de red permite reintentar', (t) async {
      final progreso = FalsoProgreso(error: const ExcepcionApi.sinConexion());
      await abrirApp(t, progreso: progreso);
      await entrarComoInvitado(t);

      await abrirMenu(t);
      await t.tap(find.text('Perfil'));
      await t.pumpAndSettle();
      expect(find.textContaining('No pudimos conectarnos'), findsWidgets);

      progreso.error = null;
      await t.tap(find.text('Reintentar'));
      await t.pumpAndSettle();
      expect(find.text('Partidas buenas: 1 de 3'), findsOneWidget);
    });
  });

  group('salón', () {
    testWidgets(
      'un invitado recibe una explicación amistosa y el camino para crear su cuenta',
      (t) async {
        await abrirApp(t);
        await entrarComoInvitado(t);

        await abrirMenu(t);
        await t.tap(find.text('Salón'));
        await t.pumpAndSettle();

        expect(
          find.text('Los salones son para quienes tienen una cuenta.'),
          findsOneWidget,
        );
        await t.tap(find.text('CREAR MI CUENTA'));
        await t.pumpAndSettle();
        expect(
          find.text('Crea tu cuenta y juega. El código de aula es opcional.'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'un estudiante sin salón ve cómo unirse y se une con el código del docente',
      (t) async {
        final app = await abrirApp(t);
        await entrarComoEstudiante(t);

        await abrirMenu(t);
        await t.tap(find.text('Salón'));
        await t.pumpAndSettle();
        expect(
          find.textContaining('Todavía no estás en un salón'),
          findsOneWidget,
        );

        await t.enterText(find.byType(TextField), 'k4821');
        await t.tap(find.text('UNIRME'));
        await t.pumpAndSettle();

        expect(app.salon.ultimoCodigo, 'k4821');
        expect(
          find.textContaining('Ahora estás en «Aula de la maestra Luz»'),
          findsOneWidget,
        );
        expect(
          find.text('Aula de la maestra Luz'),
          findsOneWidget,
        ); // ahora aparece como su salón
      },
    );

    testWidgets(
      'un código inexistente muestra un mensaje claro y no cambia el salón',
      (t) async {
        final salon = FalsoSalon()
          ..errorAlUnirse = const ExcepcionApi(
            'x',
            estado: 404,
            codigo: 'aula_no_encontrada',
          );
        await abrirApp(t, salon: salon);
        await entrarComoEstudiante(t);
        await abrirMenu(t);
        await t.tap(find.text('Salón'));
        await t.pumpAndSettle();

        await t.enterText(find.byType(TextField), 'Z9999');
        await t.tap(find.text('UNIRME'));
        await t.pumpAndSettle();

        expect(
          find.textContaining('No encontramos ese código de aula'),
          findsOneWidget,
        );
        expect(
          find.textContaining('Todavía no estás en un salón'),
          findsOneWidget,
        );
      },
    );

    testWidgets('muestra el aula asignada que informa la API', (t) async {
      final salon = FalsoSalon(
        aulas: const [
          AulaSalon(id: 'a1', nombre: 'Cuarto B', estado: 'activa'),
        ],
      );
      await abrirApp(t, salon: salon);
      await entrarComoEstudiante(t);
      await abrirMenu(t);
      await t.tap(find.text('Salón'));
      await t.pumpAndSettle();

      expect(find.text('Cuarto B'), findsOneWidget);
    });
  });

  group('ajustes', () {
    testWidgets(
      'permite cambiar animaciones y tamaño del texto, y lista el sonido como próximamente',
      (t) async {
        final app = await abrirApp(t);
        await entrarComoInvitado(t);
        await abrirMenu(t);
        await t.tap(find.text('Ajustes'));
        await t.pumpAndSettle();

        expect(find.text('Próximamente.'), findsOneWidget);
        expect(app.ajustes.textoGrande, isFalse);

        await t.tap(find.text('Texto más grande'));
        await t.pumpAndSettle();

        expect(app.ajustes.textoGrande, isTrue);
        expect(
          MediaQuery.of(t.element(find.text('Ajustes').first)).textScaler
              .scale(10),
          12.5,
        );
      },
    );

    testWidgets(
      'activar o desactivar las animaciones se refleja en el ajuste',
      (t) async {
        final app = await abrirApp(t);
        await entrarComoInvitado(t);
        await abrirMenu(t);
        await t.tap(find.text('Ajustes'));
        await t.pumpAndSettle();
        expect(app.ajustes.animaciones, isFalse);

        await t.tap(find.text('Animaciones'));
        await t.pump();
        expect(app.ajustes.animaciones, isTrue);
        await t.tap(find.text('Animaciones'));
        await t.pump();
        expect(app.ajustes.animaciones, isFalse);
      },
    );

    testWidgets('salir del modo invitado vuelve a la bienvenida', (t) async {
      final app = await abrirApp(t);
      await entrarComoInvitado(t);
      await abrirMenu(t);
      await t.tap(find.text('Ajustes'));
      await t.pumpAndSettle();

      await t.tap(find.text('SALIR DEL MODO INVITADO'));
      await t.pumpAndSettle();

      expect(app.sesion.activa, isFalse);
      expect(find.text('INICIAR SESIÓN'), findsOneWidget);
    });

    testWidgets(
      'cerrar sesión de una cuenta avisa al servidor y vuelve a la bienvenida',
      (t) async {
        final app = await abrirApp(t);
        await entrarComoEstudiante(t);
        await abrirMenu(t);
        await t.tap(find.text('Ajustes'));
        await t.pumpAndSettle();

        await t.tap(find.text('CERRAR SESIÓN'));
        await t.pumpAndSettle();

        expect(app.acceso.cierres, 1);
        expect(app.sesion.modo, ModoSesion.ninguna);
        expect(find.text('JUGAR'), findsOneWidget);
      },
    );
  });

  group('movimiento reducido', () {
    Widget envuelto(
      Widget hijo, {
      bool sistemaReduce = false,
      AjustesApp? ajustes,
    }) => MediaQuery(
      data: MediaQueryData(disableAnimations: sistemaReduce),
      child: AjustesScope(
        ajustes: ajustes ?? AjustesApp(),
        child: MaterialApp(home: Scaffold(body: hijo)),
      ),
    );

    testWidgets('el astronauta flota cuando las animaciones están activas', (
      t,
    ) async {
      await t.pumpWidget(envuelto(const AstronautaGenios()));
      expect(t.hasRunningAnimations, isTrue);
    });

    testWidgets('queda quieto si el sistema pide movimiento reducido', (
      t,
    ) async {
      await t.pumpWidget(
        envuelto(const AstronautaGenios(), sistemaReduce: true),
      );
      expect(t.hasRunningAnimations, isFalse);
    });

    testWidgets('queda quieto si la persona apaga las animaciones en Ajustes', (
      t,
    ) async {
      await t.pumpWidget(
        envuelto(
          const AstronautaGenios(),
          ajustes: AjustesApp(animaciones: false),
        ),
      );
      expect(t.hasRunningAnimations, isFalse);
    });
  });
}
