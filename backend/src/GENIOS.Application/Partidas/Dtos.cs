namespace GENIOS.Application.Partidas;

public record SolicitudCrearPartida(long CategoriaId, Guid? ClaveOperacion);

public record SolicitudResponder(Guid PreguntaPresentadaId, Guid OpcionSeleccionadaId, Guid ClaveOperacion);

public record OpcionDto(Guid Id, string Texto);

/// <summary>Nunca incluye la respuesta correcta.</summary>
public record PreguntaDto(Guid PreguntaPresentadaId, string Enunciado, string Tipo, IReadOnlyList<OpcionDto> Opciones);

public record PartidaDto(
    Guid PartidaId, string Estado, long CategoriaId, int NumeroPregunta, int TotalPreguntas,
    PreguntaDto? Pregunta, int? SegundosMecha);

/// <summary>SiguienteAccion: reintentar, siguiente_pregunta o partida_completada.</summary>
public record RespuestaDto(
    bool EsCorrecta, int NumeroIntento, bool PuedeReintentar, string SiguienteAccion,
    int PuntosOtorgados, int? SegundosMecha);

public record ResultadoPartidaDto(
    Guid PartidaId, string Estado, int PreguntasEvaluadas, int AciertosPrimerIntento, decimal PorcentajeAciertos,
    int PuntosObtenidos, int TiempoActivoSegundos, bool EsPartidaValida, bool CategoriaCompletada, string? MotivoFinalizacion);
