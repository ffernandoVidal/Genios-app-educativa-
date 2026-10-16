using System.Net;
using System.Net.Http.Json;
using GENIOS.Application.Aulas;
using GENIOS.Application.Autenticacion;
using GENIOS.Infrastructure.Autenticacion;
using GENIOS.IntegrationTests.Soporte;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.TestHost;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.DependencyInjection.Extensions;

namespace GENIOS.IntegrationTests;

[Collection(ColeccionJuego.Nombre)]
public class CuentasTests(FixtureJuego f)
{
    [Fact]
    public async Task Un_estudiante_se_registra_sin_aula_inicia_sesion_y_se_une_despues()
    {
        var cliente = f.Fabrica.CreateClient();
        var usuario = f.NombreUsuarioNuevo();

        var registro = await cliente.PostAsJsonAsync("/api/v1/estudiantes/registro",
            new SolicitudRegistroEstudiante(null, usuario, "clave123", "Estudiante sin aula"));
        Assert.Equal(HttpStatusCode.OK, registro.StatusCode);
        var datos = (await registro.Content.ReadFromJsonAsync<RespuestaAutenticacion>())!;
        cliente.DefaultRequestHeaders.Authorization = new("Bearer", datos.TokenAcceso);
        Assert.Empty((await cliente.GetFromJsonAsync<List<AulaDto>>("/api/v1/aulas/mi-aula"))!);

        var otro = f.Fabrica.CreateClient();
        var login = await otro.PostAsJsonAsync("/api/v1/autenticacion/estudiante/iniciar-sesion",
            new SolicitudInicioSesionEstudiante(usuario, "clave123"));
        Assert.Equal(HttpStatusCode.OK, login.StatusCode);

        var unirse = await cliente.PostAsJsonAsync("/api/v1/aulas/unirse", new SolicitudCodigoAula(f.CodigoAula));
        Assert.Equal(HttpStatusCode.OK, unirse.StatusCode);
        Assert.Single((await cliente.GetFromJsonAsync<List<AulaDto>>("/api/v1/aulas/mi-aula"))!);
    }

    [Fact]
    public async Task Un_codigo_de_aula_inexistente_sigue_rechazandose_y_un_codigo_vacio_no()
    {
        var cliente = f.Fabrica.CreateClient();
        var malo = await cliente.PostAsJsonAsync("/api/v1/estudiantes/registro",
            new SolicitudRegistroEstudiante("ZZZZZ", f.NombreUsuarioNuevo(), "clave123", "Ana"));
        Assert.Equal(HttpStatusCode.NotFound, malo.StatusCode);

        var vacio = await cliente.PostAsJsonAsync("/api/v1/estudiantes/registro",
            new SolicitudRegistroEstudiante("  ", f.NombreUsuarioNuevo(), "clave123", "Ana"));
        Assert.Equal(HttpStatusCode.OK, vacio.StatusCode);
    }

    [Fact]
    public async Task No_se_duplica_el_nombre_de_usuario()
    {
        var cliente = f.Fabrica.CreateClient();
        var usuario = f.NombreUsuarioNuevo();
        var solicitud = new SolicitudRegistroEstudiante(null, usuario, "clave123", "Ana");
        Assert.Equal(HttpStatusCode.OK, (await cliente.PostAsJsonAsync("/api/v1/estudiantes/registro", solicitud)).StatusCode);
        Assert.Equal(HttpStatusCode.Conflict, (await cliente.PostAsJsonAsync("/api/v1/estudiantes/registro", solicitud)).StatusCode);
    }

    [Fact]
    public async Task Una_credencial_de_google_invalida_se_rechaza_sin_crear_cuentas()
    {
        var cliente = f.Fabrica.CreateClient();
        var respuesta = await cliente.PostAsJsonAsync("/api/v1/autenticacion/google", new SolicitudGoogle("no-es-un-token"));
        Assert.Equal(HttpStatusCode.Unauthorized, respuesta.StatusCode);
    }

    [Fact]
    public async Task Un_estudiante_no_puede_usar_funciones_de_docente_ni_ver_aulas_ajenas()
    {
        var estudiante = await JuegoApi.NuevoEstudianteAsync(f);
        var crear = await estudiante.Http.PostAsJsonAsync("/api/v1/aulas", new SolicitudCrearAula("Aula intrusa", null));
        Assert.Equal(HttpStatusCode.Forbidden, crear.StatusCode);
        var estadisticas = await estudiante.Http.GetAsync($"/api/v1/aulas/{f.AulaId}/estadisticas");
        Assert.Equal(HttpStatusCode.Forbidden, estadisticas.StatusCode);
    }

    [Fact]
    public async Task El_docente_agrega_un_estudiante_a_su_aula_y_este_elige_su_contrasena_con_el_codigo()
    {
        var docente = JuegoApi.ComoDocente(f, f.DocenteId);
        var respuesta = await docente.Http.PostAsJsonAsync($"/api/v1/aulas/{f.AulaId}/estudiantes",
            new SolicitudCrearEstudianteEnAula("Estudiante agregado", f.NombreUsuarioNuevo()));
        Assert.Equal(HttpStatusCode.OK, respuesta.StatusCode);
        var creado = (await respuesta.Content.ReadFromJsonAsync<EstudianteCreadoDto>())!;
        Assert.False(string.IsNullOrWhiteSpace(creado.CodigoActivacion));

        var lista = (await docente.Http.GetFromJsonAsync<List<EstudianteAulaDto>>($"/api/v1/aulas/{f.AulaId}/estudiantes"))!;
        Assert.Contains(lista, e => e.Id == creado.Id);

        // Sin contraseña no se puede entrar.
        var anonimo = f.Fabrica.CreateClient();
        var intento = await anonimo.PostAsJsonAsync("/api/v1/autenticacion/estudiante/iniciar-sesion",
            new SolicitudInicioSesionEstudiante(creado.NombreUsuario, "clave123"));
        Assert.Equal(HttpStatusCode.Unauthorized, intento.StatusCode);

        // Con el código elige su contraseña y entra.
        var activar = await anonimo.PostAsJsonAsync("/api/v1/estudiantes/restablecimiento-confirmar",
            new SolicitudConfirmarRestablecimiento(creado.NombreUsuario, creado.CodigoActivacion, "clave-nueva-1"));
        Assert.Equal(HttpStatusCode.NoContent, activar.StatusCode);
        var entrar = await anonimo.PostAsJsonAsync("/api/v1/autenticacion/estudiante/iniciar-sesion",
            new SolicitudInicioSesionEstudiante(creado.NombreUsuario, "clave-nueva-1"));
        Assert.Equal(HttpStatusCode.OK, entrar.StatusCode);

        // El código es de un solo uso.
        var repetido = await anonimo.PostAsJsonAsync("/api/v1/estudiantes/restablecimiento-confirmar",
            new SolicitudConfirmarRestablecimiento(creado.NombreUsuario, creado.CodigoActivacion, "otra-clave-2"));
        Assert.Equal(HttpStatusCode.BadRequest, repetido.StatusCode);
    }

    [Fact]
    public async Task Un_docente_no_puede_agregar_estudiantes_al_aula_de_otro_ni_un_estudiante_a_ninguna()
    {
        var otroDocente = JuegoApi.ComoDocente(f, f.Docente2Id);
        var ajena = await otroDocente.Http.PostAsJsonAsync($"/api/v1/aulas/{f.AulaId}/estudiantes",
            new SolicitudCrearEstudianteEnAula("Intruso", f.NombreUsuarioNuevo()));
        Assert.Equal(HttpStatusCode.NotFound, ajena.StatusCode);

        var estudiante = await JuegoApi.NuevoEstudianteAsync(f);
        var comoEstudiante = await estudiante.Http.PostAsJsonAsync($"/api/v1/aulas/{f.AulaId}/estudiantes",
            new SolicitudCrearEstudianteEnAula("Intruso", f.NombreUsuarioNuevo()));
        Assert.Equal(HttpStatusCode.Forbidden, comoEstudiante.StatusCode);
    }

    [Fact]
    public async Task Agregar_un_estudiante_con_usuario_repetido_o_invalido_se_rechaza()
    {
        var docente = JuegoApi.ComoDocente(f, f.DocenteId);
        var usuario = f.NombreUsuarioNuevo();
        var uno = new SolicitudCrearEstudianteEnAula("Uno", usuario);
        Assert.Equal(HttpStatusCode.OK, (await docente.Http.PostAsJsonAsync($"/api/v1/aulas/{f.AulaId}/estudiantes", uno)).StatusCode);
        Assert.Equal(HttpStatusCode.Conflict, (await docente.Http.PostAsJsonAsync($"/api/v1/aulas/{f.AulaId}/estudiantes", uno)).StatusCode);
        Assert.Equal(HttpStatusCode.BadRequest, (await docente.Http.PostAsJsonAsync($"/api/v1/aulas/{f.AulaId}/estudiantes",
            new SolicitudCrearEstudianteEnAula("Dos", "a b!"))).StatusCode);
    }

    // --------------------------------------------------------------------- Google con un verificador simulado
    // La validación real de la firma de Google necesita un token vivo; aquí se simula solo ese paso y se prueba todo lo demás.

    private class VerificadorGoogleFalso(DatosGoogle datos) : VerificadorGoogle(Microsoft.Extensions.Options.Options.Create(new OpcionesAutenticacion()))
    {
        public override Task<DatosGoogle> ValidarAsync(string idToken) => Task.FromResult(datos);
    }

    private HttpClient ClienteConGoogle(DatosGoogle datos)
    {
        var fabrica = f.Fabrica.WithWebHostBuilder(b =>
        {
            b.ConfigureTestServices(servicios =>
            {
                servicios.RemoveAll<VerificadorGoogle>();
                servicios.AddSingleton<VerificadorGoogle>(new VerificadorGoogleFalso(datos));
            });
        });
        return fabrica.CreateClient();
    }

    private DatosGoogle NuevaIdentidad(string etiqueta) =>
        new($"sub-{f.Etiqueta}-{etiqueta}", $"t{f.Etiqueta}{etiqueta}@prueba.invalid", "Docente de prueba");

    /// <summary>Inicia con Google y confirma el rol docente: devuelve la sesión ya como docente.</summary>
    private static async Task<RespuestaAutenticacion> EntrarComoDocenteAsync(HttpClient cliente)
    {
        var pendiente = (await (await cliente.PostAsJsonAsync("/api/v1/autenticacion/google", new SolicitudGoogle("x")))
            .Content.ReadFromJsonAsync<RespuestaAutenticacion>())!;
        cliente.DefaultRequestHeaders.Authorization = new("Bearer", pendiente.TokenAcceso);
        var confirmado = (await (await cliente.PostAsync("/api/v1/autenticacion/docente/confirmar", null))
            .Content.ReadFromJsonAsync<RespuestaAutenticacion>())!;
        cliente.DefaultRequestHeaders.Authorization = new("Bearer", confirmado.TokenAcceso);
        return confirmado;
    }

    [Fact]
    public async Task El_primer_acceso_con_google_crea_un_docente_sin_aula_y_el_segundo_reutiliza_la_cuenta()
    {
        var identidad = NuevaIdentidad("g1");
        var cliente = ClienteConGoogle(identidad);

        var a = await EntrarComoDocenteAsync(cliente);
        Assert.Contains("docente", a.Usuario.Roles);
        Assert.Empty((await cliente.GetFromJsonAsync<List<AulaDto>>("/api/v1/aulas/mi-aula"))!);

        cliente.DefaultRequestHeaders.Authorization = null;

        var segundo = await cliente.PostAsJsonAsync("/api/v1/autenticacion/google", new SolicitudGoogle("x"));
        var b = (await segundo.Content.ReadFromJsonAsync<RespuestaAutenticacion>())!;
        Assert.Equal(a.Usuario.Id, b.Usuario.Id);
        Assert.Equal(1, await f.Escalar<long>("select count(*) from identidades_externas where identificador_externo = @s", ("s", identidad.Sub)));
    }

    [Fact]
    public async Task Un_docente_de_google_solo_ve_sus_propias_aulas_y_no_las_ajenas()
    {
        var cliente = ClienteConGoogle(NuevaIdentidad("g3"));
        await EntrarComoDocenteAsync(cliente);

        var ajena = await cliente.GetAsync($"/api/v1/aulas/{f.AulaId}/estadisticas");
        Assert.True(ajena.StatusCode is HttpStatusCode.Forbidden or HttpStatusCode.NotFound);

        var propia = await cliente.PostAsJsonAsync("/api/v1/aulas", new SolicitudCrearAula("Aula del docente Google", null));
        Assert.Equal(HttpStatusCode.OK, propia.StatusCode);
    }
}
