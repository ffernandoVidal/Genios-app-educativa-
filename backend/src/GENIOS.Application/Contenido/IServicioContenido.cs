using GENIOS.Application.Comun;

namespace GENIOS.Application.Contenido;

public interface IServicioContenido
{
    Task<IReadOnlyList<AsignaturaDto>> ListarAsignaturasAsync(CancellationToken ct);
    Task<IReadOnlyList<NivelDto>> ListarNivelesAsync(long asignaturaId, CancellationToken ct);

    /// <summary>Incluye si cada categoría está bloqueada para quien juega.</summary>
    Task<IReadOnlyList<CategoriaDto>> ListarCategoriasAsync(Propietario propietario, long nivelId, CancellationToken ct);

    Task<CategoriaDto> ObtenerCategoriaAsync(long categoriaId, CancellationToken ct);
    Task<ProgresoCategoriaDto> ObtenerProgresoAsync(Guid usuarioId, long categoriaId, CancellationToken ct);
}
