using GENIOS.Application.Aulas;
using GENIOS.Application.Autenticacion;
using GENIOS.Domain.Rules;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.RateLimiting;

namespace GENIOS.Api.Controllers;

[Route("api/v1/aulas")]
[Authorize]
public class AulasController(IServicioAulas aulas, IServicioAutenticacion autenticacion) : ControladorBase
{
    [HttpPost]
    [Authorize(Roles = CodigosRol.Docente)]
    public async Task<ActionResult<AulaDto>> Crear(SolicitudCrearAula solicitud, CancellationToken ct) =>
        await aulas.CrearAsync(UsuarioId, solicitud, ct);

    [HttpGet("mi-aula")]
    public async Task<ActionResult<IReadOnlyList<AulaDto>>> MiAula(CancellationToken ct) =>
        Ok(await aulas.ListarMisAulasAsync(UsuarioId, User.IsInRole(CodigosRol.Docente), ct));

    [HttpPost("unirse")]
    [Authorize(Roles = CodigosRol.Estudiante)]
    [EnableRateLimiting("autenticacion")]
    public async Task<ActionResult<AulaDto>> Unirse(SolicitudCodigoAula solicitud, CancellationToken ct) =>
        await aulas.UnirseAsync(UsuarioId, solicitud.CodigoAula, ct);

    [HttpGet("{aulaId:guid}/estudiantes")]
    [Authorize(Roles = CodigosRol.Docente)]
    public async Task<ActionResult<IReadOnlyList<EstudianteAulaDto>>> ListarEstudiantes(Guid aulaId, CancellationToken ct) =>
        Ok(await aulas.ListarEstudiantesAsync(UsuarioId, aulaId, ct));

    [HttpDelete("{aulaId:guid}/estudiantes/{estudianteId:guid}")]
    [Authorize(Roles = CodigosRol.Docente)]
    public async Task<IActionResult> RetirarEstudiante(Guid aulaId, Guid estudianteId, CancellationToken ct)
    {
        await aulas.RetirarEstudianteAsync(UsuarioId, aulaId, estudianteId, ct);
        return NoContent();
    }

    [HttpPost("{aulaId:guid}/estudiantes/{estudianteId:guid}/restablecer-contrasena")]
    [Authorize(Roles = CodigosRol.Docente)]
    public async Task<ActionResult<CodigoRestablecimientoDto>> RestablecerContrasena(Guid aulaId, Guid estudianteId, CancellationToken ct) =>
        await autenticacion.EmitirCodigoRestablecimientoAsync(UsuarioId, aulaId, estudianteId, Contexto, ct);
}
