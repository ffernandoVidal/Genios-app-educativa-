import 'modelos_partida.dart';

abstract class RepositorioPartida {
  /// Crea la partida (o devuelve la misma si se repite con la misma clave).
  Future<PartidaEnCurso> crear(int categoriaId, String claveOperacion);

  Future<PartidaEnCurso> obtener(String partidaId);

  Future<RespuestaServidor> responder(
    String partidaId,
    String preguntaId,
    String opcionId,
    String claveOperacion,
  );

  Future<ResultadoPartida> resultado(String partidaId);

  Future<void> abandonar(String partidaId);
}
