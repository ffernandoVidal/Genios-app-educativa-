import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genios_app/app/app.dart';
import 'package:genios_app/core/ajustes/ajustes_app.dart';
import 'package:genios_app/core/sesion/sesion_app.dart';

import 'repositorios_falsos.dart';

/// Todo lo que una prueba de pantalla necesita para inspeccionar la app abierta.
class AppAbierta {
  AppAbierta({
    required this.sesion,
    required this.acceso,
    required this.catalogo,
    required this.partida,
    required this.progreso,
    required this.salon,
    required this.ajustes,
  });

  final SesionApp sesion;
  final FalsoAcceso acceso;
  final FalsoCatalogo catalogo;
  final FalsoPartida partida;
  final FalsoProgreso progreso;
  final FalsoSalon salon;
  final AjustesApp ajustes;
}

/// Abre GENIOS con repositorios falsos. Las animaciones decorativas se apagan por defecto para poder usar
/// `pumpAndSettle` (el astronauta flota sin parar); las pruebas de animación las activan explícitamente.
Future<AppAbierta> abrirApp(
  WidgetTester t, {
  FalsoAcceso? acceso,
  FalsoCatalogo? catalogo,
  FalsoPartida? partida,
  FalsoProgreso? progreso,
  FalsoSalon? salon,
  SesionApp? sesion,
  AjustesApp? ajustes,
  Size? tamano,
}) async {
  t.view.devicePixelRatio = 1.0;
  t.view.physicalSize = tamano ?? const Size(1000, 1800);
  addTearDown(t.view.reset);

  final app = AppAbierta(
    sesion: sesion ?? SesionApp(),
    acceso: acceso ?? FalsoAcceso(),
    catalogo: catalogo ?? FalsoCatalogo(mapas: {1: mapaDeMatematicas()}),
    partida: partida ?? FalsoPartida(),
    progreso: progreso ?? FalsoProgreso(),
    salon: salon ?? FalsoSalon(),
    ajustes: ajustes ?? AjustesApp(animaciones: false),
  );
  await t.pumpWidget(
    AppGenios(
      sesion: app.sesion,
      repositorioAcceso: app.acceso,
      repositorioCatalogo: app.catalogo,
      repositorioPartida: app.partida,
      repositorioProgreso: app.progreso,
      repositorioSalon: app.salon,
      ajustes: app.ajustes,
    ),
  );
  await t.pumpAndSettle();
  return app;
}

/// Bienvenida → JUGAR → nombre → cabina.
Future<void> entrarComoInvitado(WidgetTester t, {String apodo = 'Luna'}) async {
  await t.tap(find.text('JUGAR'));
  await t.pumpAndSettle();
  await t.enterText(find.byType(TextField), apodo);
  await t.tap(find.text('¡DESPEGAR!'));
  await t.pumpAndSettle();
}

/// Bienvenida → INICIAR SESIÓN → credenciales → cabina.
Future<void> entrarComoEstudiante(WidgetTester t) async {
  await t.tap(find.text('INICIAR SESIÓN'));
  await t.pumpAndSettle();
  await t.enterText(find.byType(TextField).first, 'ana.luz');
  await t.enterText(find.byType(TextField).last, 'clave123');
  await t.tap(find.text('ENTRAR'));
  await t.pumpAndSettle();
}

/// Desde la cabina: JUGAR → materia por su nombre visible.
Future<void> irAMaterias(WidgetTester t) async {
  await t.tap(find.text('JUGAR'));
  await t.pumpAndSettle();
}

Future<void> irAMisiones(WidgetTester t, String materia) async {
  await irAMaterias(t);
  await t.tap(find.text(materia));
  await t.pumpAndSettle();
}
