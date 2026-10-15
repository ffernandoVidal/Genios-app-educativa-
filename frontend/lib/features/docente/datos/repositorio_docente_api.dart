import '../../../core/red/cliente_api.dart';
import '../dominio/repositorio_docente.dart';

class RepositorioDocenteApi implements RepositorioDocente {
  RepositorioDocenteApi(this._api);

  final ClienteApi _api;

  @override
  Future<List<AulaDocente>> aulas() async {
    final datos = await _api.obtener('/aulas/mi-aula') as List<dynamic>;
    return datos.map((a) => _aula(a as Map<String, dynamic>)).toList();
  }

  @override
  Future<AulaDocente> crearAula(String nombre) async => _aula(
    await _api.enviar('/aulas', {'nombre': nombre}) as Map<String, dynamic>,
  );

  @override
  Future<List<EstudianteDeAula>> estudiantes(String aulaId) async {
    final datos =
        await _api.obtener('/aulas/$aulaId/estudiantes') as List<dynamic>;
    return datos.map((e) {
      final j = e as Map<String, dynamic>;
      return EstudianteDeAula(
        id: j['id'] as String,
        nombreMostrar: j['nombreMostrar'] as String,
        nombreUsuario: j['nombreUsuario'] as String?,
      );
    }).toList();
  }

  @override
  Future<CodigoActivacion> agregarEstudiante(
    String aulaId, {
    required String nombreMostrar,
    required String nombreUsuario,
  }) async {
    final j = await _api.enviar('/aulas/$aulaId/estudiantes', {
      'nombreMostrar': nombreMostrar,
      'nombreUsuario': nombreUsuario,
    }) as Map<String, dynamic>;
    return CodigoActivacion(
      nombreUsuario: j['nombreUsuario'] as String,
      codigo: j['codigoActivacion'] as String,
      expiraEn: DateTime.parse(j['expiraEn'] as String),
    );
  }

  @override
  Future<CodigoActivacion> nuevoCodigo(
    String aulaId,
    EstudianteDeAula estudiante,
  ) async {
    final j = await _api.enviar(
      '/aulas/$aulaId/estudiantes/${estudiante.id}/restablecer-contrasena',
    ) as Map<String, dynamic>;
    return CodigoActivacion(
      nombreUsuario: estudiante.nombreUsuario ?? estudiante.nombreMostrar,
      codigo: j['codigo'] as String,
      expiraEn: DateTime.parse(j['expiraEn'] as String),
    );
  }

  AulaDocente _aula(Map<String, dynamic> j) => AulaDocente(
    id: j['id'] as String,
    nombre: j['nombre'] as String,
    codigoAcceso: j['codigoAcceso'] as String?,
  );
}
