import 'package:equatable/equatable.dart';

class Asignatura extends Equatable {
  const Asignatura({
    required this.id,
    required this.codigo,
    required this.nombre,
    this.descripcion,
  });

  final int id;
  final String codigo;
  final String nombre;
  final String? descripcion;

  @override
  List<Object?> get props => [id, codigo, nombre, descripcion];
}

/// Estado de una misión para quien juega. Lo decide el servidor; el cliente solo lo muestra.
enum EstadoMision {
  bloqueada,
  disponible,
  enProgreso,
  completada;

  /// Un valor desconocido se trata como bloqueada: ante la duda no se permite jugar.
  static EstadoMision desdeTexto(String? texto) => switch (texto) {
    'disponible' => EstadoMision.disponible,
    'en_progreso' => EstadoMision.enProgreso,
    'completada' => EstadoMision.completada,
    _ => EstadoMision.bloqueada,
  };
}

class Mision extends Equatable {
  const Mision({
    required this.id,
    required this.nombre,
    required this.numeroOrden,
    required this.estado,
    this.descripcion,
    this.requiereNombre,
  });

  final int id;
  final String nombre;
  final int numeroOrden;
  final EstadoMision estado;
  final String? descripcion;

  /// Si está bloqueada: nombre de la misión que hay que completar antes.
  final String? requiereNombre;

  @override
  List<Object?> get props => [
    id,
    nombre,
    numeroOrden,
    estado,
    descripcion,
    requiereNombre,
  ];
}

class NivelConMisiones extends Equatable {
  const NivelConMisiones({
    required this.id,
    required this.nombre,
    required this.misiones,
  });

  final int id;
  final String nombre;
  final List<Mision> misiones;

  @override
  List<Object?> get props => [id, nombre, misiones];
}

class MapaMateria extends Equatable {
  const MapaMateria({required this.asignatura, required this.niveles});

  final Asignatura asignatura;
  final List<NivelConMisiones> niveles;

  bool get sinMisiones => niveles.every((n) => n.misiones.isEmpty);

  @override
  List<Object?> get props => [asignatura, niveles];
}
