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

class EstudianteDeAula extends Equatable {
  const EstudianteDeAula({
    required this.id,
    required this.nombreMostrar,
    required this.nombreUsuario,
  });

  final String id;
  final String nombreMostrar;
  final String? nombreUsuario;

  @override
  List<Object?> get props => [id, nombreMostrar, nombreUsuario];
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

  /// `GET /aulas/{id}/estudiantes`
  Future<List<EstudianteDeAula>> estudiantes(String aulaId);

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
