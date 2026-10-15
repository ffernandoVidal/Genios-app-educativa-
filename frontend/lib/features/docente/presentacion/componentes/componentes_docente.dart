import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../diseno/tokens/colores.dart';
import '../../../../diseno/tokens/medidas.dart';
import '../../../../diseno/tokens/tipografia.dart';
import '../../dominio/modelos_docente.dart';

// ------------------------------------------------------------------ Formatos

String textoPorcentaje(double? p) {
  if (p == null) return '—';
  return '${p.toStringAsFixed(p == p.roundToDouble() ? 0 : 1)} %';
}

String textoDuracion(int? segundos) {
  if (segundos == null) return 'No disponible';
  if (segundos < 60) return '$segundos s';
  final m = segundos ~/ 60;
  final s = segundos % 60;
  return s == 0 ? '$m min' : '$m min $s s';
}

String textoFecha(DateTime? f) {
  if (f == null) return 'Sin actividad';
  final l = f.toLocal();
  String dos(int n) => n.toString().padLeft(2, '0');
  return '${dos(l.day)}/${dos(l.month)}/${l.year}';
}

String textoVariacion(double? v) {
  if (v == null) return 'Sin período anterior para comparar';
  final signo = v > 0 ? '+' : '';
  return '$signo${v.toStringAsFixed(1)} puntos porcentuales';
}

// ------------------------------------------------------------------ Rendimiento

extension PresentacionRendimiento on Rendimiento {
  Color get color => switch (this) {
    Rendimiento.refuerzo => ColoresRendimiento.refuerzo,
    Rendimiento.repaso => ColoresRendimiento.repaso,
    Rendimiento.aprobado => ColoresRendimiento.aprobado,
    Rendimiento.sinDatos => ColoresRendimiento.sinDatos,
  };

  IconData get icono => switch (this) {
    Rendimiento.refuerzo => Icons.trending_down_rounded,
    Rendimiento.repaso => Icons.autorenew_rounded,
    Rendimiento.aprobado => Icons.check_circle_rounded,
    Rendimiento.sinDatos => Icons.hourglass_empty_rounded,
  };
}

/// Estado de rendimiento: color + icono + texto (nunca solo color).
class ChipRendimiento extends StatelessWidget {
  const ChipRendimiento(this.rendimiento, {super.key});

  final Rendimiento rendimiento;

  @override
  Widget build(BuildContext context) {
    final color = rendimiento.color;
    return Semantics(
      label: 'Rendimiento: ${rendimiento.etiqueta}',
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.18),
          borderRadius: Radios.boton,
          border: Border.all(color: color, width: 1.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(rendimiento.icono, size: 16, color: color),
            const SizedBox(width: 4),
            Text(
              rendimiento.etiqueta,
              style: Tipografia.texto(12, peso: 800, color: color),
            ),
          ],
        ),
      ),
    );
  }
}

/// Barra del porcentaje de aciertos (NO del avance curricular). Sin datos, la barra queda vacía y neutra.
class BarraPorcentaje extends StatelessWidget {
  const BarraPorcentaje({
    super.key,
    required this.valor,
    required this.rendimiento,
  });

  final double? valor;
  final Rendimiento rendimiento;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: valor == null
          ? 'Sin actividad'
          : 'Aciertos ${textoPorcentaje(valor)}',
      excludeSemantics: true,
      child: ClipRRect(
        borderRadius: Radios.boton,
        child: LinearProgressIndicator(
          value: ((valor ?? 0) / 100).clamp(0.0, 1.0),
          minHeight: 12,
          backgroundColor: ColoresGenios.superficieOscura,
          color: rendimiento.color,
        ),
      ),
    );
  }
}

// ------------------------------------------------------------------ Contenedores

/// Bloque con título. Es un Material (no un contenedor con color) para que ListTile y ExpansionTile pinten bien.
class Bloque extends StatelessWidget {
  const Bloque({
    super.key,
    required this.titulo,
    required this.hijo,
    this.accion,
  });

  final String titulo;
  final Widget hijo;
  final Widget? accion;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ColoresGenios.superficie,
      borderRadius: Radios.tarjeta,
      child: Padding(
        padding: const EdgeInsets.all(Espaciado.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Semantics(
                    header: true,
                    child: Text(
                      titulo,
                      style: Tipografia.titulo(22, peso: 800),
                    ),
                  ),
                ),
                ?accion,
              ],
            ),
            const SizedBox(height: Espaciado.m),
            hijo,
          ],
        ),
      ),
    );
  }
}

class TarjetaIndicador extends StatelessWidget {
  const TarjetaIndicador({
    super.key,
    required this.icono,
    required this.titulo,
    required this.valor,
    this.detalle,
    this.color = ColoresGenios.turquesa,
  });

  final IconData icono;
  final String titulo;
  final String valor;
  final String? detalle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$titulo: $valor${detalle == null ? '' : '. $detalle'}',
      excludeSemantics: true,
      child: Material(
        color: ColoresGenios.superficie,
        borderRadius: Radios.tarjeta,
        child: Padding(
          padding: const EdgeInsets.all(Espaciado.l),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: color.withValues(alpha: 0.2),
                child: Icon(icono, color: color, size: 28),
              ),
              const SizedBox(width: Espaciado.m),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(valor, style: Tipografia.titulo(28, peso: 800)),
                    Text(
                      titulo,
                      style: Tipografia.texto(
                        14,
                        color: ColoresGenios.textoSuave,
                      ),
                    ),
                    if (detalle != null)
                      Text(
                        detalle!,
                        style: Tipografia.texto(
                          12,
                          color: ColoresGenios.textoSuave,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Cuadrícula adaptable: tantas columnas como quepan con un ancho mínimo por tarjeta.
class CuadriculaAdaptable extends StatelessWidget {
  const CuadriculaAdaptable({
    super.key,
    required this.hijos,
    this.anchoMinimo = 240,
  });

  final List<Widget> hijos;
  final double anchoMinimo;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final columnas = (c.maxWidth / anchoMinimo).floor().clamp(
          1,
          hijos.length.clamp(1, 6),
        );
        final ancho = (c.maxWidth - (columnas - 1) * Espaciado.l) / columnas;
        return Wrap(
          spacing: Espaciado.l,
          runSpacing: Espaciado.l,
          children: [for (final h in hijos) SizedBox(width: ancho, child: h)],
        );
      },
    );
  }
}

/// Mensaje de error con icono, anunciado a los lectores de pantalla.
class MensajeAccion extends StatelessWidget {
  const MensajeAccion({super.key, required this.mensaje, this.esError = true});

  final String mensaje;
  final bool esError;

  @override
  Widget build(BuildContext context) {
    final color = esError ? ColoresGenios.error : ColoresGenios.exito;
    return Semantics(
      liveRegion: true,
      child: Row(
        children: [
          Icon(
            esError ? Icons.error_outline_rounded : Icons.check_circle_rounded,
            color: color,
          ),
          const SizedBox(width: Espaciado.s),
          Flexible(
            child: Text(
              mensaje,
              style: Tipografia.texto(16, peso: 800, color: color),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> copiarTexto(BuildContext context, String texto) async {
  await Clipboard.setData(ClipboardData(text: texto));
  if (!context.mounted) return;
  ScaffoldMessenger.of(context)
      .showSnackBar(const SnackBar(content: Text('Copiado')));
}

/// Tarjeta del código de activación (de un solo uso) que el docente entrega al estudiante.
class TarjetaActivacion extends StatelessWidget {
  const TarjetaActivacion({super.key, required this.codigo});

  final CodigoActivacion codigo;

  @override
  Widget build(BuildContext context) {
    final minutos = codigo.expiraEn
        .difference(DateTime.now().toUtc())
        .inMinutes;
    return Semantics(
      liveRegion: true,
      child: Container(
        padding: const EdgeInsets.all(Espaciado.l),
        decoration: BoxDecoration(
          color: ColoresGenios.exito.withValues(alpha: 0.16),
          borderRadius: Radios.tarjeta,
          border: Border.all(color: ColoresGenios.exito, width: 2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Entrégale esto a ${codigo.nombreUsuario}:',
              style: Tipografia.titulo(20, peso: 800),
            ),
            const SizedBox(height: Espaciado.s),
            Row(
              children: [
                Expanded(
                  child: SelectableText(
                    codigo.codigo,
                    style: Tipografia.titulo(
                      36,
                      peso: 800,
                      color: ColoresGenios.amarilloEspacial,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'Copiar código de activación',
                  iconSize: 30,
                  constraints: const BoxConstraints(
                    minWidth: 56,
                    minHeight: 56,
                  ),
                  icon: const Icon(Icons.copy_rounded),
                  onPressed: () => copiarTexto(context, codigo.codigo),
                ),
              ],
            ),
            Text(
              'El estudiante entra en «Iniciar sesión → Tengo un código de mi docente». Es de un solo uso y vence en ${minutos < 1 ? 'unos minutos' : '$minutos minutos'}. No se vuelve a mostrar.',
              style: Tipografia.texto(15, color: ColoresGenios.textoSuave),
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------------------------------ Gráfica de barras

class BarraDato {
  const BarraDato(this.etiqueta, this.valor);

  final String etiqueta;
  final double valor;
}

/// Gráfica de barras simple y accesible. El título y la unidad dicen exactamente qué se cuenta.
class GraficaBarras extends StatelessWidget {
  const GraficaBarras({
    super.key,
    required this.datos,
    required this.unidad,
    this.referencia,
    this.etiquetaReferencia,
    this.color = ColoresGenios.turquesa,
  });

  final List<BarraDato> datos;

  /// Qué mide el eje Y, por ejemplo «partidas completadas».
  final String unidad;

  /// Línea de comparación opcional (por ejemplo, promedio del grupo).
  final double? referencia;
  final String? etiquetaReferencia;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final maximo = [
      ...datos.map((d) => d.valor),
      ?referencia,
      1.0,
    ].reduce((a, b) => a > b ? a : b);
    const alto = 160.0;
    final resumen = datos
        .map((d) => '${d.etiqueta}: ${d.valor.toStringAsFixed(0)}')
        .join(', ');

    return Semantics(
      label: 'Gráfica de $unidad. $resumen',
      excludeSemantics: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              height: alto + 40,
              child: Stack(
                children: [
                  if (referencia != null)
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 28 + alto * (referencia! / maximo),
                      child: Container(
                        height: 2,
                        color: ColoresGenios.amarilloEspacial,
                      ),
                    ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      for (final d in datos)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                d.valor.toStringAsFixed(0),
                                style: Tipografia.texto(12, peso: 800),
                              ),
                              const SizedBox(height: 2),
                              Container(
                                width: 28,
                                height: (alto * d.valor / maximo).clamp(
                                  2.0,
                                  alto,
                                ),
                                decoration: BoxDecoration(
                                  color: color,
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(6),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              SizedBox(
                                width: 44,
                                child: Text(
                                  d.etiqueta,
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Tipografia.texto(
                                    11,
                                    color: ColoresGenios.textoSuave,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: Espaciado.s),
          Text(
            'Eje vertical: $unidad${referencia != null ? ' · línea amarilla: ${etiquetaReferencia ?? 'referencia'}' : ''}',
            style: Tipografia.texto(13, color: ColoresGenios.textoSuave),
          ),
        ],
      ),
    );
  }
}
