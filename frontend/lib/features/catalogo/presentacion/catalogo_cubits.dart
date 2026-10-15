import '../../../core/estado/estado_carga.dart';
import '../dominio/modelos_catalogo.dart';
import '../dominio/repositorio_catalogo.dart';

class MateriasCubit extends CubitCarga<List<Asignatura>> {
  MateriasCubit(this._repositorio);

  final RepositorioCatalogo _repositorio;

  @override
  Future<List<Asignatura>> obtener() => _repositorio.asignaturas();
}

class MisionesCubit extends CubitCarga<MapaMateria> {
  MisionesCubit(this._repositorio, this._asignaturaId);

  final RepositorioCatalogo _repositorio;
  final int _asignaturaId;

  @override
  Future<MapaMateria> obtener() => _repositorio.mapa(_asignaturaId);
}
