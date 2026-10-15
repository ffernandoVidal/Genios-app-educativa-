using System;
using System.Collections.Generic;

namespace GENIOS.Infrastructure.Persistence.Entities;

public partial class Usuarios
{
    public Guid Id { get; set; }

    public string? Correo { get; set; }

    public string? CorreoNormalizado { get; set; }

    public string NombreMostrar { get; set; } = null!;

    public string? ContrasenaHash { get; set; }

    public string Estado { get; set; } = null!;

    public DateTime? CorreoConfirmadoEn { get; set; }

    public DateTime? UltimoAccesoEn { get; set; }

    public string ZonaHoraria { get; set; } = null!;

    public DateTime CreadoEn { get; set; }

    public DateTime ActualizadoEn { get; set; }

    public DateTime? EliminadoEn { get; set; }

    public string? NombreUsuario { get; set; }

    public string? NombreUsuarioNormalizado { get; set; }

    public string MetodoRegistro { get; set; } = null!;

    public bool DebeCambiarContrasena { get; set; }

    public virtual ICollection<AsignacionesPoliticaTiempo> AsignacionesPoliticaTiempoAsignadaPorNavigation { get; set; } = new List<AsignacionesPoliticaTiempo>();

    public virtual ICollection<AsignacionesPoliticaTiempo> AsignacionesPoliticaTiempoEstudiante { get; set; } = new List<AsignacionesPoliticaTiempo>();

    public virtual ICollection<AuditoriaSeguridad> AuditoriaSeguridad { get; set; } = new List<AuditoriaSeguridad>();

    public virtual ICollection<Aulas> Aulas { get; set; } = new List<Aulas>();

    public virtual ConfiguracionesUsuario? ConfiguracionesUsuario { get; set; }

    public virtual ICollection<EstudiantesLogros> EstudiantesLogros { get; set; } = new List<EstudiantesLogros>();

    public virtual ICollection<IdentidadesExternas> IdentidadesExternas { get; set; } = new List<IdentidadesExternas>();

    public virtual ICollection<MetricasHabilidad> MetricasHabilidad { get; set; } = new List<MetricasHabilidad>();

    public virtual ICollection<MiembrosAula> MiembrosAula { get; set; } = new List<MiembrosAula>();

    public virtual ICollection<Partidas> Partidas { get; set; } = new List<Partidas>();

    public virtual PerfilesDocente? PerfilesDocente { get; set; }

    public virtual PerfilesEstudiante? PerfilesEstudiante { get; set; }

    public virtual PerfilesTutor? PerfilesTutor { get; set; }

    public virtual ICollection<PoliticasTiempoUso> PoliticasTiempoUso { get; set; } = new List<PoliticasTiempoUso>();

    public virtual ICollection<ProgresoEstudiante> ProgresoEstudiante { get; set; } = new List<ProgresoEstudiante>();

    public virtual ICollection<RelacionesTutorEstudiante> RelacionesTutorEstudianteEstudiante { get; set; } = new List<RelacionesTutorEstudiante>();

    public virtual ICollection<RelacionesTutorEstudiante> RelacionesTutorEstudianteTutor { get; set; } = new List<RelacionesTutorEstudiante>();

    public virtual ICollection<SesionesAutenticacion> SesionesAutenticacion { get; set; } = new List<SesionesAutenticacion>();

    public virtual ICollection<SesionesJuego> SesionesJuego { get; set; } = new List<SesionesJuego>();

    public virtual ICollection<SolicitudesAula> SolicitudesAulaEstudiante { get; set; } = new List<SolicitudesAula>();

    public virtual ICollection<SolicitudesAula> SolicitudesAulaResueltaPorNavigation { get; set; } = new List<SolicitudesAula>();

    public virtual ICollection<TokensRecuperacionContrasena> TokensRecuperacionContrasenaEmitidoPorNavigation { get; set; } = new List<TokensRecuperacionContrasena>();

    public virtual ICollection<TokensRecuperacionContrasena> TokensRecuperacionContrasenaUsuario { get; set; } = new List<TokensRecuperacionContrasena>();

    public virtual ICollection<TransaccionesPuntos> TransaccionesPuntos { get; set; } = new List<TransaccionesPuntos>();

    public virtual ICollection<UsoDiarioEstudiante> UsoDiarioEstudianteEstudiante { get; set; } = new List<UsoDiarioEstudiante>();

    public virtual ICollection<UsoDiarioEstudiante> UsoDiarioEstudianteReiniciadoPorNavigation { get; set; } = new List<UsoDiarioEstudiante>();

    public virtual ICollection<UsuariosRoles> UsuariosRolesAsignadoPorNavigation { get; set; } = new List<UsuariosRoles>();

    public virtual ICollection<UsuariosRoles> UsuariosRolesUsuario { get; set; } = new List<UsuariosRoles>();

    public virtual ICollection<VerificacionesCorreo> VerificacionesCorreo { get; set; } = new List<VerificacionesCorreo>();
}
