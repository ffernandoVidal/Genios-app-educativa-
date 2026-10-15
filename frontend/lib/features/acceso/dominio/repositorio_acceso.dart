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

abstract class RepositorioAcceso {
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

  Future<void> cerrarSesion();
}
