using System.Text.Json;
using GENIOS.Api.Configuration;
using GENIOS.Infrastructure;
using GENIOS.Infrastructure.Persistence;
using Microsoft.AspNetCore.Diagnostics.HealthChecks;
using Microsoft.AspNetCore.HttpOverrides;
using Microsoft.Extensions.Diagnostics.HealthChecks;

var builder = WebApplication.CreateBuilder(args);

if (builder.Environment.IsDevelopment())
    DotEnvLoader.Load(builder.Environment.ContentRootPath);
builder.Configuration.AddEnvironmentVariables(); // refresca con lo cargado desde .env

// Render (y otros proveedores) indican el puerto en PORT; sin PORT se usa ASPNETCORE_URLS.
var puerto = Environment.GetEnvironmentVariable("PORT");
if (!string.IsNullOrWhiteSpace(puerto))
    builder.WebHost.UseUrls($"http://0.0.0.0:{puerto}");

// Detras del proxy del proveedor: el esquema y la IP reales vienen en X-Forwarded-*.
builder.Services.Configure<ForwardedHeadersOptions>(o =>
{
    o.ForwardedHeaders = ForwardedHeaders.XForwardedFor | ForwardedHeaders.XForwardedProto;
    o.KnownIPNetworks.Clear();
    o.KnownProxies.Clear();
});

builder.Services.AddControllers();
builder.Services.AddProblemDetails();
builder.Services.AddInfrastructure();
builder.Services.AddServiciosApi(builder.Configuration);
builder.Services.AddHealthChecks()
    .AddCheck("self", () => HealthCheckResult.Healthy(), tags: ["live"])
    .AddCheck<DatabaseHealthCheck>("database", tags: ["ready"]);

var app = builder.Build();

app.UseForwardedHeaders();

// Errores no controlados -> Problem Details sin trazas ni detalles internos.
app.UseExceptionHandler();
app.UseStatusCodePages();

if (!app.Environment.IsDevelopment())
    app.UseHttpsRedirection();

app.UseCors(ServiciosApi.PoliticaCors);
app.UseRateLimiter();
app.UseAuthentication();
app.UseAuthorization();
app.MapControllers();

static Task WriteHealth(HttpContext ctx, HealthReport report)
{
    ctx.Response.ContentType = "application/json";
    var body = new
    {
        estado = report.Status == HealthStatus.Healthy ? "saludable" : "no_disponible",
        componentes = report.Entries.ToDictionary(
            e => e.Key,
            e => e.Value.Status == HealthStatus.Healthy ? "ok" : "falla")
    };
    return ctx.Response.WriteAsync(JsonSerializer.Serialize(body));
}

app.MapHealthChecks("/health", new HealthCheckOptions
{
    Predicate = r => r.Tags.Contains("live"),
    ResponseWriter = WriteHealth
});
app.MapHealthChecks("/health/ready", new HealthCheckOptions
{
    Predicate = r => r.Tags.Contains("ready"),
    ResponseWriter = WriteHealth
});

app.Run();

public partial class Program;
