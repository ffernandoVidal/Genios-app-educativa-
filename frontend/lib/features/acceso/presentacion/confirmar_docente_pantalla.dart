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

/// Primera vez con Google: el rol docente se asigna solo si la persona lo confirma. Es permanente.
class ConfirmarDocentePantalla extends StatelessWidget {
  const ConfirmarDocentePantalla({super.key});

  @override
  Widget build(BuildContext context) {
    return PlantillaPantalla(
      titulo: 'Confirma tu cuenta docente',
      hijo: BlocBuilder<AccesoCubit, EstadoAcceso>(
        builder: (context, estado) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AstronautaGenios(alto: 140),
            const SizedBox(height: Espaciado.l),
            Text(
              '¿Eres docente?',
              textAlign: TextAlign.center,
              style: Tipografia.titulo(26),
            ),
            const SizedBox(height: Espaciado.m),
            Text(
              'Al confirmar, esta cuenta de Google será una cuenta de docente para siempre: podrás crear clases y ver el progreso de tus estudiantes. Una cuenta docente no puede jugar como estudiante.',
              textAlign: TextAlign.center,
              style: Tipografia.texto(18, color: ColoresGenios.textoSuave),
            ),
            const SizedBox(height: Espaciado.xl),
            if (estado.ocupado)
              const CircularProgressIndicator()
            else ...[
              BotonPrincipalJuego(
                texto: 'SÍ, SOY DOCENTE',
                icono: Icons.check_circle_rounded,
                alPulsar: () => context.read<AccesoCubit>().confirmarDocente(),
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
