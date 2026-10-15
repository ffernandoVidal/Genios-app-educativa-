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
      expect(find.text('Usuario: ana.luz'), findsOneWidget);
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
        expect(find.text('Estudiantes (1)'), findsOneWidget);
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

      await t.ensureVisible(find.text('Nuevo código'));
      await t.tap(find.text('Nuevo código'));
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
