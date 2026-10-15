using System;
using System.Collections.Generic;

namespace GENIOS.Infrastructure.Persistence.Entities;

public partial class IntentosRespuesta
{
    public Guid Id { get; set; }

    public Guid PreguntaPartidaId { get; set; }

    public short NumeroIntento { get; set; }

    public string RespuestaUsuario { get; set; } = null!;

    public bool EsCorrecta { get; set; }

    public int TiempoRespuestaMs { get; set; }

    public DateTime IniciadaEn { get; set; }

    public DateTime RespondidaEn { get; set; }

    public int PuntosOtorgados { get; set; }

    public Guid? ClaveIdempotencia { get; set; }

    public virtual PreguntasPartida PreguntaPartida { get; set; } = null!;
}
