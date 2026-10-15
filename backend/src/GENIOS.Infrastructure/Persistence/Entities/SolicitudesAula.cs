using System;
using System.Collections.Generic;

namespace GENIOS.Infrastructure.Persistence.Entities;

public partial class SolicitudesAula
{
    public Guid Id { get; set; }

    public Guid AulaId { get; set; }

    public Guid EstudianteId { get; set; }

    public string Estado { get; set; } = null!;

    public DateTime SolicitadaEn { get; set; }

    public DateTime? ResueltaEn { get; set; }

    public Guid? ResueltaPor { get; set; }

    public virtual Aulas Aula { get; set; } = null!;

    public virtual Usuarios Estudiante { get; set; } = null!;

    public virtual Usuarios? ResueltaPorNavigation { get; set; }
}
