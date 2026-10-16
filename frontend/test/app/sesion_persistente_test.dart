import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:genios_app/core/red/excepcion_api.dart';
import 'package:genios_app/core/sesion/sesion_app.dart';
import 'package:genios_app/features/acceso/dominio/repositorio_acceso.dart';
import 'package:genios_app/features/acceso/presentacion/acceso_cubit.dart';

import '../soporte/abrir_app.dart';
import '../soporte/repositorios_falsos.dart';

/// Falso cuya renovación se queda esperando hasta que la prueba la libere (para ver la pantalla de carga).
class _AccesoLento extends FalsoAcceso {
  final liberar = Completer<void>();

  @override
  Future<ResultadoAcceso?> renovarSesion() async {
    await liberar.future;
    return super.renovarSesion();
  }
}

const _estudiante = ResultadoAcceso(
  tokenAcceso: 'T-EST',
  roles: ['estudiante'],
  nombreMostrar: 'Ana',
);
const _docente = ResultadoAcceso(
  tokenAcceso: 'T-DOC',
  roles: ['docente'],
  nombreMostrar: 'Profe Rosa',
);

void main() {
  group('restauración de la sesión al abrir', () {
    testWidgets(
      'mientras se recupera se ve la carga y nunca una pantalla de estudiante',
      (t) async {
        final acceso = _AccesoLento()..cuentaRecuperable = _estudiante;
        await abrirApp(
          t,
          acceso: acceso,
          restaurarAlIniciar: true,
          esperar: false,
        );
        expect(find.text('Abriendo GENIOS…'), findsOneWidget);
        expect(find.text('JUGAR'), findsNothing);

        acceso.liberar.complete();
        await t.pumpAndSettle();
        expect(find.text('Abriendo GENIOS…'), findsNothing);
      },
    );

    testWidgets('un estudiante con sesión vigente vuelve a su cabina', (
      t,
    ) async {
      final acceso = FalsoAcceso()..cuentaRecuperable = _estudiante;
      final app = await abrirApp(t, acceso: acceso, restaurarAlIniciar: true);
      expect(acceso.renovaciones, 1);
      expect(app.sesion.modo, ModoSesion.estudiante);
      expect(app.sesion.tokenAcceso, 'T-EST');
      expect(find.text('INICIAR SESIÓN'), findsNothing);
      expect(find.textContaining('Ana'), findsWidgets);
    });

    testWidgets('el rol lo decide el perfil del servidor, no la renovación', (
      t,
    ) async {
      final acceso = FalsoAcceso()
        ..cuentaRecuperable = _estudiante
        ..rolesPerfil = ['docente'];
      final app = await abrirApp(t, acceso: acceso, restaurarAlIniciar: true);
      expect(app.sesion.modo, ModoSesion.docente);
    });

    testWidgets(
      'un docente vuelve a su panel y no ve la experiencia infantil',
      (t) async {
        final acceso = FalsoAcceso()..cuentaRecuperable = _docente;
        final app = await abrirApp(t, acceso: acceso, restaurarAlIniciar: true);
        expect(app.sesion.modo, ModoSesion.docente);
        expect(find.text('Inicio'), findsWidgets);
        expect(find.text('JUGAR'), findsNothing);
      },
    );

    testWidgets('un invitado con cookie vigente vuelve a la cabina', (t) async {
      final acceso = FalsoAcceso()..invitadoVigente = true;
      final app = await abrirApp(t, acceso: acceso, restaurarAlIniciar: true);
      expect(app.sesion.modo, ModoSesion.invitado);
      expect(find.text('INICIAR SESIÓN'), findsNothing);
    });

    testWidgets('sin ninguna sesión se muestra la bienvenida', (t) async {
      final app = await abrirApp(t, restaurarAlIniciar: true);
      expect(app.sesion.activa, isFalse);
      expect(find.text('JUGAR'), findsOneWidget);
      expect(find.text('INICIAR SESIÓN'), findsOneWidget);
    });

    testWidgets(
      'sin conexión no se pierde la sesión: se ofrece reintentar y al volver la red entra',
      (t) async {
        final acceso = FalsoAcceso()
          ..cuentaRecuperable = _estudiante
          ..errorRestauracion = const ExcepcionApi.sinConexion();
        final app = await abrirApp(t, acceso: acceso, restaurarAlIniciar: true);

        expect(app.sesion.restauracion, EstadoRestauracion.error);
        expect(find.text('Reintentar'), findsOneWidget);
        expect(find.text('JUGAR'), findsNothing);

        acceso.errorRestauracion = null;
        await t.tap(find.text('Reintentar'));
        await t.pumpAndSettle();

        expect(acceso.renovaciones, 2);
        expect(app.sesion.modo, ModoSesion.estudiante);
      },
    );
  });

  group('confirmación del rol docente', () {
    Future<AppAbierta> abrirPendiente(WidgetTester t) async {
      final acceso = FalsoAcceso()..rolesGoogle = const [];
      final app = await abrirApp(t, acceso: acceso);
      await t.tap(find.text('INICIAR SESIÓN'));
      await t.pumpAndSettle();
      await t.tap(find.text('Soy docente'));
      await t.pumpAndSettle();
      await t.tap(find.text('CONTINUAR CON GOOGLE'));
      await t.pumpAndSettle();
      return app;
    }

    testWidgets(
      'una identidad nueva ve la confirmación y no entra al panel sin confirmar',
      (t) async {
        final app = await abrirPendiente(t);
        expect(app.sesion.modo, ModoSesion.docentePendiente);
        expect(find.text('¿Eres docente?'), findsOneWidget);
        expect(find.text('Inicio'), findsNothing);
      },
    );

    testWidgets('confirmar pide el rol al servidor y lleva al panel docente', (
      t,
    ) async {
      final app = await abrirPendiente(t);
      await t.tap(find.text('SÍ, SOY DOCENTE'));
      await t.pumpAndSettle();

      expect(app.acceso.confirmacionesDocente, 1);
      expect(app.sesion.modo, ModoSesion.docente);
      expect(app.sesion.tokenAcceso, 'TOKEN-DOCENTE');
      expect(find.text('¿Eres docente?'), findsNothing);
    });

    testWidgets('cancelar cierra la sesión y vuelve al acceso docente', (
      t,
    ) async {
      final app = await abrirPendiente(t);
      await t.tap(find.text('CANCELAR'));
      await t.pumpAndSettle();

      expect(app.acceso.cierres, 1);
      expect(app.sesion.activa, isFalse);
      expect(find.text('¿Eres docente?'), findsNothing);
      expect(find.text('Acceso docente'), findsOneWidget);
    });

    testWidgets('si el servidor lo rechaza, se explica y no se cambia de rol', (
      t,
    ) async {
      final acceso = FalsoAcceso()..rolesGoogle = const [];
      acceso.errorConfirmar = const ExcepcionApi(
        'No',
        estado: 403,
        codigo: 'rol_no_permitido',
      );
      final app = await abrirApp(t, acceso: acceso);
      await t.tap(find.text('INICIAR SESIÓN'));
      await t.pumpAndSettle();
      await t.tap(find.text('Soy docente'));
      await t.pumpAndSettle();
      await t.tap(find.text('CONTINUAR CON GOOGLE'));
      await t.pumpAndSettle();
      await t.tap(find.text('SÍ, SOY DOCENTE'));
      await t.pumpAndSettle();

      expect(app.sesion.modo, ModoSesion.docentePendiente);
      expect(
        find.text('Esta cuenta ya tiene un rol y no puede ser de docente.'),
        findsOneWidget,
      );
    });
  });

  group('cierre de sesión', () {
    test(
      'se llama al servidor siempre (también como invitado) y es idempotente',
      () async {
        final acceso = FalsoAcceso();
        final sesion = SesionApp()..iniciarInvitado(nombre: 'Luna');
        final cubit = AccesoCubit(acceso, sesion);

        await cubit.salir();
        await cubit.salir();

        expect(acceso.cierres, 2);
        expect(sesion.activa, isFalse);
        expect(sesion.tokenAcceso, isNull);
      },
    );

    test('si el servidor no responde, igual se sale y el token en memoria se borra', () async {
      final sesion = SesionApp()
        ..iniciarCuenta(tokenAcceso: 'T', roles: ['estudiante'], nombre: 'Ana');
      final cubit = AccesoCubit(_AccesoCierreFallido(), sesion);

      await cubit.salir();

      expect(sesion.activa, isFalse);
      expect(sesion.tokenAcceso, isNull);
    });
  });
}

class _AccesoCierreFallido extends FalsoAcceso {
  @override
  Future<void> cerrarSesion() async => throw const ExcepcionApi.sinConexion();
}
