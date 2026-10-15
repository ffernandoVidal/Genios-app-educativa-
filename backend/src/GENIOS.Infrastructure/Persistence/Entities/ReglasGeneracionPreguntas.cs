using System;
using System.Collections.Generic;

namespace GENIOS.Infrastructure.Persistence.Entities;

public partial class ReglasGeneracionPreguntas
{
    public long Id { get; set; }

    public long CategoriaId { get; set; }

    public string Codigo { get; set; } = null!;

    public string Nombre { get; set; } = null!;

    public int Version { get; set; }

    public string Dificultad { get; set; } = null!;

    public string Parametros { get; set; } = null!;

    public bool Activa { get; set; }

    public DateTime CreadoEn { get; set; }

    public virtual Categorias Categoria { get; set; } = null!;

    public virtual ICollection<Partidas> Partidas { get; set; } = new List<Partidas>();

    public virtual ICollection<PreguntasPartida> PreguntasPartida { get; set; } = new List<PreguntasPartida>();
}
