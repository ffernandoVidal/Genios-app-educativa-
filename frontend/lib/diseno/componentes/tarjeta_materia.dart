import 'package:flutter/material.dart';

import '../tokens/colores.dart';
import '../tokens/medidas.dart';
import '../tokens/tipografia.dart';
import 'icono_materia.dart';

/// Tarjeta de una materia: color e icono propios, nombre grande y, si se conoce, el progreso.
/// Se hunde ligeramente al tocarla para dar respuesta inmediata.
class TarjetaMateria extends StatefulWidget {
  const TarjetaMateria({
    super.key,
    required this.codigo,
    required this.nombre,
    required this.alPulsar,
    this.progreso,
    this.textoProgreso,
  });

  final String codigo;
  final String nombre;
  final VoidCallback alPulsar;

  /// Entre 0 y 1; null si no se conoce (por ejemplo, un invitado).
  final double? progreso;
  final String? textoProgreso;

  @override
  State<TarjetaMateria> createState() => _TarjetaMateriaState();
}

class _TarjetaMateriaState extends State<TarjetaMateria> {
  bool _presionada = false;

  @override
  Widget build(BuildContext context) {
    final estilo = EstiloMateria.de(widget.codigo);
    final detalle = widget.textoProgreso == null
        ? ''
        : ' ${widget.textoProgreso}.';
    return Semantics(
      button: true,
      label: '${widget.nombre}.$detalle Toca para ver sus misiones.',
      excludeSemantics: true,
      child: AnimatedScale(
        scale: _presionada ? 0.95 : 1,
        duration: const Duration(milliseconds: 100),
        child: Material(
          color: Colors.transparent,
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: Radios.tarjeta,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.lerp(estilo.color, Colors.white, 0.18)!,
                  estilo.color,
                  Color.lerp(estilo.color, Colors.black, 0.25)!,
                ],
              ),
              border: Border.all(
                color: ColoresGenios.blancoLunar.withValues(alpha: 0.35),
                width: 2,
              ),
              boxShadow: Sombras.elevada(estilo.color),
            ),
            child: InkWell(
              borderRadius: Radios.tarjeta,
              onTap: widget.alPulsar,
              onHighlightChanged: (valor) =>
                  setState(() => _presionada = valor),
              child: Padding(
                padding: const EdgeInsets.all(Espaciado.l),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 84,
                      height: 84,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black.withValues(alpha: 0.18),
                      ),
                      child: Center(
                        child: IconoMateria(tipo: estilo.tipo, tamano: 52),
                      ),
                    ),
                    const SizedBox(height: Espaciado.m),
                    Flexible(
                      child: Text(
                        widget.nombre,
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: Tipografia.titulo(24, peso: 800),
                      ),
                    ),
                    if (widget.progreso != null) ...[
                      const SizedBox(height: Espaciado.m),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: widget.progreso,
                          minHeight: 10,
                          color: ColoresGenios.amarilloEspacial,
                          backgroundColor: Colors.black.withValues(alpha: 0.25),
                        ),
                      ),
                      if (widget.textoProgreso != null)
                        Padding(
                          padding: const EdgeInsets.only(top: Espaciado.xs),
                          child: Text(
                            widget.textoProgreso!,
                            style: Tipografia.texto(14, peso: 800),
                          ),
                        ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
