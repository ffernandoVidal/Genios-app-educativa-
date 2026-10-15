using GENIOS.Application.Comun;
using GENIOS.Infrastructure.Persistence.Entities;

namespace GENIOS.Infrastructure.Persistence;

public static class ConsultasPartidas
{
    public static IQueryable<Partidas> DelPropietario(this IQueryable<Partidas> consulta, Propietario propietario) =>
        propietario.UsuarioId is { } usuarioId
            ? consulta.Where(p => p.UsuarioId == usuarioId)
            : consulta.Where(p => p.SesionInvitadoId == propietario.SesionInvitadoId);

    public static bool EsDe(this Partidas partida, Propietario propietario) =>
        propietario.UsuarioId is { } usuarioId
            ? partida.UsuarioId == usuarioId
            : partida.SesionInvitadoId == propietario.SesionInvitadoId;
}
