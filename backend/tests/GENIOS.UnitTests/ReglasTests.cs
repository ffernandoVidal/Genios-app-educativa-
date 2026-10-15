using GENIOS.Domain.Rules;

namespace GENIOS.UnitTests;

public class ReglasInvitadoTests
{
    [Theory]
    [InlineData(6, 10, false)] // 60 %: no supera el 61 %
    [InlineData(7, 10, true)]  // 70 %
    [InlineData(10, 10, true)]
    [InlineData(0, 10, false)]
    [InlineData(0, 0, false)]  // sin preguntas evaluadas no cuenta
    public void SuperaMinimo_exige_mas_del_61_por_ciento(int aciertos, int evaluadas, bool esperado) =>
        Assert.Equal(esperado, ReglasInvitado.SuperaMinimo(aciertos, evaluadas));

    [Fact]
    public void Se_requieren_tres_partidas() => Assert.Equal(3, ReglasInvitado.PartidasRequeridas);
}

public class ReglasJuegoTests
{
    [Theory]
    [InlineData("inicial", 10)]
    [InlineData("basica", 10)]
    [InlineData("intermedia", 15)]
    [InlineData("avanzada", 20)]
    public void Puntos_por_dificultad(string dificultad, int esperado) =>
        Assert.Equal(esperado, ReglasJuego.PuntosPorRespuesta(dificultad));

    [Fact]
    public void Bono_de_categoria_es_20() => Assert.Equal(20, ReglasJuego.PuntosBonoCategoria);

    [Theory]
    [InlineData(9, 10, 90.0)]
    [InlineData(0, 0, 0.0)]
    public void Porcentaje_usa_aciertos_del_primer_intento(int aciertos, int evaluadas, double esperado) =>
        Assert.Equal((decimal)esperado, ReglasJuego.PorcentajeAciertos(aciertos, evaluadas));
}

public class ReglasCuentaTests
{
    [Theory]
    [InlineData("  Ana.Luz ", "ana.luz")]
    [InlineData("ANA_01", "ana_01")]
    public void Nombre_de_usuario_se_normaliza(string entrada, string esperado) =>
        Assert.Equal(esperado, ReglasCuenta.NormalizarNombreUsuario(entrada));

    [Theory]
    [InlineData("ab")]          // muy corto
    [InlineData("con espacio")]
    [InlineData("ñandú")]
    [InlineData("")]
    [InlineData(null)]
    public void Nombre_de_usuario_invalido_devuelve_null(string? entrada) =>
        Assert.Null(ReglasCuenta.NormalizarNombreUsuario(entrada));

    [Fact]
    public void Codigo_de_aula_generado_cumple_el_formato()
    {
        for (var i = 0; i < 500; i++)
            Assert.NotNull(ReglasCuenta.NormalizarCodigoAula(ReglasCuenta.GenerarCodigoAula()));
    }

    [Theory]
    [InlineData("k4821", "K4821")]
    [InlineData("44821", null)]
    [InlineData("K482", null)]
    public void Codigo_de_aula_se_normaliza(string entrada, string? esperado) =>
        Assert.Equal(esperado, ReglasCuenta.NormalizarCodigoAula(entrada));
}

public class GeneradorOperacionesTests
{
    private static readonly string[] Operaciones = ["suma", "resta", "multiplicacion", "division"];

    [Fact]
    public void Las_operaciones_generadas_cumplen_las_reglas_matematicas()
    {
        var azar = new Random(12345);
        foreach (var operacion in Operaciones)
        {
            for (var i = 0; i < 500; i++)
            {
                var o = GeneradorOperaciones.Generar(operacion, 1, 20, azar);

                Assert.True(o.Respuesta >= 0, "resultado negativo");
                Assert.Equal(4, o.Opciones.Count);
                Assert.Equal(4, o.Opciones.Distinct().Count());   // sin opciones repetidas
                Assert.Contains(o.Respuesta, o.Opciones);          // la correcta está entre las opciones
                Assert.All(o.Opciones, valor => Assert.True(valor >= 0));
            }
        }
    }

    [Fact]
    public void La_division_es_exacta_y_nunca_entre_cero()
    {
        var azar = new Random(7);
        for (var i = 0; i < 500; i++)
        {
            var partes = GeneradorOperaciones.Generar("division", 1, 12, azar).Enunciado.Split(' ');
            var dividendo = int.Parse(partes[0]);
            var divisor = int.Parse(partes[2]);
            Assert.NotEqual(0, divisor);
            Assert.Equal(0, dividendo % divisor);
        }
    }

    [Fact]
    public void La_resta_nunca_es_negativa()
    {
        var azar = new Random(99);
        for (var i = 0; i < 500; i++)
            Assert.True(GeneradorOperaciones.Generar("resta", 1, 20, azar).Respuesta >= 0);
    }

    [Theory]
    [InlineData(0, 10)]
    [InlineData(5, 3)]
    [InlineData(1, 5000)]
    public void Un_rango_invalido_se_rechaza(int minimo, int maximo) =>
        Assert.Throws<ArgumentException>(() => GeneradorOperaciones.Generar("suma", minimo, maximo, new Random(1)));

    [Fact]
    public void Una_operacion_desconocida_se_rechaza() =>
        Assert.Throws<ArgumentException>(() => GeneradorOperaciones.Generar("potencia", 1, 5, new Random(1)));
}
