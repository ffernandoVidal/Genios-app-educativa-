using System;
using System.Collections.Generic;

namespace GENIOS.Infrastructure.Persistence.Entities;

public partial class PoliticasTiempoUso
{
    public long Id { get; set; }

    public string Nombre { get; set; } = null!;

    public int MinutosDiarios { get; set; }

    public bool Activa { get; set; }

    public string AplicaA { get; set; } = null!;

    public Guid? CreadaPor { get; set; }

    public DateTime CreadaEn { get; set; }

    public virtual ICollection<AsignacionesPoliticaTiempo> AsignacionesPoliticaTiempo { get; set; } = new List<AsignacionesPoliticaTiempo>();

    public virtual Usuarios? CreadaPorNavigation { get; set; }
}
