import 'package:flutter_test/flutter_test.dart';
import 'package:genios_app/core/red/excepcion_api.dart';
import 'package:genios_app/features/partida/presentacion/partida_cubit.dart';

import '../../soporte/repositorios_falsos.dart';

void main() {
  late FalsoPartida repo;
  late PartidaCubit cubit;
  var contador = 0;

  setUp(() {
    contador = 0;
    repo = FalsoPartida();
    cubit = PartidaCubit(repo, generador: () => 'clave-${++contador}');
  });

  tearDown(() => cubit.close());

  test('recorre una partida completa: pregunta, retroalimentación, siguiente y resultado', () async {
    await cubit.iniciar(7);
    expect(cubit.state.fase, FasePartida.pregunta);
    expect(cubit.state.partida!.numeroPregunta, 1);

    await cubit.responder('a');
    expect(cubit.state.fase, FasePartida.retroalimentacion);
    expect(cubit.state.respuesta!.esCorrecta, isTrue);
    expect(cubit.state.respuesta!.puntosOtorgados, 10);

    await cubit.continuar();
    expect(cubit.state.fase, FasePartida.pregunta);
    expect(cubit.state.partida!.numeroPregunta, 2);

    await cubit.responder('a');
    expect(cubit.state.respuesta!.completaLaPartida, isTrue);

    await cubit.continuar();
    expect(cubit.state.fase, FasePartida.terminada);
    expect(cubit.state.resultado!.categoriaCompletada, isTrue);
    expect(cubit.state.resultado!.puntosObtenidos, 40);
  });

  test(
    'una respuesta incorrecta permite reintentar la misma pregunta',
    () async {
      await cubit.iniciar(7);

      await cubit.responder('b');
      expect(cubit.state.respuesta!.esCorrecta, isFalse);

      await cubit.continuar();
      expect(cubit.state.fase, FasePartida.pregunta);
      expect(
        cubit.state.partida!.numeroPregunta,
        1,
      ); // sigue en la misma pregunta
    },
  );

  test('si la red falla al responder, reintentar la misma opción reutiliza la clave y no duplica', () async {
    await cubit.iniciar(7);
    repo.fallosDeRed = 1;

    await cubit.responder('a');
    expect(cubit.state.fase, FasePartida.pregunta);
    expect(cubit.state.aviso, contains('No pudimos conectarnos'));

    await cubit.responder('a'); // el niño vuelve a tocar la misma opción
    expect(cubit.state.fase, FasePartida.retroalimentacion);
    expect(repo.clavesRecibidas, [
      'clave-2',
    ]); // una sola respuesta registrada, con la clave del primer envío
  });

  test('cada respuesta distinta usa una clave nueva', () async {
    await cubit.iniciar(7);
    await cubit.responder('b');
    await cubit.continuar();
    await cubit.responder('c');

    expect(repo.clavesRecibidas.toSet().length, 2);
  });

  test('crear la partida reutiliza la misma clave al reintentar', () async {
    repo.errorAlCrear = const ExcepcionApi.sinConexion();
    await cubit.iniciar(7);
    expect(cubit.state.fase, FasePartida.error);
    expect(cubit.state.puedeReintentarCarga, isTrue);

    repo.errorAlCrear = null;
    await cubit.reintentarCarga();

    expect(cubit.state.fase, FasePartida.pregunta);
    expect(repo.clavesDeCreacion.toSet().length, 1);
  });

  test(
    'sin tiempo diario no se reintenta: se muestra el mensaje del servidor',
    () async {
      repo.errorAlCrear = const ExcepcionApi(
        'Ya alcanzaste tu tiempo de juego de hoy.',
        estado: 403,
        codigo: 'limite_diario_agotado',
      );

      await cubit.iniciar(7);

      expect(cubit.state.fase, FasePartida.error);
      expect(cubit.state.mensajeError, contains('tiempo de juego de hoy'));
      expect(cubit.state.puedeReintentarCarga, isFalse);
    },
  );

  test('una categoría bloqueada no se reintenta', () async {
    repo.errorAlCrear = const ExcepcionApi(
      'Completa la categoría anterior.',
      estado: 403,
      codigo: 'categoria_bloqueada',
    );

    await cubit.iniciar(7);

    expect(cubit.state.puedeReintentarCarga, isFalse);
  });

  testWidgets(
    'el tercer error enciende la mecha, la cuenta regresiva baja y al llegar a cero decide el servidor',
    (t) async {
      await cubit.iniciar(7);
      await cubit.responder('b');
      await cubit.continuar();
      await cubit.responder('b');
      await cubit.continuar();
      expect(cubit.state.segundosMecha, isNull);

      await cubit.responder('b'); // tercer error
      expect(cubit.state.segundosMecha, 5);

      await t.pump(const Duration(seconds: 2));
      expect(cubit.state.segundosMecha, 3);

      repo.vencerMecha(); // el servidor da la partida por terminada
      await t.pump(const Duration(seconds: 3));
      await t.pump(); // deja resolver la consulta al servidor

      expect(cubit.state.fase, FasePartida.terminada);
      expect(cubit.state.resultado!.terminoPorMecha, isTrue);
    },
  );

  test('acertar apaga la mecha', () async {
    await cubit.iniciar(7);
    for (var i = 0; i < 3; i++) {
      await cubit.responder('b');
      await cubit.continuar();
    }
    expect(cubit.state.segundosMecha, 5);

    await cubit.responder('a');

    expect(cubit.state.respuesta!.esCorrecta, isTrue);
    expect(cubit.state.segundosMecha, isNull);
  });

  test('si el servidor informa que la mecha terminó la partida al responder, se muestra el resultado', () async {
    await cubit.iniciar(7);
    repo.vencerMecha();

    await cubit.responder('a');

    expect(cubit.state.fase, FasePartida.terminada);
    expect(cubit.state.resultado!.terminoPorMecha, isTrue);
  });

  test('abandonar avisa al servidor', () async {
    await cubit.iniciar(7);

    await cubit.abandonar();

    expect(repo.abandonadas, 1);
  });
}
