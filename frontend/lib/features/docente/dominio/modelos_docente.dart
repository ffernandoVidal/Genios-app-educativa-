import 'package:equatable/equatable.dart';

/// Nivel de rendimiento. Lo decide el servidor (`ReglasRendimiento`); aquí solo se interpreta su código.
enum Rendimiento {
  refuerzo('refuerzo', 'REFUERZO'),
  repaso('repaso', 'REPASO'),
  aprobado('aprobado', 'APROBADO'),
  sinDatos('sin_datos', 'SIN DATOS');

  const Rendimiento(this.codigo, this.etiqueta);

  final String codigo;
  final String etiqueta;

  static Rendimiento de(String? codigo) => Rendimiento.values.firstWhere(
    (r) => r.codigo == codigo,
    orElse: () => Rendimiento.sinDatos,
  );
}

class AulaDocente extends Equatable {
  const AulaDocente({
    required this.id,
    required this.nombre,
    required this.codigoAcceso,
    this.grado,
    this.seccion,
    this.descripcion,
    this.totalEstudiantes = 0,
  });

  final String id;
  final String nombre;

  /// Código que los estudiantes escriben en «Salón». Solo lo ve el docente dueño del aula.
  final String? codigoAcceso;
  final int? grado;
  final String? seccion;
  final String? descripcion;
  final int totalEstudiantes;

  String get detalle => [
    if (grado != null) '$grado.º grado',
    if (seccion != null && seccion!.isNotEmpty) 'sección $seccion',
  ].join(' · ');

  @override
  List<Object?> get props => [
    id,
    nombre,
    codigoAcceso,
    grado,
    seccion,
    descripcion,
    totalEstudiantes,
  ];
}

class AulaBreve extends Equatable {
  const AulaBreve({required this.id, required this.nombre, this.grado});

  final String id;
  final String nombre;
  final int? grado;

  @override
  List<Object?> get props => [id, nombre, grado];
}

class ResumenDocente extends Equatable {
  const ResumenDocente({
    required this.clasesActivas,
    required this.estudiantesAsignados,
    required this.estudiantesActivosRecientes,
    required this.promedioAciertos,
    required this.rendimiento,
    required this.partidasCompletadas,
  });

  final int clasesActivas;
  final int estudiantesAsignados;
  final int estudiantesActivosRecientes;
  final double? promedioAciertos;
  final Rendimiento rendimiento;
  final int partidasCompletadas;

  @override
  List<Object?> get props => [
    clasesActivas,
    estudiantesAsignados,
    estudiantesActivosRecientes,
    promedioAciertos,
    rendimiento,
    partidasCompletadas,
  ];
}

class FilaEstudiante extends Equatable {
  const FilaEstudiante({
    required this.id,
    required this.nombreMostrar,
    required this.nombreUsuario,
    required this.aulas,
    required this.grado,
    required this.ultimaActividad,
    required this.partidas,
    required this.promedioAciertos,
    required this.rendimiento,
  });

  final String id;
  final String nombreMostrar;
  final String? nombreUsuario;
  final List<AulaBreve> aulas;
  final int? grado;
  final DateTime? ultimaActividad;
  final int partidas;
  final double? promedioAciertos;
  final Rendimiento rendimiento;

  @override
  List<Object?> get props => [
    id,
    nombreMostrar,
    nombreUsuario,
    aulas,
    grado,
    ultimaActividad,
    partidas,
    promedioAciertos,
    rendimiento,
  ];
}

class PaginaEstudiantes extends Equatable {
  const PaginaEstudiantes({
    required this.filas,
    required this.pagina,
    required this.tamano,
    required this.total,
  });

  final List<FilaEstudiante> filas;
  final int pagina;
  final int tamano;
  final int total;

  int get paginas => total == 0 ? 1 : (total / tamano).ceil();

  @override
  List<Object?> get props => [filas, pagina, tamano, total];
}

class MateriaEstadistica extends Equatable {
  const MateriaEstadistica({
    required this.asignaturaId,
    required this.nombre,
    required this.promedioAciertos,
    required this.rendimiento,
    required this.partidas,
    required this.variacion,
  });

  final int asignaturaId;
  final String nombre;
  final double? promedioAciertos;
  final Rendimiento rendimiento;
  final int partidas;

  /// Puntos porcentuales respecto al período anterior; null si ese período no tiene partidas.
  final double? variacion;

  @override
  List<Object?> get props => [
    asignaturaId,
    nombre,
    promedioAciertos,
    rendimiento,
    partidas,
    variacion,
  ];
}

class PuntoDia extends Equatable {
  const PuntoDia({required this.fecha, required this.partidas});

  final DateTime fecha;
  final int partidas;

  @override
  List<Object?> get props => [fecha, partidas];
}

class FichaEstudiante extends Equatable {
  const FichaEstudiante({
    required this.id,
    required this.nombreMostrar,
    required this.aulas,
    required this.ultimaActividad,
    required this.partidasCompletadas,
    required this.partidasAprobadas,
    required this.promedioAciertos,
    required this.rendimiento,
    required this.tiempoMedioSegundos,
    required this.misionesCompletadas,
    required this.leccionesAprobadas,
    required this.variacion,
    required this.promedioGrupo,
    required this.materias,
    required this.partidasPorDia,
  });

  final String id;
  final String nombreMostrar;
  final List<AulaBreve> aulas;
  final DateTime? ultimaActividad;
  final int partidasCompletadas;
  final int partidasAprobadas;
  final double? promedioAciertos;
  final Rendimiento rendimiento;
  final int? tiempoMedioSegundos;
  final int misionesCompletadas;
  final int leccionesAprobadas;
  final double? variacion;
  final double? promedioGrupo;
  final List<MateriaEstadistica> materias;
  final List<PuntoDia> partidasPorDia;

  @override
  List<Object?> get props => [
    id,
    nombreMostrar,
    aulas,
    ultimaActividad,
    partidasCompletadas,
    partidasAprobadas,
    promedioAciertos,
    rendimiento,
    tiempoMedioSegundos,
    misionesCompletadas,
    leccionesAprobadas,
    variacion,
    promedioGrupo,
    materias,
    partidasPorDia,
  ];
}

class DiaActividad extends Equatable {
  const DiaActividad({
    required this.fecha,
    required this.partidas,
    required this.tiempoActivoSegundos,
    required this.materias,
  });

  final DateTime fecha;
  final int partidas;
  final int tiempoActivoSegundos;
  final List<String> materias;

  @override
  List<Object?> get props => [fecha, partidas, tiempoActivoSegundos, materias];
}

class LeccionEstado extends Equatable {
  const LeccionEstado({
    required this.nombre,
    required this.aprobada,
    required this.intentos,
    required this.mejorAciertos,
  });

  final String nombre;
  final bool aprobada;
  final int intentos;
  final int? mejorAciertos;

  @override
  List<Object?> get props => [nombre, aprobada, intentos, mejorAciertos];
}

class Evaluacion extends Equatable {
  const Evaluacion({
    required this.fecha,
    required this.leccion,
    required this.aciertos,
    required this.evaluadas,
    required this.porcentaje,
    required this.rendimiento,
  });

  final DateTime fecha;
  final String leccion;
  final int aciertos;
  final int evaluadas;
  final double porcentaje;
  final Rendimiento rendimiento;

  @override
  List<Object?> get props => [
    fecha,
    leccion,
    aciertos,
    evaluadas,
    porcentaje,
    rendimiento,
  ];
}

class ErrorFrecuente extends Equatable {
  const ErrorFrecuente({
    required this.enunciado,
    required this.errores,
    required this.veces,
  });

  final String enunciado;
  final int errores;
  final int veces;

  @override
  List<Object?> get props => [enunciado, errores, veces];
}

class DetalleMateria extends Equatable {
  const DetalleMateria({
    required this.nombre,
    required this.promedioAciertos,
    required this.rendimiento,
    required this.partidas,
    required this.tiempoMedioSegundos,
    required this.misionesTrabajadas,
    required this.leccionesAprobadas,
    required this.leccionesPendientes,
    required this.lecciones,
    required this.historial,
    required this.errores,
  });

  final String nombre;
  final double? promedioAciertos;
  final Rendimiento rendimiento;
  final int partidas;
  final int? tiempoMedioSegundos;
  final int misionesTrabajadas;
  final int leccionesAprobadas;
  final int leccionesPendientes;
  final List<LeccionEstado> lecciones;
  final List<Evaluacion> historial;
  final List<ErrorFrecuente> errores;

  @override
  List<Object?> get props => [
    nombre,
    promedioAciertos,
    rendimiento,
    partidas,
    tiempoMedioSegundos,
    misionesTrabajadas,
    leccionesAprobadas,
    leccionesPendientes,
    lecciones,
    historial,
    errores,
  ];
}

class MateriaClase extends Equatable {
  const MateriaClase({
    required this.nombre,
    required this.promedioAciertos,
    required this.rendimiento,
    required this.partidas,
  });

  final String nombre;
  final double? promedioAciertos;
  final Rendimiento rendimiento;
  final int partidas;

  @override
  List<Object?> get props => [nombre, promedioAciertos, rendimiento, partidas];
}

class SemanaClase extends Equatable {
  const SemanaClase({
    required this.inicio,
    required this.partidas,
    required this.promedioAciertos,
  });

  final DateTime inicio;
  final int partidas;
  final double? promedioAciertos;

  @override
  List<Object?> get props => [inicio, partidas, promedioAciertos];
}

class EstadisticasClase extends Equatable {
  const EstadisticasClase({
    required this.aulaId,
    required this.nombre,
    required this.totalEstudiantes,
    required this.estudiantesActivos,
    required this.partidasCompletadas,
    required this.promedioAciertos,
    required this.rendimiento,
    required this.refuerzo,
    required this.repaso,
    required this.aprobado,
    required this.sinDatos,
    required this.materias,
    required this.semanas,
  });

  final String aulaId;
  final String nombre;
  final int totalEstudiantes;
  final int estudiantesActivos;
  final int partidasCompletadas;
  final double? promedioAciertos;
  final Rendimiento rendimiento;
  final int refuerzo;
  final int repaso;
  final int aprobado;
  final int sinDatos;
  final List<MateriaClase> materias;
  final List<SemanaClase> semanas;

  @override
  List<Object?> get props => [
    aulaId,
    nombre,
    totalEstudiantes,
    estudiantesActivos,
    partidasCompletadas,
    promedioAciertos,
    rendimiento,
    refuerzo,
    repaso,
    aprobado,
    sinDatos,
    materias,
    semanas,
  ];
}

class FilaRanking extends Equatable {
  const FilaRanking({
    required this.posicion,
    required this.nombreMostrar,
    required this.nombreUsuario,
    required this.aulas,
    required this.puntos,
    required this.partidas,
    required this.porcentajeAciertos,
  });

  final int posicion;
  final String nombreMostrar;
  final String? nombreUsuario;
  final List<String> aulas;
  final int puntos;
  final int partidas;
  final double porcentajeAciertos;

  @override
  List<Object?> get props => [
    posicion,
    nombreMostrar,
    nombreUsuario,
    aulas,
    puntos,
    partidas,
    porcentajeAciertos,
  ];
}

/// Código temporal de un solo uso para que el estudiante elija su contraseña.
class CodigoActivacion extends Equatable {
  const CodigoActivacion({
    required this.nombreUsuario,
    required this.codigo,
    required this.expiraEn,
  });

  final String nombreUsuario;
  final String codigo;
  final DateTime expiraEn;

  @override
  List<Object?> get props => [nombreUsuario, codigo, expiraEn];
}

/// Período de consulta en días locales. Con [dias] se cuenta hacia atrás desde hoy.
class PeriodoConsulta extends Equatable {
  const PeriodoConsulta.ultimos(int this.dias) : desde = null, hasta = null;
  const PeriodoConsulta.rango(DateTime this.desde, DateTime this.hasta)
    : dias = null;

  final int? dias;
  final DateTime? desde;
  final DateTime? hasta;

  String get consulta {
    String f(DateTime d) =>
        '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
    return dias != null
        ? 'dias=$dias'
        : 'desde=${f(desde!)}&hasta=${f(hasta!)}';
  }

  @override
  List<Object?> get props => [dias, desde, hasta];
}
