using System;
using System.Collections.Generic;

namespace GENIOS.Infrastructure.Persistence.Entities;

public partial class TransaccionesPuntos
{
    public Guid Id { get; set; }

    public Guid UsuarioId { get; set; }

    public Guid? PartidaId { get; set; }

    public string TipoTransaccion { get; set; } = null!;

    public int Puntos { get; set; }

    public string Motivo { get; set; } = null!;

    public Guid ClaveIdempotencia { get; set; }

    public DateTime CreadoEn { get; set; }

    public virtual Partidas? Partida { get; set; }

    public virtual Usuarios Usuario { get; set; } = null!;
}
