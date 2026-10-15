using System.Net;
using System.Net.Http.Json;
using GENIOS.Application.Partidas;
using GENIOS.IntegrationTests.Soporte;

namespace GENIOS.IntegrationTests;

[Collection(ColeccionJuego.Nombre)]
public class PartidasEstudianteTests(FixtureJuego f)
{
    [Fact]
    public async Task Los_puntos_los_calcula_el_servidor_y_el_bono_de_categoria_se_paga_una_sola_vez()
    {
        var estudiante = await JuegoApi.NuevoEstudianteAsync(f);

        // 3 errores en primer intento: 7/10 al primer intento, pero las 10 preguntas terminan bien resueltas.
        var primera = await estudiante.ResultadoAsync(await estudiante.JugarAsync(f.CategoriaA1, fallosEnPrimerIntento: 3));
        Assert.Equal("completada", primera.Estado);
        Assert.True(primera.EsPartidaValida);
        Assert.Equal(7, primera.AciertosPrimerIntento);
        Assert.Equal(70m, primera.PorcentajeAciertos);
        Assert.Equal(10 * 10 + 20, primera.PuntosObtenidos); // 10 respuestas de 10 puntos + bono de categoría

        var segunda = await estudiante.ResultadoAsync(await estudiante.JugarAsync(f.CategoriaA1));
        Assert.Equal(100, segunda.PuntosObtenidos); // sin segundo bono

        var bonos = await f.Escalar<long>(
            "select count(*) from transacciones_puntos t join partidas p on p.id = t.partida_id where p.categoria_id = @c and t.usuario_id = @u and t.tipo_transaccion = 'bono_categoria'",
            ("c", f.CategoriaA1), ("u", estudiante.UsuarioId!.Value)); // solo este estudiante: otras pruebas comparten la categoría
        Assert.Equal(1, bonos);
    }

    [Fact]
    public async Task Sin_tiempo_diario_no_hay_partidas_nuevas_y_la_partida_en_curso_se_cierra()
    {
        var estudiante = await JuegoApi.NuevoEstudianteAsync(f);
        var partidaId = (await (await estudiante.CrearPartidaAsync(f.CategoriaA1)).Content.ReadFromJsonAsync<PartidaDto>())!.PartidaId;
        var (preguntaId, correcta, _) = (await estudiante.OraculoAsync(partidaId))[0];

        await f.Ejecutar(
            @"update uso_diario_estudiante set tiempo_activo_ms = 90 * 60000
              where estudiante_id = (select usuario_id from partidas where id = @p) and fecha_local = (now() at time zone 'America/Guatemala')::date",
            ("p", partidaId));

        var respuesta = await estudiante.ResponderAsync(partidaId, preguntaId, correcta);
        Assert.Equal(HttpStatusCode.Forbidden, respuesta.StatusCode);
        Assert.Equal("limite_diario_agotado", await JuegoApi.CodigoErrorAsync(respuesta));
        Assert.Equal("abandonada/limite_diario", await f.Escalar<string>("select estado || '/' || motivo_finalizacion from partidas where id = @p", ("p", partidaId)));

        var nueva = await estudiante.CrearPartidaAsync(f.CategoriaA1);
        Assert.Equal(HttpStatusCode.Forbidden, nueva.StatusCode);
        Assert.Equal("limite_diario_agotado", await JuegoApi.CodigoErrorAsync(nueva));
    }

    [Fact]
    public async Task El_tercer_error_activa_la_mecha_y_una_partida_vencida_no_se_puede_reanudar()
    {
        var invitado = await JuegoApi.NuevoInvitadoAsync(f);
        var partidaId = (await (await invitado.CrearPartidaAsync(f.CategoriaA1)).Content.ReadFromJsonAsync<PartidaDto>())!.PartidaId;
        var (preguntaId, correcta, opciones) = (await invitado.OraculoAsync(partidaId))[0];
        var mala = opciones.First(o => o != correcta);

        var primero = await (await invitado.ResponderAsync(partidaId, preguntaId, mala)).Content.ReadFromJsonAsync<RespuestaDto>();
        var segundo = await (await invitado.ResponderAsync(partidaId, preguntaId, mala)).Content.ReadFromJsonAsync<RespuestaDto>();
        var tercero = await (await invitado.ResponderAsync(partidaId, preguntaId, mala)).Content.ReadFromJsonAsync<RespuestaDto>();

        Assert.Null(primero!.SegundosMecha);
        Assert.Null(segundo!.SegundosMecha);
        Assert.NotNull(tercero!.SegundosMecha); // el tercer error enciende la mecha

        await Task.Delay(TimeSpan.FromSeconds(3)); // la mecha de prueba dura 2 s
        var tarde = await invitado.ResponderAsync(partidaId, preguntaId, correcta);
        Assert.Equal(HttpStatusCode.Conflict, tarde.StatusCode);
        Assert.Equal("partida_terminada_por_mecha", await JuegoApi.CodigoErrorAsync(tarde));

        var reanudar = await invitado.Http.PostAsync($"/api/v1/partidas/{partidaId}/reanudar", null);
        Assert.Equal(HttpStatusCode.Conflict, reanudar.StatusCode);
        Assert.Equal("partida_terminada_por_mecha", await JuegoApi.CodigoErrorAsync(reanudar));
        Assert.False((await invitado.ResultadoAsync(partidaId)).EsPartidaValida);
    }

    [Fact]
    public async Task Una_partida_se_reanuda_dentro_de_la_ventana_y_no_despues()
    {
        var invitado = await JuegoApi.NuevoInvitadoAsync(f);
        var dentro = (await (await invitado.CrearPartidaAsync(f.CategoriaA1)).Content.ReadFromJsonAsync<PartidaDto>())!.PartidaId;
        await RetrocederActividadAsync(dentro, minutos: 5);

        var reanudada = await invitado.Http.PostAsync($"/api/v1/partidas/{dentro}/reanudar", null);
        Assert.Equal(HttpStatusCode.OK, reanudada.StatusCode);
        Assert.Equal("en_curso", (await reanudada.Content.ReadFromJsonAsync<PartidaDto>())!.Estado);

        await RetrocederActividadAsync(dentro, minutos: 11);
        var tarde = await invitado.Http.PostAsync($"/api/v1/partidas/{dentro}/reanudar", null);
        Assert.Equal(HttpStatusCode.Conflict, tarde.StatusCode);
        Assert.Equal("ventana_reanudacion_vencida", await JuegoApi.CodigoErrorAsync(tarde));
        Assert.Equal("abandonada/false", await f.Escalar<string>("select estado || '/' || es_partida_valida::text from partidas where id = @p", ("p", dentro)));
    }

    private Task RetrocederActividadAsync(Guid partidaId, int minutos) =>
        f.Ejecutar("update partidas set metadatos = jsonb_set(metadatos, '{ultimaActividadEn}', to_jsonb(@t::text)) where id = @p",
            ("t", DateTime.UtcNow.AddMinutes(-minutos).ToString("yyyy-MM-ddTHH:mm:ss.ffffffZ")), ("p", partidaId));
}
