import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genios_app/core/red/excepcion_api.dart';
import 'package:genios_app/core/sesion/sesion_app.dart';
import 'package:genios_app/features/docente/dominio/repositorio_docente.dart';

import '../soporte/abrir_app.dart';
import '../soporte/repositorios_falsos.dart';

const _aula = AulaDocente(id: 'a1', nombre: '5.º A', codigoAcceso: 'K4821');

Future<void> entrarComoDocente(WidgetTester t) async {
  await t.tap(find.text('INICIAR SESIÓN'));
  await t.pumpAndSettle();
  await t.ensureVisible(find.text('Soy docente'));
  await t.tap(find.text('Soy docente'));
  await t.pumpAndSettle();
  await t.tap(find.text('CONTINUAR CON GOOGLE'));
  await t.pumpAndSettle();
}

void main() {
  group('panel docente', () {
    testWidgets('muestra sus aulas con el código y la lista de estudiantes', (
      t,
    ) async {
      final docente = FalsoDocente(
        aulas: [_aula],
        estudiantes: {
          'a1': [
            const EstudianteDeAula(
              id: 'e1',
              nombreMostrar: 'Ana',
              nombreUsuario: 'ana.luz',
            ),
          ],
        },
      );
      await abrirApp(t, docente: docente);
      await entrarComoDocente(t);

      expect(find.text('Panel docente'), findsOneWidget);
      expect(find.text('K4821'), findsOneWidget);
      expect(find.text('Ana'), findsOneWidget);
      expect(find.textContaining('Usuario: ana.luz'), findsOneWidget);
      expect(find.text('JUGAR'), findsNothing);
    });

    testWidgets('sin aulas invita a crear la primera y la crea', (t) async {
      final docente = FalsoDocente();
      await abrirApp(t, docente: docente);
      await entrarComoDocente(t);
      expect(find.textContaining('Todavía no tienes aulas'), findsOneWidget);

      await t.enterText(find.byType(TextField).first, '6.º B');
      await t.ensureVisible(find.text('CREAR AULA'));
      await t.tap(find.text('CREAR AULA'));
      await t.pumpAndSettle();

      expect(find.text('Código de «6.º B»'), findsOneWidget);
      expect(find.text('K4000'), findsOneWidget);
    });

    testWidgets(
      'agrega un estudiante y muestra su código de activación una vez',
      (t) async {
        final docente = FalsoDocente(aulas: [_aula]);
        await abrirApp(t, docente: docente);
        await entrarComoDocente(t);

        final campos = find.byType(TextField);
        await t.enterText(campos.at(1), 'Beto');
        await t.enterText(campos.at(2), 'beto.2');
        await t.ensureVisible(find.text('AGREGAR'));
        await t.tap(find.text('AGREGAR'));
        await t.pumpAndSettle();

        expect(docente.ultimoUsuarioAgregado, 'beto.2');
        expect(find.text('ABCD2345'), findsOneWidget);
        expect(find.text('Beto'), findsOneWidget);
        expect(find.text('Estudiantes de «5.º A» (1)'), findsOneWidget);
      },
    );

    testWidgets('un usuario repetido muestra un mensaje claro', (t) async {
      final docente = FalsoDocente(aulas: [_aula])
        ..errorAgregar = const ExcepcionApi(
          'x',
          estado: 409,
          codigo: 'nombre_usuario_en_uso',
        );
      await abrirApp(t, docente: docente);
      await entrarComoDocente(t);

      final campos = find.byType(TextField);
      await t.enterText(campos.at(1), 'Beto');
      await t.enterText(campos.at(2), 'beto.2');
      await t.ensureVisible(find.text('AGREGAR'));
      await t.tap(find.text('AGREGAR'));
      await t.pumpAndSettle();

      expect(
        find.text('Ese usuario ya existe. Prueba con otro.'),
        findsOneWidget,
      );
      expect(find.text('ABCD2345'), findsNothing);
    });

    testWidgets('pide un código nuevo para un estudiante existente', (t) async {
      final docente = FalsoDocente(
        aulas: [_aula],
        estudiantes: {
          'a1': [
            const EstudianteDeAula(
              id: 'e1',
              nombreMostrar: 'Ana',
              nombreUsuario: 'ana.luz',
            ),
          ],
        },
      );
      await abrirApp(t, docente: docente);
      await entrarComoDocente(t);

      await t.ensureVisible(find.text('Ana'));
      await t.tap(find.text('Ana'));
      await t.pumpAndSettle();
      await t.ensureVisible(find.text('CAMBIAR CONTRASEÑA'));
      await t.tap(find.text('CAMBIAR CONTRASEÑA'));
      await t.pumpAndSettle();
      expect(docente.codigosNuevos, 1);
      expect(find.text('NUEVO9876'), findsOneWidget);
    });

    testWidgets(
      'funciona sin desbordes en móvil y el docente puede cerrar sesión',
      (t) async {
        final app = await abrirApp(
          t,
          tamano: const Size(360, 640),
          docente: FalsoDocente(aulas: [_aula]),
        );
        await entrarComoDocente(t);
        expect(t.takeException(), isNull);

        await t.tap(find.text('Cerrar sesión'));
        await t.pumpAndSettle();
        expect(app.sesion.modo, ModoSesion.ninguna);
        expect(find.text('JUGAR'), findsOneWidget);
      },
    );
  });

  group('estadísticas y ranking', () {
    const ana = EstudianteDeAula(
      id: 'e1',
      nombreMostrar: 'Ana',
      nombreUsuario: 'ana.luz',
      partidas: 3,
      porcentajeAciertos: 80,
      puntos: 340,
      porMateria: [
        ResumenMateria(
          asignaturaId: 1,
          nombre: 'Matematicas',
          partidas: 2,
          porcentajeAciertos: 85,
          puntos: 240,
        ),
        ResumenMateria(
          asignaturaId: 2,
          nombre: 'Lenguaje',
          partidas: 1,
          porcentajeAciertos: 70.5,
          puntos: 100,
        ),
      ],
    );

    testWidgets(
      'cada estudiante muestra sus cifras y, al abrirlo, el detalle por materia',
      (t) async {
        final docente = FalsoDocente(
          aulas: [_aula],
          estudiantes: {
            'a1': [ana],
          },
        );
        await abrirApp(t, docente: docente);
        await entrarComoDocente(t);

        expect(
          find.textContaining('340 puntos · 80 % aciertos · 3 partidas'),
          findsOneWidget,
        );
        await t.ensureVisible(find.text('Ana'));
        await t.tap(find.text('Ana'));
        await t.pumpAndSettle();
        expect(
          find.textContaining(
            'Matemáticas: 2 partidas · 85 % aciertos · 240 puntos',
          ),
          findsOneWidget,
        );
        expect(
          find.textContaining(
            'Comunicación y Lenguaje: 1 partidas · 70.5 % aciertos · 100 puntos',
          ),
          findsOneWidget,
        );
        expect(find.text('CAMBIAR CONTRASEÑA'), findsOneWidget);
      },
    );

    testWidgets(
      'cambiar la contraseña emite un código nuevo para ese estudiante',
      (t) async {
        final docente = FalsoDocente(
          aulas: [_aula],
          estudiantes: {
            'a1': [ana],
          },
        );
        await abrirApp(t, docente: docente);
        await entrarComoDocente(t);

        await t.ensureVisible(find.text('Ana'));
        await t.tap(find.text('Ana'));
        await t.pumpAndSettle();
        await t.ensureVisible(find.text('CAMBIAR CONTRASEÑA'));
        await t.tap(find.text('CAMBIAR CONTRASEÑA'));
        await t.pumpAndSettle();
        expect(docente.codigosNuevos, 1);
        expect(find.text('NUEVO9876'), findsOneWidget);
      },
    );

    testWidgets(
      'el ranking se pide al servidor y muestra posiciones y puntos',
      (t) async {
        final docente = FalsoDocente(aulas: [_aula])
          ..filasRanking = const [
            FilaRanking(
              posicion: 1,
              nombreMostrar: 'Ana',
              nombreUsuario: 'ana',
              aulas: ['5.º A'],
              puntos: 340,
              partidas: 3,
              porcentajeAciertos: 80,
            ),
            FilaRanking(
              posicion: 2,
              nombreMostrar: 'Beto',
              nombreUsuario: 'beto',
              aulas: ['5.º A', '6.º B'],
              puntos: 120,
              partidas: 1,
              porcentajeAciertos: 70,
            ),
          ];
        await abrirApp(t, docente: docente);
        await entrarComoDocente(t);

        expect(docente.consultasRanking.first, (
          null,
          null,
        )); // sin filtros: todas mis aulas y materias
        await t.ensureVisible(find.text('Ranking de estudiantes'));
        expect(find.text('Ranking de estudiantes'), findsOneWidget);
        expect(find.text('340'), findsOneWidget);
        expect(find.textContaining('5.º A, 6.º B'), findsOneWidget);
      },
    );

    testWidgets(
      'filtrar por materia y por aula vuelve a pedir el ranking con esos filtros',
      (t) async {
        final docente = FalsoDocente(aulas: [_aula]);
        await abrirApp(t, docente: docente);
        await entrarComoDocente(t);

        await t.ensureVisible(find.text('Ranking de estudiantes'));
        await t.tap(find.text('Todas las materias'));
        await t.pumpAndSettle();
        await t.tap(find.text('Matemáticas').last);
        await t.pumpAndSettle();
        expect(docente.consultasRanking.last.$2, 1);

        await t.tap(find.text('Todas mis aulas'));
        await t.pumpAndSettle();
        await t.tap(find.text('5.º A').last);
        await t.pumpAndSettle();
        expect(docente.consultasRanking.last, ('a1', 1));
      },
    );

    testWidgets('sin estudiantes el ranking lo explica', (t) async {
      await abrirApp(t, docente: FalsoDocente(aulas: [_aula]));
      await entrarComoDocente(t);
      await t.ensureVisible(find.text('Ranking de estudiantes'));
      expect(
        find.textContaining('Todavía no hay estudiantes para mostrar'),
        findsOneWidget,
      );
    });
  });

  group('activar cuenta con el código del docente', () {
    testWidgets('el estudiante elige su contraseña y vuelve a iniciar sesión', (
      t,
    ) async {
      final app = await abrirApp(t);
      await t.tap(find.text('INICIAR SESIÓN'));
      await t.pumpAndSettle();
      await t.ensureVisible(find.text('Tengo un código de mi docente'));
      await t.tap(find.text('Tengo un código de mi docente'));
      await t.pumpAndSettle();

      final campos = find.byType(TextField);
      await t.enterText(campos.at(0), 'beto.2');
      await t.enterText(campos.at(1), 'abcd2345');
      await t.enterText(campos.at(2), 'clave-nueva-1');
      await t.tap(find.text('GUARDAR'));
      await t.pumpAndSettle();

      expect(app.acceso.ultimoCodigoActivacion, 'abcd2345');
      expect(find.text('ENTRAR'), findsOneWidget);
    });

    testWidgets('un código vencido se explica sin culpar al niño', (t) async {
      final acceso = FalsoAcceso()
        ..errorActivacion = const ExcepcionApi(
          'x',
          estado: 400,
          codigo: 'codigo_invalido',
        );
      await abrirApp(t, acceso: acceso);
      await t.tap(find.text('INICIAR SESIÓN'));
      await t.pumpAndSettle();
      await t.ensureVisible(find.text('Tengo un código de mi docente'));
      await t.tap(find.text('Tengo un código de mi docente'));
      await t.pumpAndSettle();

      final campos = find.byType(TextField);
      await t.enterText(campos.at(0), 'beto.2');
      await t.enterText(campos.at(1), 'XXXX');
      await t.enterText(campos.at(2), 'clave-nueva-1');
      await t.tap(find.text('GUARDAR'));
      await t.pumpAndSettle();

      expect(
        find.textContaining('Pídele uno nuevo a tu docente'),
        findsOneWidget,
      );
    });
  });
}
