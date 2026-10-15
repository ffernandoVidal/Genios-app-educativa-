using System;
using System.Collections.Generic;

namespace GENIOS.Infrastructure.Persistence.Entities;

public partial class Categorias
{
    public long Id { get; set; }

    public long NivelEducativoId { get; set; }

    public string Codigo { get; set; } = null!;

    public string Nombre { get; set; } = null!;

    public string? Descripcion { get; set; }

    public int NumeroOrden { get; set; }

    public bool Activa { get; set; }

    public virtual ICollection<MetricasHabilidad> MetricasHabilidad { get; set; } = new List<MetricasHabilidad>();

    public virtual NivelesEducativos NivelEducativo { get; set; } = null!;

    public virtual ICollection<Partidas> Partidas { get; set; } = new List<Partidas>();

    public virtual ICollection<Preguntas> Preguntas { get; set; } = new List<Preguntas>();

    public virtual ICollection<ProgresoEstudiante> ProgresoEstudiante { get; set; } = new List<ProgresoEstudiante>();

    public virtual ICollection<ReglasGeneracionPreguntas> ReglasGeneracionPreguntas { get; set; } = new List<ReglasGeneracionPreguntas>();
}
