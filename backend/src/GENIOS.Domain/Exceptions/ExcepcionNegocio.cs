namespace GENIOS.Domain.Exceptions;

public enum TipoError
{
    Validacion,
    NoAutenticado,
    Prohibido,
    NoEncontrado,
    Conflicto,
    NoDisponible
}

/// <summary>Error esperado del negocio. El Api lo traduce a una respuesta HTTP con código estable.</summary>
public class ExcepcionNegocio(TipoError tipo, string codigo, string mensaje) : Exception(mensaje)
{
    public TipoError Tipo { get; } = tipo;
    public string Codigo { get; } = codigo;
}
