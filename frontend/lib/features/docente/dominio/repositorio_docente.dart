import 'package:equatable/equatable.dart';

class AulaDocente extends Equatable {
  const AulaDocente({
    required this.id,
    required this.nombre,
    required this.codigoAcceso,
  });

  final String id;
  final String nombre;

  /// Código que los estudiantes escriben en «Salón». Solo lo ve el docente dueño del aula.
  final String? codigoAcceso;

  @override
  List<Object?> get props => [id, nombre, codigoAcceso];
}

/// Rendimiento de un estudiante en una materia. Los porcentajes cuentan solo el primer intento.
class ResumenMateria extends Equatable {
  const ResumenMateria({
    required this.asignaturaId,
    required this.nombre,
    required this.partidas,
    required this.porcentajeAciertos,
    required this.puntos,
  });

  final int asignaturaId;
  final String nombre;
  final int partidas;
  final double porcentajeAciertos;
  final int puntos;

  @override
  List<Object?> get props => [
    asignaturaId,
    nombre,
    partidas,
    porcentajeAciertos,
    puntos,
  ];
}

/// Estudiante de un aula con sus estadísticas (calculadas por el servidor).
class EstudianteDeAula extends Equatable {
  const EstudianteDeAula({
    required this.id,
    required this.nombreMostrar,
    required this.nombreUsuario,
    this.partidas = 0,
    this.porcentajeAciertos = 0,
    this.puntos = 0,
    this.ultimaActividad,
    this.porMateria = const [],
  });

  final String id;
  final String nombreMostrar;
  final String? nombreUsuario;
  final int partidas;
  final double porcentajeAciertos;
  final int puntos;
  final DateTime? ultimaActividad;
  final List<ResumenMateria> porMateria;

  @override
  List<Object?> get props => [
    id,
    nombreMostrar,
    nombreUsuario,
    partidas,
    porcentajeAciertos,
    puntos,
    ultimaActividad,
    porMateria,
  ];
}

class FilaRanking extends Equatable {
  const FilaRanking({
    required this.posicion,
    required this.nombreMostrar,
    required this.nombreUsuario,
    required this.aulas,
    required this.puntos,
    required this.partidas,
    required this.porcentajeAciertos,
  });

  final int posicion;
  final String nombreMostrar;
  final String? nombreUsuario;
  final List<String> aulas;
  final int puntos;
  final int partidas;
  final double porcentajeAciertos;

  @override
  List<Object?> get props => [
    posicion,
    nombreMostrar,
    nombreUsuario,
    aulas,
    puntos,
    partidas,
    porcentajeAciertos,
  ];
}

/// Código temporal de un solo uso para que el estudiante elija su contraseña.
class CodigoActivacion extends Equatable {
  const CodigoActivacion({
    required this.nombreUsuario,
    required this.codigo,
    required this.expiraEn,
  });

  final String nombreUsuario;
  final String codigo;
  final DateTime expiraEn;

  @override
  List<Object?> get props => [nombreUsuario, codigo, expiraEn];
}

abstract class RepositorioDocente {
  /// `GET /aulas/mi-aula`: el servidor devuelve solo las aulas del docente.
  Future<List<AulaDocente>> aulas();

  /// `POST /aulas`
  Future<AulaDocente> crearAula(String nombre);

  /// `GET /aulas/{id}/estadisticas`: estudiantes activos del aula con su rendimiento.
  Future<List<EstudianteDeAula>> estudiantes(String aulaId);

  /// `GET /aulas/ranking`: ranking por puntos de todas las aulas del docente, filtrable por aula y materia.
  Future<List<FilaRanking>> ranking({String? aulaId, int? asignaturaId});

  /// `POST /aulas/{id}/estudiantes`: crea la cuenta del estudiante dentro del aula.
  Future<CodigoActivacion> agregarEstudiante(
    String aulaId, {
    required String nombreMostrar,
    required String nombreUsuario,
  });

  /// `POST /aulas/{id}/estudiantes/{estudianteId}/restablecer-contrasena`
  Future<CodigoActivacion> nuevoCodigo(
    String aulaId,
    EstudianteDeAula estudiante,
  );
}
