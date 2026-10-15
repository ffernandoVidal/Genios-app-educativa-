import '../../../core/estado/estado_carga.dart';
import '../../catalogo/dominio/modelos_catalogo.dart';
import '../../catalogo/dominio/repositorio_catalogo.dart';

/// Busca, en la misma materia, la misión que sigue a la recién jugada y que el servidor deja jugar.
/// El estado (disponible o en progreso) lo informa la API: aquí nunca se decide qué se desbloquea.
class SiguienteMisionCubit extends CubitCarga<Mision?> {
  SiguienteMisionCubit(
    this._repositorio,
    this._asignaturaId,
    this._categoriaActualId,
  );

  final RepositorioCatalogo _repositorio;
  final int _asignaturaId;
  final int _categoriaActualId;

  int get asignaturaId => _asignaturaId;

  @override
  Future<Mision?> obtener() async {
    if (_asignaturaId < 0) {
      return null; // no se sabe de qué materia viene la misión
    }
    final mapa = await _repositorio.mapa(_asignaturaId);
    for (final nivel in mapa.niveles) {
      final indice = nivel.misiones.indexWhere(
        (m) => m.id == _categoriaActualId,
      );
      if (indice == -1) continue;
      for (final candidata in nivel.misiones.skip(indice + 1)) {
        if (candidata.estado == EstadoMision.disponible ||
            candidata.estado == EstadoMision.enProgreso) {
          return candidata;
        }
      }
    }
    return null;
  }
}
