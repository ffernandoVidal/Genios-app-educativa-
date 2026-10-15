import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genios_app/core/sesion/sesion_app.dart';
import 'package:go_router/go_router.dart';

import '../soporte/abrir_app.dart';

/// Auditoría de redirecciones: para cada tipo de sesión, a dónde termina cada ruta.
Future<String> destino(WidgetTester t, String ruta) async {
  final enrutador = GoRouter.of(t.element(find.byType(Scaffold).first));
  enrutador.go(ruta);
  await t.pumpAndSettle();
  return enrutador.routeInformationProvider.value.uri.path;
}

const privadas = [
  '/cabina',
  '/materias',
  '/materia/1',
  '/mision/1',
  '/perfil',
  '/salon',
  '/ajustes',
];

void main() {
  group('sin sesión', () {
    testWidgets(
      'las rutas públicas se abren y las privadas devuelven a la bienvenida',
      (t) async {
        await abrirApp(t);
        for (final ruta in [
          '/',
          '/jugar',
          '/ingresar',
          '/registro',
          '/activar',
          '/docente',
        ]) {
          expect(await destino(t, ruta), ruta, reason: ruta);
        }
        for (final ruta in privadas) {
          expect(await destino(t, ruta), '/', reason: ruta);
        }
      },
    );

    testWidgets('las rutas con id inválido no rompen la app', (t) async {
      final app = await abrirApp(t);
      app.sesion.iniciarInvitado(nombre: 'Luna');
      await t.pumpAndSettle();
      expect(await destino(t, '/materia/abc'), '/materias');
      expect(await destino(t, '/mision/xyz'), '/materias');
    });
  });

  group('invitado', () {
    testWidgets(
      'entra a la cabina; el acceso y la bienvenida lo devuelven a la cabina; puede crear cuenta',
      (t) async {
        final app = await abrirApp(t);
        app.sesion.iniciarInvitado(nombre: 'Luna');
        await t.pumpAndSettle();
        expect(await destino(t, '/'), '/cabina');
        expect(await destino(t, '/jugar'), '/cabina');
        expect(await destino(t, '/ingresar'), '/cabina');
        expect(await destino(t, '/registro'), '/registro');
        for (final ruta in privadas) {
          expect(await destino(t, ruta), ruta, reason: ruta);
        }
      },
    );

    testWidgets('no puede quedarse en la pantalla docente', (t) async {
      final app = await abrirApp(t);
      app.sesion.iniciarInvitado(nombre: 'Luna');
      await t.pumpAndSettle();
      expect(await destino(t, '/docente'), '/cabina');
    });
  });

  group('estudiante con cuenta', () {
    testWidgets(
      'no vuelve a registro ni a la bienvenida; ve todo el recorrido; no ve lo docente',
      (t) async {
        final app = await abrirApp(t);
        app.sesion.iniciarCuenta(
          tokenAcceso: 'T',
          roles: ['estudiante'],
          nombre: 'Ana',
        );
        await t.pumpAndSettle();
        for (final ruta in [
          '/',
          '/jugar',
          '/ingresar',
          '/registro',
          '/docente',
        ]) {
          expect(await destino(t, ruta), '/cabina', reason: ruta);
        }
        for (final ruta in privadas) {
          expect(await destino(t, ruta), ruta, reason: ruta);
        }
      },
    );
  });

  group('docente', () {
    testWidgets(
      'solo ve su panel: ninguna ruta infantil ni de acceso lo saca de allí',
      (t) async {
        final app = await abrirApp(t);
        app.sesion.iniciarCuenta(
          tokenAcceso: 'T',
          roles: ['docente'],
          nombre: 'Profe',
        );
        await t.pumpAndSettle();
        expect(app.sesion.modo, ModoSesion.docente);
        for (final ruta in [
          '/',
          '/jugar',
          '/ingresar',
          '/registro',
          '/activar',
          '/cabina',
          ...privadas,
        ]) {
          expect(await destino(t, ruta), '/docente/inicio', reason: ruta);
        }
      },
    );
  });

  group('Centro de Control Docente', () {
    const rutasDocente = [
      '/docente/inicio',
      '/docente/clases',
      '/docente/clases/nueva',
      '/docente/clases/a1',
      '/docente/alumnos',
      '/docente/alumnos/nuevo',
      '/docente/alumnos/e1',
      '/docente/estadisticas',
      '/docente/ajustes',
    ];

    testWidgets('sin sesión pide el acceso docente', (t) async {
      await abrirApp(t);
      for (final ruta in rutasDocente) {
        expect(await destino(t, ruta), '/docente', reason: ruta);
      }
    });

    testWidgets('un estudiante o invitado no entra al Centro de Control', (
      t,
    ) async {
      final app = await abrirApp(t);
      app.sesion.iniciarCuenta(
        tokenAcceso: 'T',
        roles: ['estudiante'],
        nombre: 'Ana',
      );
      await t.pumpAndSettle();
      for (final ruta in rutasDocente) {
        expect(await destino(t, ruta), '/cabina', reason: ruta);
      }
    });

    testWidgets('el docente llega a todas sus secciones', (t) async {
      final app = await abrirApp(t);
      app.sesion.iniciarCuenta(
        tokenAcceso: 'T',
        roles: ['docente'],
        nombre: 'Profe',
      );
      await t.pumpAndSettle();
      for (final ruta in rutasDocente) {
        expect(await destino(t, ruta), ruta, reason: ruta);
      }
    });
  });

  group('cerrar sesión', () {
    testWidgets(
      'al cerrar la sesión desde una pantalla privada se vuelve a la bienvenida',
      (t) async {
        final app = await abrirApp(t);
        app.sesion.iniciarInvitado(nombre: 'Luna');
        await t.pumpAndSettle();
        expect(await destino(t, '/ajustes'), '/ajustes');
        app.sesion.cerrar();
        await t.pumpAndSettle();
        final enrutador = GoRouter.of(t.element(find.byType(Scaffold).first));
        expect(enrutador.routeInformationProvider.value.uri.path, '/');
      },
    );
  });
}
