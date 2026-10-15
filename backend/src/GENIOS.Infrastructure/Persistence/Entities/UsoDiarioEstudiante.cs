using System;
using System.Collections.Generic;

namespace GENIOS.Infrastructure.Persistence.Entities;

public partial class UsoDiarioEstudiante
{
    public long Id { get; set; }

    public Guid EstudianteId { get; set; }

    public DateOnly FechaLocal { get; set; }

    public string ZonaHoraria { get; set; } = null!;

    /// <summary>
    /// Solo tiempo de juego activo; pausas e inactividad deben excluirse en la API.
    /// </summary>
    public long TiempoActivoMs { get; set; }

    public DateTime? UltimoCalculoEn { get; set; }

    public DateTime? BloqueoHasta { get; set; }

    public Guid? ReiniciadoPor { get; set; }

    public DateTime? ReiniciadoEn { get; set; }

    public DateTime ActualizadoEn { get; set; }

    public virtual Usuarios Estudiante { get; set; } = null!;

    public virtual Usuarios? ReiniciadoPorNavigation { get; set; }
}
