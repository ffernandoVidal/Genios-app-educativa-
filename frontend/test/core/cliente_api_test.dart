import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:genios_app/core/red/cliente_api.dart';
import 'package:genios_app/core/red/excepcion_api.dart';
import 'package:genios_app/core/sesion/sesion_app.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

http.Response json(Object cuerpo, [int estado = 200]) => http.Response(
  jsonEncode(cuerpo),
  estado,
  headers: {'content-type': 'application/json; charset=utf-8'},
);

void main() {
  late SesionApp sesion;

  ClienteApi crear(Future<http.Response> Function(http.Request) manejador) =>
      ClienteApi(
        cliente: MockClient(manejador),
        urlBase: 'http://api/v1',
        sesion: sesion,
      );

  setUp(() => sesion = SesionApp());

  group('cabeceras', () {
    test(
      'GET envía el token de acceso y no envía la cabecera anti-CSRF',
      () async {
        sesion.iniciarCuenta(
          tokenAcceso: 'T1',
          roles: ['estudiante'],
          nombre: 'Ana',
        );
        late http.Request recibida;
        final api = crear((r) async {
          recibida = r;
          return json([]);
        });

        await api.obtener('/asignaturas');

        expect(recibida.url.toString(), 'http://api/v1/asignaturas');
        expect(recibida.headers['Authorization'], 'Bearer T1');
        expect(
          recibida.headers.containsKey(ClienteApi.cabeceraAnticsrf),
          isFalse,
        );
      },
    );

    test('POST envía JSON y la cabecera anti-CSRF', () async {
      late http.Request recibida;
      final api = crear((r) async {
        recibida = r;
        return json({'ok': true});
      });

      await api.enviar('/partidas', {'categoriaId': 3});

      expect(recibida.method, 'POST');
      expect(recibida.headers[ClienteApi.cabeceraAnticsrf], '1');
      expect(recibida.headers['Content-Type'], contains('application/json'));
      expect(jsonDecode(recibida.body), {'categoriaId': 3});
    });

    test('sin sesión no se envía Authorization', () async {
      late http.Request recibida;
      final api = crear((r) async {
        recibida = r;
        return json([]);
      });

      await api.obtener('/asignaturas');

      expect(recibida.headers.containsKey('Authorization'), isFalse);
    });
  });

  group('errores', () {
    test(
      'Problem Details se convierte en ExcepcionApi con código y mensaje',
      () async {
        final api = crear(
          (_) async => json({
            'title': 'Completa la categoría anterior.',
            'codigo': 'categoria_bloqueada',
            'status': 403,
          }, 403),
        );

        expect(
          () => api.enviar('/partidas', {}),
          throwsA(
            isA<ExcepcionApi>()
                .having((e) => e.codigo, 'codigo', 'categoria_bloqueada')
                .having((e) => e.estado, 'estado', 403)
                .having(
                  (e) => e.mensaje,
                  'mensaje',
                  'Completa la categoría anterior.',
                ),
          ),
        );
      },
    );

    test('un 500 sin código oculta el detalle técnico', () async {
      final api = crear(
        (_) async => json({
          'title': 'An error occurred while processing your request.',
          'status': 500,
        }, 500),
      );

      await expectLater(
        api.obtener('/asignaturas'),
        throwsA(
          isA<ExcepcionApi>().having(
            (e) => e.mensaje,
            'mensaje',
            isNot(contains('An error occurred')),
          ),
        ),
      );
    });

    test('un 429 sin cuerpo explica que hay que esperar', () async {
      final api = crear((_) async => http.Response('', 429));

      await expectLater(
        api.enviar('/estudiantes/registro', {}),
        throwsA(
          isA<ExcepcionApi>().having(
            (e) => e.mensaje,
            'mensaje',
            contains('Demasiados intentos'),
          ),
        ),
      );
    });

    test('un fallo de red se informa como falta de conexión', () async {
      final api = crear((_) async => throw http.ClientException('sin red'));

      await expectLater(
        api.obtener('/asignaturas'),
        throwsA(
          isA<ExcepcionApi>().having(
            (e) => e.sinConexion,
            'sinConexion',
            isTrue,
          ),
        ),
      );
    });

    test(
      'un 401 de inicio de sesión (sin sesión activa) no intenta renovar',
      () async {
        var llamadas = 0;
        final api = crear((_) async {
          llamadas++;
          return json({
            'title': 'Usuario o contraseña incorrectos.',
            'codigo': 'credenciales_invalidas',
          }, 401);
        });

        await expectLater(
          api.enviar('/autenticacion/estudiante/iniciar-sesion', {}),
          throwsA(isA<ExcepcionApi>()),
        );
        expect(llamadas, 1);
      },
    );
  });

  group('renovación de sesión', () {
    test(
      'ante un 401 renueva una vez, actualiza el token y repite la solicitud',
      () async {
        sesion.iniciarCuenta(
          tokenAcceso: 'VIEJO',
          roles: ['estudiante'],
          nombre: 'Ana',
        );
        final registro = <String>[];
        final api = crear((r) async {
          registro.add(
            '${r.method} ${r.url.path} ${r.headers['Authorization'] ?? '-'}',
          );
          if (r.url.path.endsWith('/renovar')) {
            return json({'tokenAcceso': 'NUEVO'});
          }
          return r.headers['Authorization'] == 'Bearer NUEVO'
              ? json({'dato': 1})
              : json({}, 401);
        });

        final resultado = await api.obtener('/estudiantes/yo/puntos');

        expect(resultado, {'dato': 1});
        expect(sesion.tokenAcceso, 'NUEVO');
        expect(registro, [
          'GET /v1/estudiantes/yo/puntos Bearer VIEJO',
          'POST /v1/autenticacion/renovar Bearer VIEJO',
          'GET /v1/estudiantes/yo/puntos Bearer NUEVO',
        ]);
      },
    );

    test(
      'varias solicitudes simultáneas con 401 provocan una sola renovación',
      () async {
        sesion.iniciarCuenta(
          tokenAcceso: 'VIEJO',
          roles: ['estudiante'],
          nombre: 'Ana',
        );
        var renovaciones = 0;
        final api = crear((r) async {
          if (r.url.path.endsWith('/renovar')) {
            renovaciones++;
            await Future<void>.delayed(const Duration(milliseconds: 20));
            return json({'tokenAcceso': 'NUEVO'});
          }
          return r.headers['Authorization'] == 'Bearer NUEVO'
              ? json({'ok': true})
              : json({}, 401);
        });

        final resultados = await Future.wait([
          api.obtener('/a'),
          api.obtener('/b'),
          api.obtener('/c'),
        ]);

        expect(resultados, everyElement({'ok': true}));
        expect(renovaciones, 1);
      },
    );

    test(
      'si la renovación falla, la sesión se cierra y se informa el 401',
      () async {
        sesion.iniciarCuenta(
          tokenAcceso: 'VIEJO',
          roles: ['estudiante'],
          nombre: 'Ana',
        );
        final api = crear(
          (_) async => json({'codigo': 'sesion_invalida'}, 401),
        );

        await expectLater(
          api.obtener('/estudiantes/yo/puntos'),
          throwsA(isA<ExcepcionApi>().having((e) => e.estado, 'estado', 401)),
        );

        expect(sesion.activa, isFalse);
        expect(sesion.tokenAcceso, isNull);
      },
    );

    test('un invitado con 401 (sesión vencida) vuelve a la bienvenida sin intentar renovar', () async {
      sesion.iniciarInvitado(nombre: 'Luna');
      var llamadas = 0;
      final api = crear((_) async {
        llamadas++;
        return json({}, 401);
      });

      await expectLater(
        api.enviar('/partidas', {}),
        throwsA(isA<ExcepcionApi>()),
      );

      expect(llamadas, 1);
      expect(sesion.activa, isFalse);
    });
  });
}
