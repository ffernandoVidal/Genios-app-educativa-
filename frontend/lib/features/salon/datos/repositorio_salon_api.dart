import '../../../core/red/cliente_api.dart';
import '../dominio/repositorio_salon.dart';

class RepositorioSalonApi implements RepositorioSalon {
  RepositorioSalonApi(this._api);

  final ClienteApi _api;

  @override
  Future<List<AulaSalon>> misAulas() async {
    final datos = await _api.obtener('/aulas/mi-aula') as List<dynamic>;
    return datos.map((a) => _aula(a as Map<String, dynamic>)).toList();
  }

  @override
  Future<AulaSalon> unirse(String codigoAula) async => _aula(
    await _api.enviar('/aulas/unirse', {'codigoAula': codigoAula})
        as Map<String, dynamic>,
  );

  AulaSalon _aula(Map<String, dynamic> j) => AulaSalon(
    id: j['id'] as String,
    nombre: j['nombre'] as String,
    estado: j['estado'] as String,
  );
}
