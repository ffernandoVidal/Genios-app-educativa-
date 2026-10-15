using System;
using System.Collections.Generic;

namespace GENIOS.Infrastructure.Persistence.Entities;

public partial class VerificacionesCorreo
{
    public Guid Id { get; set; }

    public Guid UsuarioId { get; set; }

    public string TokenHash { get; set; } = null!;

    public DateTime CreadoEn { get; set; }

    public DateTime ExpiraEn { get; set; }

    public DateTime? UtilizadoEn { get; set; }

    public virtual Usuarios Usuario { get; set; } = null!;
}
