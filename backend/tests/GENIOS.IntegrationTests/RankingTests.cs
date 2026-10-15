using System.Net;
using System.Net.Http.Json;
using GENIOS.Application.Estadisticas;
using GENIOS.IntegrationTests.Soporte;

namespace GENIOS.IntegrationTests;

[Collection(ColeccionJuego.Nombre)]
public class RankingTests(FixtureJuego f)
{
    private static Task<RankingDto> Pedir(JuegoApi docente, string consulta = "") =>
        docente.Http.GetFromJsonAsync<RankingDto>("/api/v1/aulas/ranking" + consulta)!;

    [Fact]
    public async Task El_ranking_ordena_por_puntos_y_solo_incluye_estudiantes_de_las_aulas_del_docente()
    {
        var mejor = await JuegoApi.NuevoEstudianteAsync(f);                 // aula 1: dos categorías = 240 puntos
        var otro = await JuegoApi.NuevoEstudianteAsync(f);                  // aula 1: una categoría = 120 puntos
        var ajeno = await JuegoApi.NuevoEstudianteAsync(f, f.CodigoAula2);  // aula 2 (otro docente)
        await mejor.JugarAsync(f.CategoriaA1);
        await mejor.JugarAsync(f.CategoriaA2);
        await otro.JugarAsync(f.CategoriaA1);
        await ajeno.JugarAsync(f.CategoriaA1);
        var docente = JuegoApi.ComoDocente(f, f.DocenteId);

        var ranking = await Pedir(docente);
        var propios = ranking.Filas.Where(x => x.EstudianteId == mejor.UsuarioId || x.EstudianteId == otro.UsuarioId).ToList();
        Assert.Equal(new[] { mejor.UsuarioId!.Value, otro.UsuarioId!.Value }, propios.Select(x => x.EstudianteId).ToArray());
        Assert.Equal(new[] { 240L, 120L }, propios.Select(x => x.Puntos).ToArray());
        Assert.True(propios[0].Posicion < propios[1].Posicion);
        Assert.DoesNotContain(ranking.Filas, x => x.EstudianteId == ajeno.UsuarioId);
    }

    [Fact]
    public async Task El_ranking_se_filtra_por_aula_y_por_materia()
    {
        var s = await JuegoApi.NuevoEstudianteAsync(f);
        await s.JugarAsync(f.CategoriaA1);
        var docente = JuegoApi.ComoDocente(f, f.DocenteId);

        var deLaAula = await Pedir(docente, $"?aulaId={f.AulaId}");
        Assert.Contains(deLaAula.Filas, x => x.EstudianteId == s.UsuarioId && x.Puntos == 120);

        var asignaturaA = await f.Escalar<long>("select n.asignatura_id from categorias c join niveles_educativos n on n.id = c.nivel_educativo_id where c.id = @c", ("c", f.CategoriaA1));
        var asignaturaB = await f.Escalar<long>("select n.asignatura_id from categorias c join niveles_educativos n on n.id = c.nivel_educativo_id where c.id = @c", ("c", f.CategoriaB1));
        Assert.NotEqual(asignaturaA, asignaturaB);

        var enA = await Pedir(docente, $"?asignaturaId={asignaturaA}");
        Assert.Equal(120, enA.Filas.Single(x => x.EstudianteId == s.UsuarioId).Puntos);
        var enB = await Pedir(docente, $"?asignaturaId={asignaturaB}");
        var filaB = enB.Filas.Single(x => x.EstudianteId == s.UsuarioId);
        Assert.Equal((0L, 0), (filaB.Puntos, filaB.PartidasCompletadas));
    }

    [Fact]
    public async Task Los_empates_comparten_posicion_y_un_estudiante_en_dos_aulas_aparece_una_vez()
    {
        var a = await JuegoApi.NuevoEstudianteAsync(f);
        var b = await JuegoApi.NuevoEstudianteAsync(f);
        await a.JugarAsync(f.CategoriaA1);
        await b.JugarAsync(f.CategoriaA1);
        var docente = JuegoApi.ComoDocente(f, f.DocenteId);
        var ranking = await Pedir(docente);
        var fa = ranking.Filas.Single(x => x.EstudianteId == a.UsuarioId);
        var fb = ranking.Filas.Single(x => x.EstudianteId == b.UsuarioId);
        Assert.Equal(fa.Posicion, fb.Posicion);

        // Un segundo aula del mismo docente con el mismo estudiante no lo duplica.
        var nueva = await docente.Http.PostAsJsonAsync("/api/v1/aulas", new GENIOS.Application.Aulas.SolicitudCrearAula("Aula extra", null));
        var aulaExtra = (await nueva.Content.ReadFromJsonAsync<GENIOS.Application.Aulas.AulaDto>())!;
        var unirse = await a.Http.PostAsJsonAsync("/api/v1/aulas/unirse", new GENIOS.Application.Aulas.SolicitudCodigoAula(aulaExtra.CodigoAcceso!));
        Assert.Equal(HttpStatusCode.OK, unirse.StatusCode);
        var tras = await Pedir(docente);
        var unica = tras.Filas.Single(x => x.EstudianteId == a.UsuarioId);
        Assert.Equal(2, unica.Aulas.Count);
        await f.Ejecutar("delete from miembros_aula where aula_id = @a", ("a", aulaExtra.Id));
        await f.Ejecutar("delete from aulas where id = @a", ("a", aulaExtra.Id));
    }

    [Fact]
    public async Task El_ranking_rechaza_aulas_ajenas_estudiantes_e_invitados()
    {
        var otroDocente = JuegoApi.ComoDocente(f, f.Docente2Id);
        Assert.Equal(HttpStatusCode.NotFound, (await otroDocente.Http.GetAsync($"/api/v1/aulas/ranking?aulaId={f.AulaId}")).StatusCode);

        var estudiante = await JuegoApi.NuevoEstudianteAsync(f);
        Assert.Equal(HttpStatusCode.Forbidden, (await estudiante.Http.GetAsync("/api/v1/aulas/ranking")).StatusCode);

        var anonimo = f.Fabrica.CreateClient();
        Assert.Equal(HttpStatusCode.Unauthorized, (await anonimo.GetAsync("/api/v1/aulas/ranking")).StatusCode);
    }
}
