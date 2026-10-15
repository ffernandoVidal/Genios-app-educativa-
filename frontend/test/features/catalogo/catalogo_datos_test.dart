import 'dart:convert';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genios_app/core/estado/estado_carga.dart';
import 'package:genios_app/core/red/cliente_api.dart';
import 'package:genios_app/core/red/excepcion_api.dart';
import 'package:genios_app/core/sesion/sesion_app.dart';
import 'package:genios_app/features/catalogo/datos/repositorio_catalogo_api.dart';
import 'package:genios_app/features/catalogo/dominio/modelos_catalogo.dart';
import 'package:genios_app/features/catalogo/presentacion/catalogo_cubits.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import '../../soporte/repositorios_falsos.dart';

http.Response json(Object cuerpo) => http.Response(
  jsonEncode(cuerpo),
  200,
  headers: {'content-type': 'application/json; charset=utf-8'},
);

const asignaturasJson = [
  {
    'id': 1,
    'codigo': 'MATEMATICAS',
    'nombre': 'Matematicas',
    'descripcion': null,
  },
  {'id': 2, 'codigo': 'LENGUAJE', 'nombre': 'Lenguaje', 'descripcion': null},
];

void main() {
  RepositorioCatalogoApi repositorio(Map<String, Object> rutas) =>
      RepositorioCatalogoApi(
        ClienteApi(
          cliente: MockClient((r) async {
            final cuerpo = rutas[r.url.path.replaceFirst('/api/v1', '')];
            return cuerpo == null ? http.Response('', 404) : json(cuerpo);
          }),
          urlBase: 'http://api/api/v1',
          sesion: SesionApp(),
        ),
      );

  group('RepositorioCatalogoApi', () {
    test('lee las asignaturas', () async {
      final lista = await repositorio({'/asignaturas': asignaturasJson})
          .asignaturas();

      expect(lista.map((a) => a.codigo), ['MATEMATICAS', 'LENGUAJE']);
    });

    test(
      'arma el mapa con niveles, misiones, estados y requisito de desbloqueo',
      () async {
        final repo = repositorio({
          '/asignaturas': asignaturasJson,
          '/asignaturas/1/niveles': [
            {'id': 10, 'nombre': 'Nivel 1', 'numeroOrden': 1},
          ],
          '/niveles/10/categorias': [
            {
              'id': 100,
              'codigo': 'suma',
              'nombre': 'Sumas',
              'numeroOrden': 1,
              'estado': 'completada',
            },
            {
              'id': 101,
              'codigo': 'resta',
              'nombre': 'Restas',
              'numeroOrden': 2,
              'estado': 'en_progreso',
            },
            {
              'id': 102,
              'codigo': 'mult',
              'nombre': 'Multiplicaciones',
              'numeroOrden': 3,
              'estado': 'bloqueada',
              'requiereCategoriaId': 101,
              'requiereCategoriaNombre': 'Restas',
            },
            {
              'id': 103,
              'codigo': 'div',
              'nombre': 'Divisiones',
              'numeroOrden': 4,
              'estado': 'algo_nuevo',
            },
          ],
        });

        final mapa = await repo.mapa(1);

        expect(mapa.asignatura.nombre, 'Matematicas');
        final misiones = mapa.niveles.single.misiones;
        expect(misiones.map((m) => m.estado), [
          EstadoMision.completada,
          EstadoMision.enProgreso,
          EstadoMision.bloqueada,
          EstadoMision.bloqueada,
        ]);
        expect(misiones[2].requiereNombre, 'Restas');
        expect(mapa.sinMisiones, isFalse);
      },
    );

    test(
      'una materia sin niveles ni misiones se reconoce como vacía',
      () async {
        final mapa = await repositorio({
          '/asignaturas': asignaturasJson,
          '/asignaturas/2/niveles': <Object>[],
        }).mapa(2);

        expect(mapa.sinMisiones, isTrue);
      },
    );

    test('una materia inexistente produce un error 404', () async {
      await expectLater(
        repositorio({'/asignaturas': asignaturasJson}).mapa(99),
        throwsA(isA<ExcepcionApi>().having((e) => e.estado, 'estado', 404)),
      );
    });
  });

  group('MateriasCubit', () {
    blocTest<MateriasCubit, EstadoCarga<List<Asignatura>>>(
      'emite cargando y luego las asignaturas',
      build: () => MateriasCubit(FalsoCatalogo()),
      act: (c) => c.cargar(),
      expect: () => [
        const Cargando<List<Asignatura>>(),
        isA<Cargado<List<Asignatura>>>(),
      ],
    );

    blocTest<MateriasCubit, EstadoCarga<List<Asignatura>>>(
      'emite fallo con indicación de falta de conexión',
      build: () =>
          MateriasCubit(FalsoCatalogo(error: const ExcepcionApi.sinConexion())),
      act: (c) => c.cargar(),
      expect: () => [
        const Cargando<List<Asignatura>>(),
        isA<Fallido<List<Asignatura>>>().having(
          (f) => f.sinConexion,
          'sinConexion',
          isTrue,
        ),
      ],
    );
  });
}
