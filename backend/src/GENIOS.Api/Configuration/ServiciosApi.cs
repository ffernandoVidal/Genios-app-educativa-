using System.Threading.RateLimiting;
using GENIOS.Api.Middleware;
using GENIOS.Infrastructure.Autenticacion;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.Extensions.Options;

namespace GENIOS.Api.Configuration;

public static class ServiciosApi
{
    public const string PoliticaCors = "Front";

    public static IServiceCollection AddServiciosApi(this IServiceCollection servicios, IConfiguration configuracion)
    {
        servicios.AddExceptionHandler<ManejadorExcepciones>();

        // El JWT se configura al primer uso, para que la API arranque aunque falte la clave.
        servicios.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
            .AddJwtBearer()
            .AddScheme<AuthenticationSchemeOptions, ManejadorAutenticacionInvitado>(ManejadorAutenticacionInvitado.Esquema, null);
        servicios.AddOptions<JwtBearerOptions>(JwtBearerDefaults.AuthenticationScheme)
            .Configure<IOptions<OpcionesAutenticacion>>((jwt, opciones) =>
            {
                jwt.MapInboundClaims = false;
                jwt.TokenValidationParameters = EmisorTokens.ParametrosValidacion(opciones.Value);
            });
        servicios.AddAuthorization();

        // Límite de intentos por IP en login, registro y códigos de aula.
        servicios.AddRateLimiter(opciones =>
        {
            opciones.RejectionStatusCode = StatusCodes.Status429TooManyRequests;
            opciones.AddPolicy("autenticacion", contexto =>
                RateLimitPartition.GetFixedWindowLimiter(
                    contexto.Connection.RemoteIpAddress?.ToString() ?? "desconocida",
                    _ => new FixedWindowRateLimiterOptions
                    {
                        PermitLimit = configuracion.GetValue("Autenticacion:IntentosPorMinuto", 10),
                        Window = TimeSpan.FromMinutes(1)
                    }));
        });

        var origenes = configuracion.GetSection("Cors:OrigenesPermitidos").Get<string[]>() ?? [];
        servicios.AddCors(opciones => opciones.AddPolicy(PoliticaCors, politica =>
            politica.WithOrigins(origenes).AllowAnyHeader().AllowAnyMethod().AllowCredentials()));

        return servicios;
    }
}
