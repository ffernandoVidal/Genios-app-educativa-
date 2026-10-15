using GENIOS.Application.Tiempo;
using GENIOS.Infrastructure.Persistence.Context;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;

namespace GENIOS.Infrastructure.Juego;

public class ServicioTiempo(GeniosDbContext bd, IOptions<OpcionesJuego> opciones) : IServicioTiempo
{
    private const int IntentosActualizacion = 3;
    private readonly OpcionesJuego _opciones = opciones.Value;

    public async Task<ActividadRegistrada> RegistrarActividadAsync(Guid estudianteId, CancellationToken ct)
    {
        var ahora = DateTime.UtcNow;
        var fecha = FechaLocal(ahora);
        var limiteMs = await ObtenerLimiteMsAsync(estudianteId, ahora, ct);
        var umbralMs = _opciones.UmbralInactividadSegundos * 1000L;

        // Crea la fila del día si no existe; la primera actividad del día no suma tiempo.
        await bd.Database.ExecuteSqlInterpolatedAsync($@"
            INSERT INTO uso_diario_estudiante (estudiante_id, fecha_local, zona_horaria, ultimo_calculo_en)
            VALUES ({estudianteId}, {fecha}, {_opciones.ZonaHoraria}, {ahora})
            ON CONFLICT (estudiante_id, fecha_local) DO NOTHING", ct);

        for (var intento = 0; intento < IntentosActualizacion; intento++)
        {
            var fila = await bd.UsoDiarioEstudiante.AsNoTracking()
                .SingleAsync(u => u.EstudianteId == estudianteId && u.FechaLocal == fecha, ct);
            var ultimo = fila.UltimoCalculoEn ?? ahora;

            // Cada actividad suma como máximo el umbral: quien se ausenta no sigue acumulando tiempo.
            var delta = (long)Math.Clamp((ahora - ultimo).TotalMilliseconds, 0, umbralMs);

            // La condición sobre ultimo_calculo_en evita que dos solicitudes simultáneas sumen el mismo tramo.
            var filas = await bd.UsoDiarioEstudiante
                .Where(u => u.Id == fila.Id && u.UltimoCalculoEn == fila.UltimoCalculoEn)
                .ExecuteUpdateAsync(s => s
                    .SetProperty(u => u.TiempoActivoMs, u => u.TiempoActivoMs + delta)
                    .SetProperty(u => u.UltimoCalculoEn, ahora)
                    .SetProperty(u => u.ActualizadoEn, ahora), ct);
            if (filas == 1) return new ActividadRegistrada(delta, fila.TiempoActivoMs + delta, limiteMs);
        }

        var usado = await ObtenerUsadoMsAsync(estudianteId, fecha, ct);
        return new ActividadRegistrada(0, usado, limiteMs);
    }

    public async Task<UsoDiarioDto> ObtenerUsoAsync(Guid estudianteId, CancellationToken ct)
    {
        var ahora = DateTime.UtcNow;
        var usado = await ObtenerUsadoMsAsync(estudianteId, FechaLocal(ahora), ct);
        return ConvertirADto(usado, await ObtenerLimiteMsAsync(estudianteId, ahora, ct));
    }

    public async Task<UsoDiarioDto> RegistrarLatidoAsync(Guid estudianteId, CancellationToken ct)
    {
        var actividad = await RegistrarActividadAsync(estudianteId, ct);
        return ConvertirADto(actividad.UsadoMs, actividad.LimiteMs);
    }

    private DateOnly FechaLocal(DateTime ahoraUtc)
    {
        var zona = TimeZoneInfo.FindSystemTimeZoneById(_opciones.ZonaHoraria);
        return DateOnly.FromDateTime(TimeZoneInfo.ConvertTimeFromUtc(ahoraUtc, zona));
    }

    private async Task<long> ObtenerUsadoMsAsync(Guid estudianteId, DateOnly fecha, CancellationToken ct) =>
        await bd.UsoDiarioEstudiante.AsNoTracking()
            .Where(u => u.EstudianteId == estudianteId && u.FechaLocal == fecha)
            .Select(u => u.TiempoActivoMs).SingleOrDefaultAsync(ct);

    /// <summary>Política asignada al estudiante; si no hay, la política general activa; si no, la configuración.</summary>
    private async Task<long> ObtenerLimiteMsAsync(Guid estudianteId, DateTime ahora, CancellationToken ct)
    {
        var minutos = await bd.AsignacionesPoliticaTiempo.AsNoTracking()
                .Where(a => a.EstudianteId == estudianteId && a.ActivaDesde <= ahora && (a.ActivaHasta == null || a.ActivaHasta > ahora))
                .OrderByDescending(a => a.ActivaDesde)
                .Select(a => (int?)a.Politica.MinutosDiarios).FirstOrDefaultAsync(ct)
            ?? await bd.PoliticasTiempoUso.AsNoTracking()
                .Where(p => p.Activa && (p.AplicaA == "estudiante" || p.AplicaA == "todos"))
                .OrderBy(p => p.Id)
                .Select(p => (int?)p.MinutosDiarios).FirstOrDefaultAsync(ct)
            ?? _opciones.MinutosDiarios;
        return minutos * 60_000L;
    }

    private static UsoDiarioDto ConvertirADto(long usadoMs, long limiteMs)
    {
        var usados = (int)(usadoMs / 60_000);
        var limite = (int)(limiteMs / 60_000);
        return new UsoDiarioDto(usados, limite, Math.Max(0, limite - usados), usadoMs >= limiteMs);
    }
}
