/// Configuración por entorno. Se cambia al compilar: `--dart-define=URL_API=https://api.ejemplo.com`.
/// Nunca contiene secretos: la app no conoce credenciales de la base de datos.
class Configuracion {
  const Configuracion._();

  static const String urlApi = String.fromEnvironment(
    'URL_API',
    defaultValue: 'http://localhost:5136',
  );

  /// Prefijo versionado de todas las rutas de la API.
  static const String urlBaseApi = '$urlApi/api/v1';
}
