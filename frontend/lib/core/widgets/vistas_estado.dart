import 'package:flutter/material.dart';

import '../../app/tema/tema_genios.dart';

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
            const CircularProgressIndicator(color: ColoresGenios.acento),
            const SizedBox(height: 16),
            Text(mensaje, style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}

/// Error con opción de reintentar (fallos de red o del servidor).
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
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              sinConexion
                  ? Icons.wifi_off_rounded
                  : Icons.error_outline_rounded,
              size: 64,
              color: ColoresGenios.aviso,
            ),
            const SizedBox(height: 16),
            Text(
              mensaje,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: alReintentar,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Reintentar'),
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
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icono, size: 64, color: ColoresGenios.textoSuave),
            const SizedBox(height: 16),
            Text(
              mensaje,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
