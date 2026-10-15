using System;
using System.Collections.Generic;

namespace GENIOS.Infrastructure.Persistence.Entities;

public partial class PerfilesEstudiante
{
    public Guid UsuarioId { get; set; }

    public DateOnly? FechaNacimiento { get; set; }

    public string? NombreApodo { get; set; }

    public string? GradoEscolar { get; set; }

    public bool Activo { get; set; }

    public DateTime CreadoEn { get; set; }

    public virtual Usuarios Usuario { get; set; } = null!;
}
