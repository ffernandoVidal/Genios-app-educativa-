namespace GENIOS.Domain.Rules;

public static class CodigosRol
{
    public const string Estudiante = "estudiante";
    public const string Docente = "docente";

    /// <summary>Rol interno de las sesiones anónimas; no existe en la tabla de roles.</summary>
    public const string Invitado = "invitado";
}
