import 'package:flutter/material.dart';

import '../tokens/colores.dart';
import '../tokens/medidas.dart';
import '../tokens/tipografia.dart';

/// Parte superior de las pantallas del estudiante: menú, nombre y, cuando se conocen, puntos y tiempo disponible.
/// Solo recibe datos ya calculados por el servidor; no calcula nada.
class CabeceraEstudiante extends StatelessWidget {
  const CabeceraEstudiante({
    super.key,
    required this.nombre,
    this.puntos,
    this.minutosRestantes,
    this.limiteAlcanzado = false,
    this.etiquetaInvitado,
    this.alAbrirMenu,
    this.alAbrirProgreso,
  });

  final String nombre;
  final int? puntos;
  final int? minutosRestantes;
  final bool limiteAlcanzado;

  /// Si no es null, se muestra en lugar de los puntos (por ejemplo "Invitado 1/3").
  final String? etiquetaInvitado;
  final VoidCallback? alAbrirMenu;
  final VoidCallback? alAbrirProgreso;

  @override
  Widget build(BuildContext context) {
    final insignias = <Widget>[
      if (etiquetaInvitado != null)
        _Insignia(
          icono: Icons.person_outline_rounded,
          texto: etiquetaInvitado!,
          color: ColoresGenios.turquesa,
        ),
      if (puntos != null)
        _Insignia(
          icono: Icons.star_rounded,
          texto: '$puntos',
          color: ColoresGenios.amarilloEspacial,
          descripcion: '$puntos puntos',
        ),
      if (minutosRestantes != null || limiteAlcanzado)
        _Insignia(
          icono: limiteAlcanzado ? Icons.bedtime_rounded : Icons.timer_outlined,
          texto: limiteAlcanzado ? 'Hasta mañana' : '$minutosRestantes min',
          color: limiteAlcanzado
              ? ColoresGenios.aviso
              : ColoresGenios.textoSuave,
          descripcion: limiteAlcanzado
              ? 'Tiempo de hoy completo'
              : '$minutosRestantes minutos disponibles hoy',
        ),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        Espaciado.s,
        Espaciado.s,
        Espaciado.l,
        0,
      ),
      child: Row(
        children: [
          if (alAbrirMenu != null)
            IconButton(
              tooltip: 'Abrir menú',
              iconSize: 32,
              constraints: const BoxConstraints(minWidth: 56, minHeight: 56),
              icon: const Icon(
                Icons.menu_rounded,
                color: ColoresGenios.blancoLunar,
              ),
              onPressed: alAbrirMenu,
            )
          else
            const SizedBox(width: Espaciado.l),
          Expanded(
            flex: 2,
            child: Text(
              nombre,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Tipografia.titulo(24, peso: 800),
            ),
          ),
          if (insignias.isNotEmpty)
            Expanded(
              flex: 3,
              child: Semantics(
                button: alAbrirProgreso != null,
                child: InkWell(
                  borderRadius: Radios.chip,
                  onTap: alAbrirProgreso,
                  child: Padding(
                    padding: const EdgeInsets.all(Espaciado.xs),
                    child: Wrap(
                      spacing: Espaciado.s,
                      runSpacing: Espaciado.xs,
                      alignment: WrapAlignment.end,
                      children: insignias,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Insignia extends StatelessWidget {
  const _Insignia({
    required this.icono,
    required this.texto,
    required this.color,
    this.descripcion,
  });

  final IconData icono;
  final String texto;
  final Color color;
  final String? descripcion;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: descripcion ?? texto,
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: ColoresGenios.superficieOscura.withValues(alpha: 0.85),
          borderRadius: Radios.chip,
          border: Border.all(color: color, width: 1.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icono, size: 20, color: color),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                texto,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Tipografia.titulo(18, peso: 800),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
