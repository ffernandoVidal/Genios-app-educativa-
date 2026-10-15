using System;
using System.Collections.Generic;

namespace GENIOS.Infrastructure.Persistence.Entities;

public partial class Partidas
{
    public Guid Id { get; set; }

    public Guid? UsuarioId { get; set; }

    public Guid? SesionInvitadoId { get; set; }

    public Guid? SesionJuegoId { get; set; }

    public long CategoriaId { get; set; }

    public long? ReglaGeneracionId { get; set; }

    public string Origen { get; set; } = null!;

    public string Estado { get; set; } = null!;

    /// <summary>
    /// Solo marcar TRUE tras completar las reglas de validacion de partida valida.
    /// </summary>
    public bool EsPartidaValida { get; set; }

    public short CantidadPreguntasPlanificada { get; set; }

    public short CantidadPreguntasEvaluadas { get; set; }

    /// <summary>
    /// El porcentaje educativo se calcula con el primer intento de cada pregunta.
    /// </summary>
    public short AciertosPrimerIntento { get; set; }

    public int PuntosObtenidos { get; set; }

    public long TiempoActivoMs { get; set; }

    public DateTime IniciadaEn { get; set; }

    public DateTime? FinalizadaEn { get; set; }

    public string? MotivoFinalizacion { get; set; }

    public Guid? ClaveIdempotencia { get; set; }

    public string Metadatos { get; set; } = null!;

    public virtual Categorias Categoria { get; set; } = null!;

    public virtual ICollection<EstudiantesLogros> EstudiantesLogros { get; set; } = new List<EstudiantesLogros>();

    public virtual ICollection<EventosPartida> EventosPartida { get; set; } = new List<EventosPartida>();

    public virtual ICollection<PreguntasPartida> PreguntasPartida { get; set; } = new List<PreguntasPartida>();

    public virtual ReglasGeneracionPreguntas? ReglaGeneracion { get; set; }

    public virtual SesionesInvitado? SesionInvitado { get; set; }

    public virtual SesionesJuego? SesionJuego { get; set; }

    public virtual ICollection<TransaccionesPuntos> TransaccionesPuntos { get; set; } = new List<TransaccionesPuntos>();

    public virtual Usuarios? Usuario { get; set; }
}
