import '../../../core/red/excepcion_api.dart';

class ResultadoAcceso {
  const ResultadoAcceso({
    required this.tokenAcceso,
    required this.roles,
    required this.nombreMostrar,
  });

  final String tokenAcceso;
  final List<String> roles;
  final String nombreMostrar;
}

/// Quién es el usuario según el servidor (`GET /usuarios/yo`). El rol siempre viene de aquí, nunca de la app.
class PerfilUsuario {
  const PerfilUsuario({required this.roles, required this.nombreMostrar});

  final List<String> roles;
  final String nombreMostrar;
}

abstract class RepositorioAcceso {
  /// Renueva la sesión con la cookie de renovación. null = no hay sesión de cuenta (401/403).
  /// Red caída o error del servidor lanzan [ExcepcionApi]: no son una sesión vencida.
  Future<ResultadoAcceso?> renovarSesion();

  Future<PerfilUsuario> obtenerPerfil();

  /// true si la cookie de invitado del navegador sigue siendo válida.
  Future<bool> hayInvitadoVigente();

  /// Elige el rol de una identidad nueva de Google: 'estudiante' o 'docente' (permanente). El servidor decide si corresponde.
  Future<ResultadoAcceso> elegirRol(String rol);

  /// Crea (o reutiliza, si el navegador ya tiene la cookie) la sesión de invitado.
  /// La API no recibe ningún dato personal: la identidad de la sesión la genera el servidor.
  Future<void> crearSesionInvitado();

  Future<ResultadoAcceso> iniciarSesionEstudiante(
    String nombreUsuario,
    String contrasena,
  );

  /// Crea la cuenta de un estudiante con el código de aula. La cuenta empieza vacía: no hereda nada del invitado.
  Future<ResultadoAcceso> registrarEstudiante({
    required String codigoAula,
    required String nombreMostrar,
    required String nombreUsuario,
    required String contrasena,
  });

  /// Intercambia la credencial de Google (ID token) por una sesión docente. La API valida el token.
  Future<ResultadoAcceso> iniciarSesionGoogle(String idToken);

  /// El estudiante elige su contraseña con el código que le dio su docente (`POST /estudiantes/restablecimiento-confirmar`).
  Future<void> activarCuenta({
    required String nombreUsuario,
    required String codigo,
    required String contrasenaNueva,
  });

  Future<void> cerrarSesion();
}
