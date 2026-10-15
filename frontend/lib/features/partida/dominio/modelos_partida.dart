import 'package:equatable/equatable.dart';

class Opcion extends Equatable {
  const Opcion({required this.id, required this.texto});

  final String id;
  final String texto;

  @override
  List<Object?> get props => [id, texto];
}

/// Pregunta tal como la entrega el servidor: nunca incluye cuál es la respuesta correcta.
class Pregunta extends Equatable {
  const Pregunta({
    required this.id,
    required this.enunciado,
    required this.opciones,
  });

  final String id;
  final String enunciado;
  final List<Opcion> opciones;

  @override
  List<Object?> get props => [id, enunciado, opciones];
}

class PartidaEnCurso extends Equatable {
  const PartidaEnCurso({
    required this.id,
    required this.estado,
    required this.numeroPregunta,
    required this.totalPreguntas,
    this.pregunta,
    this.segundosMecha,
  });

  final String id;
  final String estado;
  final int numeroPregunta;
  final int totalPreguntas;
  final Pregunta? pregunta;

  /// Segundos que le quedan a la mecha según el servidor; null si no está encendida.
  final int? segundosMecha;

  @override
  List<Object?> get props => [
    id,
    estado,
    numeroPregunta,
    totalPreguntas,
    pregunta,
    segundosMecha,
  ];
}

/// Veredicto del servidor sobre una respuesta.
class RespuestaServidor extends Equatable {
  const RespuestaServidor({
    required this.esCorrecta,
    required this.numeroIntento,
    required this.siguienteAccion,
    required this.puntosOtorgados,
    this.segundosMecha,
  });

  final bool esCorrecta;
  final int numeroIntento;

  /// reintentar, siguiente_pregunta o partida_completada.
  final String siguienteAccion;
  final int puntosOtorgados;
  final int? segundosMecha;

  bool get completaLaPartida => siguienteAccion == 'partida_completada';

  @override
  List<Object?> get props => [
    esCorrecta,
    numeroIntento,
    siguienteAccion,
    puntosOtorgados,
    segundosMecha,
  ];
}

class ResultadoPartida extends Equatable {
  const ResultadoPartida({
    required this.estado,
    required this.preguntasEvaluadas,
    required this.aciertosPrimerIntento,
    required this.porcentajeAciertos,
    required this.puntosObtenidos,
    required this.esPartidaValida,
    required this.categoriaCompletada,
    this.motivoFinalizacion,
  });

  final String estado;
  final int preguntasEvaluadas;
  final int aciertosPrimerIntento;
  final double porcentajeAciertos;
  final int puntosObtenidos;
  final bool esPartidaValida;
  final bool categoriaCompletada;
  final String? motivoFinalizacion;

  bool get terminoPorMecha => estado == 'tiempo_agotado';

  @override
  List<Object?> get props => [
    estado,
    preguntasEvaluadas,
    aciertosPrimerIntento,
    porcentajeAciertos,
    puntosObtenidos,
    esPartidaValida,
    categoriaCompletada,
    motivoFinalizacion,
  ];
}
