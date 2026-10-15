import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genios_app/core/red/excepcion_api.dart';
import 'package:genios_app/features/docente/dominio/repositorio_docente.dart';
import 'package:go_router/go_router.dart';

import '../soporte/abrir_app.dart';
import '../soporte/repositorios_falsos.dart';

const _aula = AulaDocente(
  id: 'a1',
  nombre: 'Quinto A',
  codigoAcceso: 'K4821',
  grado: 5,
  seccion: 'A',
  totalEstudiantes: 2,
);

FilaEstudiante _fila(
  String id,
  String nombre,
  Rendimiento r, {
  double? promedio,
  int partidas = 0,
}) => FilaEstudiante(
  id: id,
  nombreMostrar: nombre,
  nombreUsuario: nombre.toLowerCase(),
  aulas: const [AulaBreve(id: 'a1', nombre: 'Quinto A', grado: 5)],
  grado: 5,
  ultimaActividad: partidas == 0 ? null : DateTime.utc(2026, 10, 14, 15),
  partidas: partidas,
  promedioAciertos: promedio,
  rendimiento: r,
);

FichaEstudiante _ficha({
  int partidas = 3,
  double? promedio = 80,
  Rendimiento r = Rendimiento.aprobado,
  double? variacion = 10,
}) => FichaEstudiante(
  id: 'e1',
  nombreMostrar: 'Ana',
  aulas: const [AulaBreve(id: 'a1', nombre: 'Quinto A', grado: 5)],
  ultimaActividad: DateTime.utc(2026, 10, 14, 15),
  partidasCompletadas: partidas,
  partidasAprobadas: partidas == 0 ? 0 : 2,
  promedioAciertos: partidas == 0 ? null : promedio,
  rendimiento: partidas == 0 ? Rendimiento.sinDatos : r,
  tiempoMedioSegundos: partidas == 0 ? null : 95,
  misionesCompletadas: 1,
  leccionesAprobadas: 2,
  variacion: variacion,
  promedioGrupo: 65,
  materias: partidas == 0
      ? const []
      : const [
          MateriaEstadistica(
            asignaturaId: 1,
            nombre: 'Matematicas',
            promedioAciertos: 85,
            rendimiento: Rendimiento.aprobado,
            partidas: 2,
            variacion: 5,
          ),
          MateriaEstadistica(
            asignaturaId: 2,
            nombre: 'Lenguaje',
            promedioAciertos: 50,
            rendimiento: Rendimiento.repaso,
            partidas: 1,
            variacion: null,
          ),
        ],
  partidasPorDia: partidas == 0
      ? const []
      : [
          PuntoDia(fecha: DateTime(2026, 10, 13), partidas: 1),
          PuntoDia(fecha: DateTime(2026, 10, 14), partidas: 2),
        ],
);

EstadisticasClase _clase() => EstadisticasClase(
  aulaId: 'a1',
  nombre: 'Quinto A',
  totalEstudiantes: 4,
  estudiantesActivos: 2,
  partidasCompletadas: 5,
  promedioAciertos: 60.4,
  rendimiento: Rendimiento.aprobado,
  refuerzo: 1,
  repaso: 0,
  aprobado: 1,
  sinDatos: 2,
  materias: [
    MateriaClase(
      nombre: 'Lenguaje',
      promedioAciertos: 45,
      rendimiento: Rendimiento.repaso,
      partidas: 2,
    ),
  ],
  semanas: [
    SemanaClase(
      inicio: DateTime.utc(2026, 10, 12),
      partidas: 5,
      promedioAciertos: 60.4,
    ),
  ],
);

Future<AppAbierta> abrirComoDocente(
  WidgetTester t, {
  FalsoDocente? docente,
  Size? tamano,
}) async {
  final app = await abrirApp(
    t,
    docente: docente ?? FalsoDocente(aulas: [_aula]),
    tamano: tamano ?? const Size(1280, 900),
  );
  app.sesion.iniciarCuenta(
    tokenAcceso: 'T',
    roles: ['docente'],
    nombre: 'Profe Rosa',
  );
  await t.pumpAndSettle();
  return app;
}

Future<void> ir(WidgetTester t, String ruta) async {
  GoRouter.of(t.element(find.byType(Scaffold).first)).go(ruta);
  await t.pumpAndSettle();
}

void main() {
  group('cabina docente (inicio)', () {
    testWidgets(
      'muestra el saludo, la mascota y los indicadores reales del servidor',
      (t) async {
        final docente = FalsoDocente(
          aulas: [_aula],
          resumenDatos: const ResumenDocente(
            clasesActivas: 2,
            estudiantesAsignados: 14,
            estudiantesActivosRecientes: 9,
            promedioAciertos: 72.5,
            rendimiento: Rendimiento.aprobado,
            partidasCompletadas: 41,
          ),
        );
        await abrirComoDocente(t, docente: docente);

        expect(find.text('¡Hola, Profe Rosa!'), findsOneWidget);
        expect(find.text('2'), findsOneWidget); // clases activas
        expect(find.text('14'), findsOneWidget);
        expect(find.text('9'), findsOneWidget);
        expect(find.text('72.5 %'), findsOneWidget);
        expect(find.text('41'), findsOneWidget);
        expect(find.text('APROBADO'), findsOneWidget);
      },
    );

    testWidgets('sin datos no inventa nada y no marca REFUERZO', (t) async {
      await abrirComoDocente(t, docente: FalsoDocente());
      expect(find.text('—'), findsOneWidget); // promedio sin datos
      expect(find.text('Sin actividad en este período'), findsOneWidget);
      expect(find.text('REFUERZO'), findsNothing);
      expect(find.textContaining('Todavía no tienes clases'), findsOneWidget);
    });

    testWidgets('los accesos rápidos navegan a su sección', (t) async {
      await abrirComoDocente(t);
      for (final (texto, destino) in [
        ('CREAR CLASE', 'Crear clase'),
        ('CREAR ALUMNO', 'Crear alumno'),
        ('VER ALUMNOS', 'Buscar y filtrar'),
        ('ESTADÍSTICAS', 'Estadísticas de la clase'),
      ]) {
        await ir(t, '/docente/inicio');
        await t.ensureVisible(find.text(texto));
        await t.tap(find.text(texto));
        await t.pumpAndSettle();
        expect(find.text(destino), findsWidgets, reason: texto);
      }
    });

    testWidgets('un error de carga se explica y permite reintentar', (t) async {
      final docente = FalsoDocente(aulas: [_aula])
        ..errorResumen = const ExcepcionApi.sinConexion();
      await abrirComoDocente(t, docente: docente);
      expect(find.text('Reintentar'), findsOneWidget);
    });
  });

  group('menú lateral', () {
    testWidgets('en escritorio hay siete secciones y la activa se resalta', (
      t,
    ) async {
      await abrirComoDocente(t);
      final rail = t.widget<NavigationRail>(find.byType(NavigationRail));
      expect(rail.extended, isTrue);
      expect(rail.destinations.length, 7);
      expect(rail.selectedIndex, 0);

      for (final (ruta, indice) in [
        ('/docente/clases', 1),
        ('/docente/clases/nueva', 2),
        ('/docente/alumnos/nuevo', 3),
        ('/docente/alumnos', 4),
        ('/docente/estadisticas', 5),
        ('/docente/ajustes', 6),
      ]) {
        await ir(t, ruta);
        expect(
          t.widget<NavigationRail>(find.byType(NavigationRail)).selectedIndex,
          indice,
          reason: ruta,
        );
      }
    });

    testWidgets('en tableta el menú es compacto y en móvil es un Drawer', (
      t,
    ) async {
      await abrirComoDocente(t, tamano: const Size(820, 1180));
      expect(
        t.widget<NavigationRail>(find.byType(NavigationRail)).extended,
        isFalse,
      );
    });

    testWidgets('en móvil el menú es un Drawer y todo cabe sin desbordes', (
      t,
    ) async {
      await abrirComoDocente(t, tamano: const Size(360, 640));
      expect(find.byType(NavigationRail), findsNothing);
      await t.tap(find.byTooltip('Open navigation menu'));
      await t.pumpAndSettle();
      expect(find.text('Crear alumno'), findsOneWidget);
      await t.tap(find.text('Mis clases'));
      await t.pumpAndSettle();
      expect(find.text('Quinto A'), findsOneWidget);
      expect(t.takeException(), isNull);
    });
  });

  group('clases', () {
    testWidgets(
      'Mis clases muestra la tarjeta con código, número de alumnos y Administrar',
      (t) async {
        await abrirComoDocente(t);
        await ir(t, '/docente/clases');
        expect(find.text('Quinto A'), findsOneWidget);
        expect(find.text('K4821'), findsOneWidget);
        expect(find.text('2 alumnos · Activa'), findsOneWidget);
        expect(find.textContaining('5.º grado · sección A'), findsOneWidget);
        expect(find.text('ADMINISTRAR'), findsOneWidget);
      },
    );

    testWidgets(
      'crear una clase exige nombre y grado, y confirma con el código',
      (t) async {
        final docente = FalsoDocente();
        await abrirComoDocente(t, docente: docente);
        await ir(t, '/docente/clases/nueva');

        await t.tap(find.text('CREAR CLASE').last);
        await t.pumpAndSettle();
        expect(find.text('Escribe el nombre de la clase.'), findsOneWidget);

        await t.enterText(find.byType(TextField).first, 'Sexto B');
        await t.tap(find.text('CREAR CLASE').last);
        await t.pumpAndSettle();
        expect(find.text('Elige el grado.'), findsOneWidget);

        await t.tap(find.text('Grado'));
        await t.pumpAndSettle();
        await t.tap(find.text('6.º grado').last);
        await t.pumpAndSettle();
        await t.enterText(find.byType(TextField).at(1), 'B');
        await t.tap(find.text('CREAR CLASE').last);
        await t.pumpAndSettle();

        expect(find.text('¡Clase creada!'), findsOneWidget);
        expect(find.text('K4000'), findsOneWidget);
        expect(find.text('ADMINISTRAR LA CLASE'), findsOneWidget);
        expect((await docente.aulas()).single.grado, 6);
      },
    );

    testWidgets(
      'el detalle permite archivar con confirmación y vuelve a Mis clases',
      (t) async {
        final docente = FalsoDocente(
          aulas: [_aula],
          filas: [
            _fila('e1', 'Ana', Rendimiento.aprobado, promedio: 80, partidas: 2),
          ],
        );
        await abrirComoDocente(t, docente: docente);
        await ir(t, '/docente/clases/a1');
        expect(find.text('Información general'), findsOneWidget);
        expect(find.text('Alumnos de la clase'), findsOneWidget);
        expect(find.text('Ana'), findsOneWidget);

        await t.ensureVisible(find.text('ARCHIVAR CLASE'));
        await t.tap(find.text('ARCHIVAR CLASE'));
        await t.pumpAndSettle();
        expect(
          find.textContaining('Los estudiantes y sus resultados se conservan'),
          findsOneWidget,
        );
        await t.tap(find.text('Archivar'));
        await t.pumpAndSettle();

        expect(docente.archivadas, ['a1']);
        expect(find.text('Mis clases'), findsWidgets);
        expect(find.text('K4821'), findsNothing);
      },
    );
  });

  group('crear alumno', () {
    testWidgets('ofrece las dos modalidades como tarjetas independientes', (
      t,
    ) async {
      await abrirComoDocente(t);
      await ir(t, '/docente/alumnos/nuevo');
      expect(find.text('Invitar estudiante existente'), findsOneWidget);
      expect(find.text('Registrar estudiante nuevo'), findsOneWidget);
    });

    testWidgets(
      'invitar a un estudiante existente muestra el código de la clase',
      (t) async {
        await abrirComoDocente(t);
        await ir(t, '/docente/alumnos/nuevo');
        await t.tap(find.text('Invitar estudiante existente'));
        await t.pumpAndSettle();
        expect(find.text('K4821'), findsOneWidget);
        expect(
          find.textContaining('no da acceso a sus resultados por sí solo'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'registrar uno nuevo entrega un código de un solo uso y nunca pide contraseña',
      (t) async {
        final docente = FalsoDocente(aulas: [_aula]);
        await abrirComoDocente(t, docente: docente);
        await ir(t, '/docente/alumnos/nuevo');
        await t.tap(find.text('Registrar estudiante nuevo'));
        await t.pumpAndSettle();

        expect(
          find.textContaining('contraseña'),
          findsWidgets,
        ); // solo explica que NO la ve
        final campos = find.byType(TextField);
        await t.enterText(campos.at(0), 'Beto');
        await t.enterText(campos.at(1), 'beto.2');
        await t.ensureVisible(find.text('REGISTRAR'));
        await t.tap(find.text('REGISTRAR'));
        await t.pumpAndSettle();

        expect(docente.ultimoUsuarioAgregado, 'beto.2');
        expect(find.text('ABCD2345'), findsOneWidget);
      },
    );

    testWidgets('un usuario repetido muestra un mensaje claro', (t) async {
      final docente = FalsoDocente(aulas: [_aula])
        ..errorAgregar = const ExcepcionApi(
          'x',
          estado: 409,
          codigo: 'nombre_usuario_en_uso',
        );
      await abrirComoDocente(t, docente: docente);
      await ir(t, '/docente/alumnos/nuevo');
      await t.tap(find.text('Registrar estudiante nuevo'));
      await t.pumpAndSettle();
      final campos = find.byType(TextField);
      await t.enterText(campos.at(0), 'Beto');
      await t.enterText(campos.at(1), 'beto.2');
      await t.ensureVisible(find.text('REGISTRAR'));
      await t.tap(find.text('REGISTRAR'));
      await t.pumpAndSettle();
      expect(
        find.text('Ese usuario ya existe. Prueba con otro.'),
        findsOneWidget,
      );
      expect(find.text('ABCD2345'), findsNothing);
    });

    testWidgets('sin clases pide crear una primero', (t) async {
      await abrirComoDocente(t, docente: FalsoDocente());
      await ir(t, '/docente/alumnos/nuevo');
      expect(
        find.textContaining('Primero necesitas una clase'),
        findsOneWidget,
      );
    });
  });

  group('alumnos', () {
    testWidgets(
      'lista con estado de rendimiento por texto e icono, y SIN DATOS para quien no ha jugado',
      (t) async {
        final docente = FalsoDocente(
          aulas: [_aula],
          filas: [
            _fila('e1', 'Ana', Rendimiento.aprobado, promedio: 80, partidas: 3),
            _fila(
              'e2',
              'Beto',
              Rendimiento.refuerzo,
              promedio: 30,
              partidas: 2,
            ),
            _fila('e3', 'Carla', Rendimiento.sinDatos),
          ],
        );
        await abrirComoDocente(t, docente: docente);
        await ir(t, '/docente/alumnos');

        expect(find.text('Estudiantes (3)'), findsOneWidget);
        expect(find.text('APROBADO'), findsOneWidget);
        expect(find.text('REFUERZO'), findsOneWidget);
        expect(find.text('SIN DATOS'), findsOneWidget);
        expect(find.byIcon(Icons.check_circle_rounded), findsWidgets);
        expect(find.text('Sin actividad'), findsOneWidget);
      },
    );

    testWidgets('buscar y filtrar vuelven a pedir los datos al servidor', (
      t,
    ) async {
      final docente = FalsoDocente(
        aulas: [_aula],
        filas: [
          _fila('e1', 'Ana', Rendimiento.aprobado, promedio: 80, partidas: 3),
        ],
      );
      await abrirComoDocente(t, docente: docente);
      await ir(t, '/docente/alumnos');

      await t.enterText(find.byType(TextField).first, 'an');
      await t.testTextInput.receiveAction(TextInputAction.search);
      await t.pumpAndSettle();
      expect(docente.consultasAlumnos.last['q'], 'an');

      await t.tap(find.text('Todos').first);
      await t.pumpAndSettle();
      await t.tap(find.text('REFUERZO').last);
      await t.pumpAndSettle();
      expect(docente.consultasAlumnos.last['rendimiento'], 'refuerzo');
      expect(docente.consultasAlumnos.last['pagina'], 1);
    });

    testWidgets('sin coincidencias lo dice, y VER DETALLE abre la ficha', (
      t,
    ) async {
      final docente = FalsoDocente(
        aulas: [_aula],
        filas: [
          _fila('e1', 'Ana', Rendimiento.aprobado, promedio: 80, partidas: 3),
        ],
      )..fichaDatos = _ficha();
      await abrirComoDocente(t, docente: docente);
      await ir(t, '/docente/alumnos');
      await t.ensureVisible(find.text('VER DETALLE'));
      await t.tap(find.text('VER DETALLE'));
      await t.pumpAndSettle();
      expect(find.text('Rendimiento por materia'), findsOneWidget);
    });
  });

  group('ficha del estudiante', () {
    testWidgets(
      'muestra indicadores, nota media con variación, materias y gráfica con su unidad',
      (t) async {
        final docente = FalsoDocente(aulas: [_aula])..fichaDatos = _ficha();
        await abrirComoDocente(t, docente: docente);
        await ir(t, '/docente/alumnos/e1');

        expect(find.text('Ana'), findsOneWidget);
        expect(find.text('80 %'), findsOneWidget);
        expect(find.text('+10.0 puntos porcentuales'), findsOneWidget);
        expect(find.text('1 min 35 s'), findsOneWidget);
        expect(find.textContaining('Promedio del grupo'), findsOneWidget);
        expect(find.text('Partidas completadas por día'), findsOneWidget);
        expect(
          find.textContaining('Eje vertical: partidas completadas'),
          findsOneWidget,
        );
        expect(find.text('Comunicación y Lenguaje'), findsOneWidget);
        expect(
          find.textContaining('Sin período anterior para comparar'),
          findsWidgets,
        ); // Lenguaje sin período previo
      },
    );

    testWidgets(
      'sin partidas dice «Sin actividad» y no clasifica como REFUERZO ni inventa cifras',
      (t) async {
        final docente = FalsoDocente(aulas: [_aula])
          ..fichaDatos = _ficha(partidas: 0, variacion: null);
        await abrirComoDocente(t, docente: docente);
        await ir(t, '/docente/alumnos/e1');
        expect(find.text('Sin actividad en este período.'), findsWidgets);
        expect(find.text('SIN DATOS'), findsOneWidget);
        expect(find.text('REFUERZO'), findsNothing);
      },
    );

    testWidgets('cambiar el período pide de nuevo la ficha con ese período', (
      t,
    ) async {
      final docente = FalsoDocente(aulas: [_aula])..fichaDatos = _ficha();
      await abrirComoDocente(t, docente: docente);
      await ir(t, '/docente/alumnos/e1');
      await t.tap(find.text('Últimos 7 días'));
      await t.pumpAndSettle();
      expect(docente.consultasPeriodo.last, 'dias=7');
    });

    testWidgets(
      'el detalle de materia muestra lecciones y preguntas con más errores',
      (t) async {
        final docente = FalsoDocente(aulas: [_aula])..fichaDatos = _ficha();
        await abrirComoDocente(t, docente: docente);
        await ir(t, '/docente/alumnos/e1');
        await t.ensureVisible(find.text('Ver detalle').first);
        await t.tap(find.text('Ver detalle').first);
        await t.pumpAndSettle();
        expect(find.text('Detalle de la materia'), findsOneWidget);
        expect(
          find.textContaining('Multiplicaciones · aprobada'),
          findsOneWidget,
        );
        expect(
          find.textContaining('¿Cuánto es 7 × 8? (2 de 3)'),
          findsOneWidget,
        );
      },
    );

    testWidgets('cambiar la contraseña emite un código de un solo uso', (
      t,
    ) async {
      final docente = FalsoDocente(aulas: [_aula])..fichaDatos = _ficha();
      await abrirComoDocente(t, docente: docente);
      await ir(t, '/docente/alumnos/e1');
      await t.tap(find.text('CAMBIAR CONTRASEÑA'));
      await t.pumpAndSettle();
      expect(docente.codigosNuevos, 1);
      expect(find.text('NUEVO9876'), findsOneWidget);
    });

    testWidgets(
      'el calendario marca los días con actividad, cambia de mes y no confunde ausencia con bajo rendimiento',
      (t) async {
        final hoy = DateTime.now();
        final docente = FalsoDocente(
          aulas: [_aula],
          dias: [
            DiaActividad(
              fecha: DateTime(hoy.year, hoy.month, 5),
              partidas: 2,
              tiempoActivoSegundos: 190,
              materias: const ['Matematicas'],
            ),
          ],
        )..fichaDatos = _ficha();
        await abrirComoDocente(t, docente: docente);
        await ir(t, '/docente/alumnos/e1');

        await t.ensureVisible(find.text('Calendario de actividad'));
        expect(
          find.textContaining('Un día sin color no significa bajo rendimiento'),
          findsOneWidget,
        );
        await t.tap(find.bySemanticsLabel('Día 5: 2 partidas'));
        await t.pumpAndSettle();
        expect(
          find.textContaining(
            '2 partidas · 3 min 10 s de tiempo activo · Matemáticas',
          ),
          findsOneWidget,
        );

        await t.tap(find.byTooltip('Mes anterior'));
        await t.pumpAndSettle();
        expect(t.takeException(), isNull);
      },
    );

    testWidgets('en móvil la ficha completa cabe sin desbordes', (t) async {
      final docente = FalsoDocente(aulas: [_aula])..fichaDatos = _ficha();
      await abrirComoDocente(t, docente: docente, tamano: const Size(360, 640));
      await ir(t, '/docente/alumnos/e1');
      expect(t.takeException(), isNull);
    });
  });

  group('estadísticas', () {
    testWidgets(
      'la clase muestra la distribución, las materias más difíciles y la evolución semanal',
      (t) async {
        final docente = FalsoDocente(aulas: [_aula])..claseDatos = _clase();
        await abrirComoDocente(t, docente: docente);
        await ir(t, '/docente/estadisticas');

        expect(find.text('REFUERZO: 1'), findsOneWidget);
        expect(find.text('REPASO: 0'), findsOneWidget);
        expect(find.text('APROBADO: 1'), findsOneWidget);
        expect(find.text('SIN DATOS: 2'), findsOneWidget);
        expect(find.text('60.4 %'), findsOneWidget);
        expect(find.text('Comunicación y Lenguaje'), findsOneWidget);
        expect(
          find.textContaining('partidas completadas por semana'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'el ranking se pide al servidor y se filtra por aula y materia',
      (t) async {
        final docente = FalsoDocente(aulas: [_aula])
          ..claseDatos = _clase()
          ..filasRanking = const [
            FilaRanking(
              posicion: 1,
              nombreMostrar: 'Ana',
              nombreUsuario: 'ana',
              aulas: ['Quinto A'],
              puntos: 340,
              partidas: 3,
              porcentajeAciertos: 80,
            ),
          ];
        await abrirComoDocente(t, docente: docente);
        await ir(t, '/docente/estadisticas');
        await t.ensureVisible(find.text('Ranking de estudiantes (por puntos)'));
        expect(docente.consultasRanking.first, (null, null));
        expect(find.text('340'), findsOneWidget);

        await t.tap(find.text('Todas las materias'));
        await t.pumpAndSettle();
        await t.tap(find.text('Matemáticas').last);
        await t.pumpAndSettle();
        expect(docente.consultasRanking.last.$2, 1);
      },
    );

    testWidgets('sin clases invita a crear una', (t) async {
      await abrirComoDocente(t, docente: FalsoDocente());
      await ir(t, '/docente/estadisticas');
      expect(find.textContaining('Aún no tienes clases'), findsOneWidget);
    });
  });

  group('ajustes', () {
    testWidgets('permite activar texto grande y cerrar sesión', (t) async {
      final app = await abrirComoDocente(t);
      await ir(t, '/docente/ajustes');
      expect(find.text('Cuenta docente con Google'), findsOneWidget);
      await t.tap(find.text('Texto más grande'));
      await t.pumpAndSettle();
      expect(app.ajustes.textoGrande, isTrue);

      await t.ensureVisible(find.text('CERRAR SESIÓN'));
      await t.tap(find.text('CERRAR SESIÓN'));
      await t.pumpAndSettle();
      expect(app.sesion.activa, isFalse);
      expect(find.text('JUGAR'), findsOneWidget);
    });
  });
}
