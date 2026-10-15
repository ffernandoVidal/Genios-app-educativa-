using System.Security.Cryptography;
using System.Text;
using GENIOS.Api.Configuration;
using GENIOS.Domain.Rules;
using GENIOS.Infrastructure.Autenticacion;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.Extensions.Configuration;
using Npgsql;

namespace GENIOS.IntegrationTests.Soporte;

[CollectionDefinition(Nombre)]
public class ColeccionJuego : ICollectionFixture<FixtureJuego>
{
    public const string Nombre = "juego";
}

/// <summary>
/// Levanta la API contra Neon y crea contenido propio de la prueba (niveles, categorías, reglas, docente y aula)
/// con una etiqueta única. Al terminar borra únicamente lo que creó: nunca toca contenido ni datos reales.
/// </summary>
public class FixtureJuego : IAsyncLifetime
{
    private readonly List<Guid> _sesionesInvitado = [];
    private NpgsqlDataSource _bd = null!;

    public WebApplicationFactory<Program> Fabrica { get; private set; } = null!;
    public string Etiqueta { get; } = Guid.NewGuid().ToString("N")[..8];

    // Nivel A (Matemáticas): dos categorías en orden. Nivel B (Lenguaje): una categoría. Todas con preguntas generadas.
    public long CategoriaA1 { get; private set; }
    public long CategoriaA2 { get; private set; }
    public long CategoriaB1 { get; private set; }
    public long NivelA { get; private set; }
    public string CodigoAula { get; private set; } = "";
    public Guid DocenteId { get; private set; }
    public Guid AulaId { get; private set; }

    // Segundo docente con su propia aula, para probar el aislamiento entre docentes.
    public string CodigoAula2 { get; private set; } = "";
    public Guid Docente2Id { get; private set; }
    public Guid Aula2Id { get; private set; }

    /// <summary>Token de acceso válido para un docente de prueba (se firma con la clave de la fábrica de pruebas).</summary>
    public string TokenDocente(Guid docenteId) =>
        Fabrica.Services.GetRequiredService<EmisorTokens>().CrearTokenAcceso(docenteId, [CodigosRol.Docente]);

    private readonly List<long> _niveles = [];
    private int _contadorEstudiantes;

    public async Task InitializeAsync()
    {
        DotEnvLoader.Load(AppContext.BaseDirectory);
        var cadena = Environment.GetEnvironmentVariable("ConnectionStrings__GeniosDatabase");
        Assert.False(string.IsNullOrWhiteSpace(cadena), "Las pruebas de integración requieren ConnectionStrings__GeniosDatabase (.env).");
        _bd = new NpgsqlDataSourceBuilder(cadena).Build();

        Fabrica = new WebApplicationFactory<Program>().WithWebHostBuilder(b =>
        {
            b.UseEnvironment("Testing"); // Program no carga el .env fuera de Development
            b.ConfigureAppConfiguration((_, cfg) => cfg.AddInMemoryCollection(new Dictionary<string, string?>
            {
                ["ConnectionStrings:GeniosDatabase"] = cadena,
                ["Autenticacion:Clave"] = Convert.ToBase64String(RandomNumberGenerator.GetBytes(48)),
                ["Autenticacion:CookieSegura"] = "false",
                ["Autenticacion:IntentosPorMinuto"] = "100000",
                ["Juego:SegundosMecha"] = "2" // en producción son 30; aquí se acorta para no esperar
            }));
        });

        var orden = 90000 + RandomNumberGenerator.GetInt32(9000);
        NivelA = await CrearNivelAsync("Matematicas", orden);
        var nivelB = await CrearNivelAsync("Lenguaje", orden);
        CategoriaA1 = await CrearCategoriaAsync(NivelA, "a1", 1);
        CategoriaA2 = await CrearCategoriaAsync(NivelA, "a2", 2);
        CategoriaB1 = await CrearCategoriaAsync(nivelB, "b1", 1);

        (DocenteId, AulaId, CodigoAula) = await CrearDocenteYAulaAsync("d1");
        (Docente2Id, Aula2Id, CodigoAula2) = await CrearDocenteYAulaAsync("d2");
    }

    public async Task DisposeAsync()
    {
        var prefijo = $"prueba.t{Etiqueta}%";
        var cats = new[] { CategoriaA1, CategoriaA2, CategoriaB1 };
        await Ejecutar("delete from transacciones_puntos where usuario_id in (select id from usuarios where nombre_usuario_normalizado like @p)", ("p", prefijo));
        await Ejecutar("delete from partidas where categoria_id = any(@c)", ("c", cats));
        await Ejecutar("delete from sesiones_invitado where id = any(@s)", ("s", _sesionesInvitado.ToArray()));
        await Ejecutar("delete from miembros_aula where estudiante_id in (select id from usuarios where nombre_usuario_normalizado like @p)", ("p", prefijo));
        var docentes = $"t{Etiqueta}%@prueba.invalid";
        await Ejecutar("delete from auditoria_seguridad where usuario_id in (select id from usuarios where nombre_usuario_normalizado like @p or correo_normalizado like @d)", ("p", prefijo), ("d", docentes));
        await Ejecutar("delete from aulas where docente_id in (select id from usuarios where correo_normalizado like @d)", ("d", docentes));
        await Ejecutar("delete from usuarios where nombre_usuario_normalizado like @p or correo_normalizado like @d", ("p", prefijo), ("d", docentes));
        await Ejecutar("delete from reglas_generacion_preguntas where categoria_id = any(@c)", ("c", cats));
        await Ejecutar("delete from categorias where id = any(@c)", ("c", cats));
        await Ejecutar("delete from niveles_educativos where id = any(@n)", ("n", _niveles.ToArray()));
        await Fabrica.DisposeAsync();
        await _bd.DisposeAsync();
    }

    // ------------------------------------------------------------ Apoyo para las pruebas

    public string NombreUsuarioNuevo() => $"prueba.t{Etiqueta}e{Interlocked.Increment(ref _contadorEstudiantes)}";

    /// <summary>Registra la sesión de invitado (por el hash de su cookie) para borrarla al final.</summary>
    public async Task<Guid> RegistrarSesionInvitadoAsync(string tokenCookie)
    {
        var hash = Convert.ToHexString(SHA256.HashData(Encoding.UTF8.GetBytes(tokenCookie)));
        var id = await Escalar<Guid>("select id from sesiones_invitado where identificador_token_hash = @h", ("h", hash));
        lock (_sesionesInvitado) _sesionesInvitado.Add(id);
        return id;
    }

    public async Task<int> Ejecutar(string sql, params (string Nombre, object Valor)[] parametros)
    {
        await using var cmd = _bd.CreateCommand(sql);
        foreach (var (nombre, valor) in parametros) cmd.Parameters.AddWithValue(nombre, valor);
        return await cmd.ExecuteNonQueryAsync();
    }

    public async Task<T> Escalar<T>(string sql, params (string Nombre, object Valor)[] parametros)
    {
        await using var cmd = _bd.CreateCommand(sql);
        foreach (var (nombre, valor) in parametros) cmd.Parameters.AddWithValue(nombre, valor);
        return (T)(await cmd.ExecuteScalarAsync())!;
    }

    public async Task<List<object[]>> Filas(string sql, params (string Nombre, object Valor)[] parametros)
    {
        await using var cmd = _bd.CreateCommand(sql);
        foreach (var (nombre, valor) in parametros) cmd.Parameters.AddWithValue(nombre, valor);
        await using var lector = await cmd.ExecuteReaderAsync();
        var filas = new List<object[]>();
        while (await lector.ReadAsync())
        {
            var fila = new object[lector.FieldCount];
            lector.GetValues(fila);
            filas.Add(fila);
        }
        return filas;
    }

    // ------------------------------------------------------------ Contenido de prueba

    private async Task<long> CrearNivelAsync(string asignatura, int orden)
    {
        var id = await Escalar<long>(
            "insert into niveles_educativos (asignatura_id, nombre, numero_orden) select id, @n, @o from asignaturas where nombre = @a returning id",
            ("n", $"Nivel test {Etiqueta}"), ("o", orden), ("a", asignatura));
        _niveles.Add(id);
        return id;
    }

    private async Task<long> CrearCategoriaAsync(long nivelId, string sufijo, int orden)
    {
        var codigo = $"t{Etiqueta}{sufijo}";
        var id = await Escalar<long>(
            "insert into categorias (nivel_educativo_id, codigo, nombre, numero_orden) values (@n, @c, @c, @o) returning id",
            ("n", nivelId), ("c", codigo), ("o", orden));
        await Ejecutar(
            "insert into reglas_generacion_preguntas (categoria_id, codigo, nombre, version, dificultad, parametros) values (@c, @k, @k, 1, 'basica', '{\"operacion\":\"suma\",\"minimo\":1,\"maximo\":9}'::jsonb)",
            ("c", id), ("k", $"{codigo}_suma"));
        return id;
    }

    private async Task<(Guid DocenteId, Guid AulaId, string Codigo)> CrearDocenteYAulaAsync(string sufijo)
    {
        var rolDocente = await Escalar<long>("select id from roles where codigo = 'docente'");
        var docenteId = await Escalar<Guid>(
            "insert into usuarios (nombre_mostrar, estado, correo, correo_normalizado, metodo_registro) values ('Docente test', 'activo', @c, @c, 'google') returning id",
            ("c", $"t{Etiqueta}{sufijo}@prueba.invalid"));
        await Ejecutar("insert into perfiles_docente (usuario_id, verificado_en) values (@u, now())", ("u", docenteId));
        await Ejecutar("insert into usuarios_roles (usuario_id, rol_id) values (@u, @r)", ("u", docenteId), ("r", rolDocente));

        for (var intento = 0; ; intento++)
        {
            var codigo = $"{(char)('A' + RandomNumberGenerator.GetInt32(26))}{RandomNumberGenerator.GetInt32(10000):D4}";
            try
            {
                var aulaId = await Escalar<Guid>("insert into aulas (docente_id, nombre, codigo_acceso) values (@d, @n, @c) returning id",
                    ("d", docenteId), ("n", $"Aula test {Etiqueta} {sufijo}"), ("c", codigo));
                return (docenteId, aulaId, codigo);
            }
            catch (PostgresException e) when (e.SqlState == PostgresErrorCodes.UniqueViolation && intento < 10) { }
        }
    }
}
