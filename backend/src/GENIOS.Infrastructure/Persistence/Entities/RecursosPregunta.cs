using System;
using System.Collections.Generic;

namespace GENIOS.Infrastructure.Persistence.Entities;

public partial class RecursosPregunta
{
    public long Id { get; set; }

    public long PreguntaId { get; set; }

    public string TipoRecurso { get; set; } = null!;

    public string UrlRecurso { get; set; } = null!;

    public string? TextoAlternativo { get; set; }

    public short OrdenVisual { get; set; }

    public string Metadatos { get; set; } = null!;

    public virtual Preguntas Pregunta { get; set; } = null!;
}
