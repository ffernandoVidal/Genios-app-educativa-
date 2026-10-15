/// Datos que la pantalla de misiones entrega a la partida al abrirla (por la ruta, sin pasar por la API).
/// Sirven para titular la partida y, al terminar, proponer la siguiente misión de la misma materia.
class ArgumentosMision {
  const ArgumentosMision({required this.nombre, required this.asignaturaId});

  final String nombre;
  final int asignaturaId;
}
