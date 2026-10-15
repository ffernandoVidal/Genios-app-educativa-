using GENIOS.Domain.Exceptions;
using GENIOS.Domain.Rules;
using GENIOS.Infrastructure.Persistence.Context;
using GENIOS.Infrastructure.Persistence.Entities;
using Microsoft.EntityFrameworkCore;
using Npgsql;

namespace GENIOS.Infrastructure.Persistence;

public static class ConsultasAulas
{
    /// <summary>Busca un aula activa (no suspendida ni eliminada) por su código de acceso.</summary>
    public static async Task<Aulas> BuscarAulaActivaAsync(this GeniosDbContext bd, string? codigo, CancellationToken ct)
    {
        var codigoNormalizado = ReglasCuenta.NormalizarCodigoAula(codigo);
        var aula = codigoNormalizado is null
            ? null
            : await bd.Aulas.SingleOrDefaultAsync(
                a => a.CodigoAcceso == codigoNormalizado && a.Estado == "activa" && a.EliminadaEn == null, ct);

        return aula ?? throw new ExcepcionNegocio(TipoError.NoEncontrado, "aula_no_encontrada",
            "No existe un aula activa con ese código.");
    }

    public static bool EsViolacionUnica(this DbUpdateException error) =>
        error.InnerException is PostgresException { SqlState: PostgresErrorCodes.UniqueViolation };
}
