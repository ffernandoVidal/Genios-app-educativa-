using GENIOS.Application.Comun;
using GENIOS.Infrastructure.Persistence;
using GENIOS.Infrastructure.Persistence.Context;
using GENIOS.Infrastructure.Persistence.Entities;
using Microsoft.EntityFrameworkCore;

namespace GENIOS.Infrastructure.Juego;

public record EstadoCategoria(string Estado, Categorias? Requiere);

/// <summary>
/// Regla de progresión: dentro de un nivel, la primera categoría activa está abierta y cada una siguiente se abre
/// al completar la anterior. Estados: bloqueada, disponible, en_progreso (hay una partida en curso) y completada.
/// </summary>
public static class EstadosCategorias
{
    public static async Task<Dictionary<long, EstadoCategoria>> CalcularAsync(
        GeniosDbContext bd, Propietario propietario, IReadOnlyCollection<Categorias> categorias, CancellationToken ct)
    {
        var partidas = bd.Partidas.AsNoTracking().DelPropietario(propietario);
        var completadas = (await partidas.Where(p => p.Estado == "completada").Select(p => p.CategoriaId).Distinct().ToListAsync(ct)).ToHashSet();
        var enCurso = (await partidas.Where(p => p.Estado == "en_curso").Select(p => p.CategoriaId).Distinct().ToListAsync(ct)).ToHashSet();

        var estados = new Dictionary<long, EstadoCategoria>();
        foreach (var nivel in categorias.GroupBy(c => c.NivelEducativoId))
        {
            Categorias? anterior = null;
            foreach (var categoria in nivel.OrderBy(c => c.NumeroOrden))
            {
                var bloqueada = anterior is not null && !completadas.Contains(anterior.Id);
                var estado = completadas.Contains(categoria.Id) ? "completada"
                    : bloqueada ? "bloqueada"
                    : enCurso.Contains(categoria.Id) ? "en_progreso"
                    : "disponible";
                estados[categoria.Id] = new EstadoCategoria(estado, bloqueada ? anterior : null);
                anterior = categoria;
            }
        }
        return estados;
    }
}
