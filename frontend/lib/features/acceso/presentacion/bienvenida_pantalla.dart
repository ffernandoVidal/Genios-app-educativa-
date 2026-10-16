import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/sesion/sesion_app.dart';
import '../../../diseno/componentes/astronauta_genios.dart';
import '../../../diseno/componentes/botones_juego.dart';
import '../../../diseno/componentes/fondo_espacial.dart';
import '../../../diseno/tokens/colores.dart';
import '../../../diseno/tokens/medidas.dart';
import '../../../diseno/tokens/tipografia.dart';

/// Pantalla 1: el logo, el astronauta sobre la Luna y solo dos decisiones (Ley de Hick):
/// JUGAR (principal) e INICIAR SESIÓN.
class BienvenidaPantalla extends StatelessWidget {
  const BienvenidaPantalla({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FondoEspacial(
        variante: VarianteFondo.paisaje,
        hijo: SafeArea(
          child: LayoutBuilder(
            builder: (context, restricciones) {
              final compacto = restricciones.maxHeight < 640;
              final alturaAstronauta =
                  (restricciones.maxHeight * (compacto ? 0.28 : 0.34)).clamp(
                    130.0,
                    320.0,
                  );
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: restricciones.maxHeight,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Espaciado.pantalla,
                      vertical: Espaciado.l,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const _Logotipo(),
                        const SizedBox(height: Espaciado.s),
                        if (context.read<FuenteModoSesion>().avisoCierre
                            case final aviso?) ...[
                          Semantics(
                            liveRegion: true,
                            child: Text(
                              aviso,
                              textAlign: TextAlign.center,
                              style: Tipografia.texto(
                                17,
                                peso: 800,
                                color: ColoresGenios.aviso,
                              ),
                            ),
                          ),
                          const SizedBox(height: Espaciado.s),
                        ],
                        Text(
                          '¡Hola, explorador! Aprende jugando por el espacio.',
                          textAlign: TextAlign.center,
                          style: Tipografia.texto(
                            20,
                            peso: 800,
                            color: ColoresGenios.blancoLunar,
                          ),
                        ),
                        SizedBox(height: compacto ? Espaciado.s : Espaciado.l),
                        AstronautaGenios(
                          pose: PoseAstronauta.saludo,
                          alto: alturaAstronauta,
                        ),
                        SizedBox(height: compacto ? Espaciado.s : Espaciado.l),
                        BotonPrincipalJuego(
                          texto: 'JUGAR',
                          icono: Icons.rocket_launch_rounded,
                          alPulsar: () => context.push('/jugar'),
                        ),
                        const SizedBox(height: Espaciado.l),
                        BotonSecundarioJuego(
                          texto: 'INICIAR SESIÓN',
                          icono: Icons.login_rounded,
                          alPulsar: () => context.push('/acceso'),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _Logotipo extends StatelessWidget {
  const _Logotipo();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      header: true,
      label: 'GENIOS',
      excludeSemantics: true,
      child: Text(
        'GENIOS',
        style:
            Tipografia.titulo(
              64,
              peso: 800,
              color: ColoresGenios.amarilloEspacial,
            ).copyWith(
              letterSpacing: 4,
              shadows: const [
                Shadow(color: Color(0xFFB37F00), offset: Offset(0, 5)),
                Shadow(
                  color: Colors.black54,
                  blurRadius: 16,
                  offset: Offset(0, 8),
                ),
              ],
            ),
      ),
    );
  }
}
