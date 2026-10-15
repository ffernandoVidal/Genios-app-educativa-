import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/red/excepcion_api.dart';
import '../dominio/repositorio_docente.dart';

class EstadoDocente extends Equatable {
  const EstadoDocente({
    this.cargando = true,
    this.aulas = const [],
    this.aulaActual,
    this.estudiantes = const [],
    this.cargandoEstudiantes = false,
    this.ocupado = false,
    this.errorCarga,
    this.mensajeError,
    this.codigo,
  });

  final bool cargando;
  final List<AulaDocente> aulas;
  final AulaDocente? aulaActual;
  final List<EstudianteDeAula> estudiantes;
  final bool cargandoEstudiantes;

  /// Hay una acción en curso (crear aula, agregar estudiante…).
  final bool ocupado;
  final String? errorCarga;
  final String? mensajeError;

  /// Último código de activación emitido: el docente se lo entrega al estudiante.
  final CodigoActivacion? codigo;

  EstadoDocente copiar({
    bool? cargando,
    List<AulaDocente>? aulas,
    AulaDocente? aulaActual,
    List<EstudianteDeAula>? estudiantes,
    bool? cargandoEstudiantes,
    bool? ocupado,
    String? errorCarga,
    String? mensajeError,
    CodigoActivacion? codigo,
    bool quitarCodigo = false,
  }) => EstadoDocente(
    cargando: cargando ?? this.cargando,
    aulas: aulas ?? this.aulas,
    aulaActual: aulaActual ?? this.aulaActual,
    estudiantes: estudiantes ?? this.estudiantes,
    cargandoEstudiantes: cargandoEstudiantes ?? this.cargandoEstudiantes,
    ocupado: ocupado ?? this.ocupado,
    errorCarga: errorCarga,
    mensajeError: mensajeError,
    codigo: quitarCodigo ? null : (codigo ?? this.codigo),
  );

  @override
  List<Object?> get props => [
    cargando,
    aulas,
    aulaActual,
    estudiantes,
    cargandoEstudiantes,
    ocupado,
    errorCarga,
    mensajeError,
    codigo,
  ];
}

class DocenteCubit extends Cubit<EstadoDocente> {
  DocenteCubit(this._repositorio) : super(const EstadoDocente());

  final RepositorioDocente _repositorio;

  Future<void> cargar() async {
    emit(const EstadoDocente());
    try {
      final aulas = await _repositorio.aulas();
      if (isClosed) return;
      emit(EstadoDocente(cargando: false, aulas: aulas));
      if (aulas.isNotEmpty) await elegirAula(aulas.first);
    } on ExcepcionApi catch (e) {
      if (!isClosed) {
        emit(EstadoDocente(cargando: false, errorCarga: e.mensaje));
      }
    }
  }

  Future<void> elegirAula(AulaDocente aula) async {
    emit(
      state.copiar(
        aulaActual: aula,
        estudiantes: const [],
        cargandoEstudiantes: true,
        quitarCodigo: true,
      ),
    );
    try {
      final estudiantes = await _repositorio.estudiantes(aula.id);
      if (!isClosed) {
        emit(
          state.copiar(estudiantes: estudiantes, cargandoEstudiantes: false),
        );
      }
    } on ExcepcionApi catch (e) {
      if (!isClosed) {
        emit(state.copiar(cargandoEstudiantes: false, mensajeError: e.mensaje));
      }
    }
  }

  Future<void> crearAula(String nombre) async {
    if (nombre.trim().isEmpty) {
      emit(state.copiar(mensajeError: 'Escribe un nombre para el aula.'));
      return;
    }
    emit(state.copiar(ocupado: true));
    try {
      final aula = await _repositorio.crearAula(nombre.trim());
      final aulas = await _repositorio.aulas();
      if (isClosed) return;
      emit(state.copiar(aulas: aulas, ocupado: false));
      await elegirAula(
        aulas.firstWhere((a) => a.id == aula.id, orElse: () => aula),
      );
    } on ExcepcionApi catch (e) {
      if (!isClosed) {
        emit(state.copiar(ocupado: false, mensajeError: _traducir(e)));
      }
    }
  }

  Future<void> agregarEstudiante(String nombre, String usuario) async {
    final aula = state.aulaActual;
    if (aula == null) return;
    if (nombre.trim().isEmpty || usuario.trim().isEmpty) {
      emit(
        state.copiar(
          mensajeError: 'Escribe el nombre y el usuario del estudiante.',
        ),
      );
      return;
    }
    emit(state.copiar(ocupado: true, quitarCodigo: true));
    try {
      final codigo = await _repositorio.agregarEstudiante(
        aula.id,
        nombreMostrar: nombre.trim(),
        nombreUsuario: usuario.trim(),
      );
      final estudiantes = await _repositorio.estudiantes(aula.id);
      if (!isClosed) {
        emit(
          state.copiar(
            estudiantes: estudiantes,
            ocupado: false,
            codigo: codigo,
          ),
        );
      }
    } on ExcepcionApi catch (e) {
      if (!isClosed) {
        emit(state.copiar(ocupado: false, mensajeError: _traducir(e)));
      }
    }
  }

  Future<void> nuevoCodigo(EstudianteDeAula estudiante) async {
    final aula = state.aulaActual;
    if (aula == null) return;
    emit(state.copiar(ocupado: true, quitarCodigo: true));
    try {
      final codigo = await _repositorio.nuevoCodigo(aula.id, estudiante);
      if (!isClosed) emit(state.copiar(ocupado: false, codigo: codigo));
    } on ExcepcionApi catch (e) {
      if (!isClosed) {
        emit(state.copiar(ocupado: false, mensajeError: _traducir(e)));
      }
    }
  }

  String _traducir(ExcepcionApi e) => switch (e.codigo) {
    'nombre_usuario_en_uso' => 'Ese usuario ya existe. Prueba con otro.',
    'nombre_usuario_invalido' => 'El usuario debe tener de 3 a 30 caracteres: letras, números, punto o guion bajo.',
    'docente_no_verificado' => 'Tu cuenta docente aún no está verificada.',
    _ => e.mensaje,
  };
}
