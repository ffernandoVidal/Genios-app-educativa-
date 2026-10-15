using System;
using System.Collections.Generic;

namespace GENIOS.Infrastructure.Persistence.Entities;

public partial class SesionesJuego
{
    public Guid Id { get; set; }

    public Guid? UsuarioId { get; set; }

    public Guid? SesionInvitadoId { get; set; }

    public DateTime IniciadaEn { get; set; }

    public DateTime UltimaActividadEn { get; set; }

    public DateTime? FinalizadaEn { get; set; }

    public string Estado { get; set; } = null!;

    public string? DispositivoTipo { get; set; }

    public string? VersionAplicacion { get; set; }

    public virtual ICollection<Partidas> Partidas { get; set; } = new List<Partidas>();

    public virtual SesionesInvitado? SesionInvitado { get; set; }

    public virtual Usuarios? Usuario { get; set; }
}
