using System;
using System.Collections.Generic;

namespace GENIOS.Infrastructure.Persistence.Entities;

public partial class Aulas
{
    public Guid Id { get; set; }

    public Guid DocenteId { get; set; }

    public string Nombre { get; set; } = null!;

    public string? Descripcion { get; set; }

    /// <summary>
    /// Formato propuesto: una letra mayuscula seguida de cuatro digitos.
    /// </summary>
    public string CodigoAcceso { get; set; } = null!;

    public string Estado { get; set; } = null!;

    public DateTime CreadaEn { get; set; }

    public DateTime? EliminadaEn { get; set; }

    /// <summary>Grado escolar de la clase (1 a 6). Opcional.</summary>
    public short? Grado { get; set; }

    public string? Seccion { get; set; }

    public virtual Usuarios Docente { get; set; } = null!;

    public virtual ICollection<MiembrosAula> MiembrosAula { get; set; } = new List<MiembrosAula>();

    public virtual ICollection<SolicitudesAula> SolicitudesAula { get; set; } = new List<SolicitudesAula>();
}
