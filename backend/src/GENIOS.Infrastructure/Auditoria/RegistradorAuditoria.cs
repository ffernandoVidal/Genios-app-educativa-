using System.Net;
using System.Text.Json;
using GENIOS.Application.Comun;
using GENIOS.Infrastructure.Persistence.Context;
using GENIOS.Infrastructure.Persistence.Entities;

namespace GENIOS.Infrastructure.Auditoria;

public class RegistradorAuditoria(GeniosDbContext bd)
{
    /// <summary>Guarda un evento de seguridad. Los detalles nunca deben incluir contraseñas ni tokens.</summary>
    public async Task RegistrarAsync(string accion, Guid? usuarioId, ContextoSolicitud contexto, object? detalles = null)
    {
        bd.AuditoriaSeguridad.Add(new AuditoriaSeguridad
        {
            UsuarioId = usuarioId,
            Accion = accion,
            DireccionIp = IPAddress.TryParse(contexto.Ip, out var ip) ? ip : null,
            AgenteUsuario = contexto.Agente,
            Detalles = JsonSerializer.Serialize(detalles ?? new { }),
            OcurridoEn = DateTime.UtcNow
        });
        await bd.SaveChangesAsync();
    }
}
