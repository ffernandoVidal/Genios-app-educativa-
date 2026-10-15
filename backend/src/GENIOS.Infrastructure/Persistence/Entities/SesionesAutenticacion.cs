using System;
using System.Collections.Generic;

namespace GENIOS.Infrastructure.Persistence.Entities;

public partial class SesionesAutenticacion
{
    public Guid Id { get; set; }

    public Guid UsuarioId { get; set; }

    public string TokenHash { get; set; } = null!;

    public Guid FamiliaTokenId { get; set; }

    public DateTime CreadoEn { get; set; }

    public DateTime ExpiraEn { get; set; }

    public DateTime? UltimoUsoEn { get; set; }

    public DateTime? RevocadoEn { get; set; }

    public Guid? ReemplazadoPorId { get; set; }

    public virtual ICollection<SesionesAutenticacion> InverseReemplazadoPor { get; set; } = new List<SesionesAutenticacion>();

    public virtual SesionesAutenticacion? ReemplazadoPor { get; set; }

    public virtual Usuarios Usuario { get; set; } = null!;
}
