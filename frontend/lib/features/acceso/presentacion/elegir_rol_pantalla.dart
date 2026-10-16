import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../diseno/componentes/astronauta_genios.dart';
import '../../../diseno/componentes/botones_juego.dart';
import '../../../diseno/componentes/plantilla_pantalla.dart';
import '../../../diseno/tokens/colores.dart';
import '../../../diseno/tokens/medidas.dart';
import '../../../diseno/tokens/tipografia.dart';
import 'acceso_cubit.dart';
import 'mensaje_error_acceso.dart';

/// Primera vez con Google: la persona elige si es estudiante o docente. La elección es permanente
/// y la valida el servidor; la app solo envía la opción elegida.
class ElegirRolPantalla extends StatelessWidget {
  const ElegirRolPantalla({super.key});

  @override
  Widget build(BuildContext context) {
    return PlantillaPantalla(
      titulo: 'Elige tu rol',
      hijo: BlocBuilder<AccesoCubit, EstadoAcceso>(
        builder: (context, estado) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AstronautaGenios(alto: 140),
            const SizedBox(height: Espaciado.l),
            Text(
              '¿Cómo vas a usar GENIOS?',
              textAlign: TextAlign.center,
              style: Tipografia.titulo(26),
            ),
            const SizedBox(height: Espaciado.m),
            Text(
              'Esta elección es permanente: una cuenta de estudiante no puede ser de docente, ni al revés.',
              textAlign: TextAlign.center,
              style: Tipografia.texto(18, color: ColoresGenios.textoSuave),
            ),
            const SizedBox(height: Espaciado.xl),
            if (estado.ocupado)
              const CircularProgressIndicator()
            else ...[
              BotonPrincipalJuego(
                texto: 'SOY ESTUDIANTE',
                icono: Icons.rocket_launch_rounded,
                alPulsar: () =>
                    context.read<AccesoCubit>().elegirRol('estudiante'),
              ),
              const SizedBox(height: Espaciado.m),
              BotonPrincipalJuego(
                texto: 'SOY DOCENTE',
                icono: Icons.school_rounded,
                alPulsar: () =>
                    context.read<AccesoCubit>().elegirRol('docente'),
              ),
              const SizedBox(height: Espaciado.m),
              BotonSecundarioJuego(
                texto: 'CANCELAR',
                icono: Icons.close_rounded,
                alPulsar: () => context.read<AccesoCubit>().salir(),
              ),
            ],
            MensajeErrorAcceso(mensaje: estado.mensajeError),
          ],
        ),
      ),
    );
  }
}
