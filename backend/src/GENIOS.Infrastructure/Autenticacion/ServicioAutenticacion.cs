using GENIOS.Application.Autenticacion;
using GENIOS.Application.Comun;
using GENIOS.Domain.Exceptions;
using GENIOS.Domain.Rules;
using GENIOS.Infrastructure.Auditoria;
using GENIOS.Infrastructure.Persistence;
using GENIOS.Infrastructure.Persistence.Context;
using GENIOS.Infrastructure.Persistence.Entities;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;

namespace GENIOS.Infrastructure.Autenticacion;

public class ServicioAutenticacion(
    GeniosDbContext bd,
    IPasswordHasher<Usuarios> hasher,
    EmisorTokens emisor,
    VerificadorGoogle google,
    IOptions<OpcionesAutenticacion> opciones,
    RegistradorAuditoria auditoria) : IServicioAutenticacion
{
    private readonly OpcionesAutenticacion _opciones = opciones.Value;

    // ---------------------------------------------------------------- Estudiantes

    public async Task<ResultadoSesion> RegistrarEstudianteAsync(SolicitudRegistroEstudiante solicitud, ContextoSolicitud contexto, CancellationToken ct)
    {
        var nombreNormalizado = ReglasCuenta.NormalizarNombreUsuario(solicitud.NombreUsuario)
            ?? throw Error(TipoError.Validacion, "nombre_usuario_invalido",
                "El nombre de usuario debe tener de 3 a 30 caracteres: letras, números, punto o guion bajo.");
        ValidarContrasena(solicitud.Contrasena);
        var nombreMostrar = (solicitud.NombreMostrar ?? "").Trim();
        if (nombreMostrar.Length is 0 or > 120)
            throw Error(TipoError.Validacion, "nombre_mostrar_invalido", "El nombre debe tener entre 1 y 120 caracteres.");

        var aula = await bd.BuscarAulaActivaAsync(solicitud.CodigoAula, ct);
        var rolId = await ObtenerRolIdAsync(CodigosRol.Estudiante, ct);

        var usuario = new Usuarios
        {
            Id = Guid.NewGuid(),
            NombreUsuario = solicitud.NombreUsuario.Trim(),
            NombreUsuarioNormalizado = nombreNormalizado,
            NombreMostrar = nombreMostrar,
            MetodoRegistro = "usuario_contrasena",
            Estado = "activo",
            ZonaHoraria = "America/Guatemala"
        };
        usuario.ContrasenaHash = hasher.HashPassword(usuario, solicitud.Contrasena);

        bd.Usuarios.Add(usuario);
        bd.PerfilesEstudiante.Add(new PerfilesEstudiante { UsuarioId = usuario.Id, Activo = true });
        bd.UsuariosRoles.Add(new UsuariosRoles { UsuarioId = usuario.Id, RolId = rolId });
        bd.MiembrosAula.Add(new MiembrosAula { AulaId = aula.Id, EstudianteId = usuario.Id, Estado = "activo" });

        try
        {
            await bd.SaveChangesAsync(ct);
        }
        catch (DbUpdateException e) when (e.EsViolacionUnica())
        {
            throw Error(TipoError.Conflicto, "nombre_usuario_en_uso", "Ese nombre de usuario ya está en uso.");
        }

        await auditoria.RegistrarAsync("estudiante_registrado", usuario.Id, contexto, new { aulaId = aula.Id });
        return (await CrearSesionAsync(usuario, null, ct)).Resultado;
    }

    public async Task<ResultadoSesion> IniciarSesionEstudianteAsync(SolicitudInicioSesionEstudiante solicitud, ContextoSolicitud contexto, CancellationToken ct)
    {
        var nombreNormalizado = ReglasCuenta.NormalizarNombreUsuario(solicitud.NombreUsuario);
        var usuario = nombreNormalizado is null
            ? null
            : await bd.Usuarios.SingleOrDefaultAsync(u => u.NombreUsuarioNormalizado == nombreNormalizado, ct);

        var correcto = usuario?.ContrasenaHash is not null
            && usuario.Estado == "activo"
            && hasher.VerifyHashedPassword(usuario, usuario.ContrasenaHash, solicitud.Contrasena ?? "") != PasswordVerificationResult.Failed;

        if (!correcto)
        {
            await auditoria.RegistrarAsync("inicio_sesion_fallido", usuario?.Id, contexto);
            throw Error(TipoError.NoAutenticado, "credenciales_invalidas", "Usuario o contraseña incorrectos.");
        }

        usuario!.UltimoAccesoEn = DateTime.UtcNow;
        return (await CrearSesionAsync(usuario, null, ct)).Resultado;
    }

    public async Task<CodigoRestablecimientoDto> EmitirCodigoRestablecimientoAsync(Guid docenteId, Guid aulaId, Guid estudianteId, ContextoSolicitud contexto, CancellationToken ct)
    {
        var esDelDocente = await bd.Aulas.AnyAsync(a => a.Id == aulaId && a.DocenteId == docenteId && a.Estado == "activa", ct);
        var esMiembro = esDelDocente && await bd.MiembrosAula.AnyAsync(
            m => m.AulaId == aulaId && m.EstudianteId == estudianteId && m.Estado == "activo", ct);
        if (!esMiembro)
            throw Error(TipoError.NoEncontrado, "estudiante_no_encontrado", "El estudiante no pertenece a tu aula.");

        var estudiante = await bd.Usuarios.SingleAsync(u => u.Id == estudianteId, ct);
        if (estudiante.MetodoRegistro != "usuario_contrasena")
            throw Error(TipoError.Validacion, "cuenta_sin_contrasena", "Esta cuenta no usa contraseña de GENIOS.");

        var ahora = DateTime.UtcNow;
        var codigo = ReglasCuenta.GenerarCodigoTemporal();
        var expira = ahora.AddMinutes(ReglasCuenta.MinutosVigenciaCodigoRestablecimiento);

        // Un código nuevo anula los anteriores sin usar.
        await bd.TokensRecuperacionContrasena
            .Where(t => t.UsuarioId == estudianteId && t.UtilizadoEn == null)
            .ExecuteUpdateAsync(s => s.SetProperty(t => t.UtilizadoEn, ahora), ct);

        bd.TokensRecuperacionContrasena.Add(new TokensRecuperacionContrasena
        {
            Id = Guid.NewGuid(),
            UsuarioId = estudianteId,
            TokenHash = emisor.CalcularHash(codigo),
            CreadoEn = ahora,
            ExpiraEn = expira,
            EmitidoPor = docenteId
        });
        await bd.SaveChangesAsync(ct);

        await auditoria.RegistrarAsync("restablecimiento_emitido", docenteId, contexto, new { estudianteId, aulaId });
        return new CodigoRestablecimientoDto(codigo, expira);
    }

    public async Task ConfirmarRestablecimientoAsync(SolicitudConfirmarRestablecimiento solicitud, ContextoSolicitud contexto, CancellationToken ct)
    {
        ValidarContrasena(solicitud.ContrasenaNueva);
        var nombreNormalizado = ReglasCuenta.NormalizarNombreUsuario(solicitud.NombreUsuario);
        var usuario = nombreNormalizado is null
            ? null
            : await bd.Usuarios.SingleOrDefaultAsync(u => u.NombreUsuarioNormalizado == nombreNormalizado, ct);

        var codigoInvalido = Error(TipoError.Validacion, "codigo_invalido", "El código no es válido o ya venció.");
        if (usuario is null) throw codigoInvalido;

        var ahora = DateTime.UtcNow;
        var hashCodigo = emisor.CalcularHash((solicitud.Codigo ?? "").Trim().ToUpperInvariant());

        await using var transaccion = await bd.Database.BeginTransactionAsync(ct);

        // Marcar el código como usado es la condición: si dos solicitudes llegan a la vez, solo una lo logra.
        var filas = await bd.TokensRecuperacionContrasena
            .Where(t => t.UsuarioId == usuario.Id && t.TokenHash == hashCodigo && t.UtilizadoEn == null && t.ExpiraEn > ahora)
            .ExecuteUpdateAsync(s => s.SetProperty(t => t.UtilizadoEn, ahora), ct);
        if (filas == 0) throw codigoInvalido;

        usuario.ContrasenaHash = hasher.HashPassword(usuario, solicitud.ContrasenaNueva);
        usuario.DebeCambiarContrasena = false;
        await bd.SaveChangesAsync(ct);

        await bd.SesionesAutenticacion
            .Where(s => s.UsuarioId == usuario.Id && s.RevocadoEn == null)
            .ExecuteUpdateAsync(s => s.SetProperty(x => x.RevocadoEn, ahora), ct);

        await transaccion.CommitAsync(ct);
        await auditoria.RegistrarAsync("restablecimiento_usado", usuario.Id, contexto);
    }

    // ---------------------------------------------------------------- Google

    public async Task<ResultadoSesion> IniciarSesionGoogleAsync(SolicitudGoogle solicitud, ContextoSolicitud contexto, CancellationToken ct)
    {
        var datos = await google.ValidarAsync(solicitud.IdToken);

        var identidad = await bd.IdentidadesExternas.Include(i => i.Usuario)
            .SingleOrDefaultAsync(i => i.Proveedor == "google" && i.IdentificadorExterno == datos.Sub, ct);
        var usuario = identidad?.Usuario ?? await CrearUsuarioGoogleAsync(datos, ct);

        if (usuario.Estado != "activo")
            throw Error(TipoError.Prohibido, "cuenta_no_activa", "La cuenta no está activa.");

        if (solicitud.SolicitaRolDocente)
            await AplicarAltaDocenteAsync(usuario, contexto, ct);

        usuario.UltimoAccesoEn = DateTime.UtcNow;
        return (await CrearSesionAsync(usuario, null, ct)).Resultado;
    }

    private async Task<Usuarios> CrearUsuarioGoogleAsync(DatosGoogle datos, CancellationToken ct)
    {
        var correoNormalizado = ReglasCuenta.NormalizarCorreo(datos.Correo);

        // No se vincula por coincidencia de correo: hacerlo exigiría probar que el usuario controla ambas cuentas.
        if (await bd.Usuarios.AnyAsync(u => u.CorreoNormalizado == correoNormalizado, ct))
            throw Error(TipoError.Conflicto, "correo_ya_registrado", "Ese correo ya está asociado a otra cuenta.");

        var rolId = await ObtenerRolIdAsync(CodigosRol.Estudiante, ct);
        var nombre = datos.Nombre.Trim();
        var usuario = new Usuarios
        {
            Id = Guid.NewGuid(),
            Correo = datos.Correo.Trim(),
            CorreoNormalizado = correoNormalizado,
            CorreoConfirmadoEn = DateTime.UtcNow,
            NombreMostrar = nombre.Length > 120 ? nombre[..120] : nombre,
            MetodoRegistro = "google",
            Estado = "activo",
            ZonaHoraria = "America/Guatemala"
        };

        bd.Usuarios.Add(usuario);
        bd.IdentidadesExternas.Add(new IdentidadesExternas
        {
            Id = Guid.NewGuid(),
            UsuarioId = usuario.Id,
            Proveedor = "google",
            IdentificadorExterno = datos.Sub,
            CorreoProveedor = datos.Correo
        });
        bd.PerfilesEstudiante.Add(new PerfilesEstudiante { UsuarioId = usuario.Id, Activo = true });
        bd.UsuariosRoles.Add(new UsuariosRoles { UsuarioId = usuario.Id, RolId = rolId });

        try
        {
            await bd.SaveChangesAsync(ct);
        }
        catch (DbUpdateException e) when (e.EsViolacionUnica())
        {
            throw Error(TipoError.Conflicto, "cuenta_en_creacion", "La cuenta ya se está creando. Intenta de nuevo.");
        }
        return usuario;
    }

    /// <summary>El rol docente solo se concede si el dominio del correo está en la lista configurada.</summary>
    private async Task AplicarAltaDocenteAsync(Usuarios usuario, ContextoSolicitud contexto, CancellationToken ct)
    {
        var rolDocenteId = await ObtenerRolIdAsync(CodigosRol.Docente, ct);
        if (await bd.UsuariosRoles.AnyAsync(r => r.UsuarioId == usuario.Id && r.RolId == rolDocenteId, ct)) return;

        var perfil = await bd.PerfilesDocente.FindAsync([usuario.Id], ct);
        if (perfil is null)
        {
            perfil = new PerfilesDocente { UsuarioId = usuario.Id, CorreoEducativo = usuario.Correo };
            bd.PerfilesDocente.Add(perfil);
        }

        var correo = usuario.Correo ?? "";
        var dominio = correo[(correo.IndexOf('@') + 1)..].ToLowerInvariant();
        var dominioPermitido = _opciones.DominiosDocentes.Any(d => d.Trim().ToLowerInvariant() == dominio);
        if (dominioPermitido)
        {
            perfil.VerificadoEn = DateTime.UtcNow;
            bd.UsuariosRoles.Add(new UsuariosRoles { UsuarioId = usuario.Id, RolId = rolDocenteId });
        }
        await bd.SaveChangesAsync(ct);

        if (dominioPermitido)
            await auditoria.RegistrarAsync("docente_verificado_por_dominio", usuario.Id, contexto);
    }

    // ---------------------------------------------------------------- Sesiones

    public async Task<ResultadoSesion> RenovarAsync(string tokenRenovacion, ContextoSolicitud contexto, CancellationToken ct)
    {
        var sesion = await bd.SesionesAutenticacion
            .SingleOrDefaultAsync(s => s.TokenHash == emisor.CalcularHash(tokenRenovacion ?? ""), ct)
            ?? throw SesionInvalida();

        var ahora = DateTime.UtcNow;
        if (sesion.ExpiraEn <= ahora) throw SesionInvalida();

        await using var transaccion = await bd.Database.BeginTransactionAsync(ct);

        // Revocar es la condición: un token solo se puede rotar una vez, incluso con solicitudes simultáneas.
        var filas = await bd.SesionesAutenticacion
            .Where(s => s.Id == sesion.Id && s.RevocadoEn == null)
            .ExecuteUpdateAsync(s => s.SetProperty(x => x.RevocadoEn, ahora).SetProperty(x => x.UltimoUsoEn, ahora), ct);

        if (filas == 0)
        {
            // Token ya usado: se asume robo y se revoca toda la familia.
            await RevocarFamiliaAsync(sesion.FamiliaTokenId, ct);
            await transaccion.CommitAsync(ct);
            await auditoria.RegistrarAsync("token_renovacion_reutilizado", sesion.UsuarioId, contexto);
            throw SesionInvalida();
        }

        var usuario = await bd.Usuarios.SingleAsync(u => u.Id == sesion.UsuarioId, ct);
        if (usuario.Estado != "activo") throw SesionInvalida();

        var (resultado, nuevaSesionId) = await CrearSesionAsync(usuario, sesion.FamiliaTokenId, ct);
        await bd.SesionesAutenticacion.Where(s => s.Id == sesion.Id)
            .ExecuteUpdateAsync(s => s.SetProperty(x => x.ReemplazadoPorId, nuevaSesionId), ct);

        await transaccion.CommitAsync(ct);
        return resultado;
    }

    public async Task CerrarSesionAsync(string tokenRenovacion, CancellationToken ct)
    {
        var hash = emisor.CalcularHash(tokenRenovacion ?? "");
        var sesion = await bd.SesionesAutenticacion.SingleOrDefaultAsync(s => s.TokenHash == hash, ct);
        if (sesion is not null) await RevocarFamiliaAsync(sesion.FamiliaTokenId, ct);
    }

    public async Task<UsuarioDto> ObtenerUsuarioAsync(Guid usuarioId, CancellationToken ct)
    {
        var usuario = await bd.Usuarios.SingleOrDefaultAsync(u => u.Id == usuarioId && u.Estado == "activo", ct)
            ?? throw Error(TipoError.NoAutenticado, "usuario_no_encontrado", "No se encontró el usuario.");
        return ConvertirADto(usuario, await ObtenerRolesAsync(usuarioId, ct));
    }

    private Task<int> RevocarFamiliaAsync(Guid familiaId, CancellationToken ct) =>
        bd.SesionesAutenticacion
            .Where(s => s.FamiliaTokenId == familiaId && s.RevocadoEn == null)
            .ExecuteUpdateAsync(s => s.SetProperty(x => x.RevocadoEn, DateTime.UtcNow), ct);

    private async Task<(ResultadoSesion Resultado, Guid SesionId)> CrearSesionAsync(Usuarios usuario, Guid? familiaId, CancellationToken ct)
    {
        var roles = await ObtenerRolesAsync(usuario.Id, ct);
        var (token, hash) = emisor.CrearTokenRenovacion();
        var ahora = DateTime.UtcNow;
        var sesion = new SesionesAutenticacion
        {
            Id = Guid.NewGuid(),
            UsuarioId = usuario.Id,
            TokenHash = hash,
            FamiliaTokenId = familiaId ?? Guid.NewGuid(),
            CreadoEn = ahora,
            ExpiraEn = ahora.AddDays(_opciones.DiasRenovacion)
        };
        bd.SesionesAutenticacion.Add(sesion);
        await bd.SaveChangesAsync(ct);

        var respuesta = new RespuestaAutenticacion(
            emisor.CrearTokenAcceso(usuario.Id, roles), emisor.SegundosAcceso, ConvertirADto(usuario, roles));
        return (new ResultadoSesion(respuesta, token, sesion.ExpiraEn), sesion.Id);
    }

    // ---------------------------------------------------------------- Apoyo

    private async Task<IReadOnlyList<string>> ObtenerRolesAsync(Guid usuarioId, CancellationToken ct) =>
        await bd.UsuariosRoles.Where(r => r.UsuarioId == usuarioId).Select(r => r.Rol.Codigo).ToListAsync(ct);

    private Task<long> ObtenerRolIdAsync(string codigo, CancellationToken ct) =>
        bd.Roles.Where(r => r.Codigo == codigo).Select(r => r.Id).SingleAsync(ct);

    private static UsuarioDto ConvertirADto(Usuarios u, IReadOnlyList<string> roles) =>
        new(u.Id, u.NombreMostrar, u.NombreUsuario, u.Correo, roles);

    private static void ValidarContrasena(string? contrasena)
    {
        if (!ReglasCuenta.EsContrasenaValida(contrasena))
            throw Error(TipoError.Validacion, "contrasena_invalida",
                $"La contraseña debe tener entre {ReglasCuenta.LargoMinimoContrasena} y {ReglasCuenta.LargoMaximoContrasena} caracteres.");
    }

    private static ExcepcionNegocio SesionInvalida() =>
        Error(TipoError.NoAutenticado, "sesion_invalida", "La sesión no es válida. Inicia sesión de nuevo.");

    private static ExcepcionNegocio Error(TipoError tipo, string codigo, string mensaje) => new(tipo, codigo, mensaje);
}
