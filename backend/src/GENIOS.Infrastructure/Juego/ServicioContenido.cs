using GENIOS.Application.Comun;
using GENIOS.Application.Contenido;
using GENIOS.Infrastructure.Persistence;
using GENIOS.Domain.Exceptions;
using GENIOS.Domain.Rules;
using GENIOS.Infrastructure.Persistence.Context;
using Microsoft.EntityFrameworkCore;

namespace GENIOS.Infrastructure.Juego;

public class ServicioContenido(GeniosDbContext bd) : IServicioContenido
{
    public async Task<IReadOnlyList<AsignaturaDto>> ListarAsignaturasAsync(CancellationToken ct) =>
        await bd.Asignaturas.AsNoTracking().Where(a => a.Activa).OrderBy(a => a.OrdenVisual)
            .Select(a => new AsignaturaDto(a.Id, a.Codigo, a.Nombre, a.Descripcion)).ToListAsync(ct);

    public async Task<IReadOnlyList<NivelDto>> ListarNivelesAsync(long asignaturaId, CancellationToken ct) =>
        await bd.NivelesEducativos.AsNoTracking().Where(n => n.AsignaturaId == asignaturaId && n.Activo)
            .OrderBy(n => n.NumeroOrden).Select(n => new NivelDto(n.Id, n.Nombre, n.NumeroOrden)).ToListAsync(ct);

    public async Task<IReadOnlyList<CategoriaDto>> ListarCategoriasAsync(Propietario propietario, long nivelId, CancellationToken ct)
    {
        var categorias = await bd.Categorias.AsNoTracking().Where(c => c.NivelEducativoId == nivelId && c.Activa)
            .OrderBy(c => c.NumeroOrden).ToListAsync(ct);
        var estados = await EstadosCategorias.CalcularAsync(bd, propietario, categorias, ct);

        return categorias.Select(c => new CategoriaDto(c.Id, c.Codigo, c.Nombre, c.Descripcion, c.NumeroOrden,
            estados[c.Id].Estado, estados[c.Id].Requiere?.Id, estados[c.Id].Requiere?.Nombre)).ToList();
    }

    public async Task<CategoriaDto> ObtenerCategoriaAsync(long categoriaId, CancellationToken ct) =>
        await bd.Categorias.AsNoTracking().Where(c => c.Id == categoriaId && c.Activa)
            .Select(c => new CategoriaDto(c.Id, c.Codigo, c.Nombre, c.Descripcion, c.NumeroOrden))
            .SingleOrDefaultAsync(ct)
        ?? throw new ExcepcionNegocio(TipoError.NoEncontrado, "categoria_no_encontrada", "No se encontró la categoría.");

    public async Task<ProgresoCategoriaDto> ObtenerProgresoAsync(Guid usuarioId, long categoriaId, CancellationToken ct)
    {
        await ObtenerCategoriaAsync(categoriaId, ct);
        var progreso = await bd.ProgresoEstudiante.AsNoTracking()
            .SingleOrDefaultAsync(p => p.UsuarioId == usuarioId && p.CategoriaId == categoriaId, ct);
        if (progreso is null) return new ProgresoCategoriaDto(categoriaId, false, 0, 0, 0, 0, 0);

        return new ProgresoCategoriaDto(
            categoriaId, progreso.PartidasCompletadas > 0, progreso.PartidasCompletadas, progreso.PreguntasEvaluadas,
            progreso.AciertosPrimerIntento,
            ReglasJuego.PorcentajeAciertos(progreso.AciertosPrimerIntento, progreso.PreguntasEvaluadas),
            progreso.PuntosTotales);
    }
}
