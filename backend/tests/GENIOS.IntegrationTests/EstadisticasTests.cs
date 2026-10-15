using System.Net;
using System.Net.Http.Json;
using GENIOS.Application.Estadisticas;
using GENIOS.IntegrationTests.Soporte;

namespace GENIOS.IntegrationTests;

[Collection(ColeccionJuego.Nombre)]
public class EstadisticasTests(FixtureJuego f)
{
    // ------------------------------------------------------------ Estudiante: datos propios

    [Fact]
    public async Task El_estudiante_consulta_su_progreso_estadisticas_y_puntos()
    {
        var estudiante = await JuegoApi.NuevoEstudianteAsync(f);
        await estudiante.JugarAsync(f.CategoriaA1, fallosEnPrimerIntento: 3);                   // completada: 7/10 al primer intento
        var incompleta = await estudiante.JugarAsync(f.CategoriaA2, soloPreguntas: 2);          // 2 respuestas y se abandona
        await estudiante.Http.PostAsync($"/api/v1/partidas/{incompleta}/abandonar", null);

        // Progreso por materia
        var progreso = (await estudiante.Http.GetFromJsonAsync<ProgresoEstudianteDto>("/api/v1/estudiantes/yo/progreso"))!;
        Assert.Equal(4, progreso.Asignaturas.Count); // las cuatro materias, aunque alguna no tenga contenido
        var categorias = progreso.Asignaturas.SelectMany(a => a.Categorias).ToDictionary(c => c.CategoriaId);
        Assert.Equal(("completada", 1, 70m, 120L), (categorias[f.CategoriaA1].Estado, categorias[f.CategoriaA1].PartidasCompletadas, categorias[f.CategoriaA1].PorcentajeAciertos, categorias[f.CategoriaA1].Puntos));
        Assert.Equal(("disponible", 0, 20L), (categorias[f.CategoriaA2].Estado, categorias[f.CategoriaA2].PartidasCompletadas, categorias[f.CategoriaA2].Puntos));
        Assert.Equal("disponible", categorias[f.CategoriaB1].Estado);
        var matematicas = progreso.Asignaturas.Single(a => a.Categorias.Any(c => c.CategoriaId == f.CategoriaA1));
        Assert.Equal(1, matematicas.CategoriasCompletadas);
        Assert.Equal(70m, matematicas.PorcentajeAciertos);

        // Estadísticas: el primer intento aparte de los reintentos, y las incompletas aparte de las completadas
        var est = (await estudiante.Http.GetFromJsonAsync<EstadisticasEstudianteDto>("/api/v1/estudiantes/yo/estadisticas"))!;
        Assert.Equal((1, 1, 10, 7, 70m), (est.PartidasCompletadas, est.PartidasIncompletas, est.PreguntasEvaluadas, est.AciertosPrimerIntento, est.PorcentajePrimerIntento));
        Assert.Equal((13, 3, 1.3m), (est.Reintentos.IntentosTotales, est.Reintentos.PreguntasCorregidasConReintento, est.Reintentos.PromedioIntentosPorPregunta));
        Assert.Equal(2, est.PartidasRecientes.Count);
        Assert.Equal(("abandonada", false), (est.PartidasRecientes[0].Estado, est.PartidasRecientes[0].EsPartidaValida)); // la más reciente primero
        Assert.Equal(("completada", true, 70m), (est.PartidasRecientes[1].Estado, est.PartidasRecientes[1].EsPartidaValida, est.PartidasRecientes[1].PorcentajeAciertos));

        // Puntos: 10 respuestas + 2 de la partida abandonada (10 c/u) y un bono de categoría
        var puntos = (await estudiante.Http.GetFromJsonAsync<PuntosEstudianteDto>("/api/v1/estudiantes/yo/puntos"))!;
        Assert.Equal(140, puntos.PuntosTotales);
        Assert.Equal(("respuesta_correcta", 120L, 12), (puntos.PorTipo[1].Tipo, puntos.PorTipo[1].Puntos, puntos.PorTipo[1].Cantidad));
        Assert.Equal(("bono_categoria", 20L, 1), (puntos.PorTipo[0].Tipo, puntos.PorTipo[0].Puntos, puntos.PorTipo[0].Cantidad));
        Assert.Equal(1, puntos.CategoriasConBono);
        Assert.Equal(10, puntos.Recientes.Count);
    }

    [Fact]
    public async Task Un_estudiante_nunca_ve_los_datos_de_otro()
    {
        var conDatos = await JuegoApi.NuevoEstudianteAsync(f);
        var sinDatos = await JuegoApi.NuevoEstudianteAsync(f);
        await conDatos.JugarAsync(f.CategoriaA1);

        // Los endpoints "yo" se resuelven por el token; el otro estudiante ve solo lo suyo (nada).
        var puntos = (await sinDatos.Http.GetFromJsonAsync<PuntosEstudianteDto>("/api/v1/estudiantes/yo/puntos"))!;
        var est = (await sinDatos.Http.GetFromJsonAsync<EstadisticasEstudianteDto>("/api/v1/estudiantes/yo/estadisticas"))!;
        var progreso = (await sinDatos.Http.GetFromJsonAsync<ProgresoEstudianteDto>("/api/v1/estudiantes/yo/progreso"))!;
        Assert.Equal(0, puntos.PuntosTotales);
        Assert.Empty(puntos.PorTipo);
        Assert.Equal((0, 0), (est.PartidasCompletadas, est.PartidasRecientes.Count));
        Assert.All(progreso.Asignaturas.SelectMany(a => a.Categorias), c => Assert.Equal(0, c.PartidasCompletadas));

        // No existe ninguna ruta que reciba el id de otro estudiante.
        Assert.Equal(HttpStatusCode.NotFound, (await sinDatos.Http.GetAsync($"/api/v1/estudiantes/{conDatos.UsuarioId}/progreso")).StatusCode);
        Assert.Equal(HttpStatusCode.NotFound, (await sinDatos.Http.GetAsync($"/api/v1/estudiantes/{conDatos.UsuarioId}/puntos")).StatusCode);

        // Y el dueño sí ve lo suyo.
        Assert.Equal(120, (await conDatos.Http.GetFromJsonAsync<PuntosEstudianteDto>("/api/v1/estudiantes/yo/puntos"))!.PuntosTotales);
    }

    // ------------------------------------------------------------ Docente: aula

    [Fact]
    public async Task El_docente_ve_solo_a_los_estudiantes_activos_de_su_propia_aula()
    {
        var s1 = await JuegoApi.NuevoEstudianteAsync(f);                    // aula 1, juega
        var s2 = await JuegoApi.NuevoEstudianteAsync(f);                    // aula 1, sin jugar
        var s3 = await JuegoApi.NuevoEstudianteAsync(f, f.CodigoAula2);     // aula 2, juega
        await s1.JugarAsync(f.CategoriaA1, fallosEnPrimerIntento: 3);
        await s3.JugarAsync(f.CategoriaA1);
        var docente1 = JuegoApi.ComoDocente(f, f.DocenteId);
        var docente2 = JuegoApi.ComoDocente(f, f.Docente2Id);

        var aula1 = (await docente1.Http.GetFromJsonAsync<EstadisticasAulaDto>($"/api/v1/aulas/{f.AulaId}/estadisticas"))!;
        var ids = aula1.Estudiantes.Select(e => e.EstudianteId).ToList();
        Assert.Contains(s1.UsuarioId!.Value, ids);
        Assert.Contains(s2.UsuarioId!.Value, ids);
        Assert.DoesNotContain(s3.UsuarioId!.Value, ids); // estudiante de otra aula: invisible para este docente

        var fila1 = aula1.Estudiantes.Single(e => e.EstudianteId == s1.UsuarioId);
        Assert.Equal((1, 70m, 120L), (fila1.PartidasCompletadas, fila1.PorcentajeAciertos, fila1.PuntosTotales));
        Assert.Equal(70m, fila1.PorAsignatura.Single().PorcentajeAciertos);
        Assert.Equal(0, aula1.Estudiantes.Single(e => e.EstudianteId == s2.UsuarioId).PartidasCompletadas);

        // El otro docente ve su propia aula, con su estudiante.
        var aula2 = (await docente2.Http.GetFromJsonAsync<EstadisticasAulaDto>($"/api/v1/aulas/{f.Aula2Id}/estadisticas"))!;
        Assert.Contains(s3.UsuarioId!.Value, aula2.Estudiantes.Select(e => e.EstudianteId));
        Assert.DoesNotContain(s1.UsuarioId.Value, aula2.Estudiantes.Select(e => e.EstudianteId));

        // Un estudiante retirado deja de aparecer.
        Assert.Equal(HttpStatusCode.NoContent, (await docente1.Http.DeleteAsync($"/api/v1/aulas/{f.AulaId}/estudiantes/{s2.UsuarioId}")).StatusCode);
        var tras = (await docente1.Http.GetFromJsonAsync<EstadisticasAulaDto>($"/api/v1/aulas/{f.AulaId}/estadisticas"))!;
        Assert.DoesNotContain(s2.UsuarioId.Value, tras.Estudiantes.Select(e => e.EstudianteId));
        Assert.Contains(s1.UsuarioId.Value, tras.Estudiantes.Select(e => e.EstudianteId));
    }

    [Fact]
    public async Task Las_estadisticas_de_aula_rechazan_a_docentes_ajenos_estudiantes_e_invitados()
    {
        var docenteAjeno = JuegoApi.ComoDocente(f, f.Docente2Id);
        var estudiante = await JuegoApi.NuevoEstudianteAsync(f);
        var invitado = await JuegoApi.NuevoInvitadoAsync(f);
        var anonimo = f.Fabrica.CreateClient();
        var ruta = $"/api/v1/aulas/{f.AulaId}/estadisticas";

        var antes = await f.Escalar<long>("select count(*) from auditoria_seguridad where usuario_id = @u and accion = 'acceso_aula_no_autorizado'", ("u", f.Docente2Id));

        // Docente de otra aula: 404 (no se revela que existe) y queda registrado el intento.
        Assert.Equal(HttpStatusCode.NotFound, (await docenteAjeno.Http.GetAsync(ruta)).StatusCode);
        Assert.Equal(HttpStatusCode.NotFound, (await docenteAjeno.Http.GetAsync($"/api/v1/aulas/{Guid.NewGuid()}/estadisticas")).StatusCode);
        var despues = await f.Escalar<long>("select count(*) from auditoria_seguridad where usuario_id = @u and accion = 'acceso_aula_no_autorizado'", ("u", f.Docente2Id));
        Assert.Equal(antes + 2, despues);

        // Estudiante, invitado y anónimo no tienen acceso.
        Assert.Equal(HttpStatusCode.Forbidden, (await estudiante.Http.GetAsync(ruta)).StatusCode);
        Assert.Equal(HttpStatusCode.Unauthorized, (await invitado.Http.GetAsync(ruta)).StatusCode);
        Assert.Equal(HttpStatusCode.Unauthorized, (await anonimo.GetAsync(ruta)).StatusCode);

        // Y un docente no usa los endpoints propios de estudiante ni un invitado los de cuenta.
        Assert.Equal(HttpStatusCode.Forbidden, (await docenteAjeno.Http.GetAsync("/api/v1/estudiantes/yo/progreso")).StatusCode);
        Assert.Equal(HttpStatusCode.Unauthorized, (await invitado.Http.GetAsync("/api/v1/estudiantes/yo/puntos")).StatusCode);
    }
}
