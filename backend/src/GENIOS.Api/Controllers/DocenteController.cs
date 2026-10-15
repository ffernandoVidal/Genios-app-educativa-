using GENIOS.Application.Docente;
using GENIOS.Domain.Rules;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace GENIOS.Api.Controllers;

/// <summary>Centro de Control Docente. Solo lectura de estadísticas de estudiantes autorizados.</summary>
[Route("api/v1/docente")]
[Authorize(Roles = CodigosRol.Docente)]
public class DocenteController(IServicioDocente docente) : ControladorBase
{
    [HttpGet("resumen")]
    public async Task<ActionResult<ResumenDocenteDto>> Resumen([FromQuery] DateOnly? desde, [FromQuery] DateOnly? hasta, [FromQuery] int? dias, CancellationToken ct) =>
        await docente.ObtenerResumenAsync(UsuarioId, new PeriodoSolicitado(desde, hasta, dias), ct);

    [HttpGet("estudiantes")]
    public async Task<ActionResult<PaginaDto<FilaEstudianteDto>>> Estudiantes(
        [FromQuery] string? q, [FromQuery] Guid? aulaId, [FromQuery] short? grado, [FromQuery] string? rendimiento,
        [FromQuery] string? orden, [FromQuery] int pagina, [FromQuery] int tamano,
        [FromQuery] DateOnly? desde, [FromQuery] DateOnly? hasta, [FromQuery] int? dias, CancellationToken ct) =>
        await docente.ListarEstudiantesAsync(UsuarioId, new FiltroEstudiantes(q, aulaId, grado, rendimiento, orden, pagina, tamano),
            new PeriodoSolicitado(desde, hasta, dias), Contexto, ct);

    [HttpGet("estudiantes/{estudianteId:guid}/estadisticas")]
    public async Task<ActionResult<FichaEstudianteDto>> Ficha(Guid estudianteId, [FromQuery] DateOnly? desde, [FromQuery] DateOnly? hasta, [FromQuery] int? dias, CancellationToken ct) =>
        await docente.ObtenerFichaAsync(UsuarioId, estudianteId, new PeriodoSolicitado(desde, hasta, dias), Contexto, ct);

    [HttpGet("estudiantes/{estudianteId:guid}/actividad")]
    public async Task<ActionResult<ActividadMesDto>> Actividad(Guid estudianteId, [FromQuery] int anio, [FromQuery] int mes, CancellationToken ct) =>
        await docente.ObtenerActividadAsync(UsuarioId, estudianteId, anio, mes, Contexto, ct);

    [HttpGet("estudiantes/{estudianteId:guid}/materias/{asignaturaId:long}")]
    public async Task<ActionResult<DetalleMateriaDto>> DetalleMateria(Guid estudianteId, long asignaturaId, CancellationToken ct) =>
        await docente.ObtenerDetalleMateriaAsync(UsuarioId, estudianteId, asignaturaId, Contexto, ct);

    [HttpGet("aulas/{aulaId:guid}/estadisticas")]
    public async Task<ActionResult<EstadisticasClaseDto>> Clase(Guid aulaId, [FromQuery] DateOnly? desde, [FromQuery] DateOnly? hasta, [FromQuery] int? dias, CancellationToken ct) =>
        await docente.ObtenerEstadisticasClaseAsync(UsuarioId, aulaId, new PeriodoSolicitado(desde, hasta, dias), Contexto, ct);
}
