using System;
using System.Collections.Generic;

namespace GENIOS.Infrastructure.Persistence.Entities;

public partial class EventosPartida
{
    public long Id { get; set; }

    public Guid PartidaId { get; set; }

    public string TipoEvento { get; set; } = null!;

    public string DatosEvento { get; set; } = null!;

    public DateTime OcurridoEn { get; set; }

    public virtual Partidas Partida { get; set; } = null!;
}
