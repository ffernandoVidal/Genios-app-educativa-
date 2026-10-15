/// Reglas del apodo de un invitado. Es solo un nombre para mostrar: no es una credencial ni se envía al servidor.
class ValidacionApodo {
  const ValidacionApodo._();

  static const int largoMinimo = 2;
  static const int largoMaximo = 20;

  static final RegExp _permitidos = RegExp(
    r'^[\p{L}\p{N} _.\-]+$',
    unicode: true,
  );

  /// Devuelve el mensaje de error para mostrar, o null si el apodo es válido.
  static String? validar(String? texto) {
    final apodo = (texto ?? '').trim();
    if (apodo.isEmpty) return 'Escribe tu nombre o un apodo.';
    if (apodo.length < largoMinimo) {
      return 'Tu nombre necesita al menos $largoMinimo letras.';
    }
    if (apodo.length > largoMaximo) return 'Usa $largoMaximo letras o menos.';
    if (!_permitidos.hasMatch(apodo)) {
      return 'Usa solo letras, números y espacios.';
    }
    return null;
  }
}
