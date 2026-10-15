namespace GENIOS.Application.Contenido;

public record AsignaturaDto(long Id, string Codigo, string Nombre, string? Descripcion);

public record NivelDto(long Id, string Nombre, int NumeroOrden);

/// <summary>
/// Estado para quien consulta: bloqueada, disponible, en_progreso o completada (null si no se sabe quién consulta).
/// Si está bloqueada, RequiereCategoria* indica qué categoría hay que completar antes.
/// </summary>
public record CategoriaDto(
    long Id, string Codigo, string Nombre, string? Descripcion, int NumeroOrden,
    string? Estado = null, long? RequiereCategoriaId = null, string? RequiereCategoriaNombre = null);

/// <summary>Completada = al menos una partida con las 10 preguntas resueltas. El porcentaje usa solo el primer intento.</summary>
public record ProgresoCategoriaDto(
    long CategoriaId, bool Completada, int PartidasCompletadas, int PreguntasEvaluadas,
    int AciertosPrimerIntento, decimal PorcentajeAciertos, long PuntosTotales);
