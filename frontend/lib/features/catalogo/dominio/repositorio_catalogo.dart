import 'modelos_catalogo.dart';

abstract class RepositorioCatalogo {
  Future<List<Asignatura>> asignaturas();

  /// Niveles de la materia con sus misiones y el estado de cada una para quien juega.
  Future<MapaMateria> mapa(int asignaturaId);
}
