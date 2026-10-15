using GENIOS.Application.Invitados;
using GENIOS.Domain.Rules;
using GENIOS.Infrastructure.Autenticacion;
using GENIOS.Infrastructure.Persistence.Context;
using GENIOS.Infrastructure.Persistence.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;

namespace GENIOS.Infrastructure.Juego;

public class ServicioInvitados(GeniosDbContext bd, EmisorTokens emisor, IOptions<OpcionesJuego> opciones) : IServicioInvitados
{
    private static readonly TimeSpan IntervaloActualizacion = TimeSpan.FromMinutes(1);

    public async Task<ResultadoSesionInvitado> CrearOReutilizarAsync(string? tokenActual, CancellationToken ct)
    {
        if (!string.IsNullOrEmpty(tokenActual) && await ValidarTokenAsync(tokenActual, ct) is { } existenteId)
        {
            var existente = await bd.SesionesInvitado.AsNoTracking().SingleAsync(s => s.Id == existenteId, ct);
            return new ResultadoSesionInvitado(await ObtenerEstadoAsync(existenteId, ct), null, existente.ExpiraEn!.Value);
        }

        // El token es aleatorio; en la base solo se guarda su hash.
        var (token, hash) = emisor.CrearTokenRenovacion();
        var ahora = DateTime.UtcNow;
        var sesion = new SesionesInvitado
        {
            Id = Guid.NewGuid(),
            IdentificadorTokenHash = hash,
            Estado = "activa",
            CreadaEn = ahora,
            UltimaActividadEn = ahora,
            ExpiraEn = ahora.AddDays(opciones.Value.DiasVigenciaInvitado)
        };
        bd.SesionesInvitado.Add(sesion);
        await bd.SaveChangesAsync(ct);

        return new ResultadoSesionInvitado(await ObtenerEstadoAsync(sesion.Id, ct), token, sesion.ExpiraEn.Value);
    }

    public async Task<Guid?> ValidarTokenAsync(string token, CancellationToken ct)
    {
        var hash = emisor.CalcularHash(token);
        var sesion = await bd.SesionesInvitado.SingleOrDefaultAsync(s => s.IdentificadorTokenHash == hash, ct);
        if (sesion is null || sesion.Estado != "activa") return null;

        var ahora = DateTime.UtcNow;
        if (sesion.ExpiraEn is { } expira && expira <= ahora)
        {
            sesion.Estado = "expirada";
            await bd.SaveChangesAsync(ct);
            return null;
        }

        if (ahora - sesion.UltimaActividadEn > IntervaloActualizacion)
        {
            sesion.UltimaActividadEn = ahora;
            await bd.SaveChangesAsync(ct);
        }
        return sesion.Id;
    }

    public async Task<SesionInvitadoDto> ObtenerEstadoAsync(Guid sesionInvitadoId, CancellationToken ct)
    {
        var expiraEn = await bd.SesionesInvitado.AsNoTracking().Where(s => s.Id == sesionInvitadoId)
            .Select(s => s.ExpiraEn!.Value).SingleAsync(ct);

        // Solo cuentan las partidas completadas (10 preguntas evaluadas); las incompletas no.
        var partidas = await bd.Partidas.AsNoTracking()
            .Where(p => p.SesionInvitadoId == sesionInvitadoId && p.Estado == "completada" && p.EsPartidaValida)
            .Select(p => new { p.AciertosPrimerIntento, p.CantidadPreguntasEvaluadas }).ToListAsync(ct);
        var queCuentan = partidas.Count(p => ReglasInvitado.SuperaMinimo(p.AciertosPrimerIntento, p.CantidadPreguntasEvaluadas));

        return new SesionInvitadoDto(expiraEn, partidas.Count, queCuentan, ReglasInvitado.PartidasRequeridas,
            queCuentan >= ReglasInvitado.PartidasRequeridas, ReglasInvitado.AvisoProgresoAnonimo);
    }
}
