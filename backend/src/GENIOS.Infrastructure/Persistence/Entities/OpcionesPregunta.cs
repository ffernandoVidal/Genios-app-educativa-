using System;
using System.Collections.Generic;

namespace GENIOS.Infrastructure.Persistence.Entities;

public partial class OpcionesPregunta
{
    public long Id { get; set; }

    public long PreguntaId { get; set; }

    public string? CodigoOpcion { get; set; }

    public string TextoOpcion { get; set; } = null!;

    public short OrdenVisual { get; set; }

    public string? RecursoUrl { get; set; }

    public bool Activa { get; set; }

    public virtual Preguntas Pregunta { get; set; } = null!;
}
