using Microsoft.Extensions.Diagnostics.HealthChecks;
using Microsoft.Extensions.Logging;
using Npgsql;

namespace GENIOS.Infrastructure.Persistence;

/// <summary>
/// Comprueba la disponibilidad de PostgreSQL con SELECT 1. El resultado nunca incluye
/// detalles de la excepción ni de la conexión.
/// </summary>
public sealed class DatabaseHealthCheck(IServiceProvider services, ILogger<DatabaseHealthCheck> logger) : IHealthCheck
{
    private static readonly TimeSpan Timeout = TimeSpan.FromSeconds(5);

    public async Task<HealthCheckResult> CheckHealthAsync(HealthCheckContext context, CancellationToken cancellationToken = default)
    {
        using var cts = CancellationTokenSource.CreateLinkedTokenSource(cancellationToken);
        cts.CancelAfter(Timeout);
        try
        {
            var dataSource = (NpgsqlDataSource?)services.GetService(typeof(NpgsqlDataSource));
            if (dataSource is null)
                return HealthCheckResult.Unhealthy("Base de datos no configurada.");

            await using var cmd = dataSource.CreateCommand("SELECT 1");
            await cmd.ExecuteScalarAsync(cts.Token);
            return HealthCheckResult.Healthy();
        }
        catch (Exception ex)
        {
            // Solo el tipo de excepción: el mensaje puede contener host o usuario.
            logger.LogWarning("Fallo de readiness de base de datos ({ExceptionType}).", ex.GetType().Name);
            return HealthCheckResult.Unhealthy("Base de datos no disponible.");
        }
    }
}
