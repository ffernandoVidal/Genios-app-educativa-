using System;
using System.Collections.Generic;

namespace GENIOS.Infrastructure.Persistence.Entities;

public partial class ConfiguracionesUsuario
{
    public Guid UsuarioId { get; set; }

    public bool SonidoActivado { get; set; }

    public bool MusicaActivada { get; set; }

    public bool AnimacionesActivadas { get; set; }

    public string Accesibilidad { get; set; } = null!;

    public DateTime ActualizadoEn { get; set; }

    public virtual Usuarios Usuario { get; set; } = null!;
}
