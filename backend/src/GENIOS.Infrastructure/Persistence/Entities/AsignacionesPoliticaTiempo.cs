using System;
using System.Collections.Generic;

namespace GENIOS.Infrastructure.Persistence.Entities;

public partial class AsignacionesPoliticaTiempo
{
    public long Id { get; set; }

    public long PoliticaId { get; set; }

    public Guid EstudianteId { get; set; }

    public Guid? AsignadaPor { get; set; }

    public DateTime ActivaDesde { get; set; }

    public DateTime? ActivaHasta { get; set; }

    public virtual Usuarios? AsignadaPorNavigation { get; set; }

    public virtual Usuarios Estudiante { get; set; } = null!;

    public virtual PoliticasTiempoUso Politica { get; set; } = null!;
}
