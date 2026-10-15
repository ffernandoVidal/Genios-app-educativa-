/// Error de comunicación con la API, con un mensaje apto para mostrar a una niña o un niño.
class ExcepcionApi implements Exception {
  const ExcepcionApi(
    this.mensaje, {
    this.estado,
    this.codigo,
    this.sinConexion = false,
  });

  const ExcepcionApi.sinConexion()
    : mensaje =
          'No pudimos conectarnos. Revisa tu internet e inténtalo de nuevo.',
      estado = null,
      codigo = null,
      sinConexion = true;

  final String mensaje;

  /// Código HTTP, si hubo respuesta.
  final int? estado;

  /// Código estable del servidor (por ejemplo `categoria_bloqueada`).
  final String? codigo;

  final bool sinConexion;

  @override
  String toString() => 'ExcepcionApi($estado, $codigo): $mensaje';
}
