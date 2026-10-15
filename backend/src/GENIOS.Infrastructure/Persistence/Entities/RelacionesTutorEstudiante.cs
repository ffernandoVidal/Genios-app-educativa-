using System;
using System.Collections.Generic;

namespace GENIOS.Infrastructure.Persistence.Entities;

public partial class RelacionesTutorEstudiante
{
    public Guid Id { get; set; }

    public Guid TutorId { get; set; }

    public Guid EstudianteId { get; set; }

    public string Estado { get; set; } = null!;

    public string MetodoVinculacion { get; set; } = null!;

    public DateTime SolicitadoEn { get; set; }

    public DateTime? ConfirmadoEn { get; set; }

    public DateTime? RevocadoEn { get; set; }

    public virtual Usuarios Estudiante { get; set; } = null!;

    public virtual Usuarios Tutor { get; set; } = null!;
}
