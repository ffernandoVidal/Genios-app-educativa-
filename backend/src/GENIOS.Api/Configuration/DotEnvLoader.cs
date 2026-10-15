namespace GENIOS.Api.Configuration;

/// <summary>
/// Carga variables desde un archivo .env (solo desarrollo). No sobrescribe variables
/// de entorno ya definidas, de modo que un gestor de secretos siempre tiene prioridad.
/// </summary>
public static class DotEnvLoader
{
    public static string? FindFile(string startDirectory)
    {
        var dir = new DirectoryInfo(startDirectory);
        while (dir is not null)
        {
            var candidate = Path.Combine(dir.FullName, ".env");
            if (File.Exists(candidate)) return candidate;
            dir = dir.Parent;
        }
        return null;
    }

    public static void Load(string startDirectory)
    {
        var file = FindFile(startDirectory);
        if (file is null) return;

        foreach (var raw in File.ReadAllLines(file))
        {
            var line = raw.Trim();
            if (line.Length == 0 || line.StartsWith('#')) continue;

            var idx = line.IndexOf('=');
            if (idx <= 0) continue;

            var key = line[..idx].Trim();
            var value = line[(idx + 1)..].Trim().Trim('"');
            if (Environment.GetEnvironmentVariable(key) is null)
                Environment.SetEnvironmentVariable(key, value);
        }
    }
}
