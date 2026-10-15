import 'package:genios_app/core/red/excepcion_api.dart';
import 'package:genios_app/features/acceso/dominio/repositorio_acceso.dart';
import 'package:genios_app/features/catalogo/dominio/modelos_catalogo.dart';
import 'package:genios_app/features/catalogo/dominio/repositorio_catalogo.dart';

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
  int sesionesInvitado = 0;
  int cierres = 0;
  String? ultimoUsuario;

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
    return const ResultadoAcceso(tokenAcceso: 'TOKEN', roles: ['estudiante']);
  }

  @override
  Future<void> cerrarSesion() async => cierres++;
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
