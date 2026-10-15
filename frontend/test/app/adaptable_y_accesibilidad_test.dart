import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genios_app/core/ajustes/ajustes_app.dart';

import '../soporte/abrir_app.dart';

/// Toca un texto; si en pantallas pequeñas queda fuera de vista, primero lo desplaza hasta verlo.
Future<void> tocar(WidgetTester t, String texto) async {
  await t.ensureVisible(find.text(texto));
  await t.pumpAndSettle();
  await t.tap(find.text(texto));
  await t.pumpAndSettle();
}

/// Recorre todas las pantallas del estudiante. Cualquier desbordamiento hace fallar la prueba.
Future<void> recorrerPantallas(WidgetTester t) async {
  expect(find.text('JUGAR'), findsOneWidget); // bienvenida
  expect(t.takeException(), isNull);

  await tocar(t, 'JUGAR');
  expect(find.text('¡DESPEGAR!'), findsOneWidget); // nombre del invitado
  expect(t.takeException(), isNull);

  await t.enterText(find.byType(TextField), 'Luna');
  await tocar(t, '¡DESPEGAR!');
  expect(find.text('Luna'), findsOneWidget); // cabina
  expect(t.takeException(), isNull);

  await tocar(t, 'JUGAR');
  expect(find.text('Matemáticas'), findsOneWidget); // materias
  expect(t.takeException(), isNull);

  await tocar(t, 'Matemáticas');
  expect(find.text('1. Sumas'), findsOneWidget); // misiones
  expect(t.takeException(), isNull);

  await t.scrollUntilVisible(
    find.text('4. Divisiones'),
    200,
    scrollable: find.byType(Scrollable).first,
  );
  await tocar(t, '4. Divisiones');
  expect(find.text('Pregunta 1 de 2'), findsOneWidget); // partida
  expect(t.takeException(), isNull);

  await tocar(t, 'Cuatro');
  expect(find.text('¡Correcto!'), findsOneWidget); // retroalimentación
  expect(t.takeException(), isNull);

  await t.ensureVisible(find.text('SIGUIENTE PREGUNTA'));
  await tocar(t, 'SIGUIENTE PREGUNTA');
  await tocar(t, 'Cuatro');
  await t.ensureVisible(find.text('VER MI RESULTADO'));
  await tocar(t, 'VER MI RESULTADO');
  expect(find.text('¡Misión completada!'), findsOneWidget); // resultados
  expect(t.takeException(), isNull);
}

void main() {
  group('diseño adaptable: ninguna pantalla se desborda', () {
    for (final (nombre, tamano) in [
      ('móvil pequeño', const Size(320, 568)),
      ('móvil', const Size(360, 640)),
      ('tableta', const Size(820, 1180)),
      ('escritorio', const Size(1440, 900)),
    ]) {
      testWidgets(
        'en $nombre (${tamano.width.toInt()}×${tamano.height.toInt()})',
        (t) async {
          await abrirApp(t, tamano: tamano);
          await recorrerPantallas(t);
        },
      );
    }

    testWidgets('en móvil con el texto más grande', (t) async {
      await abrirApp(
        t,
        tamano: const Size(360, 640),
        ajustes: AjustesApp(animaciones: false, textoGrande: true),
      );
      await recorrerPantallas(t);
    });
  });

  group('accesibilidad', () {
    testWidgets(
      'los controles principales tienen etiqueta, rol de botón y objetivo táctil amplio',
      (t) async {
        final semantica = t.ensureSemantics();
        await abrirApp(t);

        expect(find.bySemanticsLabel('JUGAR'), findsOneWidget);
        expect(find.bySemanticsLabel('INICIAR SESIÓN'), findsOneWidget);
        for (final texto in ['JUGAR', 'INICIAR SESIÓN']) {
          final tamano = t.getSize(
            find
                .ancestor(of: find.text(texto), matching: find.byType(InkWell))
                .first,
          );
          expect(tamano.height, greaterThanOrEqualTo(48), reason: texto);
          expect(tamano.width, greaterThanOrEqualTo(48), reason: texto);
        }
        semantica.dispose();
      },
    );

    testWidgets(
      'las cards de materia, los nodos de misión y las opciones se anuncian completos',
      (t) async {
        final semantica = t.ensureSemantics();
        await abrirApp(t);
        await entrarComoInvitado(t);

        await irAMaterias(t);
        expect(
          find.bySemanticsLabel(
            RegExp('Comunicación y Lenguaje. Toca para ver sus misiones'),
          ),
          findsOneWidget,
        );

        await t.tap(find.text('Matemáticas'));
        await t.pumpAndSettle();
        expect(
          find.bySemanticsLabel(
            RegExp('Misión 3: Multiplicaciones. Bloqueada. Completa «Restas»'),
          ),
          findsOneWidget,
        );
        expect(
          find.bySemanticsLabel(RegExp('Misión 1: Sumas. Completada')),
          findsOneWidget,
        );

        await t.tap(find.text('4. Divisiones'));
        await t.pumpAndSettle();
        expect(find.bySemanticsLabel('Pregunta 1 de 2'), findsOneWidget);
        expect(find.bySemanticsLabel('Cuatro'), findsOneWidget);
        semantica.dispose();
      },
    );

    testWidgets(
      'los estados nunca dependen solo del color: llevan texto e icono',
      (t) async {
        await abrirApp(t);
        await entrarComoInvitado(t);
        await irAMisiones(t, 'Matemáticas');

        for (final (texto, icono) in [
          ('Completada', Icons.star_rounded),
          ('En progreso', Icons.play_arrow_rounded),
          ('Bloqueada', Icons.lock_rounded),
          ('Disponible', Icons.rocket_launch_rounded),
        ]) {
          expect(find.text(texto), findsOneWidget, reason: texto);
          expect(
            find.byIcon(icono),
            findsOneWidget,
            reason: '$texto necesita su icono',
          );
        }
      },
    );

    testWidgets(
      'los mensajes de error se anuncian a los lectores de pantalla',
      (t) async {
        final semantica = t.ensureSemantics();
        await abrirApp(t);
        await t.tap(find.text('JUGAR'));
        await t.pumpAndSettle();
        await t.tap(find.text('¡DESPEGAR!'));
        await t.pumpAndSettle();

        final mensaje = find.ancestor(
          of: find.text('Escribe tu nombre o un apodo.'),
          matching: find.byType(Semantics),
        );
        expect(mensaje, findsWidgets);
        expect(
          t.getSemantics(find.text('Escribe tu nombre o un apodo.')).label,
          contains('Escribe tu nombre'),
        );
        semantica.dispose();
      },
    );
  });
}
