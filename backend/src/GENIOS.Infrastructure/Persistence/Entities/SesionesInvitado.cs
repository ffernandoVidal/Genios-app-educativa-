using System;
using System.Collections.Generic;

namespace GENIOS.Infrastructure.Persistence.Entities;

public partial class SesionesInvitado
{
    public Guid Id { get; set; }

    public string IdentificadorTokenHash { get; set; } = null!;

    public DateTime CreadaEn { get; set; }

    public DateTime UltimaActividadEn { get; set; }

    public DateTime? ExpiraEn { get; set; }

    public string Estado { get; set; } = null!;

    public virtual ICollection<Partidas> Partidas { get; set; } = new List<Partidas>();

    public virtual ICollection<SesionesJuego> SesionesJuego { get; set; } = new List<SesionesJuego>();
}
