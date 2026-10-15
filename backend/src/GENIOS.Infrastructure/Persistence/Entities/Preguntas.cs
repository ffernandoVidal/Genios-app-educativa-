using System;
using System.Collections.Generic;

namespace GENIOS.Infrastructure.Persistence.Entities;

public partial class Preguntas
{
    public long Id { get; set; }

    public long CategoriaId { get; set; }

    public string? Codigo { get; set; }

    public string TipoPregunta { get; set; } = null!;

    public string Enunciado { get; set; } = null!;

    public string? Explicacion { get; set; }

    public string Dificultad { get; set; } = null!;

    public int Version { get; set; }

    public string? Fuente { get; set; }

    public bool Activa { get; set; }

    public DateTime CreadaEn { get; set; }

    public DateTime ActualizadaEn { get; set; }

    public virtual Categorias Categoria { get; set; } = null!;

    public virtual ClavesRespuesta? ClavesRespuesta { get; set; }

    public virtual ICollection<OpcionesPregunta> OpcionesPregunta { get; set; } = new List<OpcionesPregunta>();

    public virtual ICollection<PreguntasPartida> PreguntasPartida { get; set; } = new List<PreguntasPartida>();

    public virtual ICollection<RecursosPregunta> RecursosPregunta { get; set; } = new List<RecursosPregunta>();
}
