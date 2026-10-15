using System.Net;
using System.Net.Http.Json;
using System.Text.Json;
using GENIOS.Application.Autenticacion;
using GENIOS.Application.Invitados;
using GENIOS.Application.Partidas;

namespace GENIOS.IntegrationTests.Soporte;

/// <summary>Un jugador (invitado o estudiante) con su propio HttpClient, y atajos para jugar partidas completas.</summary>
public class JuegoApi(HttpClient http, FixtureJuego fixture)
{
    public HttpClient Http { get; } = http;
    public string? TokenCookie { get; private set; }
    public Guid? SesionInvitadoId { get; private set; }

    public static async Task<JuegoApi> NuevoInvitadoAsync(FixtureJuego fixture)
    {
        var cliente = fixture.Fabrica.CreateClient();
        cliente.DefaultRequestHeaders.Add("X-GENIOS-CSRF", "1");
        var api = new JuegoApi(cliente, fixture);

        var respuesta = await cliente.PostAsync("/api/v1/sesiones-juego", null);
        respuesta.EnsureSuccessStatusCode();
        api.TokenCookie = LeerCookie(respuesta, "genios_invitado");
        api.SesionInvitadoId = await fixture.RegistrarSesionInvitadoAsync(api.TokenCookie!);
        return api;
    }

    public Guid? UsuarioId { get; private set; }

    /// <summary>Estudiante nuevo; se une al aula 1 salvo que se indique otro código de aula.</summary>
    public static async Task<JuegoApi> NuevoEstudianteAsync(FixtureJuego fixture, string? codigoAula = null)
    {
        var cliente = fixture.Fabrica.CreateClient();
        var respuesta = await cliente.PostAsJsonAsync("/api/v1/estudiantes/registro", new SolicitudRegistroEstudiante(
            codigoAula ?? fixture.CodigoAula, fixture.NombreUsuarioNuevo(), "clave123", "Estudiante test"));
        respuesta.EnsureSuccessStatusCode();
        var datos = (await respuesta.Content.ReadFromJsonAsync<RespuestaAutenticacion>())!;
        cliente.DefaultRequestHeaders.Authorization = new("Bearer", datos.TokenAcceso);
        return new JuegoApi(cliente, fixture) { UsuarioId = datos.Usuario.Id };
    }

    /// <summary>Cliente autenticado como un docente de prueba.</summary>
    public static JuegoApi ComoDocente(FixtureJuego fixture, Guid docenteId)
    {
        var cliente = fixture.Fabrica.CreateClient();
        cliente.DefaultRequestHeaders.Authorization = new("Bearer", fixture.TokenDocente(docenteId));
        return new JuegoApi(cliente, fixture) { UsuarioId = docenteId };
    }

    public static string? LeerCookie(HttpResponseMessage respuesta, string nombre) =>
        respuesta.Headers.TryGetValues("Set-Cookie", out var valores)
            ? valores.Select(v => v.Split(';')[0]).Where(v => v.StartsWith(nombre + "=")).Select(v => v[(nombre.Length + 1)..]).FirstOrDefault()
            : null;

    public async Task<SesionInvitadoDto> EstadoInvitadoAsync() =>
        (await Http.GetFromJsonAsync<SesionInvitadoDto>("/api/v1/sesiones-juego/yo"))!;

    public Task<HttpResponseMessage> CrearPartidaAsync(long categoriaId, Guid? clave = null) =>
        Http.PostAsJsonAsync("/api/v1/partidas", new SolicitudCrearPartida(categoriaId, clave));

    public Task<HttpResponseMessage> ResponderAsync(Guid partidaId, Guid preguntaId, Guid opcionId, Guid? clave = null) =>
        Http.PostAsJsonAsync($"/api/v1/partidas/{partidaId}/respuestas",
            new SolicitudResponder(preguntaId, opcionId, clave ?? Guid.NewGuid()));

    /// <summary>Crea la partida y responde las preguntas usando las claves que solo el servidor conoce (leídas de la base).</summary>
    public async Task<Guid> JugarAsync(long categoriaId, int fallosEnPrimerIntento = 0, int? soloPreguntas = null)
    {
        var respuesta = await CrearPartidaAsync(categoriaId);
        Assert.Equal(HttpStatusCode.OK, respuesta.StatusCode);
        var partidaId = (await respuesta.Content.ReadFromJsonAsync<PartidaDto>())!.PartidaId;

        var preguntas = await OraculoAsync(partidaId);
        for (var i = 0; i < (soloPreguntas ?? preguntas.Count); i++)
        {
            var (preguntaId, correcta, opciones) = preguntas[i];
            if (i < fallosEnPrimerIntento)
            {
                var mala = await ResponderAsync(partidaId, preguntaId, opciones.First(o => o != correcta));
                Assert.Equal(HttpStatusCode.OK, mala.StatusCode);
            }
            var buena = await ResponderAsync(partidaId, preguntaId, correcta);
            Assert.Equal(HttpStatusCode.OK, buena.StatusCode);
        }
        return partidaId;
    }

    public async Task<List<(Guid PreguntaId, Guid Correcta, List<Guid> Opciones)>> OraculoAsync(Guid partidaId)
    {
        var filas = await fixture.Filas(
            @"select q.id, (r.respuesta_correcta->>'opcionId')::uuid, q.opciones_instantanea::text
              from preguntas_partida q join respuestas_correctas_partida r on r.pregunta_partida_id = q.id
              where q.partida_id = @p order by q.posicion", ("p", partidaId));
        return filas.Select(f => ((Guid)f[0], (Guid)f[1],
            JsonDocument.Parse((string)f[2]).RootElement.EnumerateArray().Select(o => o.GetProperty("id").GetGuid()).ToList())).ToList();
    }

    public async Task<ResultadoPartidaDto> ResultadoAsync(Guid partidaId) =>
        (await Http.GetFromJsonAsync<ResultadoPartidaDto>($"/api/v1/partidas/{partidaId}/resultado"))!;

    public static async Task<string?> CodigoErrorAsync(HttpResponseMessage respuesta)
    {
        var json = JsonDocument.Parse(await respuesta.Content.ReadAsStringAsync());
        return json.RootElement.TryGetProperty("codigo", out var c) ? c.GetString() : null;
    }
}
