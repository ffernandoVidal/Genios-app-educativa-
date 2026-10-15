using System;
using System.Collections.Generic;

namespace GENIOS.Infrastructure.Persistence.Entities;

public partial class PerfilesDocente
{
    public Guid UsuarioId { get; set; }

    public string? Institucion { get; set; }

    public string? CorreoEducativo { get; set; }

    public DateTime? VerificadoEn { get; set; }

    public DateTime CreadoEn { get; set; }

    public virtual Usuarios Usuario { get; set; } = null!;
}
