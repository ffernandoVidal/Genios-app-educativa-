using GENIOS.Application.Tiempo;
using GENIOS.Domain.Rules;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace GENIOS.Api.Controllers;

[Route("api/v1/estudiantes/yo/uso-diario")]
[Authorize(Roles = CodigosRol.Estudiante)]
public class UsoDiarioController(IServicioTiempo servicio) : ControladorBase
{
    [HttpGet]
    public async Task<ActionResult<UsoDiarioDto>> Obtener(CancellationToken ct) =>
        await servicio.ObtenerUsoAsync(UsuarioId, ct);

    [HttpPost("latido")]
    public async Task<ActionResult<UsoDiarioDto>> Latido(CancellationToken ct) =>
        await servicio.RegistrarLatidoAsync(UsuarioId, ct);
}
