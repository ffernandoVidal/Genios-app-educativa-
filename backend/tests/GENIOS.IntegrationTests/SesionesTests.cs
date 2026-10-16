using System.Net;
using System.Net.Http.Json;
using System.Text;
using GENIOS.Application.Autenticacion;
using GENIOS.Infrastructure.Autenticacion;
using GENIOS.IntegrationTests.Soporte;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.AspNetCore.TestHost;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.DependencyInjection.Extensions;

namespace GENIOS.IntegrationTests;

/// <summary>Sesiones persistentes: rotación, límite absoluto, cierre idempotente y confirmación del rol docente.</summary>
[Collection(ColeccionJuego.Nombre)]
public class SesionesTests(FixtureJuego f)
{
    private const string Renovar = "/api/v1/autenticacion/renovar";
    private const string CerrarSesion = "/api/v1/autenticacion/cerrar-sesion";
    private const string Cookie = "genios_renovacion";

    // El cliente no guarda cookies: cada prueba decide qué cookie envía.
    private static HttpClient SinCookies(WebApplicationFactory<Program> fabrica) =>
        fabrica.CreateClient(new WebApplicationFactoryClientOptions { HandleCookies = false });

    private static Task<HttpResponseMessage> Post(HttpClient cliente, string ruta, string? cookie, bool csrf = true)
    {
        var peticion = new HttpRequestMessage(HttpMethod.Post, ruta);
        if (cookie is not null) peticion.Headers.Add("Cookie", $"{Cookie}={cookie}");
        if (csrf) peticion.Headers.Add("X-GENIOS-CSRF", "1");
        return cliente.SendAsync(peticion);
    }

    private async Task<(HttpClient Cliente, string Cookie, Guid UsuarioId)> NuevaSesionEstudianteAsync()
    {
        var cliente = SinCookies(f.Fabrica);
        var registro = await cliente.PostAsJsonAsync("/api/v1/estudiantes/registro",
            new SolicitudRegistroEstudiante(null, f.NombreUsuarioNuevo(), "clave123", "Estudiante sesión"));
        Assert.Equal(HttpStatusCode.OK, registro.StatusCode);
        var datos = (await registro.Content.ReadFromJsonAsync<RespuestaAutenticacion>())!;
        return (cliente, JuegoApi.LeerCookie(registro, Cookie)!, datos.Usuario.Id);
    }

    // ------------------------------------------------------------------ Cookie

    [Fact]
    public async Task La_cookie_de_renovacion_es_httponly_con_ruta_limitada_sin_domain_y_el_token_no_va_en_el_cuerpo()
    {
        var cliente = SinCookies(f.Fabrica);
        var respuesta = await cliente.PostAsJsonAsync("/api/v1/estudiantes/registro",
            new SolicitudRegistroEstudiante(null, f.NombreUsuarioNuevo(), "clave123", "Ana"));
        var cookie = respuesta.Headers.GetValues("Set-Cookie").Single(v => v.StartsWith(Cookie + "="));
        Assert.Contains("httponly", cookie, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("path=/api/v1/autenticacion", cookie, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("samesite=lax", cookie, StringComparison.OrdinalIgnoreCase);
        Assert.DoesNotContain("domain=", cookie, StringComparison.OrdinalIgnoreCase);

        var cuerpo = await respuesta.Content.ReadAsStringAsync();
        Assert.DoesNotContain(JuegoApi.LeerCookie(respuesta, Cookie)!, cuerpo);
    }

    // ------------------------------------------------------------------ Renovación

    [Fact]
    public async Task Renovar_rota_el_token_y_el_anterior_deja_de_servir_y_revoca_la_familia()
    {
        var (cliente, primera, usuarioId) = await NuevaSesionEstudianteAsync();

        var uno = await Post(cliente, Renovar, primera);
        Assert.Equal(HttpStatusCode.OK, uno.StatusCode);
        var segunda = JuegoApi.LeerCookie(uno, Cookie)!;
        Assert.NotEqual(primera, segunda);
        var acceso = (await uno.Content.ReadFromJsonAsync<RespuestaAutenticacion>())!;
        Assert.Equal(usuarioId, acceso.Usuario.Id);

        // Reutilizar el token viejo es sospechoso: se rechaza y se revoca toda la familia, incluido el token nuevo.
        Assert.Equal(HttpStatusCode.Unauthorized, (await Post(cliente, Renovar, primera)).StatusCode);
        Assert.Equal(HttpStatusCode.Unauthorized, (await Post(cliente, Renovar, segunda)).StatusCode);
        Assert.True(await f.Escalar<long>("select count(*) from auditoria_seguridad where usuario_id = @u and accion = 'token_renovacion_reutilizado'", ("u", usuarioId)) >= 1);
    }

    [Fact]
    public async Task Dos_renovaciones_simultaneas_con_el_mismo_token_solo_dejan_una_sesion_nueva()
    {
        var (cliente, primera, usuarioId) = await NuevaSesionEstudianteAsync();

        var resultados = await Task.WhenAll(Enumerable.Range(0, 2).Select(_ => Post(cliente, Renovar, primera)));
        Assert.Equal(1, resultados.Count(r => r.StatusCode == HttpStatusCode.OK));
        Assert.Equal(1, resultados.Count(r => r.StatusCode == HttpStatusCode.Unauthorized));

        // El token que ganó se creó y luego la reutilización perdedora revoca la familia: no queda ninguna sesión activa independiente.
        var activas = await f.Escalar<long>("select count(*) from sesiones_autenticacion where usuario_id = @u and revocado_en is null", ("u", usuarioId));
        Assert.True(activas <= 1);
    }

    [Fact]
    public async Task Renovar_sin_cookie_con_token_inventado_o_sin_cabecera_anticsrf_se_rechaza()
    {
        var (cliente, primera, _) = await NuevaSesionEstudianteAsync();

        Assert.Equal(HttpStatusCode.Unauthorized, (await Post(cliente, Renovar, null)).StatusCode);
        Assert.Equal(HttpStatusCode.Unauthorized, (await Post(cliente, Renovar, "token-inventado")).StatusCode);
        Assert.Equal(HttpStatusCode.Forbidden, (await Post(cliente, Renovar, primera, csrf: false)).StatusCode);
    }

    [Fact]
    public async Task Una_sesion_expirada_no_se_puede_renovar()
    {
        var (cliente, cookie, usuarioId) = await NuevaSesionEstudianteAsync();
        await f.Ejecutar("update sesiones_autenticacion set creado_en = now() - interval '2 hours', expira_en = now() - interval '1 hour' where usuario_id = @u", ("u", usuarioId));
        Assert.Equal(HttpStatusCode.Unauthorized, (await Post(cliente, Renovar, cookie)).StatusCode);
    }

    [Fact]
    public async Task La_sesion_dura_como_maximo_30_dias_desde_el_inicio_de_sesion_aunque_se_renueve()
    {
        var (cliente, cookie, usuarioId) = await NuevaSesionEstudianteAsync();

        // La sesión nació hace 29 días: lo que queda es 1 día, no 30 más.
        await f.Ejecutar("update sesiones_autenticacion set creado_en = now() - interval '29 days', expira_en = now() + interval '1 day' where usuario_id = @u", ("u", usuarioId));
        var renovada = await Post(cliente, Renovar, cookie);
        Assert.Equal(HttpStatusCode.OK, renovada.StatusCode);

        var maximo = (double)await f.Escalar<decimal>(
            "select extract(epoch from (max(expira_en) - (select min(creado_en) from sesiones_autenticacion where usuario_id = @u))) / 86400.0 from sesiones_autenticacion where usuario_id = @u", ("u", usuarioId));
        Assert.True(maximo <= 30.001, $"La sesión dura {maximo} días.");

        // Con 31 días de antigüedad ya no hay renovación posible.
        await f.Ejecutar("update sesiones_autenticacion set creado_en = now() - interval '31 days', expira_en = now() + interval '1 hour' where usuario_id = @u and revocado_en is null", ("u", usuarioId));
        Assert.Equal(HttpStatusCode.Unauthorized, (await Post(cliente, Renovar, JuegoApi.LeerCookie(renovada, Cookie)!)).StatusCode);
    }

    // ------------------------------------------------------------------ Cierre de sesión

    [Fact]
    public async Task Cerrar_sesion_revoca_la_renovacion_y_limpia_las_dos_cookies_con_sus_mismos_atributos()
    {
        var (cliente, cookie, _) = await NuevaSesionEstudianteAsync();

        var salida = await Post(cliente, CerrarSesion, cookie);
        Assert.Equal(HttpStatusCode.NoContent, salida.StatusCode);
        var cookies = salida.Headers.GetValues("Set-Cookie").ToList();
        var renovacion = Assert.Single(cookies, c => c.StartsWith(Cookie + "="));
        var invitado = Assert.Single(cookies, c => c.StartsWith("genios_invitado="));
        Assert.Contains("path=/api/v1/autenticacion", renovacion, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("path=/;", invitado + ";", StringComparison.OrdinalIgnoreCase);
        foreach (var c in new[] { renovacion, invitado })
        {
            Assert.Contains("expires=Thu, 01 Jan 1970", c, StringComparison.OrdinalIgnoreCase);
            Assert.Contains("httponly", c, StringComparison.OrdinalIgnoreCase);
            Assert.Contains("samesite=lax", c, StringComparison.OrdinalIgnoreCase);
        }

        Assert.Equal(HttpStatusCode.Unauthorized, (await Post(cliente, Renovar, cookie)).StatusCode);
    }

    [Fact]
    public async Task Cerrar_sesion_sin_sesion_es_idempotente_pero_exige_la_cabecera_anticsrf()
    {
        var cliente = SinCookies(f.Fabrica);
        Assert.Equal(HttpStatusCode.NoContent, (await Post(cliente, CerrarSesion, null)).StatusCode);
        Assert.Equal(HttpStatusCode.NoContent, (await Post(cliente, CerrarSesion, "token-inventado")).StatusCode);
        Assert.Equal(HttpStatusCode.Forbidden, (await Post(cliente, CerrarSesion, null, csrf: false)).StatusCode);
    }

    // ------------------------------------------------------------------ Google y rol docente

    private class VerificadorGoogleFalso(DatosGoogle datos) : VerificadorGoogle(Microsoft.Extensions.Options.Options.Create(new OpcionesAutenticacion()))
    {
        public override Task<DatosGoogle> ValidarAsync(string idToken) => Task.FromResult(datos);
    }

    private HttpClient ClienteConGoogle(DatosGoogle datos) => f.Fabrica.WithWebHostBuilder(b =>
        b.ConfigureTestServices(servicios =>
        {
            servicios.RemoveAll<VerificadorGoogle>();
            servicios.AddSingleton<VerificadorGoogle>(new VerificadorGoogleFalso(datos));
        })).CreateClient(new WebApplicationFactoryClientOptions { HandleCookies = false });

    private DatosGoogle Identidad(string etiqueta) =>
        new($"sub-{f.Etiqueta}-{etiqueta}", $"t{f.Etiqueta}{etiqueta}@prueba.invalid", "Docente de prueba");

    private static void ConToken(HttpClient cliente, string token) =>
        cliente.DefaultRequestHeaders.Authorization = new("Bearer", token);

    private static Task<HttpResponseMessage> Confirmar(HttpClient cliente) =>
        cliente.PostAsync("/api/v1/autenticacion/docente/confirmar", null);

    [Fact]
    public async Task Una_identidad_nueva_de_google_entra_sin_rol_ni_perfiles_y_confirmar_le_da_el_rol_docente()
    {
        var identidad = Identidad("sx1");
        var cliente = ClienteConGoogle(identidad);

        var login = await cliente.PostAsJsonAsync("/api/v1/autenticacion/google", new SolicitudGoogle("x"));
        Assert.True(login.StatusCode == HttpStatusCode.OK, await login.Content.ReadAsStringAsync());
        var pendiente = (await login.Content.ReadFromJsonAsync<RespuestaAutenticacion>())!;
        Assert.Empty(pendiente.Usuario.Roles);
        Assert.Equal(0, await f.Escalar<long>("select count(*) from perfiles_docente where usuario_id = @u", ("u", pendiente.Usuario.Id)));
        Assert.Equal(0, await f.Escalar<long>("select count(*) from perfiles_estudiante where usuario_id = @u", ("u", pendiente.Usuario.Id)));

        // Sin rol no hay acceso a nada docente.
        ConToken(cliente, pendiente.TokenAcceso);
        Assert.Equal(HttpStatusCode.Forbidden, (await cliente.GetAsync("/api/v1/docente/resumen")).StatusCode);

        var confirmado = await Confirmar(cliente);
        Assert.Equal(HttpStatusCode.OK, confirmado.StatusCode);
        var docente = (await confirmado.Content.ReadFromJsonAsync<RespuestaAutenticacion>())!;
        Assert.Equal(["docente"], docente.Usuario.Roles);
        Assert.Equal(1, await f.Escalar<long>("select count(*) from perfiles_docente where usuario_id = @u", ("u", pendiente.Usuario.Id)));

        ConToken(cliente, docente.TokenAcceso);
        Assert.Equal(HttpStatusCode.OK, (await cliente.GetAsync("/api/v1/docente/resumen")).StatusCode);

        // Volver a iniciar sesión no duplica la cuenta y ya entra como docente.
        cliente.DefaultRequestHeaders.Authorization = null;
        var otra = (await (await cliente.PostAsJsonAsync("/api/v1/autenticacion/google", new SolicitudGoogle("x")))
            .Content.ReadFromJsonAsync<RespuestaAutenticacion>())!;
        Assert.Equal(pendiente.Usuario.Id, otra.Usuario.Id);
        Assert.Equal(["docente"], otra.Usuario.Roles);
        Assert.Equal(1, await f.Escalar<long>("select count(*) from identidades_externas where identificador_externo = @s", ("s", identidad.Sub)));
    }

    [Fact]
    public async Task Confirmar_dos_veces_o_a_la_vez_deja_un_solo_rol_y_un_solo_perfil()
    {
        var cliente = ClienteConGoogle(Identidad("sx2"));
        var pendiente = (await (await cliente.PostAsJsonAsync("/api/v1/autenticacion/google", new SolicitudGoogle("x")))
            .Content.ReadFromJsonAsync<RespuestaAutenticacion>())!;
        ConToken(cliente, pendiente.TokenAcceso);

        var resultados = await Task.WhenAll(Enumerable.Range(0, 4).Select(_ => Confirmar(cliente)));
        Assert.All(resultados, r => Assert.Equal(HttpStatusCode.OK, r.StatusCode));
        Assert.Equal(1, await f.Escalar<long>("select count(*) from usuarios_roles where usuario_id = @u", ("u", pendiente.Usuario.Id)));
        Assert.Equal(1, await f.Escalar<long>("select count(*) from perfiles_docente where usuario_id = @u", ("u", pendiente.Usuario.Id)));
        Assert.Equal(HttpStatusCode.OK, (await Confirmar(cliente)).StatusCode);
    }

    [Fact]
    public async Task Pedir_el_rol_docente_en_la_solicitud_de_google_no_lo_concede()
    {
        var cliente = ClienteConGoogle(Identidad("sx3"));
        var respuesta = await cliente.PostAsync("/api/v1/autenticacion/google",
            new StringContent("""{"idToken":"x","solicitaRolDocente":true,"roles":["docente"]}""", Encoding.UTF8, "application/json"));
        var datos = (await respuesta.Content.ReadFromJsonAsync<RespuestaAutenticacion>())!;
        Assert.Empty(datos.Usuario.Roles);
    }

    [Fact]
    public async Task Un_estudiante_no_puede_convertirse_en_docente()
    {
        // Estudiante con contraseña.
        var (cliente, _, _) = await NuevaSesionEstudianteAsync();
        var login = await cliente.PostAsJsonAsync("/api/v1/estudiantes/registro",
            new SolicitudRegistroEstudiante(null, f.NombreUsuarioNuevo(), "clave123", "Otro"));
        ConToken(cliente, (await login.Content.ReadFromJsonAsync<RespuestaAutenticacion>())!.TokenAcceso);
        Assert.Equal(HttpStatusCode.Forbidden, (await Confirmar(cliente)).StatusCode);

        // Cuenta de Google que ya es estudiante.
        var google = ClienteConGoogle(Identidad("sx4"));
        var datos = (await (await google.PostAsJsonAsync("/api/v1/autenticacion/google", new SolicitudGoogle("x")))
            .Content.ReadFromJsonAsync<RespuestaAutenticacion>())!;
        await f.Ejecutar("insert into usuarios_roles (usuario_id, rol_id) select @u, id from roles where codigo = 'estudiante'", ("u", datos.Usuario.Id));
        var relogin = (await (await google.PostAsJsonAsync("/api/v1/autenticacion/google", new SolicitudGoogle("x")))
            .Content.ReadFromJsonAsync<RespuestaAutenticacion>())!;
        Assert.Equal(["estudiante"], relogin.Usuario.Roles);
        ConToken(google, relogin.TokenAcceso);
        Assert.Equal(HttpStatusCode.Forbidden, (await Confirmar(google)).StatusCode);
        Assert.Equal(0, await f.Escalar<long>("select count(*) from perfiles_docente where usuario_id = @u", ("u", datos.Usuario.Id)));
    }

    [Fact]
    public async Task Confirmar_el_rol_exige_estar_autenticado()
    {
        var cliente = SinCookies(f.Fabrica);
        Assert.Equal(HttpStatusCode.Unauthorized, (await Confirmar(cliente)).StatusCode);
    }

    // ------------------------------------------------------------------ Datos académicos y sesión

    [Fact]
    public async Task Cerrar_sesion_no_borra_la_cuenta_ni_el_progreso_y_se_puede_volver_a_entrar()
    {
        var cliente = SinCookies(f.Fabrica);
        var usuario = f.NombreUsuarioNuevo();
        var registro = await cliente.PostAsJsonAsync("/api/v1/estudiantes/registro",
            new SolicitudRegistroEstudiante(null, usuario, "clave123", "Ana"));
        var cookie = JuegoApi.LeerCookie(registro, Cookie)!;
        var id = (await registro.Content.ReadFromJsonAsync<RespuestaAutenticacion>())!.Usuario.Id;

        await Post(cliente, CerrarSesion, cookie);

        Assert.Equal(1, await f.Escalar<long>("select count(*) from usuarios where id = @u", ("u", id)));
        var otra = await cliente.PostAsJsonAsync("/api/v1/autenticacion/estudiante/iniciar-sesion", new SolicitudInicioSesionEstudiante(usuario, "clave123"));
        Assert.Equal(HttpStatusCode.OK, otra.StatusCode);
        Assert.Equal(id, (await otra.Content.ReadFromJsonAsync<RespuestaAutenticacion>())!.Usuario.Id);
    }
}
