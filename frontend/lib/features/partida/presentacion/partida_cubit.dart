import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/red/excepcion_api.dart';
import '../../../core/utilidades/guid.dart';
import '../dominio/modelos_partida.dart';
import '../dominio/repositorio_partida.dart';

enum FasePartida {
  cargando,
  pregunta,
  enviando,
  retroalimentacion,
  terminada,
  error,
}

class EstadoPartida extends Equatable {
  const EstadoPartida({
    this.fase = FasePartida.cargando,
    this.partida,
    this.opcionElegidaId,
    this.respuesta,
    this.resultado,
    this.segundosMecha,
    this.aviso,
    this.mensajeError,
    this.puedeReintentarCarga = false,
  });

  final FasePartida fase;
  final PartidaEnCurso? partida;
  final String? opcionElegidaId;
  final RespuestaServidor? respuesta;
  final ResultadoPartida? resultado;

  /// Cuenta regresiva de la mecha que se muestra; la decisión final siempre la toma el servidor.
  final int? segundosMecha;

  /// Mensaje no bloqueante (por ejemplo, un fallo de red al enviar una respuesta).
  final String? aviso;
  final String? mensajeError;
  final bool puedeReintentarCarga;

  EstadoPartida conMecha(int? segundos) => EstadoPartida(
    fase: fase,
    partida: partida,
    opcionElegidaId: opcionElegidaId,
    respuesta: respuesta,
    resultado: resultado,
    segundosMecha: segundos,
    aviso: aviso,
    mensajeError: mensajeError,
    puedeReintentarCarga: puedeReintentarCarga,
  );

  @override
  List<Object?> get props => [
    fase,
    partida,
    opcionElegidaId,
    respuesta,
    resultado,
    segundosMecha,
    aviso,
    mensajeError,
    puedeReintentarCarga,
  ];
}

/// Conduce una partida. No evalúa nada: envía la opción elegida y muestra lo que decide el servidor.
class PartidaCubit extends Cubit<EstadoPartida> {
  PartidaCubit(this._repositorio, {GeneradorClaves? generador})
    : _generar = generador ?? generarGuid,
      super(const EstadoPartida());

  final RepositorioPartida _repositorio;
  final GeneradorClaves _generar;

  int? _categoriaId;
  String? _claveCreacion;
  PartidaEnCurso? _partida;
  Timer? _reloj;

  // Si un envío falla por la red, al tocar la misma opción se reutiliza la clave: el servidor no duplica nada.
  String? _opcionPendiente;
  String? _clavePendiente;

  Future<void> iniciar(int categoriaId) async {
    _categoriaId = categoriaId;
    _claveCreacion ??= _generar();
    emit(const EstadoPartida());
    try {
      _mostrar(await _repositorio.crear(categoriaId, _claveCreacion!));
    } on ExcepcionApi catch (e) {
      _fallar(e);
    }
  }

  Future<void> reintentarCarga() async {
    final partida = _partida;
    if (partida == null) {
      if (_categoriaId != null) await iniciar(_categoriaId!);
      return;
    }
    emit(const EstadoPartida());
    try {
      _mostrar(await _repositorio.obtener(partida.id));
    } on ExcepcionApi catch (e) {
      _fallar(e);
    }
  }

  Future<void> responder(String opcionId) async {
    final partida = _partida;
    if (partida == null ||
        partida.pregunta == null ||
        state.fase != FasePartida.pregunta) {
      return;
    }

    if (_opcionPendiente != opcionId) {
      _opcionPendiente = opcionId;
      _clavePendiente = _generar();
    }
    final mecha = state.segundosMecha;
    emit(
      EstadoPartida(
        fase: FasePartida.enviando,
        partida: partida,
        opcionElegidaId: opcionId,
        segundosMecha: mecha,
      ),
    );

    try {
      final respuesta = await _repositorio.responder(
        partida.id,
        partida.pregunta!.id,
        opcionId,
        _clavePendiente!,
      );
      _opcionPendiente = null;
      _clavePendiente = null;
      emit(
        EstadoPartida(
          fase: FasePartida.retroalimentacion,
          partida: partida,
          opcionElegidaId: opcionId,
          respuesta: respuesta,
          segundosMecha: respuesta.segundosMecha,
        ),
      );
      _programarMecha(respuesta.segundosMecha);
    } on ExcepcionApi catch (e) {
      if (e.codigo == 'partida_terminada_por_mecha') {
        await _terminar();
      } else if (e.sinConexion) {
        emit(
          EstadoPartida(
            fase: FasePartida.pregunta,
            partida: partida,
            segundosMecha: mecha,
            aviso: e.mensaje,
          ),
        );
      } else {
        _fallar(e);
      }
    }
  }

  /// Tras la retroalimentación: reintentar la misma pregunta, pasar a la siguiente o ver el resultado.
  Future<void> continuar() async {
    final partida = _partida;
    final respuesta = state.respuesta;
    if (partida == null ||
        respuesta == null ||
        state.fase != FasePartida.retroalimentacion) {
      return;
    }

    if (!respuesta.esCorrecta) {
      emit(
        EstadoPartida(
          fase: FasePartida.pregunta,
          partida: partida,
          segundosMecha: state.segundosMecha,
        ),
      );
      return;
    }
    if (respuesta.completaLaPartida) {
      await _terminar();
      return;
    }
    emit(const EstadoPartida());
    try {
      _mostrar(await _repositorio.obtener(partida.id));
    } on ExcepcionApi catch (e) {
      _fallar(e);
    }
  }

  Future<void> abandonar() async {
    _reloj?.cancel();
    final partida = _partida;
    if (partida == null || state.fase == FasePartida.terminada) return;
    try {
      await _repositorio.abandonar(partida.id);
    } on ExcepcionApi {
      // Se ignora: la partida vencerá sola en el servidor.
    }
  }

  // ---------------------------------------------------------------- Interno

  void _mostrar(PartidaEnCurso partida) {
    _partida = partida;
    if (partida.pregunta == null) {
      unawaited(_terminar()); // la partida ya no está en curso
      return;
    }
    emit(
      EstadoPartida(
        fase: FasePartida.pregunta,
        partida: partida,
        segundosMecha: partida.segundosMecha,
      ),
    );
    _programarMecha(partida.segundosMecha);
  }

  void _programarMecha(int? segundos) {
    _reloj?.cancel();
    if (segundos == null) return;
    _reloj = Timer.periodic(const Duration(seconds: 1), (_) => _tic());
  }

  void _tic() {
    final segundos = state.segundosMecha;
    if (segundos == null || isClosed) {
      _reloj?.cancel();
      return;
    }
    if (segundos <= 1) {
      _reloj?.cancel();
      emit(state.conMecha(0));
      unawaited(_alVencerLaMecha());
      return;
    }
    emit(state.conMecha(segundos - 1));
  }

  /// El reloj local llegó a cero: se pregunta al servidor, que es quien decide si la partida terminó.
  Future<void> _alVencerLaMecha() async {
    final partida = _partida;
    if (partida == null) return;
    try {
      final actual = await _repositorio.obtener(partida.id);
      if (actual.estado == 'en_curso' &&
          actual.segundosMecha != null &&
          actual.segundosMecha! > 0) {
        emit(state.conMecha(actual.segundosMecha));
        _programarMecha(actual.segundosMecha);
      } else {
        await _terminar();
      }
    } on ExcepcionApi {
      // Sin conexión: al responder, el servidor aplicará su decisión.
    }
  }

  Future<void> _terminar() async {
    _reloj?.cancel();
    final partida = _partida;
    if (partida == null) return;
    emit(const EstadoPartida());
    try {
      final resultado = await _repositorio.resultado(partida.id);
      if (!isClosed) {
        emit(
          EstadoPartida(
            fase: FasePartida.terminada,
            partida: partida,
            resultado: resultado,
          ),
        );
      }
    } on ExcepcionApi catch (e) {
      _fallar(e);
    }
  }

  void _fallar(ExcepcionApi e) {
    _reloj?.cancel();
    if (isClosed) return;
    final reintentable =
        e.sinConexion ||
        (e.estado != null && e.estado! >= 500 && e.codigo == null);
    emit(
      EstadoPartida(
        fase: FasePartida.error,
        partida: _partida,
        mensajeError: e.mensaje,
        puedeReintentarCarga: reintentable,
      ),
    );
  }

  @override
  Future<void> close() {
    _reloj?.cancel();
    return super.close();
  }
}
