using System;
using System.Collections.Generic;

namespace GENIOS.Infrastructure.Persistence.Entities;

public partial class EstudiantesLogros
{
    public Guid UsuarioId { get; set; }

    public long LogroId { get; set; }

    public DateTime ObtenidoEn { get; set; }

    public Guid? PartidaId { get; set; }

    public virtual Logros Logro { get; set; } = null!;

    public virtual Partidas? Partida { get; set; }

    public virtual Usuarios Usuario { get; set; } = null!;
}
