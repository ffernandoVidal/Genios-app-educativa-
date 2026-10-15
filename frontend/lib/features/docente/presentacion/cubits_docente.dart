import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/estado/estado_carga.dart';
import '../../../core/red/excepcion_api.dart';
import '../dominio/repositorio_docente.dart';

/// Traduce los códigos de error del servidor a mensajes claros para el docente.
String mensajeDeError(ExcepcionApi e) => switch (e.codigo) {
  'nombre_usuario_en_uso' => 'Ese usuario ya existe. Prueba con otro.',
  'nombre_usuario_invalido' => 'El usuario debe tener de 3 a 30 caracteres: letras, números, punto o guion bajo.',
  'docente_no_verificado' => 'Tu cuenta docente aún no está verificada.',
  'grado_invalido' => 'El grado debe estar entre 1 y 6.',
  'nombre_aula_invalido' =>
    'El nombre de la clase debe tener entre 1 y 140 caracteres.',
  _ => e.mensaje,
};

// ------------------------------------------------------------------ Clases

/// Lista de clases del docente, compartida por todas las secciones. Crear, editar y archivar recargan la lista.
class AulasDocenteCubit extends CubitCarga<List<AulaDocente>> {
  AulasDocenteCubit(this._repositorio);

  final RepositorioDocente _repositorio;

  @override
  Future<List<AulaDocente>> obtener() => _repositorio.aulas();

  /// Devuelve la clase creada, o lanza [ExcepcionApi] para que el formulario muestre el motivo.
  Future<AulaDocente> crear({
    required String nombre,
    int? grado,
    String? seccion,
    String? descripcion,
  }) async {
    final aula = await _repositorio.crearAula(
      nombre: nombre,
      grado: grado,
      seccion: seccion,
      descripcion: descripcion,
    );
    await cargar();
    return aula;
  }

  Future<void> editar(
    String id, {
    String? nombre,
    int? grado,
    String? seccion,
    String? descripcion,
  }) async {
    await _repositorio.editarAula(
      id,
      nombre: nombre,
      grado: grado,
      seccion: seccion,
      descripcion: descripcion,
    );
    await cargar();
  }

  Future<void> archivar(String id) async {
    await _repositorio.archivarAula(id);
    await cargar();
  }
}

// ------------------------------------------------------------------ Inicio

class ResumenCubit extends CubitCarga<ResumenDocente> {
  ResumenCubit(
    this._repositorio, {
    this.periodo = const PeriodoConsulta.ultimos(30),
  });

  final RepositorioDocente _repositorio;
  final PeriodoConsulta periodo;

  @override
  Future<ResumenDocente> obtener() => _repositorio.resumen(periodo);
}

// ------------------------------------------------------------------ Alumnos

class EstadoAlumnos extends Equatable {
  const EstadoAlumnos({
    this.cargando = true,
    this.pagina,
    this.error,
    this.busqueda = '',
    this.aulaId,
    this.grado,
    this.rendimiento,
    this.orden = 'nombre',
    this.numeroPagina = 1,
  });

  final bool cargando;
  final PaginaEstudiantes? pagina;
  final String? error;
  final String busqueda;
  final String? aulaId;
  final int? grado;
  final Rendimiento? rendimiento;
  final String orden;
  final int numeroPagina;

  EstadoAlumnos copiar({
    bool? cargando,
    PaginaEstudiantes? pagina,
    String? error,
    String? busqueda,
    String? aulaId,
    int? grado,
    Rendimiento? rendimiento,
    String? orden,
    int? numeroPagina,
    bool filtros = false,
  }) => EstadoAlumnos(
    cargando: cargando ?? this.cargando,
    pagina: pagina ?? this.pagina,
    error: error,
    busqueda: busqueda ?? this.busqueda,
    aulaId: filtros ? aulaId : this.aulaId,
    grado: filtros ? grado : this.grado,
    rendimiento: filtros ? rendimiento : this.rendimiento,
    orden: orden ?? this.orden,
    numeroPagina: numeroPagina ?? this.numeroPagina,
  );

  @override
  List<Object?> get props => [
    cargando,
    pagina,
    error,
    busqueda,
    aulaId,
    grado,
    rendimiento,
    orden,
    numeroPagina,
  ];
}

/// Listado paginado con búsqueda y filtros. Todo se resuelve en el servidor.
class AlumnosCubit extends Cubit<EstadoAlumnos> {
  AlumnosCubit(this._repositorio, {String? aulaInicial})
    : super(EstadoAlumnos(aulaId: aulaInicial));

  final RepositorioDocente _repositorio;
  static const tamanoPagina = 10;

  Future<void> cargar() async {
    emit(state.copiar(cargando: true));
    try {
      final pagina = await _repositorio.alumnos(
        busqueda: state.busqueda,
        aulaId: state.aulaId,
        grado: state.grado,
        rendimiento: state.rendimiento,
        orden: state.orden,
        pagina: state.numeroPagina,
        tamano: tamanoPagina,
      );
      if (!isClosed) emit(state.copiar(cargando: false, pagina: pagina));
    } on ExcepcionApi catch (e) {
      if (!isClosed) {
        emit(state.copiar(cargando: false, error: mensajeDeError(e)));
      }
    }
  }

  /// Cambiar un filtro vuelve a la primera página.
  Future<void> filtrar({
    String? busqueda,
    String? aulaId,
    int? grado,
    Rendimiento? rendimiento,
    String? orden,
    bool limpiarAula = false,
    bool limpiarGrado = false,
    bool limpiarRendimiento = false,
  }) {
    emit(
      state.copiar(
        busqueda: busqueda ?? state.busqueda,
        orden: orden ?? state.orden,
        numeroPagina: 1,
        filtros: true,
        aulaId: limpiarAula ? null : (aulaId ?? state.aulaId),
        grado: limpiarGrado ? null : (grado ?? state.grado),
        rendimiento: limpiarRendimiento
            ? null
            : (rendimiento ?? state.rendimiento),
      ),
    );
    return cargar();
  }

  Future<void> irAPagina(int pagina) {
    emit(state.copiar(numeroPagina: pagina));
    return cargar();
  }
}

// ------------------------------------------------------------------ Ficha del estudiante

class FichaCubit extends CubitCarga<FichaEstudiante> {
  FichaCubit(this._repositorio, this.estudianteId);

  final RepositorioDocente _repositorio;
  final String estudianteId;
  PeriodoConsulta periodo = const PeriodoConsulta.ultimos(30);

  @override
  Future<FichaEstudiante> obtener() =>
      _repositorio.ficha(estudianteId, periodo);

  Future<void> cambiarPeriodo(PeriodoConsulta nuevo) {
    periodo = nuevo;
    return cargar();
  }
}

class EstadoActividad extends Equatable {
  const EstadoActividad({
    required this.anio,
    required this.mes,
    this.dias = const [],
    this.cargando = true,
    this.error,
    this.diaElegido,
  });

  final int anio;
  final int mes;
  final List<DiaActividad> dias;
  final bool cargando;
  final String? error;
  final DateTime? diaElegido;

  @override
  List<Object?> get props => [anio, mes, dias, cargando, error, diaElegido];
}

/// Calendario mensual de actividad. La ausencia de actividad no se interpreta como bajo rendimiento.
class ActividadCubit extends Cubit<EstadoActividad> {
  ActividadCubit(this._repositorio, this.estudianteId, DateTime hoy)
    : super(EstadoActividad(anio: hoy.year, mes: hoy.month));

  final RepositorioDocente _repositorio;
  final String estudianteId;

  Future<void> cargar() async {
    emit(EstadoActividad(anio: state.anio, mes: state.mes));
    try {
      final dias = await _repositorio.actividad(
        estudianteId,
        state.anio,
        state.mes,
      );
      if (!isClosed) {
        emit(
          EstadoActividad(
            anio: state.anio,
            mes: state.mes,
            dias: dias,
            cargando: false,
          ),
        );
      }
    } on ExcepcionApi catch (e) {
      if (!isClosed) {
        emit(
          EstadoActividad(
            anio: state.anio,
            mes: state.mes,
            cargando: false,
            error: mensajeDeError(e),
          ),
        );
      }
    }
  }

  Future<void> cambiarMes(int delta) {
    final nuevo = DateTime(state.anio, state.mes + delta);
    emit(EstadoActividad(anio: nuevo.year, mes: nuevo.month));
    return cargar();
  }

  void elegirDia(DateTime dia) => emit(
    EstadoActividad(
      anio: state.anio,
      mes: state.mes,
      dias: state.dias,
      cargando: state.cargando,
      diaElegido: dia,
    ),
  );
}

class DetalleMateriaCubit extends CubitCarga<DetalleMateria> {
  DetalleMateriaCubit(this._repositorio, this.estudianteId, this.asignaturaId);

  final RepositorioDocente _repositorio;
  final String estudianteId;
  final int asignaturaId;

  @override
  Future<DetalleMateria> obtener() =>
      _repositorio.detalleMateria(estudianteId, asignaturaId);
}

// ------------------------------------------------------------------ Estadísticas de clase y ranking

class ClaseCubit extends CubitCarga<EstadisticasClase> {
  ClaseCubit(
    this._repositorio,
    this.aulaId, {
    this.periodo = const PeriodoConsulta.ultimos(30),
  });

  final RepositorioDocente _repositorio;
  final String aulaId;
  PeriodoConsulta periodo;

  @override
  Future<EstadisticasClase> obtener() => _repositorio.clase(aulaId, periodo);

  Future<void> cambiarPeriodo(PeriodoConsulta nuevo) {
    periodo = nuevo;
    return cargar();
  }
}

class EstadoRanking extends Equatable {
  const EstadoRanking({
    this.cargando = true,
    this.filas = const [],
    this.error,
    this.aulaId,
    this.materiaId,
  });

  final bool cargando;
  final List<FilaRanking> filas;
  final String? error;
  final String? aulaId;
  final int? materiaId;

  @override
  List<Object?> get props => [cargando, filas, error, aulaId, materiaId];
}

class RankingCubit extends Cubit<EstadoRanking> {
  RankingCubit(this._repositorio) : super(const EstadoRanking());

  final RepositorioDocente _repositorio;

  Future<void> cargar({String? aulaId, int? materiaId}) async {
    emit(EstadoRanking(aulaId: aulaId, materiaId: materiaId));
    try {
      final filas = await _repositorio.ranking(
        aulaId: aulaId,
        asignaturaId: materiaId,
      );
      if (!isClosed) {
        emit(
          EstadoRanking(
            cargando: false,
            filas: filas,
            aulaId: aulaId,
            materiaId: materiaId,
          ),
        );
      }
    } on ExcepcionApi catch (e) {
      if (!isClosed) {
        emit(
          EstadoRanking(
            cargando: false,
            error: mensajeDeError(e),
            aulaId: aulaId,
            materiaId: materiaId,
          ),
        );
      }
    }
  }
}
