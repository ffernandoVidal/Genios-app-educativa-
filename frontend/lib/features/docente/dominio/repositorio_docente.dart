import 'modelos_docente.dart';

export 'modelos_docente.dart';

/// Acceso a los datos del Centro de Control Docente. Toda la autorización y todos los cálculos son del servidor.
abstract class RepositorioDocente {
  // ---- Clases (GET/POST/PATCH /aulas)
  Future<List<AulaDocente>> aulas();

  Future<AulaDocente> crearAula({
    required String nombre,
    int? grado,
    String? seccion,
    String? descripcion,
  });

  Future<AulaDocente> editarAula(
    String aulaId, {
    String? nombre,
    int? grado,
    String? seccion,
    String? descripcion,
  });

  /// Eliminación lógica: se conserva el historial académico.
  Future<void> archivarAula(String aulaId);

  // ---- Alumnos
  /// `POST /aulas/{id}/estudiantes`: crea la cuenta del estudiante dentro del aula y devuelve su código de activación.
  Future<CodigoActivacion> agregarEstudiante(
    String aulaId, {
    required String nombreMostrar,
    required String nombreUsuario,
  });

  /// `POST /aulas/{id}/estudiantes/{estudianteId}/restablecer-contrasena`
  Future<CodigoActivacion> nuevoCodigo(
    String aulaId,
    String estudianteId,
    String nombreUsuario,
  );

  // ---- Estadísticas (GET /docente/...)
  Future<ResumenDocente> resumen(PeriodoConsulta periodo);

  Future<PaginaEstudiantes> alumnos({
    String? busqueda,
    String? aulaId,
    int? grado,
    Rendimiento? rendimiento,
    String orden = 'nombre',
    int pagina = 1,
    int tamano = 10,
    PeriodoConsulta periodo = const PeriodoConsulta.ultimos(30),
  });

  Future<FichaEstudiante> ficha(String estudianteId, PeriodoConsulta periodo);

  Future<List<DiaActividad>> actividad(String estudianteId, int anio, int mes);

  Future<DetalleMateria> detalleMateria(String estudianteId, int asignaturaId);

  Future<EstadisticasClase> clase(String aulaId, PeriodoConsulta periodo);

  /// `GET /aulas/ranking`: por puntos, de todas las aulas del docente; filtrable por aula y materia.
  Future<List<FilaRanking>> ranking({String? aulaId, int? asignaturaId});
}
