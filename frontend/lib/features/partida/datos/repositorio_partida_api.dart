import '../../../core/red/cliente_api.dart';
import '../dominio/modelos_partida.dart';
import '../dominio/repositorio_partida.dart';

class RepositorioPartidaApi implements RepositorioPartida {
  RepositorioPartidaApi(this._api);

  final ClienteApi _api;

  @override
  Future<PartidaEnCurso> crear(int categoriaId, String claveOperacion) async =>
      _partida(
        await _api.enviar('/partidas', {
          'categoriaId': categoriaId,
          'claveOperacion': claveOperacion,
        }),
      );

  @override
  Future<PartidaEnCurso> obtener(String partidaId) async =>
      _partida(await _api.obtener('/partidas/$partidaId'));

  @override
  Future<RespuestaServidor> responder(
    String partidaId,
    String preguntaId,
    String opcionId,
    String claveOperacion,
  ) async {
    final j = await _api.enviar('/partidas/$partidaId/respuestas', {
      'preguntaPresentadaId': preguntaId,
      'opcionSeleccionadaId': opcionId,
      'claveOperacion': claveOperacion,
    }) as Map<String, dynamic>;
    return RespuestaServidor(
      esCorrecta: j['esCorrecta'] as bool,
      numeroIntento: j['numeroIntento'] as int,
      siguienteAccion: j['siguienteAccion'] as String,
      puntosOtorgados: j['puntosOtorgados'] as int,
      segundosMecha: j['segundosMecha'] as int?,
    );
  }

  @override
  Future<ResultadoPartida> resultado(String partidaId) async {
    final j = await _api.obtener(
      '/partidas/$partidaId/resultado',
    ) as Map<String, dynamic>;
    return ResultadoPartida(
      estado: j['estado'] as String,
      preguntasEvaluadas: j['preguntasEvaluadas'] as int,
      aciertosPrimerIntento: j['aciertosPrimerIntento'] as int,
      porcentajeAciertos: (j['porcentajeAciertos'] as num).toDouble(),
      puntosObtenidos: j['puntosObtenidos'] as int,
      esPartidaValida: j['esPartidaValida'] as bool,
      categoriaCompletada: j['categoriaCompletada'] as bool,
      motivoFinalizacion: j['motivoFinalizacion'] as String?,
    );
  }

  @override
  Future<void> abandonar(String partidaId) =>
      _api.enviar('/partidas/$partidaId/abandonar');

  PartidaEnCurso _partida(dynamic datos) {
    final j = datos as Map<String, dynamic>;
    final p = j['pregunta'] as Map<String, dynamic>?;
    return PartidaEnCurso(
      id: j['partidaId'] as String,
      estado: j['estado'] as String,
      numeroPregunta: j['numeroPregunta'] as int,
      totalPreguntas: j['totalPreguntas'] as int,
      segundosMecha: j['segundosMecha'] as int?,
      pregunta: p == null
          ? null
          : Pregunta(
              id: p['preguntaPresentadaId'] as String,
              enunciado: p['enunciado'] as String,
              opciones: (p['opciones'] as List<dynamic>)
                  .map(
                    (o) => Opcion(
                      id: (o as Map<String, dynamic>)['id'] as String,
                      texto: o['texto'] as String,
                    ),
                  )
                  .toList(),
            ),
    );
  }
}
