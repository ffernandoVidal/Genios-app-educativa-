import '../../../core/estado/estado_carga.dart';
import '../dominio/modelos_catalogo.dart';
import '../dominio/repositorio_catalogo.dart';

class UniversoCubit extends CubitCarga<List<Asignatura>> {
  UniversoCubit(this._repositorio);

  final RepositorioCatalogo _repositorio;

  @override
  Future<List<Asignatura>> obtener() => _repositorio.asignaturas();
}

class MapaMateriaCubit extends CubitCarga<MapaMateria> {
  MapaMateriaCubit(this._repositorio, this._asignaturaId);

  final RepositorioCatalogo _repositorio;
  final int _asignaturaId;

  @override
  Future<MapaMateria> obtener() => _repositorio.mapa(_asignaturaId);
}
