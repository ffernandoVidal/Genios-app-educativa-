using GENIOS.Application.Autenticacion;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace GENIOS.Api.Controllers;

[Route("api/v1/usuarios")]
[Authorize]
public class UsuariosController(IServicioAutenticacion servicio) : ControladorBase
{
    [HttpGet("yo")]
    public async Task<ActionResult<UsuarioDto>> ObtenerYo(CancellationToken ct) =>
        await servicio.ObtenerUsuarioAsync(UsuarioId, ct);
}
