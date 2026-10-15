import 'package:flutter/material.dart';

import '../tokens/colores.dart';
import '../tokens/medidas.dart';
import '../tokens/tipografia.dart';

/// Botón principal de la experiencia: grande, amarillo, con borde inferior que le da volumen.
/// Responde al toque al instante (se hunde y se aclara) y muestra un círculo de carga mientras [ocupado].
class BotonPrincipalJuego extends StatefulWidget {
  const BotonPrincipalJuego({
    super.key,
    required this.texto,
    required this.alPulsar,
    this.icono,
    this.ocupado = false,
    this.etiquetaSemantica,
  });

  final String texto;
  final VoidCallback? alPulsar;
  final IconData? icono;
  final bool ocupado;
  final String? etiquetaSemantica;

  @override
  State<BotonPrincipalJuego> createState() => _BotonPrincipalJuegoState();
}

class _BotonPrincipalJuegoState extends State<BotonPrincipalJuego> {
  bool _presionado = false;

  bool get _activo => widget.alPulsar != null && !widget.ocupado;

  @override
  Widget build(BuildContext context) {
    final color = _activo
        ? ColoresGenios.amarilloEspacial
        : ColoresGenios.amarilloEspacial.withValues(alpha: 0.45);
    return Semantics(
      button: true,
      enabled: _activo,
      label: widget.etiquetaSemantica ?? widget.texto,
      excludeSemantics: true,
      child: AnimatedScale(
        scale: _presionado ? 0.95 : 1,
        duration: const Duration(milliseconds: 90),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: Radios.boton,
            boxShadow: _activo
                ? Sombras.resplandor(ColoresGenios.amarilloEspacial)
                : null,
          ),
          child: Material(
            color: color,
            shape: RoundedRectangleBorder(
              borderRadius: Radios.boton,
              side: const BorderSide(color: Color(0xFFD9A800), width: 3),
            ),
            child: InkWell(
              customBorder: RoundedRectangleBorder(borderRadius: Radios.boton),
              onTap: _activo ? widget.alPulsar : null,
              onHighlightChanged: (valor) =>
                  setState(() => _presionado = valor),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 72, minWidth: 220),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.ocupado)
                        const SizedBox(
                          width: 26,
                          height: 26,
                          child: CircularProgressIndicator(
                            strokeWidth: 3.5,
                            color: ColoresGenios.textoSobreClaro,
                          ),
                        )
                      else if (widget.icono != null)
                        Icon(
                          widget.icono,
                          size: 30,
                          color: ColoresGenios.textoSobreClaro,
                        ),
                      if (widget.ocupado || widget.icono != null)
                        const SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          widget.texto,
                          textAlign: TextAlign.center,
                          style: Tipografia.titulo(
                            28,
                            peso: 800,
                            color: ColoresGenios.textoSobreClaro,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Botón secundario: borde turquesa sobre el fondo. Menos protagonismo que el principal.
class BotonSecundarioJuego extends StatelessWidget {
  const BotonSecundarioJuego({
    super.key,
    required this.texto,
    required this.alPulsar,
    this.icono,
  });

  final String texto;
  final VoidCallback? alPulsar;
  final IconData? icono;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: alPulsar != null,
      label: texto,
      excludeSemantics: true,
      child: OutlinedButton(
        onPressed: alPulsar,
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(220, 64),
          backgroundColor: ColoresGenios.espacioProfundo.withValues(
            alpha: 0.55,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icono != null) ...[
              Icon(icono, size: 26),
              const SizedBox(width: 10),
            ],
            Flexible(
              child: Text(
                texto,
                textAlign: TextAlign.center,
                style: Tipografia.titulo(22, peso: 800),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
