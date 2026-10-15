using System;
using System.Collections.Generic;

namespace GENIOS.Infrastructure.Persistence.Entities;

/// <summary>
/// DATOS PRIVADOS. Nunca incluir en respuestas publicas de la API.
/// </summary>
public partial class ClavesRespuesta
{
    public long PreguntaId { get; set; }

    public string RespuestaCorrecta { get; set; } = null!;

    public string ReglasValidacion { get; set; } = null!;

    public string? ExplicacionCorrecta { get; set; }

    public DateTime ActualizadoEn { get; set; }

    public virtual Preguntas Pregunta { get; set; } = null!;
}
