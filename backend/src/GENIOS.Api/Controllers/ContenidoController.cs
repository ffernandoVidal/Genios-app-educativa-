using GENIOS.Application.Contenido;
using GENIOS.Domain.Rules;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace GENIOS.Api.Controllers;

[Route("api/v1")]
public class ContenidoController(IServicioContenido servicio) : ControladorBase
{
    [HttpGet("asignaturas")]
    public async Task<ActionResult<IReadOnlyList<AsignaturaDto>>> ListarAsignaturas(CancellationToken ct) =>
        Ok(await servicio.ListarAsignaturasAsync(ct));

    [HttpGet("asignaturas/{asignaturaId:long}/niveles")]
    public async Task<ActionResult<IReadOnlyList<NivelDto>>> ListarNiveles(long asignaturaId, CancellationToken ct) =>
        Ok(await servicio.ListarNivelesAsync(asignaturaId, ct));

    /// <summary>Requiere quien juega (estudiante o invitado) para indicar qué categorías están bloqueadas.</summary>
    [HttpGet("niveles/{nivelId:long}/categorias")]
    [Authorize(AuthenticationSchemes = EsquemasJuego, Roles = RolesJuego)]
    public async Task<ActionResult<IReadOnlyList<CategoriaDto>>> ListarCategorias(long nivelId, CancellationToken ct) =>
        Ok(await servicio.ListarCategoriasAsync(Propietario, nivelId, ct));

    [HttpGet("categorias/{categoriaId:long}")]
    public async Task<ActionResult<CategoriaDto>> ObtenerCategoria(long categoriaId, CancellationToken ct) =>
        await servicio.ObtenerCategoriaAsync(categoriaId, ct);

    [HttpGet("categorias/{categoriaId:long}/progreso")]
    [Authorize(Roles = CodigosRol.Estudiante)]
    public async Task<ActionResult<ProgresoCategoriaDto>> ObtenerProgreso(long categoriaId, CancellationToken ct) =>
        await servicio.ObtenerProgresoAsync(UsuarioId, categoriaId, ct);
}
