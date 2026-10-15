class ResultadoAcceso {
  const ResultadoAcceso({required this.tokenAcceso, required this.roles});

  final String tokenAcceso;
  final List<String> roles;
}

abstract class RepositorioAcceso {
  /// Crea (o reutiliza, si el navegador ya tiene la cookie) la sesión de invitado.
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
