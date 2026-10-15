using GENIOS.Application.Aulas;
using GENIOS.Application.Autenticacion;
using GENIOS.Infrastructure.GestionAulas;
using GENIOS.Infrastructure.Auditoria;
using GENIOS.Application.Contenido;
using GENIOS.Application.Estadisticas;
using GENIOS.Application.Invitados;
using GENIOS.Infrastructure.Estadisticas;
using GENIOS.Application.Partidas;
using GENIOS.Application.Tiempo;
using GENIOS.Infrastructure.Autenticacion;
using GENIOS.Infrastructure.Juego;
using GENIOS.Infrastructure.Persistence;
using GENIOS.Infrastructure.Persistence.Entities;
using Microsoft.AspNetCore.Identity;
using GENIOS.Infrastructure.Persistence.Context;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Npgsql;

namespace GENIOS.Infrastructure;

public static class DependencyInjection
{
    public const string ConnectionStringName = "GeniosDatabase";

    public static IServiceCollection AddInfrastructure(this IServiceCollection services)
    {
        // La cadena se lee al resolver el servicio, no al registrarlo: si falta, solo falla
        // la base de datos (readiness) y la API sigue arrancando.
        services.AddSingleton(sp =>
        {
            var cs = sp.GetRequiredService<IConfiguration>().GetConnectionString(ConnectionStringName);
            if (string.IsNullOrWhiteSpace(cs))
                throw new InvalidOperationException($"Falta la cadena de conexión '{ConnectionStringName}'.");
            return new NpgsqlDataSourceBuilder(cs).Build();
        });
        services.AddDbContext<GeniosDbContext>((sp, options) =>
            options.UseNpgsql(sp.GetRequiredService<NpgsqlDataSource>()));
        services.AddTransient<DatabaseHealthCheck>();

        services.AddOptions<OpcionesAutenticacion>().BindConfiguration(OpcionesAutenticacion.Seccion);
        services.AddSingleton<IPasswordHasher<Usuarios>, PasswordHasher<Usuarios>>();
        services.AddSingleton<EmisorTokens>();
        services.AddSingleton<VerificadorGoogle>();
        services.AddScoped<RegistradorAuditoria>();
        services.AddScoped<IServicioAutenticacion, ServicioAutenticacion>();
        services.AddScoped<IServicioAulas, ServicioAulas>();

        services.AddOptions<OpcionesJuego>().BindConfiguration(OpcionesJuego.Seccion);
        services.AddScoped<IServicioTiempo, ServicioTiempo>();
        services.AddScoped<IServicioContenido, ServicioContenido>();
        services.AddScoped<GeneradorPreguntas>();
        services.AddScoped<IServicioPartidas, ServicioPartidas>();
        services.AddScoped<IServicioInvitados, ServicioInvitados>();
        services.AddScoped<IServicioEstadisticas, ServicioEstadisticas>();
        return services;
    }
}

