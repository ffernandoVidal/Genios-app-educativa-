using GENIOS.Application.Aulas;
using GENIOS.Domain.Exceptions;
using GENIOS.Domain.Rules;
using GENIOS.Infrastructure.Persistence;
using GENIOS.Infrastructure.Persistence.Context;
using GENIOS.Infrastructure.Persistence.Entities;
using Microsoft.EntityFrameworkCore;

namespace GENIOS.Infrastructure.GestionAulas;

public class ServicioAulas(GeniosDbContext bd) : IServicioAulas
{
    private const int IntentosCodigoAula = 5;

    public async Task<AulaDto> CrearAsync(Guid docenteId, SolicitudCrearAula solicitud, CancellationToken ct)
    {
        var nombre = (solicitud.Nombre ?? "").Trim();
        if (nombre.Length is 0 or > 140)
            throw new ExcepcionNegocio(TipoError.Validacion, "nombre_aula_invalido", "El nombre del aula debe tener entre 1 y 140 caracteres.");

        var verificado = await bd.PerfilesDocente.AnyAsync(p => p.UsuarioId == docenteId && p.VerificadoEn != null, ct);
        if (!verificado)
            throw new ExcepcionNegocio(TipoError.Prohibido, "docente_no_verificado", "Tu cuenta docente aún no está verificada.");

        // El código es aleatorio; si choca con otro (índice único) se genera uno nuevo.
        for (var intento = 1; ; intento++)
        {
            var aula = new Aulas
            {
                Id = Guid.NewGuid(),
                DocenteId = docenteId,
                Nombre = nombre,
                Descripcion = solicitud.Descripcion?.Trim(),
                CodigoAcceso = ReglasCuenta.GenerarCodigoAula(),
                Estado = "activa"
            };
            bd.Aulas.Add(aula);
            try
            {
                await bd.SaveChangesAsync(ct);
                return ConvertirADto(aula, true);
            }
            catch (DbUpdateException e) when (e.EsViolacionUnica() && intento < IntentosCodigoAula)
            {
                bd.Entry(aula).State = EntityState.Detached;
            }
        }
    }

    public async Task<IReadOnlyList<AulaDto>> ListarMisAulasAsync(Guid usuarioId, bool esDocente, CancellationToken ct)
    {
        if (esDocente)
        {
            var propias = await bd.Aulas.AsNoTracking()
                .Where(a => a.DocenteId == usuarioId && a.EliminadaEn == null)
                .OrderBy(a => a.CreadaEn).ToListAsync(ct);
            return propias.Select(a => ConvertirADto(a, true)).ToList();
        }

        var inscritas = await bd.MiembrosAula.AsNoTracking()
            .Where(m => m.EstudianteId == usuarioId && m.Estado == "activo" && m.Aula.EliminadaEn == null)
            .Select(m => m.Aula).ToListAsync(ct);
        return inscritas.Select(a => ConvertirADto(a, false)).ToList();
    }

    public async Task<CodigoAulaValidoDto> ValidarCodigoAsync(string codigoAula, CancellationToken ct)
    {
        var aula = await bd.BuscarAulaActivaAsync(codigoAula, ct);
        return new CodigoAulaValidoDto(aula.Nombre);
    }

    public async Task<AulaDto> UnirseAsync(Guid estudianteId, string codigoAula, CancellationToken ct)
    {
        var aula = await bd.BuscarAulaActivaAsync(codigoAula, ct);

        // Una sola sentencia atómica: crea la membresía o reactiva una retirada. Una repetición no cambia nada.
        await bd.Database.ExecuteSqlInterpolatedAsync($@"
            INSERT INTO miembros_aula (aula_id, estudiante_id, estado)
            VALUES ({aula.Id}, {estudianteId}, 'activo')
            ON CONFLICT (aula_id, estudiante_id)
            DO UPDATE SET estado = 'activo', retirado_en = NULL, unido_en = NOW()
            WHERE miembros_aula.estado = 'retirado'", ct);

        var estado = await bd.MiembrosAula.AsNoTracking()
            .Where(m => m.AulaId == aula.Id && m.EstudianteId == estudianteId)
            .Select(m => m.Estado).SingleAsync(ct);
        if (estado != "activo")
            throw new ExcepcionNegocio(TipoError.Prohibido, "membresia_suspendida", "No puedes unirte a esta aula.");

        return ConvertirADto(aula, false);
    }

    public async Task<IReadOnlyList<EstudianteAulaDto>> ListarEstudiantesAsync(Guid docenteId, Guid aulaId, CancellationToken ct)
    {
        await ExigirAulaDelDocenteAsync(docenteId, aulaId, ct);
        return await bd.MiembrosAula.AsNoTracking()
            .Where(m => m.AulaId == aulaId && m.Estado == "activo")
            .OrderBy(m => m.Estudiante.NombreMostrar)
            .Select(m => new EstudianteAulaDto(m.EstudianteId, m.Estudiante.NombreMostrar, m.Estudiante.NombreUsuario, m.UnidoEn))
            .ToListAsync(ct);
    }

    public async Task RetirarEstudianteAsync(Guid docenteId, Guid aulaId, Guid estudianteId, CancellationToken ct)
    {
        await ExigirAulaDelDocenteAsync(docenteId, aulaId, ct);
        var filas = await bd.MiembrosAula
            .Where(m => m.AulaId == aulaId && m.EstudianteId == estudianteId && m.Estado == "activo")
            .ExecuteUpdateAsync(s => s.SetProperty(m => m.Estado, "retirado").SetProperty(m => m.RetiradoEn, DateTime.UtcNow), ct);
        if (filas == 0)
            throw new ExcepcionNegocio(TipoError.NoEncontrado, "estudiante_no_encontrado", "El estudiante no pertenece a tu aula.");
    }

    private async Task ExigirAulaDelDocenteAsync(Guid docenteId, Guid aulaId, CancellationToken ct)
    {
        var esDelDocente = await bd.Aulas.AnyAsync(a => a.Id == aulaId && a.DocenteId == docenteId && a.EliminadaEn == null, ct);
        if (!esDelDocente)
            throw new ExcepcionNegocio(TipoError.NoEncontrado, "aula_no_encontrada", "No se encontró el aula.");
    }

    private static AulaDto ConvertirADto(Aulas aula, bool mostrarCodigo) =>
        new(aula.Id, aula.Nombre, aula.Estado, mostrarCodigo ? aula.CodigoAcceso : null);
}

