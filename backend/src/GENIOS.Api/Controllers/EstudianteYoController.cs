using GENIOS.Application.Estadisticas;
using GENIOS.Domain.Rules;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace GENIOS.Api.Controllers;

/// <summary>Datos propios del estudiante autenticado. El identificador sale del token, nunca de la ruta.</summary>
[Route("api/v1/estudiantes/yo")]
[Authorize(Roles = CodigosRol.Estudiante)]
public class EstudianteYoController(IServicioEstadisticas servicio) : ControladorBase
{
    [HttpGet("progreso")]
    public async Task<ActionResult<ProgresoEstudianteDto>> Progreso(CancellationToken ct) =>
        await servicio.ObtenerProgresoAsync(UsuarioId, ct);

    [HttpGet("estadisticas")]
    public async Task<ActionResult<EstadisticasEstudianteDto>> Estadisticas(CancellationToken ct) =>
        await servicio.ObtenerEstadisticasAsync(UsuarioId, ct);

    [HttpGet("puntos")]
    public async Task<ActionResult<PuntosEstudianteDto>> Puntos(CancellationToken ct) =>
        await servicio.ObtenerPuntosAsync(UsuarioId, ct);
}
