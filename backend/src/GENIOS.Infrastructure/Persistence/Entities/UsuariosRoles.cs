using System;
using System.Collections.Generic;

namespace GENIOS.Infrastructure.Persistence.Entities;

public partial class UsuariosRoles
{
    public Guid UsuarioId { get; set; }

    public long RolId { get; set; }

    public DateTime AsignadoEn { get; set; }

    public Guid? AsignadoPor { get; set; }

    public virtual Usuarios? AsignadoPorNavigation { get; set; }

    public virtual Roles Rol { get; set; } = null!;

    public virtual Usuarios Usuario { get; set; } = null!;
}
