import 'package:flutter/material.dart';

import '../tokens/colores.dart';
import '../tokens/medidas.dart';
import '../tokens/tipografia.dart';
import 'astronauta_genios.dart';

enum OpcionMenu { perfil, salon, ajustes }

/// Menú lateral del estudiante: solo tres secciones. No navega por sí mismo; avisa cuál se eligió.
class MenuLateralEstudiante extends StatelessWidget {
  const MenuLateralEstudiante({
    super.key,
    required this.nombre,
    required this.esInvitado,
    required this.alElegir,
  });

  final String nombre;
  final bool esInvitado;
  final void Function(OpcionMenu) alElegir;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(Espaciado.xl),
              child: Row(
                children: [
                  const AstronautaGenios(alto: 96),
                  const SizedBox(width: Espaciado.l),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          nombre,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Tipografia.titulo(24, peso: 800),
                        ),
                        Text(
                          esInvitado ? 'Jugando como invitado' : 'Explorador',
                          style: Tipografia.texto(
                            14,
                            color: ColoresGenios.textoSuave,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: ColoresGenios.superficie, height: 1),
            const SizedBox(height: Espaciado.s),
            _Opcion(
              icono: Icons.person_rounded,
              texto: 'Perfil',
              alPulsar: () => alElegir(OpcionMenu.perfil),
            ),
            _Opcion(
              icono: Icons.meeting_room_rounded,
              texto: 'Salón',
              alPulsar: () => alElegir(OpcionMenu.salon),
            ),
            _Opcion(
              icono: Icons.settings_rounded,
              texto: 'Ajustes',
              alPulsar: () => alElegir(OpcionMenu.ajustes),
            ),
          ],
        ),
      ),
    );
  }
}

class _Opcion extends StatelessWidget {
  const _Opcion({
    required this.icono,
    required this.texto,
    required this.alPulsar,
  });

  final IconData icono;
  final String texto;
  final VoidCallback alPulsar;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: texto,
      excludeSemantics: true,
      child: ListTile(
        minTileHeight: 64,
        contentPadding: const EdgeInsets.symmetric(horizontal: Espaciado.xl),
        leading: Icon(icono, size: 32, color: ColoresGenios.turquesa),
        title: Text(texto, style: Tipografia.titulo(24, peso: 700)),
        trailing: const Icon(
          Icons.chevron_right_rounded,
          color: ColoresGenios.textoSuave,
        ),
        onTap: alPulsar,
      ),
    );
  }
}
