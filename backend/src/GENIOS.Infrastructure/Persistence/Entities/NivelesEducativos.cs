using System;
using System.Collections.Generic;

namespace GENIOS.Infrastructure.Persistence.Entities;

public partial class NivelesEducativos
{
    public long Id { get; set; }

    public long AsignaturaId { get; set; }

    public string Nombre { get; set; } = null!;

    public int NumeroOrden { get; set; }

    public short? EdadMinima { get; set; }

    public short? EdadMaxima { get; set; }

    public bool Activo { get; set; }

    public virtual Asignaturas Asignatura { get; set; } = null!;

    public virtual ICollection<Categorias> Categorias { get; set; } = new List<Categorias>();
}
