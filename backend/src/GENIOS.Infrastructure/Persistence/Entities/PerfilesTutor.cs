using System;
using System.Collections.Generic;

namespace GENIOS.Infrastructure.Persistence.Entities;

public partial class PerfilesTutor
{
    public Guid UsuarioId { get; set; }

    public string? NombreCompleto { get; set; }

    public DateTime CreadoEn { get; set; }

    public virtual Usuarios Usuario { get; set; } = null!;
}
