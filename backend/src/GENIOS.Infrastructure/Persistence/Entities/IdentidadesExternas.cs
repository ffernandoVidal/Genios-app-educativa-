using System;
using System.Collections.Generic;

namespace GENIOS.Infrastructure.Persistence.Entities;

public partial class IdentidadesExternas
{
    public Guid Id { get; set; }

    public Guid UsuarioId { get; set; }

    public string Proveedor { get; set; } = null!;

    public string IdentificadorExterno { get; set; } = null!;

    public string? CorreoProveedor { get; set; }

    public DateTime CreadoEn { get; set; }

    public virtual Usuarios Usuario { get; set; } = null!;
}
