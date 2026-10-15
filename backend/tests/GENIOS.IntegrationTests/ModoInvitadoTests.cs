using System.Net;
using System.Net.Http.Json;
using System.Text.Json;
using GENIOS.Application.Contenido;
using GENIOS.Application.Invitados;
using GENIOS.Application.Partidas;
using GENIOS.IntegrationTests.Soporte;

namespace GENIOS.IntegrationTests;

[Collection(ColeccionJuego.Nombre)]
public class ModoInvitadoTests(FixtureJuego f)
{
    // ------------------------------------------------------------ Sesión: seguridad y expiración

    [Fact]
    public async Task Crear_sesion_entrega_cookie_HttpOnly_y_no_expone_el_token()
    {
        var cliente = f.Fabrica.CreateClient();
        var respuesta = await cliente.PostAsync("/api/v1/sesiones-juego", null);
        Assert.Equal(HttpStatusCode.OK, respuesta.StatusCode);

        var cookie = respuesta.Headers.GetValues("Set-Cookie").Single(v => v.StartsWith("genios_invitado="));
        Assert.Contains("httponly", cookie, StringComparison.OrdinalIgnoreCase);

        var token = JuegoApi.LeerCookie(respuesta, "genios_invitado")!;
        var sesionId = await f.RegistrarSesionInvitadoAsync(token);
        Assert.DoesNotContain(token, await respuesta.Content.ReadAsStringAsync());

        // En la base solo está el hash, nunca el token.
        var hash = await f.Escalar<string>("select identificador_token_hash from sesiones_invitado where id = @i", ("i", sesionId));
        Assert.NotEqual(token, hash);
        Assert.Equal(64, hash.Length);
    }

    [Fact]
    public async Task Crear_sesion_con_cookie_vigente_reutiliza_la_misma_sesion()
    {
        var invitado = await JuegoApi.NuevoInvitadoAsync(f);

        var otra = await invitado.Http.PostAsync("/api/v1/sesiones-juego", null);

        Assert.Equal(HttpStatusCode.OK, otra.StatusCode);
        Assert.Null(JuegoApi.LeerCookie(otra, "genios_invitado")); // no se emite una cookie nueva
    }

    [Fact]
    public async Task Las_operaciones_de_invitado_sin_cabecera_anticsrf_son_rechazadas()
    {
        var invitado = await JuegoApi.NuevoInvitadoAsync(f);
        var sinCabecera = f.Fabrica.CreateClient();
        sinCabecera.DefaultRequestHeaders.Add("Cookie", $"genios_invitado={invitado.TokenCookie}");

        var rechazada = await sinCabecera.PostAsJsonAsync("/api/v1/partidas", new SolicitudCrearPartida(f.CategoriaA1, null));
        var aceptada = await invitado.CrearPartidaAsync(f.CategoriaA1);

        Assert.Equal(HttpStatusCode.Unauthorized, rechazada.StatusCode);
        Assert.Equal(HttpStatusCode.OK, aceptada.StatusCode);
    }

    [Fact]
    public async Task Una_sesion_expirada_no_puede_continuar_y_la_nueva_empieza_vacia()
    {
        var invitado = await JuegoApi.NuevoInvitadoAsync(f);
        var partidaId = await invitado.JugarAsync(f.CategoriaA1);
        Assert.Equal(1, (await invitado.EstadoInvitadoAsync()).PartidasValidas);

        await f.Ejecutar("update sesiones_invitado set expira_en = now() - interval '1 minute' where id = @i", ("i", invitado.SesionInvitadoId!.Value));

        Assert.Equal(HttpStatusCode.Unauthorized, (await invitado.Http.GetAsync("/api/v1/sesiones-juego/yo")).StatusCode);
        Assert.Equal(HttpStatusCode.Unauthorized, (await invitado.Http.GetAsync($"/api/v1/partidas/{partidaId}")).StatusCode);
        Assert.Equal(HttpStatusCode.Unauthorized, (await invitado.CrearPartidaAsync(f.CategoriaA1)).StatusCode);
        Assert.Equal("expirada", await f.Escalar<string>("select estado from sesiones_invitado where id = @i", ("i", invitado.SesionInvitadoId.Value)));

        // Con la cookie vencida se obtiene una sesión nueva, sin el progreso anterior.
        var nueva = await invitado.Http.PostAsync("/api/v1/sesiones-juego", null);
        var token = JuegoApi.LeerCookie(nueva, "genios_invitado");
        Assert.NotNull(token);
        await f.RegistrarSesionInvitadoAsync(token);
        var estado = (await nueva.Content.ReadFromJsonAsync<SesionInvitadoDto>())!;
        Assert.Equal(0, estado.PartidasValidas);
    }

    // ------------------------------------------------------------ Propiedad

    [Fact]
    public async Task Una_partida_pertenece_solo_a_su_propietario()
    {
        var duenio = await JuegoApi.NuevoInvitadoAsync(f);
        var otroInvitado = await JuegoApi.NuevoInvitadoAsync(f);
        var estudiante = await JuegoApi.NuevoEstudianteAsync(f);
        var partidaDeInvitado = await duenio.JugarAsync(f.CategoriaA1, soloPreguntas: 1);
        var partidaDeEstudiante = await estudiante.JugarAsync(f.CategoriaA1, soloPreguntas: 1);
        var oraculo = await duenio.OraculoAsync(partidaDeInvitado);
        var (preguntaId, correcta, _) = oraculo[1];

        foreach (var intruso in new[] { otroInvitado, estudiante })
        {
            Assert.Equal(HttpStatusCode.NotFound, (await intruso.Http.GetAsync($"/api/v1/partidas/{partidaDeInvitado}")).StatusCode);
            Assert.Equal(HttpStatusCode.NotFound, (await intruso.ResponderAsync(partidaDeInvitado, preguntaId, correcta)).StatusCode);
            Assert.Equal(HttpStatusCode.NotFound, (await intruso.Http.PostAsync($"/api/v1/partidas/{partidaDeInvitado}/reanudar", null)).StatusCode);
            Assert.Equal(HttpStatusCode.NotFound, (await intruso.Http.PostAsync($"/api/v1/partidas/{partidaDeInvitado}/abandonar", null)).StatusCode);
            Assert.Equal(HttpStatusCode.NotFound, (await intruso.Http.GetAsync($"/api/v1/partidas/{partidaDeInvitado}/resultado")).StatusCode);
        }
        // Y al revés: un invitado no ve la partida de un estudiante.
        Assert.Equal(HttpStatusCode.NotFound, (await duenio.Http.GetAsync($"/api/v1/partidas/{partidaDeEstudiante}")).StatusCode);
        // El dueño sí.
        Assert.Equal(HttpStatusCode.OK, (await duenio.Http.GetAsync($"/api/v1/partidas/{partidaDeInvitado}")).StatusCode);
    }

    // ------------------------------------------------------------ Idempotencia

    [Fact]
    public async Task Una_respuesta_repetida_con_la_misma_clave_no_se_registra_dos_veces()
    {
        var invitado = await JuegoApi.NuevoInvitadoAsync(f);
        var partidaId = (await (await invitado.CrearPartidaAsync(f.CategoriaA1)).Content.ReadFromJsonAsync<PartidaDto>())!.PartidaId;
        var (preguntaId, correcta, _) = (await invitado.OraculoAsync(partidaId))[0];
        var clave = Guid.NewGuid();

        var primera = await (await invitado.ResponderAsync(partidaId, preguntaId, correcta, clave)).Content.ReadFromJsonAsync<RespuestaDto>();
        var repetida = await (await invitado.ResponderAsync(partidaId, preguntaId, correcta, clave)).Content.ReadFromJsonAsync<RespuestaDto>();

        Assert.Equal(primera, repetida);
        Assert.Equal(1, await f.Escalar<long>("select count(*) from intentos_respuesta where clave_idempotencia = @c", ("c", clave)));
        Assert.Equal(1, await f.Escalar<long>(
            "select count(*) from intentos_respuesta i join preguntas_partida q on q.id = i.pregunta_partida_id where q.partida_id = @p", ("p", partidaId)));
    }

    [Fact]
    public async Task Crear_partida_con_la_misma_clave_devuelve_la_misma_partida_y_otro_jugador_no_puede_usarla()
    {
        var invitado = await JuegoApi.NuevoInvitadoAsync(f);
        var otro = await JuegoApi.NuevoInvitadoAsync(f);
        var clave = Guid.NewGuid();

        var a = await (await invitado.CrearPartidaAsync(f.CategoriaA1, clave)).Content.ReadFromJsonAsync<PartidaDto>();
        var b = await (await invitado.CrearPartidaAsync(f.CategoriaA1, clave)).Content.ReadFromJsonAsync<PartidaDto>();
        var ajena = await otro.CrearPartidaAsync(f.CategoriaA1, clave);

        Assert.Equal(a!.PartidaId, b!.PartidaId);
        Assert.Equal(HttpStatusCode.Conflict, ajena.StatusCode);
        Assert.Equal("clave_operacion_en_uso", await JuegoApi.CodigoErrorAsync(ajena));
    }

    // ------------------------------------------------------------ Regla de la invitación a registrarse

    [Fact]
    public async Task La_invitacion_exige_tres_partidas_validas_con_mas_del_61_por_ciento_cada_una()
    {
        var invitado = await JuegoApi.NuevoInvitadoAsync(f);

        // 7/10 = 70 %: cuenta. Es de Matemáticas.
        await invitado.JugarAsync(f.CategoriaA1, fallosEnPrimerIntento: 3);
        var estado = await invitado.EstadoInvitadoAsync();
        Assert.Equal((1, 1, false), (estado.PartidasValidas, estado.PartidasQueCuentan, estado.InvitarARegistrarse));

        // 6/10 = 60 %: es válida pero no supera el 61 %. Es de otra materia (Lenguaje).
        await invitado.JugarAsync(f.CategoriaB1, fallosEnPrimerIntento: 4);
        estado = await invitado.EstadoInvitadoAsync();
        Assert.Equal((2, 1, false), (estado.PartidasValidas, estado.PartidasQueCuentan, estado.InvitarARegistrarse));

        // Una partida incompleta (abandonada a la mitad) no cuenta.
        var incompleta = await invitado.JugarAsync(f.CategoriaA1, soloPreguntas: 5);
        Assert.Equal(HttpStatusCode.NoContent, (await invitado.Http.PostAsync($"/api/v1/partidas/{incompleta}/abandonar", null)).StatusCode);
        estado = await invitado.EstadoInvitadoAsync();
        Assert.Equal((2, 1, false), (estado.PartidasValidas, estado.PartidasQueCuentan, estado.InvitarARegistrarse));
        Assert.False((await invitado.ResultadoAsync(incompleta)).EsPartidaValida);

        // 10/10: segunda que cuenta.
        await invitado.JugarAsync(f.CategoriaA1);
        estado = await invitado.EstadoInvitadoAsync();
        Assert.Equal((3, 2, false), (estado.PartidasValidas, estado.PartidasQueCuentan, estado.InvitarARegistrarse));

        // Las partidas se acumulan entre días: se mueven dos días al pasado y siguen contando.
        await f.Ejecutar(
            "update partidas set iniciada_en = iniciada_en - interval '2 days', finalizada_en = finalizada_en - interval '2 days' where sesion_invitado_id = @i",
            ("i", invitado.SesionInvitadoId!.Value));
        estado = await invitado.EstadoInvitadoAsync();
        Assert.Equal((3, 2, false), (estado.PartidasValidas, estado.PartidasQueCuentan, estado.InvitarARegistrarse));

        // 7/10: tercera que cuenta -> aparece la invitación, con el aviso sobre el progreso anónimo.
        await invitado.JugarAsync(f.CategoriaA1, fallosEnPrimerIntento: 3);
        estado = await invitado.EstadoInvitadoAsync();
        Assert.Equal((4, 3, true), (estado.PartidasValidas, estado.PartidasQueCuentan, estado.InvitarARegistrarse));
        Assert.Contains("no se guardará", estado.AvisoProgreso);
    }

    [Fact]
    public async Task Registrarse_no_transfiere_el_progreso_del_invitado()
    {
        var invitado = await JuegoApi.NuevoInvitadoAsync(f);
        await invitado.JugarAsync(f.CategoriaA1);
        Assert.Equal(1, (await invitado.EstadoInvitadoAsync()).PartidasValidas);

        // El mismo dispositivo se registra como estudiante: cuenta nueva y vacía.
        var estudiante = await JuegoApi.NuevoEstudianteAsync(f);
        var progreso = await estudiante.Http.GetFromJsonAsync<ProgresoCategoriaDto>($"/api/v1/categorias/{f.CategoriaA1}/progreso");
        var categorias = await estudiante.Http.GetFromJsonAsync<List<CategoriaDto>>($"/api/v1/niveles/{f.NivelA}/categorias");

        Assert.Equal(0, progreso!.PartidasCompletadas);
        Assert.False(progreso.Completada);
        Assert.True(categorias!.Single(c => c.Id == f.CategoriaA2).Bloqueada); // sigue bloqueada para la cuenta nueva
    }

    // ------------------------------------------------------------ Progresión de categorías

    [Fact]
    public async Task La_categoria_siguiente_esta_bloqueada_hasta_completar_la_anterior()
    {
        var invitado = await JuegoApi.NuevoInvitadoAsync(f);

        var antes = await invitado.Http.GetFromJsonAsync<List<CategoriaDto>>($"/api/v1/niveles/{f.NivelA}/categorias");
        Assert.False(antes!.Single(c => c.Id == f.CategoriaA1).Bloqueada);
        Assert.True(antes.Single(c => c.Id == f.CategoriaA2).Bloqueada);

        var bloqueada = await invitado.CrearPartidaAsync(f.CategoriaA2);
        Assert.Equal(HttpStatusCode.Forbidden, bloqueada.StatusCode);
        Assert.Equal("categoria_bloqueada", await JuegoApi.CodigoErrorAsync(bloqueada));

        await invitado.JugarAsync(f.CategoriaA1);

        var despues = await invitado.Http.GetFromJsonAsync<List<CategoriaDto>>($"/api/v1/niveles/{f.NivelA}/categorias");
        Assert.False(despues!.Single(c => c.Id == f.CategoriaA2).Bloqueada);
        Assert.Equal(2, despues.Count);
        Assert.Equal(HttpStatusCode.OK, (await invitado.CrearPartidaAsync(f.CategoriaA2)).StatusCode);
    }
}
