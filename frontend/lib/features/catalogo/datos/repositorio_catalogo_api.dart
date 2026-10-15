import '../../../core/red/cliente_api.dart';
import '../../../core/red/excepcion_api.dart';
import '../dominio/modelos_catalogo.dart';
import '../dominio/repositorio_catalogo.dart';

class RepositorioCatalogoApi implements RepositorioCatalogo {
  RepositorioCatalogoApi(this._api);

  final ClienteApi _api;

  @override
  Future<List<Asignatura>> asignaturas() async {
    final datos = await _api.obtener('/asignaturas') as List<dynamic>;
    return datos.map((e) => _asignatura(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<MapaMateria> mapa(int asignaturaId) async {
    final materias = await asignaturas();
    final asignatura = materias.where((a) => a.id == asignaturaId).firstOrNull;
    if (asignatura == null) {
      throw const ExcepcionApi('No encontramos ese planeta.', estado: 404);
    }

    final niveles = await _api.obtener(
      '/asignaturas/$asignaturaId/niveles',
    ) as List<dynamic>;
    final resultado = <NivelConMisiones>[];
    for (final nivel in niveles.cast<Map<String, dynamic>>()) {
      final id = nivel['id'] as int;
      final categorias =
          await _api.obtener('/niveles/$id/categorias') as List<dynamic>;
      resultado.add(
        NivelConMisiones(
          id: id,
          nombre: nivel['nombre'] as String,
          misiones: categorias
              .map((c) => _mision(c as Map<String, dynamic>))
              .toList(),
        ),
      );
    }
    return MapaMateria(asignatura: asignatura, niveles: resultado);
  }

  Asignatura _asignatura(Map<String, dynamic> j) => Asignatura(
    id: j['id'] as int,
    codigo: j['codigo'] as String,
    nombre: j['nombre'] as String,
    descripcion: j['descripcion'] as String?,
  );

  Mision _mision(Map<String, dynamic> j) => Mision(
    id: j['id'] as int,
    nombre: j['nombre'] as String,
    numeroOrden: j['numeroOrden'] as int,
    descripcion: j['descripcion'] as String?,
    estado: EstadoMision.desdeTexto(j['estado'] as String?),
    requiereNombre: j['requiereCategoriaNombre'] as String?,
  );
}
