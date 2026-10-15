using System;
using System.Collections.Generic;

namespace GENIOS.Infrastructure.Persistence.Entities;

public partial class ProgresoEstudiante
{
    public long Id { get; set; }

    public Guid UsuarioId { get; set; }

    public long CategoriaId { get; set; }

    public int PartidasCompletadas { get; set; }

    public int PreguntasEvaluadas { get; set; }

    public int AciertosPrimerIntento { get; set; }

    public long PuntosTotales { get; set; }

    public DateTime? UltimaActividadEn { get; set; }

    public DateTime ActualizadoEn { get; set; }

    public virtual Categorias Categoria { get; set; } = null!;

    public virtual Usuarios Usuario { get; set; } = null!;
}
