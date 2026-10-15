using System;
using System.Collections.Generic;

namespace GENIOS.Infrastructure.Persistence.Entities;

public partial class MiembrosAula
{
    public Guid AulaId { get; set; }

    public Guid EstudianteId { get; set; }

    public DateTime UnidoEn { get; set; }

    public DateTime? RetiradoEn { get; set; }

    public string Estado { get; set; } = null!;

    public virtual Aulas Aula { get; set; } = null!;

    public virtual Usuarios Estudiante { get; set; } = null!;
}
