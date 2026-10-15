using System.Net;
using GENIOS.Api.Configuration;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.Extensions.Configuration;

namespace GENIOS.IntegrationTests;

public class HealthEndpointsTests
{
    private const string ConnKey = "ConnectionStrings:GeniosDatabase";

    private static WebApplicationFactory<Program> Factory(string? connectionString) =>
        new WebApplicationFactory<Program>().WithWebHostBuilder(b =>
        {
            b.UseEnvironment("Testing"); // evita que Program cargue el .env
            b.ConfigureAppConfiguration((_, cfg) =>
                cfg.AddInMemoryCollection(new Dictionary<string, string?> { [ConnKey] = connectionString }));
        });

    [Fact]
    public async Task Health_responde_200_sin_necesitar_base_de_datos()
    {
        await using var factory = Factory(null);
        var resp = await factory.CreateClient().GetAsync("/health");

        Assert.Equal(HttpStatusCode.OK, resp.StatusCode);
    }

    [Fact]
    public async Task Ready_sin_cadena_de_conexion_responde_503_controlado()
    {
        await using var factory = Factory(null);
        var resp = await factory.CreateClient().GetAsync("/health/ready");
        var body = await resp.Content.ReadAsStringAsync();

        Assert.Equal(HttpStatusCode.ServiceUnavailable, resp.StatusCode);
        Assert.Contains("no_disponible", body);
    }

    [Fact]
    public async Task Ready_con_base_inalcanzable_responde_503_sin_filtrar_credenciales()
    {
        const string fakePassword = "contrasena-secreta-de-prueba";
        var cs = $"Host=127.0.0.1;Port=1;Database=x;Username=usuario-de-prueba;Password={fakePassword};Timeout=2";
        await using var factory = Factory(cs);
        var resp = await factory.CreateClient().GetAsync("/health/ready");
        var body = await resp.Content.ReadAsStringAsync();

        Assert.Equal(HttpStatusCode.ServiceUnavailable, resp.StatusCode);
        Assert.DoesNotContain(fakePassword, body);
        Assert.DoesNotContain("usuario-de-prueba", body);
        Assert.DoesNotContain("127.0.0.1", body);
    }

    [Fact]
    public async Task Ready_contra_Neon_real_responde_200()
    {
        DotEnvLoader.Load(AppContext.BaseDirectory);
        var cs = Environment.GetEnvironmentVariable("ConnectionStrings__GeniosDatabase");
        Assert.False(string.IsNullOrWhiteSpace(cs),
            "Esta prueba requiere ConnectionStrings__GeniosDatabase (variable de entorno o archivo .env).");

        await using var factory = Factory(cs);
        var resp = await factory.CreateClient().GetAsync("/health/ready");
        var body = await resp.Content.ReadAsStringAsync();

        Assert.Equal(HttpStatusCode.OK, resp.StatusCode);
        Assert.DoesNotContain("npg_", body);
    }
}
