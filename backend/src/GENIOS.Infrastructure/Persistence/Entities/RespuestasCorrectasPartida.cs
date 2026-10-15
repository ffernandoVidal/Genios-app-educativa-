using System;
using System.Collections.Generic;

namespace GENIOS.Infrastructure.Persistence.Entities;

/// <summary>
/// Clave exacta de la pregunta presentada; solo acceso interno del servidor.
/// </summary>
public partial class RespuestasCorrectasPartida
{
    public Guid PreguntaPartidaId { get; set; }

    public string RespuestaCorrecta { get; set; } = null!;

    public string ReglasValidacion { get; set; } = null!;

    public DateTime CreadaEn { get; set; }

    public virtual PreguntasPartida PreguntaPartida { get; set; } = null!;
}
