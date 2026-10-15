import '../../../core/red/cliente_api.dart';
import '../dominio/repositorio_docente.dart';

class RepositorioDocenteApi implements RepositorioDocente {
  RepositorioDocenteApi(this._api);

  final ClienteApi _api;

  // ------------------------------------------------------------ Clases

  @override
  Future<List<AulaDocente>> aulas() async {
    final datos = await _api.obtener('/aulas/mi-aula') as List<dynamic>;
    return datos.map((a) => _aula(a as Map<String, dynamic>)).toList();
  }

  @override
  Future<AulaDocente> crearAula({
    required String nombre,
    int? grado,
    String? seccion,
    String? descripcion,
  }) async => _aula(
    await _api.enviar('/aulas', {
      'nombre': nombre,
      'grado': grado,
      'seccion': seccion,
      'descripcion': descripcion,
    }) as Map<String, dynamic>,
  );

  @override
  Future<AulaDocente> editarAula(
    String aulaId, {
    String? nombre,
    int? grado,
    String? seccion,
    String? descripcion,
  }) async => _aula(
    await _api.modificar('/aulas/$aulaId', {
      'nombre': nombre,
      'grado': grado,
      'seccion': seccion,
      'descripcion': descripcion,
    }) as Map<String, dynamic>,
  );

  @override
  Future<void> archivarAula(String aulaId) =>
      _api.enviar('/aulas/$aulaId/archivar');

  // ------------------------------------------------------------ Alumnos

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
    String estudianteId,
    String nombreUsuario,
  ) async {
    final j = await _api.enviar(
      '/aulas/$aulaId/estudiantes/$estudianteId/restablecer-contrasena',
    ) as Map<String, dynamic>;
    return CodigoActivacion(
      nombreUsuario: nombreUsuario,
      codigo: j['codigo'] as String,
      expiraEn: DateTime.parse(j['expiraEn'] as String),
    );
  }

  // ------------------------------------------------------------ Estadísticas

  @override
  Future<ResumenDocente> resumen(PeriodoConsulta periodo) async {
    final j = await _api.obtener(
      '/docente/resumen?${periodo.consulta}',
    ) as Map<String, dynamic>;
    return ResumenDocente(
      clasesActivas: j['clasesActivas'] as int,
      estudiantesAsignados: j['estudiantesAsignados'] as int,
      estudiantesActivosRecientes: j['estudiantesActivosRecientes'] as int,
      promedioAciertos: _numero(j['promedioAciertos']),
      rendimiento: Rendimiento.de(j['rendimiento'] as String?),
      partidasCompletadas: j['partidasCompletadas'] as int,
    );
  }

  @override
  Future<PaginaEstudiantes> alumnos({
    String? busqueda,
    String? aulaId,
    int? grado,
    Rendimiento? rendimiento,
    String orden = 'nombre',
    int pagina = 1,
    int tamano = 10,
    PeriodoConsulta periodo = const PeriodoConsulta.ultimos(30),
  }) async {
    final consulta = [
      if (busqueda != null && busqueda.trim().isNotEmpty)
        'q=${Uri.encodeQueryComponent(busqueda.trim())}',
      if (aulaId != null) 'aulaId=$aulaId',
      if (grado != null) 'grado=$grado',
      if (rendimiento != null) 'rendimiento=${rendimiento.codigo}',
      'orden=$orden',
      'pagina=$pagina',
      'tamano=$tamano',
      periodo.consulta,
    ].join('&');
    final j = await _api.obtener(
      '/docente/estudiantes?$consulta',
    ) as Map<String, dynamic>;
    return PaginaEstudiantes(
      filas: (j['elementos'] as List<dynamic>)
          .map((e) => _fila(e as Map<String, dynamic>))
          .toList(),
      pagina: j['pagina'] as int,
      tamano: j['tamano'] as int,
      total: j['total'] as int,
    );
  }

  @override
  Future<FichaEstudiante> ficha(
    String estudianteId,
    PeriodoConsulta periodo,
  ) async {
    final j = await _api.obtener(
      '/docente/estudiantes/$estudianteId/estadisticas?${periodo.consulta}',
    ) as Map<String, dynamic>;
    return FichaEstudiante(
      id: j['estudianteId'] as String,
      nombreMostrar: j['nombreMostrar'] as String,
      aulas: _aulasBreves(j['aulas']),
      ultimaActividad: _fecha(j['ultimaActividadEn']),
      partidasCompletadas: j['partidasCompletadas'] as int,
      partidasAprobadas: j['partidasAprobadas'] as int,
      promedioAciertos: _numero(j['promedioAciertos']),
      rendimiento: Rendimiento.de(j['rendimiento'] as String?),
      tiempoMedioSegundos: j['tiempoMedioSegundos'] as int?,
      misionesCompletadas: j['misionesCompletadas'] as int,
      leccionesAprobadas: j['leccionesAprobadas'] as int,
      variacion: _numero(j['variacionPuntosPorcentuales']),
      promedioGrupo: _numero(j['promedioGrupoAciertos']),
      materias: (j['materias'] as List<dynamic>).map((m) {
        final x = m as Map<String, dynamic>;
        return MateriaEstadistica(
          asignaturaId: (x['asignaturaId'] as num).toInt(),
          nombre: x['nombre'] as String,
          promedioAciertos: _numero(x['promedioAciertos']),
          rendimiento: Rendimiento.de(x['rendimiento'] as String?),
          partidas: x['partidas'] as int,
          variacion: _numero(x['variacionPuntosPorcentuales']),
        );
      }).toList(),
      partidasPorDia: (j['partidasPorDia'] as List<dynamic>).map((d) {
        final x = d as Map<String, dynamic>;
        return PuntoDia(
          fecha: DateTime.parse(x['fecha'] as String),
          partidas: x['partidas'] as int,
        );
      }).toList(),
    );
  }

  @override
  Future<List<DiaActividad>> actividad(
    String estudianteId,
    int anio,
    int mes,
  ) async {
    final j = await _api.obtener(
      '/docente/estudiantes/$estudianteId/actividad?anio=$anio&mes=$mes',
    ) as Map<String, dynamic>;
    return (j['dias'] as List<dynamic>).map((d) {
      final x = d as Map<String, dynamic>;
      return DiaActividad(
        fecha: DateTime.parse(x['fecha'] as String),
        partidas: x['partidas'] as int,
        tiempoActivoSegundos: x['tiempoActivoSegundos'] as int,
        materias: (x['materias'] as List<dynamic>).cast<String>(),
      );
    }).toList();
  }

  @override
  Future<DetalleMateria> detalleMateria(
    String estudianteId,
    int asignaturaId,
  ) async {
    final j = await _api.obtener(
      '/docente/estudiantes/$estudianteId/materias/$asignaturaId',
    ) as Map<String, dynamic>;
    return DetalleMateria(
      nombre: j['nombre'] as String,
      promedioAciertos: _numero(j['promedioAciertos']),
      rendimiento: Rendimiento.de(j['rendimiento'] as String?),
      partidas: j['partidas'] as int,
      tiempoMedioSegundos: j['tiempoMedioSegundos'] as int?,
      misionesTrabajadas: j['misionesTrabajadas'] as int,
      leccionesAprobadas: j['leccionesAprobadas'] as int,
      leccionesPendientes: j['leccionesPendientes'] as int,
      lecciones: (j['lecciones'] as List<dynamic>).map((l) {
        final x = l as Map<String, dynamic>;
        return LeccionEstado(
          nombre: x['nombre'] as String,
          aprobada: x['aprobada'] as bool,
          intentos: x['intentos'] as int,
          mejorAciertos: x['mejorAciertos'] as int?,
        );
      }).toList(),
      historial: (j['historial'] as List<dynamic>).map((h) {
        final x = h as Map<String, dynamic>;
        return Evaluacion(
          fecha: DateTime.parse(x['fecha'] as String),
          leccion: x['leccion'] as String,
          aciertos: x['aciertos'] as int,
          evaluadas: x['evaluadas'] as int,
          porcentaje: _numero(x['porcentaje']) ?? 0,
          rendimiento: Rendimiento.de(x['rendimiento'] as String?),
        );
      }).toList(),
      errores: (j['erroresFrecuentes'] as List<dynamic>).map((e) {
        final x = e as Map<String, dynamic>;
        return ErrorFrecuente(
          enunciado: x['enunciado'] as String,
          errores: x['errores'] as int,
          veces: x['veces'] as int,
        );
      }).toList(),
    );
  }

  @override
  Future<EstadisticasClase> clase(
    String aulaId,
    PeriodoConsulta periodo,
  ) async {
    final j = await _api.obtener(
      '/docente/aulas/$aulaId/estadisticas?${periodo.consulta}',
    ) as Map<String, dynamic>;
    final d = j['distribucion'] as Map<String, dynamic>;
    return EstadisticasClase(
      aulaId: j['aulaId'] as String,
      nombre: j['nombre'] as String,
      totalEstudiantes: j['totalEstudiantes'] as int,
      estudiantesActivos: j['estudiantesActivos'] as int,
      partidasCompletadas: j['partidasCompletadas'] as int,
      promedioAciertos: _numero(j['promedioAciertos']),
      rendimiento: Rendimiento.de(j['rendimiento'] as String?),
      refuerzo: d['refuerzo'] as int,
      repaso: d['repaso'] as int,
      aprobado: d['aprobado'] as int,
      sinDatos: d['sinDatos'] as int,
      materias: (j['materiasPorDificultad'] as List<dynamic>).map((m) {
        final x = m as Map<String, dynamic>;
        return MateriaClase(
          nombre: x['nombre'] as String,
          promedioAciertos: _numero(x['promedioAciertos']),
          rendimiento: Rendimiento.de(x['rendimiento'] as String?),
          partidas: x['partidas'] as int,
        );
      }).toList(),
      semanas: (j['evolucionSemanal'] as List<dynamic>).map((s) {
        final x = s as Map<String, dynamic>;
        return SemanaClase(
          inicio: DateTime.parse(x['inicio'] as String),
          partidas: x['partidas'] as int,
          promedioAciertos: _numero(x['promedioAciertos']),
        );
      }).toList(),
    );
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
        porcentajeAciertos: _numero(j['porcentajeAciertos']) ?? 0,
      );
    }).toList();
  }

  // ------------------------------------------------------------ Conversión

  FilaEstudiante _fila(Map<String, dynamic> j) => FilaEstudiante(
    id: j['estudianteId'] as String,
    nombreMostrar: j['nombreMostrar'] as String,
    nombreUsuario: j['nombreUsuario'] as String?,
    aulas: _aulasBreves(j['aulas']),
    grado: (j['grado'] as num?)?.toInt(),
    ultimaActividad: _fecha(j['ultimaActividadEn']),
    partidas: j['partidasCompletadas'] as int,
    promedioAciertos: _numero(j['promedioAciertos']),
    rendimiento: Rendimiento.de(j['rendimiento'] as String?),
  );

  List<AulaBreve> _aulasBreves(dynamic datos) =>
      (datos as List<dynamic>).map((a) {
        final x = a as Map<String, dynamic>;
        return AulaBreve(
          id: x['id'] as String,
          nombre: x['nombre'] as String,
          grado: (x['grado'] as num?)?.toInt(),
        );
      }).toList();

  AulaDocente _aula(Map<String, dynamic> j) => AulaDocente(
    id: j['id'] as String,
    nombre: j['nombre'] as String,
    codigoAcceso: j['codigoAcceso'] as String?,
    grado: (j['grado'] as num?)?.toInt(),
    seccion: j['seccion'] as String?,
    descripcion: j['descripcion'] as String?,
    totalEstudiantes: (j['totalEstudiantes'] as num?)?.toInt() ?? 0,
  );

  double? _numero(dynamic v) => (v as num?)?.toDouble();

  DateTime? _fecha(dynamic v) => v == null ? null : DateTime.parse(v as String);
}
