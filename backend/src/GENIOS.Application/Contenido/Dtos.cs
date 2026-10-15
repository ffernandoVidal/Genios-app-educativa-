namespace GENIOS.Application.Contenido;

public record AsignaturaDto(long Id, string Codigo, string Nombre, string? Descripcion);

public record NivelDto(long Id, string Nombre, int NumeroOrden);

/// <summary>
/// Bloqueada = hay una categoría anterior en el nivel sin completar. Es null cuando no se sabe quién consulta.
/// </summary>
public record CategoriaDto(long Id, string Codigo, string Nombre, string? Descripcion, int NumeroOrden, bool? Bloqueada = null);

/// <summary>Completada = al menos una partida con las 10 preguntas resueltas. El porcentaje usa solo el primer intento.</summary>
public record ProgresoCategoriaDto(
    long CategoriaId, bool Completada, int PartidasCompletadas, int PreguntasEvaluadas,
    int AciertosPrimerIntento, decimal PorcentajeAciertos, long PuntosTotales);
