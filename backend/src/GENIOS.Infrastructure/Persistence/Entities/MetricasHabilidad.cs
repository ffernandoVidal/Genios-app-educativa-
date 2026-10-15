using System;
using System.Collections.Generic;

namespace GENIOS.Infrastructure.Persistence.Entities;

public partial class MetricasHabilidad
{
    public long Id { get; set; }

    public Guid UsuarioId { get; set; }

    public long CategoriaId { get; set; }

    public string HabilidadCodigo { get; set; } = null!;

    public decimal NivelEstimado { get; set; }

    public int TotalRespuestas { get; set; }

    public int AciertosPrimerIntento { get; set; }

    public DateTime ActualizadoEn { get; set; }

    public virtual Categorias Categoria { get; set; } = null!;

    public virtual Usuarios Usuario { get; set; } = null!;
}
