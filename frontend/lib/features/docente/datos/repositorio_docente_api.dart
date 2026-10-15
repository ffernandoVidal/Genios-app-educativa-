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
    final datos = await _api.obtener(
      '/aulas/$aulaId/estadisticas',
    ) as Map<String, dynamic>;
    return (datos['estudiantes'] as List<dynamic>).map((e) {
      final j = e as Map<String, dynamic>;
      return EstudianteDeAula(
        id: j['estudianteId'] as String,
        nombreMostrar: j['nombreMostrar'] as String,
        nombreUsuario: j['nombreUsuario'] as String?,
        partidas: j['partidasCompletadas'] as int,
        porcentajeAciertos: (j['porcentajeAciertos'] as num).toDouble(),
        puntos: (j['puntosTotales'] as num).toInt(),
        ultimaActividad: j['ultimaActividadEn'] == null
            ? null
            : DateTime.parse(j['ultimaActividadEn'] as String),
        porMateria: (j['porAsignatura'] as List<dynamic>).map((m) {
          final x = m as Map<String, dynamic>;
          return ResumenMateria(
            asignaturaId: (x['asignaturaId'] as num).toInt(),
            nombre: x['asignatura'] as String,
            partidas: x['partidasCompletadas'] as int,
            porcentajeAciertos: (x['porcentajeAciertos'] as num).toDouble(),
            puntos: (x['puntos'] as num).toInt(),
          );
        }).toList(),
      );
    }).toList();
  }

  @override
  Future<List<FilaRanking>> ranking({String? aulaId, int? asignaturaId}) async {
    final consulta = [
      if (aulaId != null) 'aulaId=$aulaId',
      if (asignaturaId != null) 'asignaturaId=$asignaturaId',
    ].join('&');
    final datos = await _api.obtener(
      '/aulas/ranking${consulta.isEmpty ? '' : '?$consulta'}',
    ) as Map<String, dynamic>;
    return (datos['filas'] as List<dynamic>).map((f) {
      final j = f as Map<String, dynamic>;
      return FilaRanking(
        posicion: j['posicion'] as int,
        nombreMostrar: j['nombreMostrar'] as String,
        nombreUsuario: j['nombreUsuario'] as String?,
        aulas: (j['aulas'] as List<dynamic>).cast<String>(),
        puntos: (j['puntos'] as num).toInt(),
        partidas: j['partidasCompletadas'] as int,
        porcentajeAciertos: (j['porcentajeAciertos'] as num).toDouble(),
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
