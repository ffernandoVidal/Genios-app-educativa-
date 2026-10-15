import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/ajustes/ajustes_app.dart';
import '../../../core/sesion/sesion_app.dart';
import '../../../diseno/componentes/botones_juego.dart';
import '../../../diseno/componentes/plantilla_pantalla.dart';
import '../../../diseno/tokens/colores.dart';
import '../../../diseno/tokens/medidas.dart';
import '../../../diseno/tokens/tipografia.dart';
import '../../acceso/presentacion/acceso_cubit.dart';

/// Ajustes: animaciones, texto más grande, información de la app y salir.
/// El sonido aparece como "próximamente" porque todavía no hay audio en la app.
class AjustesPantalla extends StatelessWidget {
  const AjustesPantalla({super.key});

  @override
  Widget build(BuildContext context) {
    final ajustes = AjustesScope.of(context);
    final esInvitado =
        context.read<FuenteModoSesion>().modo == ModoSesion.invitado;
    return PlantillaPantalla(
      titulo: 'Ajustes',
      hijo: ListenableBuilder(
        listenable: ajustes,
        builder: (context, _) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Interruptor(
              icono: Icons.animation_rounded,
              titulo: 'Animaciones',
              detalle: 'El astronauta flota y saluda.',
              valor: ajustes.animaciones,
              alCambiar: (v) => ajustes.animaciones = v,
            ),
            _Interruptor(
              icono: Icons.text_increase_rounded,
              titulo: 'Texto más grande',
              detalle: 'Hace las letras más fáciles de leer.',
              valor: ajustes.textoGrande,
              alCambiar: (v) => ajustes.textoGrande = v,
            ),
            const _Interruptor(
              icono: Icons.volume_up_rounded,
              titulo: 'Sonido',
              detalle: 'Próximamente.',
              valor: false,
              alCambiar: null,
            ),
            const SizedBox(height: Espaciado.l),
            Container(
              padding: const EdgeInsets.all(Espaciado.l),
              decoration: BoxDecoration(
                color: ColoresGenios.superficie,
                borderRadius: Radios.chip,
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline_rounded,
                    size: 32,
                    color: ColoresGenios.turquesa,
                  ),
                  const SizedBox(width: Espaciado.l),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('GENIOS', style: Tipografia.titulo(22, peso: 800)),
                        Text(
                          'Aprender jugando. Versión de desarrollo.',
                          style: Tipografia.texto(
                            15,
                            color: ColoresGenios.textoSuave,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: Espaciado.xl),
            Center(
              child: BotonSecundarioJuego(
                texto: esInvitado ? 'SALIR DEL MODO INVITADO' : 'CERRAR SESIÓN',
                icono: Icons.logout_rounded,
                alPulsar: () => context.read<AccesoCubit>().salir(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Interruptor extends StatelessWidget {
  const _Interruptor({
    required this.icono,
    required this.titulo,
    required this.detalle,
    required this.valor,
    required this.alCambiar,
  });

  final IconData icono;
  final String titulo;
  final String detalle;
  final bool valor;
  final ValueChanged<bool>? alCambiar;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Espaciado.s),
      // Material (no un contenedor con color): el SwitchListTile pinta su fondo y su efecto de toque sobre él.
      child: Material(
        color: ColoresGenios.superficie,
        borderRadius: Radios.chip,
        clipBehavior: Clip.antiAlias,
        child: SwitchListTile(
          value: valor,
          onChanged: alCambiar,
          secondary: Icon(
            icono,
            size: 32,
            color: alCambiar == null
                ? ColoresGenios.textoSuave
                : ColoresGenios.turquesa,
          ),
          title: Text(titulo, style: Tipografia.titulo(22, peso: 700)),
          subtitle: Text(
            detalle,
            style: Tipografia.texto(15, color: ColoresGenios.textoSuave),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: Espaciado.l,
            vertical: Espaciado.xs,
          ),
        ),
      ),
    );
  }
}
