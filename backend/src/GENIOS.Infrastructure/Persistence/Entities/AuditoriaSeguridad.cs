using System;
using System.Collections.Generic;
using System.Net;

namespace GENIOS.Infrastructure.Persistence.Entities;

public partial class AuditoriaSeguridad
{
    public long Id { get; set; }

    public Guid? UsuarioId { get; set; }

    public string Accion { get; set; } = null!;

    public string? Entidad { get; set; }

    public string? IdentificadorEntidad { get; set; }

    public IPAddress? DireccionIp { get; set; }

    public string? AgenteUsuario { get; set; }

    public string Detalles { get; set; } = null!;

    public DateTime OcurridoEn { get; set; }

    public virtual Usuarios? Usuario { get; set; }
}
