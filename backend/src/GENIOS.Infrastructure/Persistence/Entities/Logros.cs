using System;
using System.Collections.Generic;

namespace GENIOS.Infrastructure.Persistence.Entities;

public partial class Logros
{
    public long Id { get; set; }

    public string Codigo { get; set; } = null!;

    public string Nombre { get; set; } = null!;

    public string Descripcion { get; set; } = null!;

    public string? IconoUrl { get; set; }

    public string Criterio { get; set; } = null!;

    public int PuntosBono { get; set; }

    public bool Activo { get; set; }

    public virtual ICollection<EstudiantesLogros> EstudiantesLogros { get; set; } = new List<EstudiantesLogros>();
}
