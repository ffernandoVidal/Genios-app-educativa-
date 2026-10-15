import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/red/excepcion_api.dart';
import '../dominio/repositorio_salon.dart';

class EstadoSalon extends Equatable {
  const EstadoSalon({
    this.cargando = true,
    this.aulas = const [],
    this.errorCarga,
    this.uniendose = false,
    this.mensaje,
    this.mensajeEsError = false,
  });

  final bool cargando;
  final List<AulaSalon> aulas;
  final String? errorCarga;
  final bool uniendose;

  /// Resultado de intentar unirse (éxito o error), para mostrarlo bajo el formulario.
  final String? mensaje;
  final bool mensajeEsError;

  EstadoSalon copiar({
    bool? cargando,
    List<AulaSalon>? aulas,
    String? errorCarga,
    bool? uniendose,
    String? mensaje,
    bool? mensajeEsError,
  }) => EstadoSalon(
    cargando: cargando ?? this.cargando,
    aulas: aulas ?? this.aulas,
    errorCarga: errorCarga,
    uniendose: uniendose ?? this.uniendose,
    mensaje: mensaje,
    mensajeEsError: mensajeEsError ?? this.mensajeEsError,
  );

  @override
  List<Object?> get props => [
    cargando,
    aulas,
    errorCarga,
    uniendose,
    mensaje,
    mensajeEsError,
  ];
}

class SalonCubit extends Cubit<EstadoSalon> {
  SalonCubit(this._repositorio) : super(const EstadoSalon());

  final RepositorioSalon _repositorio;

  Future<void> cargar() async {
    emit(const EstadoSalon());
    try {
      final aulas = await _repositorio.misAulas();
      if (!isClosed) emit(EstadoSalon(cargando: false, aulas: aulas));
    } on ExcepcionApi catch (e) {
      if (!isClosed) emit(EstadoSalon(cargando: false, errorCarga: e.mensaje));
    }
  }

  Future<void> unirse(String codigo) async {
    if (codigo.trim().isEmpty) {
      emit(
        state.copiar(
          mensaje: 'Escribe el código de tu aula.',
          mensajeEsError: true,
        ),
      );
      return;
    }
    emit(state.copiar(uniendose: true));
    try {
      final aula = await _repositorio.unirse(codigo.trim());
      final aulas = await _repositorio.misAulas();
      if (!isClosed) {
        emit(
          state.copiar(
            aulas: aulas,
            uniendose: false,
            mensaje: '¡Listo! Ahora estás en «${aula.nombre}».',
            mensajeEsError: false,
          ),
        );
      }
    } on ExcepcionApi catch (e) {
      if (!isClosed) {
        emit(
          state.copiar(
            uniendose: false,
            mensaje: e.codigo == 'aula_no_encontrada'
                ? 'No encontramos ese código de aula. Revisa que esté bien escrito.'
                : e.mensaje,
            mensajeEsError: true,
          ),
        );
      }
    }
  }
}
