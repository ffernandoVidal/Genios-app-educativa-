/// Configuración por entorno. Se cambia al compilar: `--dart-define=URL_API=https://api.ejemplo.com`.
/// Nunca contiene secretos: la app no conoce credenciales de la base de datos.
class Configuracion {
  const Configuracion._();

  static const String urlApi = String.fromEnvironment(
    'URL_API',
    defaultValue: 'http://localhost:5136',
  );

  /// Client ID público de Google (acceso docente): `--dart-define=GOOGLE_CLIENT_ID=...`. No es un secreto.
  /// Vacío = el acceso con Google se muestra como no disponible.
  static const String googleClientId = String.fromEnvironment(
    'GOOGLE_CLIENT_ID',
  );

  /// Prefijo versionado de todas las rutas de la API.
  static const String urlBaseApi = '$urlApi/api/v1';
}
