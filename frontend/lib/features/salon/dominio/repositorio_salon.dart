import 'package:equatable/equatable.dart';

class AulaSalon extends Equatable {
  const AulaSalon({
    required this.id,
    required this.nombre,
    required this.estado,
  });

  final String id;
  final String nombre;
  final String estado;

  @override
  List<Object?> get props => [id, nombre, estado];
}

abstract class RepositorioSalon {
  /// Aulas a las que pertenece el estudiante (`GET /aulas/mi-aula`). El servidor decide qué puede ver.
  Future<List<AulaSalon>> misAulas();

  /// Unirse con un código de aula (`POST /aulas/unirse`). El código no sustituye a la contraseña.
  Future<AulaSalon> unirse(String codigoAula);
}
