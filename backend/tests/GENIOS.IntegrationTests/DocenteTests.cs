using System.Net;
using System.Net.Http.Json;
using GENIOS.Application.Aulas;
using GENIOS.Application.Docente;
using GENIOS.IntegrationTests.Soporte;

namespace GENIOS.IntegrationTests;

[Collection(ColeccionJuego.Nombre)]
public class DocenteTests(FixtureJuego f)
{
    private JuegoApi Docente1 => JuegoApi.ComoDocente(f, f.DocenteId);
    private JuegoApi Docente2 => JuegoApi.ComoDocente(f, f.Docente2Id);

    // ------------------------------------------------------------ Aulas: grado, sección, edición y archivo

    [Fact]
    public async Task Crear_y_editar_una_clase_guarda_grado_y_seccion_y_nunca_cambia_el_codigo()
    {
        var docente = Docente1;
        var creada = await (await docente.Http.PostAsJsonAsync("/api/v1/aulas", new SolicitudCrearAula("Quinto A (prueba)", "Desc", 5, "A")))
            .Content.ReadFromJsonAsync<AulaDto>();
        Assert.Equal((5, "A"), ((int)creada!.Grado!, creada.Seccion));
        Assert.Matches("^[A-Z][0-9]{4}$", creada.CodigoAcceso);

        var edit = await docente.Http.PatchAsJsonAsync($"/api/v1/aulas/{creada.Id}", new SolicitudEditarAula("Quinto B (prueba)", null, 5, "B"));
        Assert.Equal(HttpStatusCode.OK, edit.StatusCode);
        var editada = (await edit.Content.ReadFromJsonAsync<AulaDto>())!;
        Assert.Equal(("Quinto B (prueba)", "B"), (editada.Nombre, editada.Seccion));
        Assert.Equal(creada.CodigoAcceso, editada.CodigoAcceso); // el código es permanente

        Assert.Equal(HttpStatusCode.BadRequest, (await docente.Http.PostAsJsonAsync("/api/v1/aulas", new SolicitudCrearAula("X", null, 9))).StatusCode);

        await f.Ejecutar("delete from aulas where id = @a", ("a", creada.Id));
    }

    [Fact]
    public async Task Archivar_una_clase_la_oculta_pero_conserva_sus_estudiantes_y_partidas()
    {
        var docente = Docente1;
        var aula = await (await docente.Http.PostAsJsonAsync("/api/v1/aulas", new SolicitudCrearAula("Aula a archivar (prueba)", null)))
            .Content.ReadFromJsonAsync<AulaDto>();
        var s = await JuegoApi.NuevoEstudianteAsync(f, aula!.CodigoAcceso);
        await s.JugarAsync(f.CategoriaA1);

        Assert.Equal(HttpStatusCode.NoContent, (await docente.Http.PostAsync($"/api/v1/aulas/{aula.Id}/archivar", null)).StatusCode);
        var mias = (await docente.Http.GetFromJsonAsync<List<AulaDto>>("/api/v1/aulas/mi-aula"))!;
        Assert.DoesNotContain(mias, a => a.Id == aula.Id);

        // El historial sigue ahí.
        Assert.Equal(1, await f.Escalar<long>("select count(*) from partidas where usuario_id = @u and es_partida_valida", ("u", s.UsuarioId!.Value)));
        Assert.Equal(1, await f.Escalar<long>("select count(*) from miembros_aula where aula_id = @a", ("a", aula.Id)));
        // Y un docente ajeno no puede archivarla.
        Assert.Equal(HttpStatusCode.NotFound, (await Docente2.Http.PostAsync($"/api/v1/aulas/{aula.Id}/archivar", null)).StatusCode);
        await f.Ejecutar("delete from miembros_aula where aula_id = @a", ("a", aula.Id));
        await f.Ejecutar("delete from aulas where id = @a", ("a", aula.Id));
    }

    // ------------------------------------------------------------ Estudiantes, ficha y autorización

    [Fact]
    public async Task El_listado_filtra_busca_y_clasifica_sin_datos_como_sin_datos()
    {
        var jugador = await JuegoApi.NuevoEstudianteAsync(f);
        var inactivo = await JuegoApi.NuevoEstudianteAsync(f);
        await jugador.JugarAsync(f.CategoriaA1); // 10/10 = 100 %
        var d = Docente1;

        var todos = (await d.Http.GetFromJsonAsync<PaginaDto<FilaEstudianteDto>>($"/api/v1/docente/estudiantes?aulaId={f.AulaId}&tamano=100"))!;
        var fj = todos.Elementos.Single(x => x.EstudianteId == jugador.UsuarioId);
        var fi = todos.Elementos.Single(x => x.EstudianteId == inactivo.UsuarioId);
        Assert.Equal(("aprobado", 1), (fj.Rendimiento, fj.PartidasCompletadas));
        Assert.Equal(("sin_datos", 0), (fi.Rendimiento, fi.PartidasCompletadas)); // sin partidas NO es refuerzo
        Assert.Null(fi.PromedioAciertos);

        var soloSinDatos = (await d.Http.GetFromJsonAsync<PaginaDto<FilaEstudianteDto>>("/api/v1/docente/estudiantes?rendimiento=sin_datos&tamano=100"))!;
        Assert.Contains(soloSinDatos.Elementos, x => x.EstudianteId == inactivo.UsuarioId);
        Assert.DoesNotContain(soloSinDatos.Elementos, x => x.EstudianteId == jugador.UsuarioId);

        var busqueda = (await d.Http.GetFromJsonAsync<PaginaDto<FilaEstudianteDto>>($"/api/v1/docente/estudiantes?q={fj.NombreUsuario}"))!;
        Assert.Equal(jugador.UsuarioId, busqueda.Elementos.Single().EstudianteId);

        var pagina = (await d.Http.GetFromJsonAsync<PaginaDto<FilaEstudianteDto>>("/api/v1/docente/estudiantes?tamano=1&pagina=1"))!;
        Assert.Single(pagina.Elementos);
        Assert.True(pagina.Total >= 2);
        Assert.Equal(HttpStatusCode.BadRequest, (await d.Http.GetAsync("/api/v1/docente/estudiantes?rendimiento=genial")).StatusCode);
    }

    [Fact]
    public async Task La_ficha_usa_solo_partidas_validas_y_el_primer_intento()
    {
        var s = await JuegoApi.NuevoEstudianteAsync(f);
        await s.JugarAsync(f.CategoriaA1, fallosEnPrimerIntento: 3);          // 7/10: aprobada
        await s.CrearPartidaAsync(f.CategoriaA2);                              // en curso: no cuenta
        var d = Docente1;

        var ficha = (await d.Http.GetFromJsonAsync<FichaEstudianteDto>($"/api/v1/docente/estudiantes/{s.UsuarioId}/estadisticas"))!;
        Assert.Equal((1, 1), (ficha.PartidasCompletadas, ficha.PartidasAprobadas));
        Assert.Equal(70m, ficha.PromedioAciertos);
        Assert.Equal("aprobado", ficha.Rendimiento);
        Assert.Null(ficha.VariacionPuntosPorcentuales); // sin período anterior: no hay flecha
        Assert.Equal(1, ficha.LeccionesAprobadas);
        Assert.NotNull(ficha.TiempoMedioSegundos);
        Assert.Single(ficha.Materias);
        Assert.Equal(1, ficha.PartidasPorDia.Sum(x => x.Partidas));

        var asignatura = ficha.Materias[0].AsignaturaId;
        var detalle = (await d.Http.GetFromJsonAsync<DetalleMateriaDto>($"/api/v1/docente/estudiantes/{s.UsuarioId}/materias/{asignatura}"))!;
        Assert.Equal(1, detalle.Partidas);
        Assert.True(detalle.LeccionesPendientes >= 1);
        Assert.Contains(detalle.Lecciones, l => l.Aprobada);
        Assert.NotEmpty(detalle.ErroresFrecuentes); // fallaron 3 preguntas al primer intento
        Assert.DoesNotContain("correcta", System.Text.Json.JsonSerializer.Serialize(detalle), StringComparison.OrdinalIgnoreCase);
    }

    [Fact]
    public async Task Una_partida_de_4_a_6_aciertos_es_repaso_y_no_aprueba_la_leccion()
    {
        var s = await JuegoApi.NuevoEstudianteAsync(f);
        await s.JugarAsync(f.CategoriaA1, fallosEnPrimerIntento: 6); // 4/10
        var ficha = (await Docente1.Http.GetFromJsonAsync<FichaEstudianteDto>($"/api/v1/docente/estudiantes/{s.UsuarioId}/estadisticas"))!;
        Assert.Equal((40m, "repaso", 0, 0), (ficha.PromedioAciertos, ficha.Rendimiento, ficha.PartidasAprobadas, ficha.LeccionesAprobadas));
    }

    [Fact]
    public async Task El_calendario_muestra_la_actividad_del_dia_real()
    {
        var s = await JuegoApi.NuevoEstudianteAsync(f);
        await s.JugarAsync(f.CategoriaA1);
        var hoy = DateTime.UtcNow.AddHours(-6);
        var mes = (await Docente1.Http.GetFromJsonAsync<ActividadMesDto>($"/api/v1/docente/estudiantes/{s.UsuarioId}/actividad?anio={hoy.Year}&mes={hoy.Month}"))!;
        Assert.Equal(1, mes.Dias.Sum(x => x.Partidas));
        Assert.Single(mes.Dias[0].Materias);
        Assert.Equal(HttpStatusCode.BadRequest, (await Docente1.Http.GetAsync($"/api/v1/docente/estudiantes/{s.UsuarioId}/actividad?anio=2026&mes=13")).StatusCode);
    }

    [Fact]
    public async Task Un_docente_no_puede_ver_estudiantes_ajenos_y_queda_auditado()
    {
        var ajeno = await JuegoApi.NuevoEstudianteAsync(f, f.CodigoAula2); // aula del docente 2
        var d1 = Docente1;
        var antes = await f.Escalar<long>("select count(*) from auditoria_seguridad where usuario_id = @u and accion = 'acceso_estudiante_no_autorizado'", ("u", f.DocenteId));

        foreach (var ruta in new[] { "estadisticas", "actividad?anio=2026&mes=10", "materias/1" })
            Assert.Equal(HttpStatusCode.NotFound, (await d1.Http.GetAsync($"/api/v1/docente/estudiantes/{ajeno.UsuarioId}/{ruta}")).StatusCode);

        var despues = await f.Escalar<long>("select count(*) from auditoria_seguridad where usuario_id = @u and accion = 'acceso_estudiante_no_autorizado'", ("u", f.DocenteId));
        Assert.Equal(antes + 3, despues);

        var lista = (await d1.Http.GetFromJsonAsync<PaginaDto<FilaEstudianteDto>>("/api/v1/docente/estudiantes?tamano=100"))!;
        Assert.DoesNotContain(lista.Elementos, x => x.EstudianteId == ajeno.UsuarioId);
        Assert.Equal(HttpStatusCode.NotFound, (await d1.Http.GetAsync($"/api/v1/docente/aulas/{f.Aula2Id}/estadisticas")).StatusCode);
        Assert.Equal(HttpStatusCode.NotFound, (await d1.Http.GetAsync($"/api/v1/docente/estudiantes?aulaId={f.Aula2Id}")).StatusCode);
    }

    [Fact]
    public async Task Los_estudiantes_e_invitados_no_acceden_al_centro_docente()
    {
        var e = await JuegoApi.NuevoEstudianteAsync(f);
        var invitado = await JuegoApi.NuevoInvitadoAsync(f);
        var anonimo = f.Fabrica.CreateClient();
        foreach (var ruta in new[] { "resumen", "estudiantes", $"aulas/{f.AulaId}/estadisticas" })
        {
            Assert.Equal(HttpStatusCode.Forbidden, (await e.Http.GetAsync($"/api/v1/docente/{ruta}")).StatusCode);
            Assert.Equal(HttpStatusCode.Unauthorized, (await anonimo.GetAsync($"/api/v1/docente/{ruta}")).StatusCode);
        }
        Assert.NotNull(invitado);
    }

    // ------------------------------------------------------------ Resumen y clase

    [Fact]
    public async Task El_resumen_y_las_estadisticas_de_clase_reflejan_las_partidas_reales()
    {
        var a = await JuegoApi.NuevoEstudianteAsync(f);
        var b = await JuegoApi.NuevoEstudianteAsync(f);
        await JuegoApi.NuevoEstudianteAsync(f); // sin partidas
        await a.JugarAsync(f.CategoriaA1);                                         // 100 %: aprobado
        await b.JugarAsync(f.CategoriaA1, fallosEnPrimerIntento: 8);               // 2/10: refuerzo
        var d = Docente1;

        var clase = (await d.Http.GetFromJsonAsync<EstadisticasClaseDto>($"/api/v1/docente/aulas/{f.AulaId}/estadisticas"))!;
        var dist = clase.Distribucion;
        Assert.True(dist.Aprobado >= 1 && dist.Refuerzo >= 1 && dist.SinDatos >= 1);
        Assert.Equal(clase.TotalEstudiantes, dist.Refuerzo + dist.Repaso + dist.Aprobado + dist.SinDatos); // nadie se cuenta dos veces
        Assert.True(clase.PartidasCompletadas >= 2);
        Assert.NotEmpty(clase.EvolucionSemanal);

        var resumen = (await d.Http.GetFromJsonAsync<ResumenDocenteDto>("/api/v1/docente/resumen"))!;
        Assert.True(resumen.ClasesActivas >= 1);
        Assert.True(resumen.EstudiantesAsignados >= 3);
        Assert.True(resumen.EstudiantesActivosRecientes >= 2);
        Assert.NotNull(resumen.PromedioAciertos);
        Assert.Equal(HttpStatusCode.BadRequest, (await d.Http.GetAsync("/api/v1/docente/resumen?desde=2026-10-10&hasta=2026-10-01")).StatusCode);
    }
}
