using System;
using System.Collections.Generic;
using GENIOS.Infrastructure.Persistence.Entities;
using Microsoft.EntityFrameworkCore;

namespace GENIOS.Infrastructure.Persistence.Context;

public partial class GeniosDbContext : DbContext
{
    public GeniosDbContext(DbContextOptions<GeniosDbContext> options)
        : base(options)
    {
    }

    public virtual DbSet<AsignacionesPoliticaTiempo> AsignacionesPoliticaTiempo { get; set; }

    public virtual DbSet<Asignaturas> Asignaturas { get; set; }

    public virtual DbSet<AuditoriaSeguridad> AuditoriaSeguridad { get; set; }

    public virtual DbSet<Aulas> Aulas { get; set; }

    public virtual DbSet<Categorias> Categorias { get; set; }

    public virtual DbSet<ClavesRespuesta> ClavesRespuesta { get; set; }

    public virtual DbSet<ConfiguracionesUsuario> ConfiguracionesUsuario { get; set; }

    public virtual DbSet<EstudiantesLogros> EstudiantesLogros { get; set; }

    public virtual DbSet<EventosPartida> EventosPartida { get; set; }

    public virtual DbSet<IdentidadesExternas> IdentidadesExternas { get; set; }

    public virtual DbSet<IntentosRespuesta> IntentosRespuesta { get; set; }

    public virtual DbSet<Logros> Logros { get; set; }

    public virtual DbSet<MetricasHabilidad> MetricasHabilidad { get; set; }

    public virtual DbSet<MiembrosAula> MiembrosAula { get; set; }

    public virtual DbSet<NivelesEducativos> NivelesEducativos { get; set; }

    public virtual DbSet<OpcionesPregunta> OpcionesPregunta { get; set; }

    public virtual DbSet<Partidas> Partidas { get; set; }

    public virtual DbSet<PerfilesDocente> PerfilesDocente { get; set; }

    public virtual DbSet<PerfilesEstudiante> PerfilesEstudiante { get; set; }

    public virtual DbSet<PerfilesTutor> PerfilesTutor { get; set; }

    public virtual DbSet<PoliticasTiempoUso> PoliticasTiempoUso { get; set; }

    public virtual DbSet<Preguntas> Preguntas { get; set; }

    public virtual DbSet<PreguntasPartida> PreguntasPartida { get; set; }

    public virtual DbSet<ProgresoEstudiante> ProgresoEstudiante { get; set; }

    public virtual DbSet<RecursosPregunta> RecursosPregunta { get; set; }

    public virtual DbSet<ReglasGeneracionPreguntas> ReglasGeneracionPreguntas { get; set; }

    public virtual DbSet<RelacionesTutorEstudiante> RelacionesTutorEstudiante { get; set; }

    public virtual DbSet<RespuestasCorrectasPartida> RespuestasCorrectasPartida { get; set; }

    public virtual DbSet<Roles> Roles { get; set; }

    public virtual DbSet<SesionesAutenticacion> SesionesAutenticacion { get; set; }

    public virtual DbSet<SesionesInvitado> SesionesInvitado { get; set; }

    public virtual DbSet<SesionesJuego> SesionesJuego { get; set; }

    public virtual DbSet<SolicitudesAula> SolicitudesAula { get; set; }

    public virtual DbSet<TokensRecuperacionContrasena> TokensRecuperacionContrasena { get; set; }

    public virtual DbSet<TransaccionesPuntos> TransaccionesPuntos { get; set; }

    public virtual DbSet<UsoDiarioEstudiante> UsoDiarioEstudiante { get; set; }

    public virtual DbSet<Usuarios> Usuarios { get; set; }

    public virtual DbSet<UsuariosRoles> UsuariosRoles { get; set; }

    public virtual DbSet<VerificacionesCorreo> VerificacionesCorreo { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.HasPostgresExtension("pgcrypto");

        modelBuilder.Entity<AsignacionesPoliticaTiempo>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("asignaciones_politica_tiempo_pkey");

            entity.ToTable("asignaciones_politica_tiempo");

            entity.HasIndex(e => new { e.EstudianteId, e.ActivaDesde }, "idx_asignacion_politica_estudiante").IsDescending(false, true);

            entity.Property(e => e.Id)
                .UseIdentityAlwaysColumn()
                .HasColumnName("id");
            entity.Property(e => e.ActivaDesde)
                .HasDefaultValueSql("now()")
                .HasColumnName("activa_desde");
            entity.Property(e => e.ActivaHasta).HasColumnName("activa_hasta");
            entity.Property(e => e.AsignadaPor).HasColumnName("asignada_por");
            entity.Property(e => e.EstudianteId).HasColumnName("estudiante_id");
            entity.Property(e => e.PoliticaId).HasColumnName("politica_id");

            entity.HasOne(d => d.AsignadaPorNavigation).WithMany(p => p.AsignacionesPoliticaTiempoAsignadaPorNavigation)
                .HasForeignKey(d => d.AsignadaPor)
                .OnDelete(DeleteBehavior.SetNull)
                .HasConstraintName("asignaciones_politica_tiempo_asignada_por_fkey");

            entity.HasOne(d => d.Estudiante).WithMany(p => p.AsignacionesPoliticaTiempoEstudiante)
                .HasForeignKey(d => d.EstudianteId)
                .HasConstraintName("asignaciones_politica_tiempo_estudiante_id_fkey");

            entity.HasOne(d => d.Politica).WithMany(p => p.AsignacionesPoliticaTiempo)
                .HasForeignKey(d => d.PoliticaId)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("asignaciones_politica_tiempo_politica_id_fkey");
        });

        modelBuilder.Entity<Asignaturas>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("asignaturas_pkey");

            entity.ToTable("asignaturas");

            entity.HasIndex(e => e.Codigo, "asignaturas_codigo_key").IsUnique();

            entity.HasIndex(e => e.Nombre, "asignaturas_nombre_key").IsUnique();

            entity.Property(e => e.Id)
                .UseIdentityAlwaysColumn()
                .HasColumnName("id");
            entity.Property(e => e.Activa)
                .HasDefaultValue(true)
                .HasColumnName("activa");
            entity.Property(e => e.Codigo)
                .HasMaxLength(40)
                .HasColumnName("codigo");
            entity.Property(e => e.CreadoEn)
                .HasDefaultValueSql("now()")
                .HasColumnName("creado_en");
            entity.Property(e => e.Descripcion).HasColumnName("descripcion");
            entity.Property(e => e.Nombre)
                .HasMaxLength(120)
                .HasColumnName("nombre");
            entity.Property(e => e.OrdenVisual).HasColumnName("orden_visual");
        });

        modelBuilder.Entity<AuditoriaSeguridad>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("auditoria_seguridad_pkey");

            entity.ToTable("auditoria_seguridad");

            entity.HasIndex(e => new { e.Accion, e.OcurridoEn }, "idx_auditoria_accion_fecha").IsDescending(false, true);

            entity.HasIndex(e => new { e.UsuarioId, e.OcurridoEn }, "idx_auditoria_usuario_fecha").IsDescending(false, true);

            entity.Property(e => e.Id)
                .UseIdentityAlwaysColumn()
                .HasColumnName("id");
            entity.Property(e => e.Accion)
                .HasMaxLength(100)
                .HasColumnName("accion");
            entity.Property(e => e.AgenteUsuario).HasColumnName("agente_usuario");
            entity.Property(e => e.Detalles)
                .HasDefaultValueSql("'{}'::jsonb")
                .HasColumnType("jsonb")
                .HasColumnName("detalles");
            entity.Property(e => e.DireccionIp).HasColumnName("direccion_ip");
            entity.Property(e => e.Entidad)
                .HasMaxLength(100)
                .HasColumnName("entidad");
            entity.Property(e => e.IdentificadorEntidad)
                .HasMaxLength(120)
                .HasColumnName("identificador_entidad");
            entity.Property(e => e.OcurridoEn)
                .HasDefaultValueSql("now()")
                .HasColumnName("ocurrido_en");
            entity.Property(e => e.UsuarioId).HasColumnName("usuario_id");

            entity.HasOne(d => d.Usuario).WithMany(p => p.AuditoriaSeguridad)
                .HasForeignKey(d => d.UsuarioId)
                .OnDelete(DeleteBehavior.SetNull)
                .HasConstraintName("auditoria_seguridad_usuario_id_fkey");
        });

        modelBuilder.Entity<Aulas>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("aulas_pkey");

            entity.ToTable("aulas");

            entity.HasIndex(e => e.CodigoAcceso, "aulas_codigo_acceso_key").IsUnique();

            entity.HasIndex(e => new { e.DocenteId, e.Estado }, "idx_aulas_docente_estado");

            entity.Property(e => e.Id)
                .HasDefaultValueSql("gen_random_uuid()")
                .HasColumnName("id");
            entity.Property(e => e.CodigoAcceso)
                .HasMaxLength(5)
                .HasComment("Formato propuesto: una letra mayuscula seguida de cuatro digitos.")
                .HasColumnName("codigo_acceso");
            entity.Property(e => e.CreadaEn)
                .HasDefaultValueSql("now()")
                .HasColumnName("creada_en");
            entity.Property(e => e.Descripcion).HasColumnName("descripcion");
            entity.Property(e => e.DocenteId).HasColumnName("docente_id");
            entity.Property(e => e.EliminadaEn).HasColumnName("eliminada_en");
            entity.Property(e => e.Estado)
                .HasMaxLength(20)
                .HasDefaultValueSql("'activa'::character varying")
                .HasColumnName("estado");
            entity.Property(e => e.Nombre)
                .HasMaxLength(140)
                .HasColumnName("nombre");
            entity.Property(e => e.Grado).HasColumnName("grado");
            entity.Property(e => e.Seccion)
                .HasMaxLength(10)
                .HasColumnName("seccion");

            entity.HasOne(d => d.Docente).WithMany(p => p.Aulas)
                .HasForeignKey(d => d.DocenteId)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("aulas_docente_id_fkey");
        });

        modelBuilder.Entity<Categorias>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("categorias_pkey");

            entity.ToTable("categorias");

            entity.HasIndex(e => new { e.NivelEducativoId, e.Codigo }, "uq_categoria_codigo").IsUnique();

            entity.HasIndex(e => new { e.NivelEducativoId, e.NumeroOrden }, "uq_categoria_orden").IsUnique();

            entity.Property(e => e.Id)
                .UseIdentityAlwaysColumn()
                .HasColumnName("id");
            entity.Property(e => e.Activa)
                .HasDefaultValue(true)
                .HasColumnName("activa");
            entity.Property(e => e.Codigo)
                .HasMaxLength(60)
                .HasColumnName("codigo");
            entity.Property(e => e.Descripcion).HasColumnName("descripcion");
            entity.Property(e => e.NivelEducativoId).HasColumnName("nivel_educativo_id");
            entity.Property(e => e.Nombre)
                .HasMaxLength(140)
                .HasColumnName("nombre");
            entity.Property(e => e.NumeroOrden).HasColumnName("numero_orden");

            entity.HasOne(d => d.NivelEducativo).WithMany(p => p.Categorias)
                .HasForeignKey(d => d.NivelEducativoId)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("categorias_nivel_educativo_id_fkey");
        });

        modelBuilder.Entity<ClavesRespuesta>(entity =>
        {
            entity.HasKey(e => e.PreguntaId).HasName("claves_respuesta_pkey");

            entity.ToTable("claves_respuesta", tb => tb.HasComment("DATOS PRIVADOS. Nunca incluir en respuestas publicas de la API."));

            entity.Property(e => e.PreguntaId)
                .ValueGeneratedNever()
                .HasColumnName("pregunta_id");
            entity.Property(e => e.ActualizadoEn)
                .HasDefaultValueSql("now()")
                .HasColumnName("actualizado_en");
            entity.Property(e => e.ExplicacionCorrecta).HasColumnName("explicacion_correcta");
            entity.Property(e => e.ReglasValidacion)
                .HasDefaultValueSql("'{}'::jsonb")
                .HasColumnType("jsonb")
                .HasColumnName("reglas_validacion");
            entity.Property(e => e.RespuestaCorrecta)
                .HasColumnType("jsonb")
                .HasColumnName("respuesta_correcta");

            entity.HasOne(d => d.Pregunta).WithOne(p => p.ClavesRespuesta)
                .HasForeignKey<ClavesRespuesta>(d => d.PreguntaId)
                .HasConstraintName("claves_respuesta_pregunta_id_fkey");
        });

        modelBuilder.Entity<ConfiguracionesUsuario>(entity =>
        {
            entity.HasKey(e => e.UsuarioId).HasName("configuraciones_usuario_pkey");

            entity.ToTable("configuraciones_usuario");

            entity.Property(e => e.UsuarioId)
                .ValueGeneratedNever()
                .HasColumnName("usuario_id");
            entity.Property(e => e.Accesibilidad)
                .HasDefaultValueSql("'{}'::jsonb")
                .HasColumnType("jsonb")
                .HasColumnName("accesibilidad");
            entity.Property(e => e.ActualizadoEn)
                .HasDefaultValueSql("now()")
                .HasColumnName("actualizado_en");
            entity.Property(e => e.AnimacionesActivadas)
                .HasDefaultValue(true)
                .HasColumnName("animaciones_activadas");
            entity.Property(e => e.MusicaActivada)
                .HasDefaultValue(true)
                .HasColumnName("musica_activada");
            entity.Property(e => e.SonidoActivado)
                .HasDefaultValue(true)
                .HasColumnName("sonido_activado");

            entity.HasOne(d => d.Usuario).WithOne(p => p.ConfiguracionesUsuario)
                .HasForeignKey<ConfiguracionesUsuario>(d => d.UsuarioId)
                .HasConstraintName("configuraciones_usuario_usuario_id_fkey");
        });

        modelBuilder.Entity<EstudiantesLogros>(entity =>
        {
            entity.HasKey(e => new { e.UsuarioId, e.LogroId }).HasName("estudiantes_logros_pkey");

            entity.ToTable("estudiantes_logros");

            entity.Property(e => e.UsuarioId).HasColumnName("usuario_id");
            entity.Property(e => e.LogroId).HasColumnName("logro_id");
            entity.Property(e => e.ObtenidoEn)
                .HasDefaultValueSql("now()")
                .HasColumnName("obtenido_en");
            entity.Property(e => e.PartidaId).HasColumnName("partida_id");

            entity.HasOne(d => d.Logro).WithMany(p => p.EstudiantesLogros)
                .HasForeignKey(d => d.LogroId)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("estudiantes_logros_logro_id_fkey");

            entity.HasOne(d => d.Partida).WithMany(p => p.EstudiantesLogros)
                .HasForeignKey(d => d.PartidaId)
                .OnDelete(DeleteBehavior.SetNull)
                .HasConstraintName("estudiantes_logros_partida_id_fkey");

            entity.HasOne(d => d.Usuario).WithMany(p => p.EstudiantesLogros)
                .HasForeignKey(d => d.UsuarioId)
                .HasConstraintName("estudiantes_logros_usuario_id_fkey");
        });

        modelBuilder.Entity<EventosPartida>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("eventos_partida_pkey");

            entity.ToTable("eventos_partida");

            entity.HasIndex(e => new { e.PartidaId, e.OcurridoEn }, "idx_eventos_partida_fecha");

            entity.Property(e => e.Id)
                .UseIdentityAlwaysColumn()
                .HasColumnName("id");
            entity.Property(e => e.DatosEvento)
                .HasDefaultValueSql("'{}'::jsonb")
                .HasColumnType("jsonb")
                .HasColumnName("datos_evento");
            entity.Property(e => e.OcurridoEn)
                .HasDefaultValueSql("now()")
                .HasColumnName("ocurrido_en");
            entity.Property(e => e.PartidaId).HasColumnName("partida_id");
            entity.Property(e => e.TipoEvento)
                .HasMaxLength(50)
                .HasColumnName("tipo_evento");

            entity.HasOne(d => d.Partida).WithMany(p => p.EventosPartida)
                .HasForeignKey(d => d.PartidaId)
                .HasConstraintName("eventos_partida_partida_id_fkey");
        });

        modelBuilder.Entity<IdentidadesExternas>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("identidades_externas_pkey");

            entity.ToTable("identidades_externas");

            entity.HasIndex(e => e.UsuarioId, "idx_identidades_usuario");

            entity.HasIndex(e => new { e.Proveedor, e.IdentificadorExterno }, "uq_identidad_externa").IsUnique();

            entity.Property(e => e.Id)
                .HasDefaultValueSql("gen_random_uuid()")
                .HasColumnName("id");
            entity.Property(e => e.CorreoProveedor)
                .HasMaxLength(320)
                .HasColumnName("correo_proveedor");
            entity.Property(e => e.CreadoEn)
                .HasDefaultValueSql("now()")
                .HasColumnName("creado_en");
            entity.Property(e => e.IdentificadorExterno)
                .HasMaxLength(255)
                .HasColumnName("identificador_externo");
            entity.Property(e => e.Proveedor)
                .HasMaxLength(30)
                .HasColumnName("proveedor");
            entity.Property(e => e.UsuarioId).HasColumnName("usuario_id");

            entity.HasOne(d => d.Usuario).WithMany(p => p.IdentidadesExternas)
                .HasForeignKey(d => d.UsuarioId)
                .HasConstraintName("identidades_externas_usuario_id_fkey");
        });

        modelBuilder.Entity<IntentosRespuesta>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("intentos_respuesta_pkey");

            entity.ToTable("intentos_respuesta");

            entity.HasIndex(e => new { e.PreguntaPartidaId, e.NumeroIntento }, "idx_intentos_pregunta_numero");

            entity.HasIndex(e => e.ClaveIdempotencia, "intentos_respuesta_clave_idempotencia_key").IsUnique();

            entity.HasIndex(e => new { e.PreguntaPartidaId, e.NumeroIntento }, "uq_intento_numero").IsUnique();

            entity.Property(e => e.Id)
                .HasDefaultValueSql("gen_random_uuid()")
                .HasColumnName("id");
            entity.Property(e => e.ClaveIdempotencia).HasColumnName("clave_idempotencia");
            entity.Property(e => e.EsCorrecta).HasColumnName("es_correcta");
            entity.Property(e => e.IniciadaEn)
                .HasDefaultValueSql("now()")
                .HasColumnName("iniciada_en");
            entity.Property(e => e.NumeroIntento).HasColumnName("numero_intento");
            entity.Property(e => e.PreguntaPartidaId).HasColumnName("pregunta_partida_id");
            entity.Property(e => e.PuntosOtorgados).HasColumnName("puntos_otorgados");
            entity.Property(e => e.RespondidaEn)
                .HasDefaultValueSql("now()")
                .HasColumnName("respondida_en");
            entity.Property(e => e.RespuestaUsuario)
                .HasColumnType("jsonb")
                .HasColumnName("respuesta_usuario");
            entity.Property(e => e.TiempoRespuestaMs).HasColumnName("tiempo_respuesta_ms");

            entity.HasOne(d => d.PreguntaPartida).WithMany(p => p.IntentosRespuesta)
                .HasForeignKey(d => d.PreguntaPartidaId)
                .HasConstraintName("intentos_respuesta_pregunta_partida_id_fkey");
        });

        modelBuilder.Entity<Logros>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("logros_pkey");

            entity.ToTable("logros");

            entity.HasIndex(e => e.Codigo, "logros_codigo_key").IsUnique();

            entity.Property(e => e.Id)
                .UseIdentityAlwaysColumn()
                .HasColumnName("id");
            entity.Property(e => e.Activo)
                .HasDefaultValue(true)
                .HasColumnName("activo");
            entity.Property(e => e.Codigo)
                .HasMaxLength(80)
                .HasColumnName("codigo");
            entity.Property(e => e.Criterio)
                .HasDefaultValueSql("'{}'::jsonb")
                .HasColumnType("jsonb")
                .HasColumnName("criterio");
            entity.Property(e => e.Descripcion).HasColumnName("descripcion");
            entity.Property(e => e.IconoUrl).HasColumnName("icono_url");
            entity.Property(e => e.Nombre)
                .HasMaxLength(120)
                .HasColumnName("nombre");
            entity.Property(e => e.PuntosBono).HasColumnName("puntos_bono");
        });

        modelBuilder.Entity<MetricasHabilidad>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("metricas_habilidad_pkey");

            entity.ToTable("metricas_habilidad");

            entity.HasIndex(e => new { e.UsuarioId, e.CategoriaId, e.HabilidadCodigo }, "uq_metrica_habilidad").IsUnique();

            entity.Property(e => e.Id)
                .UseIdentityAlwaysColumn()
                .HasColumnName("id");
            entity.Property(e => e.AciertosPrimerIntento).HasColumnName("aciertos_primer_intento");
            entity.Property(e => e.ActualizadoEn)
                .HasDefaultValueSql("now()")
                .HasColumnName("actualizado_en");
            entity.Property(e => e.CategoriaId).HasColumnName("categoria_id");
            entity.Property(e => e.HabilidadCodigo)
                .HasMaxLength(80)
                .HasColumnName("habilidad_codigo");
            entity.Property(e => e.NivelEstimado)
                .HasPrecision(5, 2)
                .HasColumnName("nivel_estimado");
            entity.Property(e => e.TotalRespuestas).HasColumnName("total_respuestas");
            entity.Property(e => e.UsuarioId).HasColumnName("usuario_id");

            entity.HasOne(d => d.Categoria).WithMany(p => p.MetricasHabilidad)
                .HasForeignKey(d => d.CategoriaId)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("metricas_habilidad_categoria_id_fkey");

            entity.HasOne(d => d.Usuario).WithMany(p => p.MetricasHabilidad)
                .HasForeignKey(d => d.UsuarioId)
                .HasConstraintName("metricas_habilidad_usuario_id_fkey");
        });

        modelBuilder.Entity<MiembrosAula>(entity =>
        {
            entity.HasKey(e => new { e.AulaId, e.EstudianteId }).HasName("miembros_aula_pkey");

            entity.ToTable("miembros_aula");

            entity.HasIndex(e => new { e.EstudianteId, e.Estado }, "idx_miembros_estudiante_estado");

            entity.Property(e => e.AulaId).HasColumnName("aula_id");
            entity.Property(e => e.EstudianteId).HasColumnName("estudiante_id");
            entity.Property(e => e.Estado)
                .HasMaxLength(20)
                .HasDefaultValueSql("'activo'::character varying")
                .HasColumnName("estado");
            entity.Property(e => e.RetiradoEn).HasColumnName("retirado_en");
            entity.Property(e => e.UnidoEn)
                .HasDefaultValueSql("now()")
                .HasColumnName("unido_en");

            entity.HasOne(d => d.Aula).WithMany(p => p.MiembrosAula)
                .HasForeignKey(d => d.AulaId)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("miembros_aula_aula_id_fkey");

            entity.HasOne(d => d.Estudiante).WithMany(p => p.MiembrosAula)
                .HasForeignKey(d => d.EstudianteId)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("miembros_aula_estudiante_id_fkey");
        });

        modelBuilder.Entity<NivelesEducativos>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("niveles_educativos_pkey");

            entity.ToTable("niveles_educativos");

            entity.HasIndex(e => new { e.AsignaturaId, e.NumeroOrden }, "uq_nivel_asignatura_orden").IsUnique();

            entity.Property(e => e.Id)
                .UseIdentityAlwaysColumn()
                .HasColumnName("id");
            entity.Property(e => e.Activo)
                .HasDefaultValue(true)
                .HasColumnName("activo");
            entity.Property(e => e.AsignaturaId).HasColumnName("asignatura_id");
            entity.Property(e => e.EdadMaxima).HasColumnName("edad_maxima");
            entity.Property(e => e.EdadMinima).HasColumnName("edad_minima");
            entity.Property(e => e.Nombre)
                .HasMaxLength(120)
                .HasColumnName("nombre");
            entity.Property(e => e.NumeroOrden).HasColumnName("numero_orden");

            entity.HasOne(d => d.Asignatura).WithMany(p => p.NivelesEducativos)
                .HasForeignKey(d => d.AsignaturaId)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("niveles_educativos_asignatura_id_fkey");
        });

        modelBuilder.Entity<OpcionesPregunta>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("opciones_pregunta_pkey");

            entity.ToTable("opciones_pregunta");

            entity.HasIndex(e => new { e.PreguntaId, e.OrdenVisual }, "uq_opcion_orden").IsUnique();

            entity.Property(e => e.Id)
                .UseIdentityAlwaysColumn()
                .HasColumnName("id");
            entity.Property(e => e.Activa)
                .HasDefaultValue(true)
                .HasColumnName("activa");
            entity.Property(e => e.CodigoOpcion)
                .HasMaxLength(30)
                .HasColumnName("codigo_opcion");
            entity.Property(e => e.OrdenVisual).HasColumnName("orden_visual");
            entity.Property(e => e.PreguntaId).HasColumnName("pregunta_id");
            entity.Property(e => e.RecursoUrl).HasColumnName("recurso_url");
            entity.Property(e => e.TextoOpcion).HasColumnName("texto_opcion");

            entity.HasOne(d => d.Pregunta).WithMany(p => p.OpcionesPregunta)
                .HasForeignKey(d => d.PreguntaId)
                .HasConstraintName("opciones_pregunta_pregunta_id_fkey");
        });

        modelBuilder.Entity<Partidas>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("partidas_pkey");

            entity.ToTable("partidas");

            entity.HasIndex(e => new { e.CategoriaId, e.Estado }, "idx_partidas_categoria_estado");

            entity.HasIndex(e => new { e.SesionInvitadoId, e.IniciadaEn }, "idx_partidas_invitado_fecha").IsDescending(false, true);

            entity.HasIndex(e => new { e.UsuarioId, e.IniciadaEn }, "idx_partidas_usuario_fecha").IsDescending(false, true);

            entity.HasIndex(e => e.ClaveIdempotencia, "uq_partida_idempotencia").IsUnique();

            entity.Property(e => e.Id)
                .HasDefaultValueSql("gen_random_uuid()")
                .HasColumnName("id");
            entity.Property(e => e.AciertosPrimerIntento)
                .HasComment("El porcentaje educativo se calcula con el primer intento de cada pregunta.")
                .HasColumnName("aciertos_primer_intento");
            entity.Property(e => e.CantidadPreguntasEvaluadas).HasColumnName("cantidad_preguntas_evaluadas");
            entity.Property(e => e.CantidadPreguntasPlanificada)
                .HasDefaultValue((short)10)
                .HasColumnName("cantidad_preguntas_planificada");
            entity.Property(e => e.CategoriaId).HasColumnName("categoria_id");
            entity.Property(e => e.ClaveIdempotencia).HasColumnName("clave_idempotencia");
            entity.Property(e => e.EsPartidaValida)
                .HasComment("Solo marcar TRUE tras completar las reglas de validacion de partida valida.")
                .HasColumnName("es_partida_valida");
            entity.Property(e => e.Estado)
                .HasMaxLength(20)
                .HasDefaultValueSql("'en_curso'::character varying")
                .HasColumnName("estado");
            entity.Property(e => e.FinalizadaEn).HasColumnName("finalizada_en");
            entity.Property(e => e.IniciadaEn)
                .HasDefaultValueSql("now()")
                .HasColumnName("iniciada_en");
            entity.Property(e => e.Metadatos)
                .HasDefaultValueSql("'{}'::jsonb")
                .HasColumnType("jsonb")
                .HasColumnName("metadatos");
            entity.Property(e => e.MotivoFinalizacion)
                .HasMaxLength(40)
                .HasColumnName("motivo_finalizacion");
            entity.Property(e => e.Origen)
                .HasMaxLength(20)
                .HasDefaultValueSql("'aplicacion'::character varying")
                .HasColumnName("origen");
            entity.Property(e => e.PuntosObtenidos).HasColumnName("puntos_obtenidos");
            entity.Property(e => e.ReglaGeneracionId).HasColumnName("regla_generacion_id");
            entity.Property(e => e.SesionInvitadoId).HasColumnName("sesion_invitado_id");
            entity.Property(e => e.SesionJuegoId).HasColumnName("sesion_juego_id");
            entity.Property(e => e.TiempoActivoMs).HasColumnName("tiempo_activo_ms");
            entity.Property(e => e.UsuarioId).HasColumnName("usuario_id");

            entity.HasOne(d => d.Categoria).WithMany(p => p.Partidas)
                .HasForeignKey(d => d.CategoriaId)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("partidas_categoria_id_fkey");

            entity.HasOne(d => d.ReglaGeneracion).WithMany(p => p.Partidas)
                .HasForeignKey(d => d.ReglaGeneracionId)
                .OnDelete(DeleteBehavior.SetNull)
                .HasConstraintName("partidas_regla_generacion_id_fkey");

            entity.HasOne(d => d.SesionInvitado).WithMany(p => p.Partidas)
                .HasForeignKey(d => d.SesionInvitadoId)
                .OnDelete(DeleteBehavior.SetNull)
                .HasConstraintName("partidas_sesion_invitado_id_fkey");

            entity.HasOne(d => d.SesionJuego).WithMany(p => p.Partidas)
                .HasForeignKey(d => d.SesionJuegoId)
                .OnDelete(DeleteBehavior.SetNull)
                .HasConstraintName("partidas_sesion_juego_id_fkey");

            entity.HasOne(d => d.Usuario).WithMany(p => p.Partidas)
                .HasForeignKey(d => d.UsuarioId)
                .OnDelete(DeleteBehavior.SetNull)
                .HasConstraintName("partidas_usuario_id_fkey");
        });

        modelBuilder.Entity<PerfilesDocente>(entity =>
        {
            entity.HasKey(e => e.UsuarioId).HasName("perfiles_docente_pkey");

            entity.ToTable("perfiles_docente");

            entity.Property(e => e.UsuarioId)
                .ValueGeneratedNever()
                .HasColumnName("usuario_id");
            entity.Property(e => e.CorreoEducativo)
                .HasMaxLength(320)
                .HasColumnName("correo_educativo");
            entity.Property(e => e.CreadoEn)
                .HasDefaultValueSql("now()")
                .HasColumnName("creado_en");
            entity.Property(e => e.Institucion)
                .HasMaxLength(160)
                .HasColumnName("institucion");
            entity.Property(e => e.VerificadoEn).HasColumnName("verificado_en");

            entity.HasOne(d => d.Usuario).WithOne(p => p.PerfilesDocente)
                .HasForeignKey<PerfilesDocente>(d => d.UsuarioId)
                .HasConstraintName("perfiles_docente_usuario_id_fkey");
        });

        modelBuilder.Entity<PerfilesEstudiante>(entity =>
        {
            entity.HasKey(e => e.UsuarioId).HasName("perfiles_estudiante_pkey");

            entity.ToTable("perfiles_estudiante");

            entity.Property(e => e.UsuarioId)
                .ValueGeneratedNever()
                .HasColumnName("usuario_id");
            entity.Property(e => e.Activo)
                .HasDefaultValue(true)
                .HasColumnName("activo");
            entity.Property(e => e.CreadoEn)
                .HasDefaultValueSql("now()")
                .HasColumnName("creado_en");
            entity.Property(e => e.FechaNacimiento).HasColumnName("fecha_nacimiento");
            entity.Property(e => e.GradoEscolar)
                .HasMaxLength(80)
                .HasColumnName("grado_escolar");
            entity.Property(e => e.NombreApodo)
                .HasMaxLength(80)
                .HasColumnName("nombre_apodo");

            entity.HasOne(d => d.Usuario).WithOne(p => p.PerfilesEstudiante)
                .HasForeignKey<PerfilesEstudiante>(d => d.UsuarioId)
                .HasConstraintName("perfiles_estudiante_usuario_id_fkey");
        });

        modelBuilder.Entity<PerfilesTutor>(entity =>
        {
            entity.HasKey(e => e.UsuarioId).HasName("perfiles_tutor_pkey");

            entity.ToTable("perfiles_tutor");

            entity.Property(e => e.UsuarioId)
                .ValueGeneratedNever()
                .HasColumnName("usuario_id");
            entity.Property(e => e.CreadoEn)
                .HasDefaultValueSql("now()")
                .HasColumnName("creado_en");
            entity.Property(e => e.NombreCompleto)
                .HasMaxLength(160)
                .HasColumnName("nombre_completo");

            entity.HasOne(d => d.Usuario).WithOne(p => p.PerfilesTutor)
                .HasForeignKey<PerfilesTutor>(d => d.UsuarioId)
                .HasConstraintName("perfiles_tutor_usuario_id_fkey");
        });

        modelBuilder.Entity<PoliticasTiempoUso>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("politicas_tiempo_uso_pkey");

            entity.ToTable("politicas_tiempo_uso");

            entity.Property(e => e.Id)
                .UseIdentityAlwaysColumn()
                .HasColumnName("id");
            entity.Property(e => e.Activa)
                .HasDefaultValue(true)
                .HasColumnName("activa");
            entity.Property(e => e.AplicaA)
                .HasMaxLength(20)
                .HasDefaultValueSql("'estudiante'::character varying")
                .HasColumnName("aplica_a");
            entity.Property(e => e.CreadaEn)
                .HasDefaultValueSql("now()")
                .HasColumnName("creada_en");
            entity.Property(e => e.CreadaPor).HasColumnName("creada_por");
            entity.Property(e => e.MinutosDiarios)
                .HasDefaultValue(90)
                .HasColumnName("minutos_diarios");
            entity.Property(e => e.Nombre)
                .HasMaxLength(120)
                .HasColumnName("nombre");

            entity.HasOne(d => d.CreadaPorNavigation).WithMany(p => p.PoliticasTiempoUso)
                .HasForeignKey(d => d.CreadaPor)
                .OnDelete(DeleteBehavior.SetNull)
                .HasConstraintName("politicas_tiempo_uso_creada_por_fkey");
        });

        modelBuilder.Entity<Preguntas>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("preguntas_pkey");

            entity.ToTable("preguntas");

            entity.HasIndex(e => new { e.CategoriaId, e.Dificultad }, "idx_preguntas_categoria_activas").HasFilter("(activa = true)");

            entity.HasIndex(e => new { e.Codigo, e.Version }, "uq_pregunta_codigo_version")
                .IsUnique()
                .HasFilter("(codigo IS NOT NULL)");

            entity.Property(e => e.Id)
                .UseIdentityAlwaysColumn()
                .HasColumnName("id");
            entity.Property(e => e.Activa)
                .HasDefaultValue(true)
                .HasColumnName("activa");
            entity.Property(e => e.ActualizadaEn)
                .HasDefaultValueSql("now()")
                .HasColumnName("actualizada_en");
            entity.Property(e => e.CategoriaId).HasColumnName("categoria_id");
            entity.Property(e => e.Codigo)
                .HasMaxLength(100)
                .HasColumnName("codigo");
            entity.Property(e => e.CreadaEn)
                .HasDefaultValueSql("now()")
                .HasColumnName("creada_en");
            entity.Property(e => e.Dificultad)
                .HasMaxLength(20)
                .HasColumnName("dificultad");
            entity.Property(e => e.Enunciado).HasColumnName("enunciado");
            entity.Property(e => e.Explicacion).HasColumnName("explicacion");
            entity.Property(e => e.Fuente)
                .HasMaxLength(160)
                .HasColumnName("fuente");
            entity.Property(e => e.TipoPregunta)
                .HasMaxLength(30)
                .HasColumnName("tipo_pregunta");
            entity.Property(e => e.Version)
                .HasDefaultValue(1)
                .HasColumnName("version");

            entity.HasOne(d => d.Categoria).WithMany(p => p.Preguntas)
                .HasForeignKey(d => d.CategoriaId)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("preguntas_categoria_id_fkey");
        });

        modelBuilder.Entity<PreguntasPartida>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("preguntas_partida_pkey");

            entity.ToTable("preguntas_partida", tb => tb.HasComment("Instantanea de lo que se mostro al estudiante; permite conservar preguntas generadas."));

            entity.HasIndex(e => e.PartidaId, "idx_preguntas_partida_partida");

            entity.HasIndex(e => new { e.PartidaId, e.Posicion }, "uq_pregunta_partida_posicion").IsUnique();

            entity.Property(e => e.Id)
                .HasDefaultValueSql("gen_random_uuid()")
                .HasColumnName("id");
            entity.Property(e => e.CreadaEn)
                .HasDefaultValueSql("now()")
                .HasColumnName("creada_en");
            entity.Property(e => e.DatosGeneracion)
                .HasDefaultValueSql("'{}'::jsonb")
                .HasColumnType("jsonb")
                .HasColumnName("datos_generacion");
            entity.Property(e => e.Dificultad)
                .HasMaxLength(20)
                .HasColumnName("dificultad");
            entity.Property(e => e.EnunciadoInstantanea).HasColumnName("enunciado_instantanea");
            entity.Property(e => e.EvaluadaEn).HasColumnName("evaluada_en");
            entity.Property(e => e.OpcionesInstantanea)
                .HasDefaultValueSql("'[]'::jsonb")
                .HasColumnType("jsonb")
                .HasColumnName("opciones_instantanea");
            entity.Property(e => e.PartidaId).HasColumnName("partida_id");
            entity.Property(e => e.Posicion).HasColumnName("posicion");
            entity.Property(e => e.PreguntaId).HasColumnName("pregunta_id");
            entity.Property(e => e.PrimeraRespuestaCorrecta).HasColumnName("primera_respuesta_correcta");
            entity.Property(e => e.ReglaGeneracionId).HasColumnName("regla_generacion_id");
            entity.Property(e => e.TiempoLimiteSegundos).HasColumnName("tiempo_limite_segundos");
            entity.Property(e => e.TipoOrigen)
                .HasMaxLength(20)
                .HasColumnName("tipo_origen");

            entity.HasOne(d => d.Partida).WithMany(p => p.PreguntasPartida)
                .HasForeignKey(d => d.PartidaId)
                .HasConstraintName("preguntas_partida_partida_id_fkey");

            entity.HasOne(d => d.Pregunta).WithMany(p => p.PreguntasPartida)
                .HasForeignKey(d => d.PreguntaId)
                .OnDelete(DeleteBehavior.SetNull)
                .HasConstraintName("preguntas_partida_pregunta_id_fkey");

            entity.HasOne(d => d.ReglaGeneracion).WithMany(p => p.PreguntasPartida)
                .HasForeignKey(d => d.ReglaGeneracionId)
                .OnDelete(DeleteBehavior.SetNull)
                .HasConstraintName("preguntas_partida_regla_generacion_id_fkey");
        });

        modelBuilder.Entity<ProgresoEstudiante>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("progreso_estudiante_pkey");

            entity.ToTable("progreso_estudiante");

            entity.HasIndex(e => new { e.UsuarioId, e.CategoriaId }, "uq_progreso_estudiante_categoria").IsUnique();

            entity.Property(e => e.Id)
                .UseIdentityAlwaysColumn()
                .HasColumnName("id");
            entity.Property(e => e.AciertosPrimerIntento).HasColumnName("aciertos_primer_intento");
            entity.Property(e => e.ActualizadoEn)
                .HasDefaultValueSql("now()")
                .HasColumnName("actualizado_en");
            entity.Property(e => e.CategoriaId).HasColumnName("categoria_id");
            entity.Property(e => e.PartidasCompletadas).HasColumnName("partidas_completadas");
            entity.Property(e => e.PreguntasEvaluadas).HasColumnName("preguntas_evaluadas");
            entity.Property(e => e.PuntosTotales).HasColumnName("puntos_totales");
            entity.Property(e => e.UltimaActividadEn).HasColumnName("ultima_actividad_en");
            entity.Property(e => e.UsuarioId).HasColumnName("usuario_id");

            entity.HasOne(d => d.Categoria).WithMany(p => p.ProgresoEstudiante)
                .HasForeignKey(d => d.CategoriaId)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("progreso_estudiante_categoria_id_fkey");

            entity.HasOne(d => d.Usuario).WithMany(p => p.ProgresoEstudiante)
                .HasForeignKey(d => d.UsuarioId)
                .HasConstraintName("progreso_estudiante_usuario_id_fkey");
        });

        modelBuilder.Entity<RecursosPregunta>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("recursos_pregunta_pkey");

            entity.ToTable("recursos_pregunta");

            entity.Property(e => e.Id)
                .UseIdentityAlwaysColumn()
                .HasColumnName("id");
            entity.Property(e => e.Metadatos)
                .HasDefaultValueSql("'{}'::jsonb")
                .HasColumnType("jsonb")
                .HasColumnName("metadatos");
            entity.Property(e => e.OrdenVisual).HasColumnName("orden_visual");
            entity.Property(e => e.PreguntaId).HasColumnName("pregunta_id");
            entity.Property(e => e.TextoAlternativo)
                .HasMaxLength(250)
                .HasColumnName("texto_alternativo");
            entity.Property(e => e.TipoRecurso)
                .HasMaxLength(30)
                .HasColumnName("tipo_recurso");
            entity.Property(e => e.UrlRecurso).HasColumnName("url_recurso");

            entity.HasOne(d => d.Pregunta).WithMany(p => p.RecursosPregunta)
                .HasForeignKey(d => d.PreguntaId)
                .HasConstraintName("recursos_pregunta_pregunta_id_fkey");
        });

        modelBuilder.Entity<ReglasGeneracionPreguntas>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("reglas_generacion_preguntas_pkey");

            entity.ToTable("reglas_generacion_preguntas");

            entity.HasIndex(e => new { e.CategoriaId, e.Codigo, e.Version }, "uq_regla_categoria_codigo_version").IsUnique();

            entity.Property(e => e.Id)
                .UseIdentityAlwaysColumn()
                .HasColumnName("id");
            entity.Property(e => e.Activa)
                .HasDefaultValue(true)
                .HasColumnName("activa");
            entity.Property(e => e.CategoriaId).HasColumnName("categoria_id");
            entity.Property(e => e.Codigo)
                .HasMaxLength(80)
                .HasColumnName("codigo");
            entity.Property(e => e.CreadoEn)
                .HasDefaultValueSql("now()")
                .HasColumnName("creado_en");
            entity.Property(e => e.Dificultad)
                .HasMaxLength(20)
                .HasColumnName("dificultad");
            entity.Property(e => e.Nombre)
                .HasMaxLength(140)
                .HasColumnName("nombre");
            entity.Property(e => e.Parametros)
                .HasDefaultValueSql("'{}'::jsonb")
                .HasColumnType("jsonb")
                .HasColumnName("parametros");
            entity.Property(e => e.Version)
                .HasDefaultValue(1)
                .HasColumnName("version");

            entity.HasOne(d => d.Categoria).WithMany(p => p.ReglasGeneracionPreguntas)
                .HasForeignKey(d => d.CategoriaId)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("reglas_generacion_preguntas_categoria_id_fkey");
        });

        modelBuilder.Entity<RelacionesTutorEstudiante>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("relaciones_tutor_estudiante_pkey");

            entity.ToTable("relaciones_tutor_estudiante");

            entity.HasIndex(e => new { e.TutorId, e.EstudianteId }, "uq_tutor_estudiante").IsUnique();

            entity.Property(e => e.Id)
                .HasDefaultValueSql("gen_random_uuid()")
                .HasColumnName("id");
            entity.Property(e => e.ConfirmadoEn).HasColumnName("confirmado_en");
            entity.Property(e => e.Estado)
                .HasMaxLength(20)
                .HasDefaultValueSql("'pendiente'::character varying")
                .HasColumnName("estado");
            entity.Property(e => e.EstudianteId).HasColumnName("estudiante_id");
            entity.Property(e => e.MetodoVinculacion)
                .HasMaxLength(30)
                .HasDefaultValueSql("'mismo_dispositivo'::character varying")
                .HasColumnName("metodo_vinculacion");
            entity.Property(e => e.RevocadoEn).HasColumnName("revocado_en");
            entity.Property(e => e.SolicitadoEn)
                .HasDefaultValueSql("now()")
                .HasColumnName("solicitado_en");
            entity.Property(e => e.TutorId).HasColumnName("tutor_id");

            entity.HasOne(d => d.Estudiante).WithMany(p => p.RelacionesTutorEstudianteEstudiante)
                .HasForeignKey(d => d.EstudianteId)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("relaciones_tutor_estudiante_estudiante_id_fkey");

            entity.HasOne(d => d.Tutor).WithMany(p => p.RelacionesTutorEstudianteTutor)
                .HasForeignKey(d => d.TutorId)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("relaciones_tutor_estudiante_tutor_id_fkey");
        });

        modelBuilder.Entity<RespuestasCorrectasPartida>(entity =>
        {
            entity.HasKey(e => e.PreguntaPartidaId).HasName("respuestas_correctas_partida_pkey");

            entity.ToTable("respuestas_correctas_partida", tb => tb.HasComment("Clave exacta de la pregunta presentada; solo acceso interno del servidor."));

            entity.Property(e => e.PreguntaPartidaId)
                .ValueGeneratedNever()
                .HasColumnName("pregunta_partida_id");
            entity.Property(e => e.CreadaEn)
                .HasDefaultValueSql("now()")
                .HasColumnName("creada_en");
            entity.Property(e => e.ReglasValidacion)
                .HasDefaultValueSql("'{}'::jsonb")
                .HasColumnType("jsonb")
                .HasColumnName("reglas_validacion");
            entity.Property(e => e.RespuestaCorrecta)
                .HasColumnType("jsonb")
                .HasColumnName("respuesta_correcta");

            entity.HasOne(d => d.PreguntaPartida).WithOne(p => p.RespuestasCorrectasPartida)
                .HasForeignKey<RespuestasCorrectasPartida>(d => d.PreguntaPartidaId)
                .HasConstraintName("respuestas_correctas_partida_pregunta_partida_id_fkey");
        });

        modelBuilder.Entity<Roles>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("roles_pkey");

            entity.ToTable("roles");

            entity.HasIndex(e => e.Codigo, "roles_codigo_key").IsUnique();

            entity.Property(e => e.Id)
                .UseIdentityAlwaysColumn()
                .HasColumnName("id");
            entity.Property(e => e.Activo)
                .HasDefaultValue(true)
                .HasColumnName("activo");
            entity.Property(e => e.Codigo)
                .HasMaxLength(30)
                .HasColumnName("codigo");
            entity.Property(e => e.CreadoEn)
                .HasDefaultValueSql("now()")
                .HasColumnName("creado_en");
            entity.Property(e => e.Descripcion).HasColumnName("descripcion");
            entity.Property(e => e.Nombre)
                .HasMaxLength(80)
                .HasColumnName("nombre");
        });

        modelBuilder.Entity<SesionesAutenticacion>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("sesiones_autenticacion_pkey");

            entity.ToTable("sesiones_autenticacion");

            entity.HasIndex(e => e.FamiliaTokenId, "idx_sesiones_auth_familia");

            entity.HasIndex(e => e.UsuarioId, "idx_sesiones_auth_usuario");

            entity.HasIndex(e => e.TokenHash, "sesiones_autenticacion_token_hash_key").IsUnique();

            entity.Property(e => e.Id)
                .HasDefaultValueSql("gen_random_uuid()")
                .HasColumnName("id");
            entity.Property(e => e.CreadoEn)
                .HasDefaultValueSql("now()")
                .HasColumnName("creado_en");
            entity.Property(e => e.ExpiraEn).HasColumnName("expira_en");
            entity.Property(e => e.FamiliaTokenId).HasColumnName("familia_token_id");
            entity.Property(e => e.ReemplazadoPorId).HasColumnName("reemplazado_por_id");
            entity.Property(e => e.RevocadoEn).HasColumnName("revocado_en");
            entity.Property(e => e.TokenHash).HasColumnName("token_hash");
            entity.Property(e => e.UltimoUsoEn).HasColumnName("ultimo_uso_en");
            entity.Property(e => e.UsuarioId).HasColumnName("usuario_id");

            entity.HasOne(d => d.ReemplazadoPor).WithMany(p => p.InverseReemplazadoPor)
                .HasForeignKey(d => d.ReemplazadoPorId)
                .OnDelete(DeleteBehavior.SetNull)
                .HasConstraintName("sesiones_autenticacion_reemplazado_por_id_fkey");

            entity.HasOne(d => d.Usuario).WithMany(p => p.SesionesAutenticacion)
                .HasForeignKey(d => d.UsuarioId)
                .HasConstraintName("sesiones_autenticacion_usuario_id_fkey");
        });

        modelBuilder.Entity<SesionesInvitado>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("sesiones_invitado_pkey");

            entity.ToTable("sesiones_invitado");

            entity.HasIndex(e => e.IdentificadorTokenHash, "sesiones_invitado_identificador_token_hash_key").IsUnique();

            entity.Property(e => e.Id)
                .HasDefaultValueSql("gen_random_uuid()")
                .HasColumnName("id");
            entity.Property(e => e.CreadaEn)
                .HasDefaultValueSql("now()")
                .HasColumnName("creada_en");
            entity.Property(e => e.Estado)
                .HasMaxLength(20)
                .HasDefaultValueSql("'activa'::character varying")
                .HasColumnName("estado");
            entity.Property(e => e.ExpiraEn).HasColumnName("expira_en");
            entity.Property(e => e.IdentificadorTokenHash).HasColumnName("identificador_token_hash");
            entity.Property(e => e.UltimaActividadEn)
                .HasDefaultValueSql("now()")
                .HasColumnName("ultima_actividad_en");
        });

        modelBuilder.Entity<SesionesJuego>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("sesiones_juego_pkey");

            entity.ToTable("sesiones_juego");

            entity.Property(e => e.Id)
                .HasDefaultValueSql("gen_random_uuid()")
                .HasColumnName("id");
            entity.Property(e => e.DispositivoTipo)
                .HasMaxLength(30)
                .HasColumnName("dispositivo_tipo");
            entity.Property(e => e.Estado)
                .HasMaxLength(20)
                .HasDefaultValueSql("'activa'::character varying")
                .HasColumnName("estado");
            entity.Property(e => e.FinalizadaEn).HasColumnName("finalizada_en");
            entity.Property(e => e.IniciadaEn)
                .HasDefaultValueSql("now()")
                .HasColumnName("iniciada_en");
            entity.Property(e => e.SesionInvitadoId).HasColumnName("sesion_invitado_id");
            entity.Property(e => e.UltimaActividadEn)
                .HasDefaultValueSql("now()")
                .HasColumnName("ultima_actividad_en");
            entity.Property(e => e.UsuarioId).HasColumnName("usuario_id");
            entity.Property(e => e.VersionAplicacion)
                .HasMaxLength(40)
                .HasColumnName("version_aplicacion");

            entity.HasOne(d => d.SesionInvitado).WithMany(p => p.SesionesJuego)
                .HasForeignKey(d => d.SesionInvitadoId)
                .OnDelete(DeleteBehavior.SetNull)
                .HasConstraintName("sesiones_juego_sesion_invitado_id_fkey");

            entity.HasOne(d => d.Usuario).WithMany(p => p.SesionesJuego)
                .HasForeignKey(d => d.UsuarioId)
                .OnDelete(DeleteBehavior.SetNull)
                .HasConstraintName("sesiones_juego_usuario_id_fkey");
        });

        modelBuilder.Entity<SolicitudesAula>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("solicitudes_aula_pkey");

            entity.ToTable("solicitudes_aula");

            entity.HasIndex(e => new { e.AulaId, e.Estado }, "idx_solicitudes_aula_estado");

            entity.HasIndex(e => new { e.AulaId, e.EstudianteId }, "uq_solicitud_aula_estudiante").IsUnique();

            entity.Property(e => e.Id)
                .HasDefaultValueSql("gen_random_uuid()")
                .HasColumnName("id");
            entity.Property(e => e.AulaId).HasColumnName("aula_id");
            entity.Property(e => e.Estado)
                .HasMaxLength(20)
                .HasDefaultValueSql("'pendiente'::character varying")
                .HasColumnName("estado");
            entity.Property(e => e.EstudianteId).HasColumnName("estudiante_id");
            entity.Property(e => e.ResueltaEn).HasColumnName("resuelta_en");
            entity.Property(e => e.ResueltaPor).HasColumnName("resuelta_por");
            entity.Property(e => e.SolicitadaEn)
                .HasDefaultValueSql("now()")
                .HasColumnName("solicitada_en");

            entity.HasOne(d => d.Aula).WithMany(p => p.SolicitudesAula)
                .HasForeignKey(d => d.AulaId)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("solicitudes_aula_aula_id_fkey");

            entity.HasOne(d => d.Estudiante).WithMany(p => p.SolicitudesAulaEstudiante)
                .HasForeignKey(d => d.EstudianteId)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("solicitudes_aula_estudiante_id_fkey");

            entity.HasOne(d => d.ResueltaPorNavigation).WithMany(p => p.SolicitudesAulaResueltaPorNavigation)
                .HasForeignKey(d => d.ResueltaPor)
                .OnDelete(DeleteBehavior.SetNull)
                .HasConstraintName("solicitudes_aula_resuelta_por_fkey");
        });

        modelBuilder.Entity<TokensRecuperacionContrasena>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("tokens_recuperacion_contrasena_pkey");

            entity.ToTable("tokens_recuperacion_contrasena");

            entity.HasIndex(e => e.TokenHash, "tokens_recuperacion_contrasena_token_hash_key").IsUnique();

            entity.Property(e => e.Id)
                .HasDefaultValueSql("gen_random_uuid()")
                .HasColumnName("id");
            entity.Property(e => e.CreadoEn)
                .HasDefaultValueSql("now()")
                .HasColumnName("creado_en");
            entity.Property(e => e.EmitidoPor).HasColumnName("emitido_por");
            entity.Property(e => e.ExpiraEn).HasColumnName("expira_en");
            entity.Property(e => e.TokenHash).HasColumnName("token_hash");
            entity.Property(e => e.UsuarioId).HasColumnName("usuario_id");
            entity.Property(e => e.UtilizadoEn).HasColumnName("utilizado_en");

            entity.HasOne(d => d.EmitidoPorNavigation).WithMany(p => p.TokensRecuperacionContrasenaEmitidoPorNavigation)
                .HasForeignKey(d => d.EmitidoPor)
                .OnDelete(DeleteBehavior.SetNull)
                .HasConstraintName("tokens_recuperacion_contrasena_emitido_por_fkey");

            entity.HasOne(d => d.Usuario).WithMany(p => p.TokensRecuperacionContrasenaUsuario)
                .HasForeignKey(d => d.UsuarioId)
                .HasConstraintName("tokens_recuperacion_contrasena_usuario_id_fkey");
        });

        modelBuilder.Entity<TransaccionesPuntos>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("transacciones_puntos_pkey");

            entity.ToTable("transacciones_puntos");

            entity.HasIndex(e => new { e.UsuarioId, e.CreadoEn }, "idx_transacciones_usuario_fecha").IsDescending(false, true);

            entity.HasIndex(e => e.ClaveIdempotencia, "transacciones_puntos_clave_idempotencia_key").IsUnique();

            entity.Property(e => e.Id)
                .HasDefaultValueSql("gen_random_uuid()")
                .HasColumnName("id");
            entity.Property(e => e.ClaveIdempotencia).HasColumnName("clave_idempotencia");
            entity.Property(e => e.CreadoEn)
                .HasDefaultValueSql("now()")
                .HasColumnName("creado_en");
            entity.Property(e => e.Motivo)
                .HasMaxLength(180)
                .HasColumnName("motivo");
            entity.Property(e => e.PartidaId).HasColumnName("partida_id");
            entity.Property(e => e.Puntos).HasColumnName("puntos");
            entity.Property(e => e.TipoTransaccion)
                .HasMaxLength(30)
                .HasColumnName("tipo_transaccion");
            entity.Property(e => e.UsuarioId).HasColumnName("usuario_id");

            entity.HasOne(d => d.Partida).WithMany(p => p.TransaccionesPuntos)
                .HasForeignKey(d => d.PartidaId)
                .OnDelete(DeleteBehavior.SetNull)
                .HasConstraintName("transacciones_puntos_partida_id_fkey");

            entity.HasOne(d => d.Usuario).WithMany(p => p.TransaccionesPuntos)
                .HasForeignKey(d => d.UsuarioId)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("transacciones_puntos_usuario_id_fkey");
        });

        modelBuilder.Entity<UsoDiarioEstudiante>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("uso_diario_estudiante_pkey");

            entity.ToTable("uso_diario_estudiante");

            entity.HasIndex(e => new { e.EstudianteId, e.FechaLocal }, "uq_uso_diario_estudiante_fecha").IsUnique();

            entity.Property(e => e.Id)
                .UseIdentityAlwaysColumn()
                .HasColumnName("id");
            entity.Property(e => e.ActualizadoEn)
                .HasDefaultValueSql("now()")
                .HasColumnName("actualizado_en");
            entity.Property(e => e.BloqueoHasta).HasColumnName("bloqueo_hasta");
            entity.Property(e => e.EstudianteId).HasColumnName("estudiante_id");
            entity.Property(e => e.FechaLocal).HasColumnName("fecha_local");
            entity.Property(e => e.ReiniciadoEn).HasColumnName("reiniciado_en");
            entity.Property(e => e.ReiniciadoPor).HasColumnName("reiniciado_por");
            entity.Property(e => e.TiempoActivoMs)
                .HasComment("Solo tiempo de juego activo; pausas e inactividad deben excluirse en la API.")
                .HasColumnName("tiempo_activo_ms");
            entity.Property(e => e.UltimoCalculoEn).HasColumnName("ultimo_calculo_en");
            entity.Property(e => e.ZonaHoraria)
                .HasMaxLength(80)
                .HasDefaultValueSql("'America/Guatemala'::character varying")
                .HasColumnName("zona_horaria");

            entity.HasOne(d => d.Estudiante).WithMany(p => p.UsoDiarioEstudianteEstudiante)
                .HasForeignKey(d => d.EstudianteId)
                .HasConstraintName("uso_diario_estudiante_estudiante_id_fkey");

            entity.HasOne(d => d.ReiniciadoPorNavigation).WithMany(p => p.UsoDiarioEstudianteReiniciadoPorNavigation)
                .HasForeignKey(d => d.ReiniciadoPor)
                .OnDelete(DeleteBehavior.SetNull)
                .HasConstraintName("uso_diario_estudiante_reiniciado_por_fkey");
        });

        modelBuilder.Entity<Usuarios>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("usuarios_pkey");

            entity.ToTable("usuarios");

            entity.HasIndex(e => e.NombreUsuarioNormalizado, "uq_usuarios_nombre_usuario").IsUnique();

            entity.HasIndex(e => e.CorreoNormalizado, "usuarios_correo_normalizado_key").IsUnique();

            entity.Property(e => e.Id)
                .HasDefaultValueSql("gen_random_uuid()")
                .HasColumnName("id");
            entity.Property(e => e.ActualizadoEn)
                .HasDefaultValueSql("now()")
                .HasColumnName("actualizado_en");
            entity.Property(e => e.ContrasenaHash).HasColumnName("contrasena_hash");
            entity.Property(e => e.Correo)
                .HasMaxLength(320)
                .HasColumnName("correo");
            entity.Property(e => e.CorreoConfirmadoEn).HasColumnName("correo_confirmado_en");
            entity.Property(e => e.CorreoNormalizado)
                .HasMaxLength(320)
                .HasColumnName("correo_normalizado");
            entity.Property(e => e.CreadoEn)
                .HasDefaultValueSql("now()")
                .HasColumnName("creado_en");
            entity.Property(e => e.DebeCambiarContrasena).HasColumnName("debe_cambiar_contrasena");
            entity.Property(e => e.EliminadoEn).HasColumnName("eliminado_en");
            entity.Property(e => e.Estado)
                .HasMaxLength(20)
                .HasDefaultValueSql("'pendiente'::character varying")
                .HasColumnName("estado");
            entity.Property(e => e.MetodoRegistro)
                .HasMaxLength(30)
                .HasColumnName("metodo_registro");
            entity.Property(e => e.NombreMostrar)
                .HasMaxLength(120)
                .HasColumnName("nombre_mostrar");
            entity.Property(e => e.NombreUsuario)
                .HasMaxLength(30)
                .HasColumnName("nombre_usuario");
            entity.Property(e => e.NombreUsuarioNormalizado)
                .HasMaxLength(30)
                .HasColumnName("nombre_usuario_normalizado");
            entity.Property(e => e.UltimoAccesoEn).HasColumnName("ultimo_acceso_en");
            entity.Property(e => e.ZonaHoraria)
                .HasMaxLength(80)
                .HasDefaultValueSql("'America/Guatemala'::character varying")
                .HasColumnName("zona_horaria");
        });

        modelBuilder.Entity<UsuariosRoles>(entity =>
        {
            entity.HasKey(e => new { e.UsuarioId, e.RolId }).HasName("usuarios_roles_pkey");

            entity.ToTable("usuarios_roles");

            entity.Property(e => e.UsuarioId).HasColumnName("usuario_id");
            entity.Property(e => e.RolId).HasColumnName("rol_id");
            entity.Property(e => e.AsignadoEn)
                .HasDefaultValueSql("now()")
                .HasColumnName("asignado_en");
            entity.Property(e => e.AsignadoPor).HasColumnName("asignado_por");

            entity.HasOne(d => d.AsignadoPorNavigation).WithMany(p => p.UsuariosRolesAsignadoPorNavigation)
                .HasForeignKey(d => d.AsignadoPor)
                .OnDelete(DeleteBehavior.SetNull)
                .HasConstraintName("usuarios_roles_asignado_por_fkey");

            entity.HasOne(d => d.Rol).WithMany(p => p.UsuariosRoles)
                .HasForeignKey(d => d.RolId)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("usuarios_roles_rol_id_fkey");

            entity.HasOne(d => d.Usuario).WithMany(p => p.UsuariosRolesUsuario)
                .HasForeignKey(d => d.UsuarioId)
                .HasConstraintName("usuarios_roles_usuario_id_fkey");
        });

        modelBuilder.Entity<VerificacionesCorreo>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("verificaciones_correo_pkey");

            entity.ToTable("verificaciones_correo");

            entity.HasIndex(e => e.TokenHash, "verificaciones_correo_token_hash_key").IsUnique();

            entity.Property(e => e.Id)
                .HasDefaultValueSql("gen_random_uuid()")
                .HasColumnName("id");
            entity.Property(e => e.CreadoEn)
                .HasDefaultValueSql("now()")
                .HasColumnName("creado_en");
            entity.Property(e => e.ExpiraEn).HasColumnName("expira_en");
            entity.Property(e => e.TokenHash).HasColumnName("token_hash");
            entity.Property(e => e.UsuarioId).HasColumnName("usuario_id");
            entity.Property(e => e.UtilizadoEn).HasColumnName("utilizado_en");

            entity.HasOne(d => d.Usuario).WithMany(p => p.VerificacionesCorreo)
                .HasForeignKey(d => d.UsuarioId)
                .HasConstraintName("verificaciones_correo_usuario_id_fkey");
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
