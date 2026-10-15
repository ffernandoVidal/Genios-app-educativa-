import 'package:flutter/material.dart';

import '../tokens/colores.dart';
import '../tokens/medidas.dart';
import '../tokens/tipografia.dart';
import 'astronauta_genios.dart';
import 'botones_juego.dart';

/// Estado de carga: se anuncia a los lectores de pantalla.
class VistaCarga extends StatelessWidget {
  const VistaCarga({super.key, this.mensaje = 'Cargando…'});

  final String mensaje;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Semantics(
        liveRegion: true,
        label: mensaje,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(
              color: ColoresGenios.amarilloEspacial,
              strokeWidth: 5,
            ),
            const SizedBox(height: Espaciado.l),
            Text(
              mensaje,
              textAlign: TextAlign.center,
              style: Tipografia.titulo(22),
            ),
          ],
        ),
      ),
    );
  }
}

/// Error con astronauta sorprendido y opción de reintentar (fallos de red o del servidor).
class VistaError extends StatelessWidget {
  const VistaError({
    super.key,
    required this.mensaje,
    required this.alReintentar,
    this.sinConexion = false,
  });

  final String mensaje;
  final VoidCallback alReintentar;
  final bool sinConexion;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(Espaciado.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AstronautaGenios(pose: PoseAstronauta.sorpresa, alto: 150),
            const SizedBox(height: Espaciado.l),
            Icon(
              sinConexion
                  ? Icons.wifi_off_rounded
                  : Icons.error_outline_rounded,
              size: 40,
              color: ColoresGenios.aviso,
            ),
            const SizedBox(height: Espaciado.s),
            Semantics(
              liveRegion: true,
              child: Text(
                mensaje,
                textAlign: TextAlign.center,
                style: Tipografia.texto(20, peso: 800),
              ),
            ),
            const SizedBox(height: Espaciado.xl),
            BotonPrincipalJuego(
              texto: 'Reintentar',
              icono: Icons.refresh_rounded,
              alPulsar: alReintentar,
            ),
          ],
        ),
      ),
    );
  }
}

/// Respuesta correcta pero sin datos todavía.
class VistaVacia extends StatelessWidget {
  const VistaVacia({
    super.key,
    required this.mensaje,
    this.icono = Icons.rocket_launch_rounded,
  });

  final String mensaje;
  final IconData icono;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Espaciado.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icono, size: 64, color: ColoresGenios.textoSuave),
            const SizedBox(height: Espaciado.l),
            Text(
              mensaje,
              textAlign: TextAlign.center,
              style: Tipografia.texto(20, peso: 800),
            ),
          ],
        ),
      ),
    );
  }
}
