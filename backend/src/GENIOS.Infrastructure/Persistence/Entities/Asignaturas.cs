using System;
using System.Collections.Generic;

namespace GENIOS.Infrastructure.Persistence.Entities;

public partial class Asignaturas
{
    public long Id { get; set; }

    public string Codigo { get; set; } = null!;

    public string Nombre { get; set; } = null!;

    public string? Descripcion { get; set; }

    public short OrdenVisual { get; set; }

    public bool Activa { get; set; }

    public DateTime CreadoEn { get; set; }

    public virtual ICollection<NivelesEducativos> NivelesEducativos { get; set; } = new List<NivelesEducativos>();
}
