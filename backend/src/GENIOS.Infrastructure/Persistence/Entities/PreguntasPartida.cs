using System;
using System.Collections.Generic;

namespace GENIOS.Infrastructure.Persistence.Entities;

/// <summary>
/// Instantanea de lo que se mostro al estudiante; permite conservar preguntas generadas.
/// </summary>
public partial class PreguntasPartida
{
    public Guid Id { get; set; }

    public Guid PartidaId { get; set; }

    public long? PreguntaId { get; set; }

    public string TipoOrigen { get; set; } = null!;

    public long? ReglaGeneracionId { get; set; }

    public short Posicion { get; set; }

    public string EnunciadoInstantanea { get; set; } = null!;

    public string OpcionesInstantanea { get; set; } = null!;

    public string DatosGeneracion { get; set; } = null!;

    public string Dificultad { get; set; } = null!;

    public bool? PrimeraRespuestaCorrecta { get; set; }

    public DateTime? EvaluadaEn { get; set; }

    public int? TiempoLimiteSegundos { get; set; }

    public DateTime CreadaEn { get; set; }

    public virtual ICollection<IntentosRespuesta> IntentosRespuesta { get; set; } = new List<IntentosRespuesta>();

    public virtual Partidas Partida { get; set; } = null!;

    public virtual Preguntas? Pregunta { get; set; }

    public virtual ReglasGeneracionPreguntas? ReglaGeneracion { get; set; }

    public virtual RespuestasCorrectasPartida? RespuestasCorrectasPartida { get; set; }
}
