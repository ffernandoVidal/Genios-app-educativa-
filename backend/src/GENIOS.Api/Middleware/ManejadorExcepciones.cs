using GENIOS.Domain.Exceptions;
using Microsoft.AspNetCore.Diagnostics;
using Microsoft.AspNetCore.Mvc;

namespace GENIOS.Api.Middleware;

/// <summary>Convierte los errores de negocio en Problem Details con un código estable. Los demás errores siguen su curso.</summary>
public class ManejadorExcepciones(IProblemDetailsService problemas) : IExceptionHandler
{
    public async ValueTask<bool> TryHandleAsync(HttpContext contexto, Exception excepcion, CancellationToken ct)
    {
        if (excepcion is not ExcepcionNegocio error) return false;

        var estado = error.Tipo switch
        {
            TipoError.Validacion => StatusCodes.Status400BadRequest,
            TipoError.NoAutenticado => StatusCodes.Status401Unauthorized,
            TipoError.Prohibido => StatusCodes.Status403Forbidden,
            TipoError.NoEncontrado => StatusCodes.Status404NotFound,
            TipoError.Conflicto => StatusCodes.Status409Conflict,
            _ => StatusCodes.Status503ServiceUnavailable
        };

        contexto.Response.StatusCode = estado;
        var detalle = new ProblemDetails { Status = estado, Title = error.Message };
        detalle.Extensions["codigo"] = error.Codigo;
        detalle.Extensions["idCorrelacion"] = contexto.TraceIdentifier;

        return await problemas.TryWriteAsync(new ProblemDetailsContext { HttpContext = contexto, ProblemDetails = detalle });
    }
}
