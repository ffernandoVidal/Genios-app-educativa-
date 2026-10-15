import 'package:flutter/material.dart';

import '../tokens/colores.dart';
import '../tokens/medidas.dart';
import '../tokens/tipografia.dart';

/// Estado visual de una misión. Lo decide el servidor; el diseño solo lo dibuja.
enum EstadoNodo { bloqueada, disponible, enProgreso, completada }

/// Un nodo del camino de misiones. El estado se comunica con icono y texto, no solo con color.
class TarjetaMision extends StatefulWidget {
  const TarjetaMision({
    super.key,
    required this.numero,
    required this.nombre,
    required this.estado,
    required this.color,
    required this.alPulsar,
    this.requisito,
    this.diametro = 88,
  });

  final int numero;
  final String nombre;
  final EstadoNodo estado;
  final Color color;
  final VoidCallback alPulsar;

  /// Nombre de la misión que hay que completar antes (solo cuando está bloqueada).
  final String? requisito;
  final double diametro;

  @override
  State<TarjetaMision> createState() => _TarjetaMisionState();
}

class _TarjetaMisionState extends State<TarjetaMision> {
  bool _presionada = false;

  @override
  Widget build(BuildContext context) {
    final (icono, colorNodo, etiqueta) = switch (widget.estado) {
      EstadoNodo.bloqueada => (
        Icons.lock_rounded,
        ColoresGenios.bloqueado,
        'Bloqueada',
      ),
      EstadoNodo.disponible => (
        Icons.rocket_launch_rounded,
        widget.color,
        'Disponible',
      ),
      EstadoNodo.enProgreso => (
        Icons.play_arrow_rounded,
        ColoresGenios.aviso,
        'En progreso',
      ),
      EstadoNodo.completada => (
        Icons.star_rounded,
        ColoresGenios.exito,
        'Completada',
      ),
    };
    final bloqueada = widget.estado == EstadoNodo.bloqueada;
    final detalle = bloqueada
        ? (widget.requisito == null
              ? 'Aún no disponible'
              : 'Completa «${widget.requisito}»')
        : switch (widget.estado) {
            EstadoNodo.disponible => '¡Lista para empezar!',
            EstadoNodo.enProgreso => 'Sigue donde ibas',
            _ => '¡Misión cumplida!',
          };

    return Semantics(
      button: true,
      label: 'Misión ${widget.numero}: ${widget.nombre}. $etiqueta. $detalle',
      excludeSemantics: true,
      child: AnimatedScale(
        scale: _presionada ? 0.94 : 1,
        duration: const Duration(milliseconds: 100),
        child: InkWell(
          borderRadius: Radios.tarjeta,
          onTap: widget.alPulsar,
          onHighlightChanged: (valor) => setState(() => _presionada = valor),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: widget.diametro,
                height: widget.diametro,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    center: const Alignment(-0.4, -0.4),
                    colors: [
                      Color.lerp(colorNodo, Colors.white, 0.3)!,
                      colorNodo,
                      Color.lerp(colorNodo, Colors.black, 0.4)!,
                    ],
                  ),
                  border: Border.all(
                    color: ColoresGenios.blancoLunar.withValues(
                      alpha: bloqueada ? 0.25 : 0.9,
                    ),
                    width: 4,
                  ),
                  boxShadow: bloqueada ? null : Sombras.resplandor(colorNodo),
                ),
                child: Icon(
                  icono,
                  size: widget.diametro * 0.5,
                  color: ColoresGenios.blancoLunar,
                ),
              ),
              const SizedBox(height: Espaciado.s),
              Text(
                '${widget.numero}. ${widget.nombre}',
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Tipografia.titulo(18, peso: 800),
              ),
              Text(
                etiqueta,
                style: Tipografia.texto(
                  14,
                  peso: 900,
                  color: bloqueada ? ColoresGenios.textoSuave : colorNodo,
                ),
              ),
              if (bloqueada)
                Text(
                  detalle,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Tipografia.texto(13, color: ColoresGenios.textoSuave),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
