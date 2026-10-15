import 'package:genios_app/core/red/excepcion_api.dart';
import 'package:genios_app/core/sesion/sesion_app.dart';
import 'package:genios_app/features/acceso/dominio/repositorio_acceso.dart';
import 'package:genios_app/features/catalogo/dominio/modelos_catalogo.dart';
import 'package:genios_app/features/catalogo/dominio/repositorio_catalogo.dart';
import 'package:genios_app/features/partida/dominio/modelos_partida.dart';
import 'package:genios_app/features/partida/dominio/repositorio_partida.dart';
import 'package:genios_app/features/progreso/dominio/modelos_progreso.dart';
import 'package:genios_app/features/progreso/dominio/repositorio_progreso.dart';
import 'package:genios_app/features/salon/dominio/repositorio_salon.dart';

const materiasDePrueba = [
  Asignatura(id: 1, codigo: 'MATEMATICAS', nombre: 'Matematicas'),
  Asignatura(id: 2, codigo: 'LENGUAJE', nombre: 'Lenguaje'),
  Asignatura(id: 3, codigo: 'CIENCIAS_SOCIALES', nombre: 'Ciencias Sociales'),
  Asignatura(id: 4, codigo: 'CIENCIAS_NATURALES', nombre: 'Ciencias Naturales'),
];

class FalsoCatalogo implements RepositorioCatalogo {
  FalsoCatalogo({
    this.materias = materiasDePrueba,
    this.mapas = const {},
    this.error,
  });

  final List<Asignatura> materias;
  final Map<int, MapaMateria> mapas;

  /// Si no es null, toda consulta falla con este error (se puede quitar para simular que se recupera).
  ExcepcionApi? error;
  int consultas = 0;

  @override
  Future<List<Asignatura>> asignaturas() async {
    consultas++;
    if (error != null) throw error!;
    return materias;
  }

  @override
  Future<MapaMateria> mapa(int asignaturaId) async {
    consultas++;
    if (error != null) throw error!;
    return mapas[asignaturaId] ??
        (throw const ExcepcionApi('No encontramos ese planeta.', estado: 404));
  }
}

class FalsoAcceso implements RepositorioAcceso {
  ExcepcionApi? errorInvitado;
  ExcepcionApi? errorInicioSesion;
  ExcepcionApi? errorRegistro;
  int sesionesInvitado = 0;
  int cierres = 0;
  String? ultimoUsuario;
  String? ultimoCodigoAula;

  @override
  Future<void> crearSesionInvitado() async {
    if (errorInvitado != null) throw errorInvitado!;
    sesionesInvitado++;
  }

  @override
  Future<ResultadoAcceso> iniciarSesionEstudiante(
    String nombreUsuario,
    String contrasena,
  ) async {
    ultimoUsuario = nombreUsuario;
    if (errorInicioSesion != null) throw errorInicioSesion!;
    return const ResultadoAcceso(
      tokenAcceso: 'TOKEN',
      roles: ['estudiante'],
      nombreMostrar: 'Ana',
    );
  }

  @override
  Future<ResultadoAcceso> registrarEstudiante({
    required String codigoAula,
    required String nombreMostrar,
    required String nombreUsuario,
    required String contrasena,
  }) async {
    ultimoCodigoAula = codigoAula;
    if (errorRegistro != null) throw errorRegistro!;
    return const ResultadoAcceso(
      tokenAcceso: 'TOKEN',
      roles: ['estudiante'],
      nombreMostrar: 'Ana',
    );
  }

  ExcepcionApi? errorGoogle;
  String? ultimoIdToken;
  List<String> rolesGoogle = const ['docente'];

  @override
  Future<ResultadoAcceso> iniciarSesionGoogle(String idToken) async {
    ultimoIdToken = idToken;
    if (errorGoogle != null) throw errorGoogle!;
    return ResultadoAcceso(
      tokenAcceso: 'TOKEN',
      roles: rolesGoogle,
      nombreMostrar: 'Profe Rosa',
    );
  }

  @override
  Future<void> cerrarSesion() async => cierres++;
}

/// Partida guionada: dos preguntas; la opción 'a' es la correcta de la prueba (solo este doble lo sabe).
/// Tres errores en la misma pregunta encienden una mecha de [mechaInicial] segundos, como haría el servidor.
class FalsoPartida implements RepositorioPartida {
  FalsoPartida({this.total = 2, this.mechaInicial = 5});

  final int total;
  final int mechaInicial;

  ExcepcionApi? errorAlCrear;
  int fallosDeRed = 0; // los próximos N envíos de respuesta fallan por la red
  int creadas = 0;
  int abandonadas = 0;
  final List<String> clavesRecibidas = [];
  final List<String> clavesDeCreacion = [];
  ResultadoPartida resultadoFinal = const ResultadoPartida(
    estado: 'completada',
    preguntasEvaluadas: 2,
    aciertosPrimerIntento: 2,
    porcentajeAciertos: 100,
    puntosObtenidos: 40,
    esPartidaValida: true,
    categoriaCompletada: true,
  );

  int _actual = 1;
  int _errores = 0;
  int? _mecha;
  bool _venciada = false;

  PartidaEnCurso _estado() => PartidaEnCurso(
    id: 'p1',
    estado: _venciada ? 'tiempo_agotado' : 'en_curso',
    numeroPregunta: _actual,
    totalPreguntas: total,
    segundosMecha: _venciada ? null : _mecha,
    pregunta: _venciada
        ? null
        : Pregunta(
            id: 'q$_actual',
            enunciado: '¿Cuánto es ${_actual + 1} + ${_actual + 1}?',
            opciones: const [
              Opcion(id: 'a', texto: 'Cuatro'),
              Opcion(id: 'b', texto: 'Cinco'),
              Opcion(id: 'c', texto: 'Seis'),
            ],
          ),
  );

  /// Simula que el tiempo pasó y el servidor cerró la partida por la mecha.
  void vencerMecha() => _venciada = true;

  @override
  Future<PartidaEnCurso> crear(int categoriaId, String claveOperacion) async {
    clavesDeCreacion.add(claveOperacion);
    if (errorAlCrear != null) throw errorAlCrear!;
    creadas++;
    _actual = 1; // cada partida nueva empieza desde la primera pregunta
    _errores = 0;
    _mecha = null;
    _venciada = false;
    return _estado();
  }

  @override
  Future<PartidaEnCurso> obtener(String partidaId) async => _estado();

  @override
  Future<RespuestaServidor> responder(
    String partidaId,
    String preguntaId,
    String opcionId,
    String claveOperacion,
  ) async {
    if (fallosDeRed > 0) {
      fallosDeRed--;
      throw const ExcepcionApi.sinConexion();
    }
    if (_venciada) {
      throw const ExcepcionApi(
        'La mecha se agotó y la partida terminó.',
        estado: 409,
        codigo: 'partida_terminada_por_mecha',
      );
    }
    clavesRecibidas.add(claveOperacion);

    if (opcionId == 'a') {
      _errores = 0;
      _mecha = null;
      final ultima = _actual == total;
      if (!ultima) _actual++;
      return RespuestaServidor(
        esCorrecta: true,
        numeroIntento: 1,
        siguienteAccion: ultima ? 'partida_completada' : 'siguiente_pregunta',
        puntosOtorgados: 10,
      );
    }
    _errores++;
    if (_errores >= 3) _mecha ??= mechaInicial;
    return RespuestaServidor(
      esCorrecta: false,
      numeroIntento: _errores,
      siguienteAccion: 'reintentar',
      puntosOtorgados: 0,
      segundosMecha: _mecha,
    );
  }

  @override
  Future<ResultadoPartida> resultado(String partidaId) async => _venciada
      ? const ResultadoPartida(
          estado: 'tiempo_agotado',
          preguntasEvaluadas: 1,
          aciertosPrimerIntento: 0,
          porcentajeAciertos: 0,
          puntosObtenidos: 0,
          esPartidaValida: false,
          categoriaCompletada: false,
        )
      : resultadoFinal;

  @override
  Future<void> abandonar(String partidaId) async => abandonadas++;
}

class FalsoProgreso implements RepositorioProgreso {
  FalsoProgreso({
    this.resumenEstudiante,
    this.progresoEstudiante,
    this.progresoInvitado,
    this.error,
  });

  ResumenJugador? resumenEstudiante;
  VistaProgreso? progresoEstudiante;
  ProgresoInvitado? progresoInvitado;
  ExcepcionApi? error;
  int consultas = 0;

  @override
  Future<ResumenJugador> resumen(ModoSesion modo) async {
    consultas++;
    if (error != null) throw error!;
    if (modo == ModoSesion.invitado) {
      final i = progresoInvitado ?? _invitadoInicial;
      return ResumenJugador(
        esInvitado: true,
        partidasQueCuentan: i.partidasQueCuentan,
        partidasRequeridas: i.partidasRequeridas,
        invitarARegistrarse: i.invitarARegistrarse,
      );
    }
    return resumenEstudiante ??
        const ResumenJugador(
          esInvitado: false,
          puntos: 120,
          minutosRestantes: 85,
        );
  }

  @override
  Future<VistaProgreso> progreso(ModoSesion modo) async {
    if (error != null) throw error!;
    if (modo == ModoSesion.invitado) {
      return progresoInvitado ?? _invitadoInicial;
    }
    return progresoEstudiante ?? _estudianteInicial;
  }

  static const _invitadoInicial = ProgresoInvitado(
    partidasValidas: 1,
    partidasQueCuentan: 1,
    partidasRequeridas: 3,
    invitarARegistrarse: false,
    aviso: 'Si no te registras, tu progreso como invitado no se guardará en una cuenta.',
  );

  static const _estudianteInicial = ProgresoEstudiante(
    puntosTotales: 140,
    porcentajePrimerIntento: 70,
    preguntasCorregidasConReintento: 3,
    partidasCompletadas: 1,
    partidasIncompletas: 1,
    materias: [
      ProgresoMateria(
        nombre: 'Matematicas',
        categoriasTotales: 4,
        categoriasCompletadas: 1,
        porcentajeAciertos: 70,
        puntos: 140,
      ),
      ProgresoMateria(
        nombre: 'Lenguaje',
        categoriasTotales: 0,
        categoriasCompletadas: 0,
        porcentajeAciertos: 0,
        puntos: 0,
      ),
    ],
    recientes: [
      PartidaReciente(
        asignatura: 'Matematicas',
        categoria: 'Restas',
        estado: 'abandonada',
        aciertosPrimerIntento: 2,
        preguntasEvaluadas: 2,
        puntos: 20,
      ),
      PartidaReciente(
        asignatura: 'Matematicas',
        categoria: 'Sumas',
        estado: 'completada',
        aciertosPrimerIntento: 7,
        preguntasEvaluadas: 10,
        puntos: 120,
      ),
    ],
  );
}

MapaMateria mapaDeMatematicas() => const MapaMateria(
  asignatura: Asignatura(id: 1, codigo: 'MATEMATICAS', nombre: 'Matematicas'),
  niveles: [
    NivelConMisiones(
      id: 10,
      nombre: 'Nivel 1',
      misiones: [
        Mision(
          id: 100,
          nombre: 'Sumas',
          numeroOrden: 1,
          estado: EstadoMision.completada,
        ),
        Mision(
          id: 101,
          nombre: 'Restas',
          numeroOrden: 2,
          estado: EstadoMision.enProgreso,
        ),
        Mision(
          id: 102,
          nombre: 'Multiplicaciones',
          numeroOrden: 3,
          estado: EstadoMision.bloqueada,
          requiereNombre: 'Restas',
        ),
        Mision(
          id: 103,
          nombre: 'Divisiones',
          numeroOrden: 4,
          estado: EstadoMision.disponible,
        ),
      ],
    ),
  ],
);

class FalsoSalon implements RepositorioSalon {
  FalsoSalon({List<AulaSalon>? aulas}) : _aulas = aulas ?? [];

  final List<AulaSalon> _aulas;
  ExcepcionApi? errorAlUnirse;
  String? ultimoCodigo;

  @override
  Future<List<AulaSalon>> misAulas() async => List.of(_aulas);

  @override
  Future<AulaSalon> unirse(String codigoAula) async {
    ultimoCodigo = codigoAula;
    if (errorAlUnirse != null) throw errorAlUnirse!;
    final aula = const AulaSalon(
      id: 'a1',
      nombre: 'Aula de la maestra Luz',
      estado: 'activa',
    );
    _aulas.add(aula);
    return aula;
  }
}
