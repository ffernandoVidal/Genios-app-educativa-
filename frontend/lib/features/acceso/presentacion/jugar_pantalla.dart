import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../diseno/componentes/astronauta_genios.dart';
import '../../../diseno/componentes/botones_juego.dart';
import '../../../diseno/componentes/campo_genios.dart';
import '../../../diseno/componentes/plantilla_pantalla.dart';
import '../../../diseno/tokens/colores.dart';
import '../../../diseno/tokens/medidas.dart';
import '../../../diseno/tokens/tipografia.dart';
import '../dominio/validacion_apodo.dart';
import 'acceso_cubit.dart';
import 'mensaje_error_acceso.dart';

/// JUGAR sin cuenta: solo se pide un nombre o apodo. No hay correo, contraseña ni código de aula.
class JugarPantalla extends StatefulWidget {
  const JugarPantalla({super.key});

  @override
  State<JugarPantalla> createState() => _JugarPantallaState();
}

class _JugarPantallaState extends State<JugarPantalla> {
  final _apodo = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<AccesoCubit>().limpiarError();
    });
  }

  @override
  void dispose() {
    _apodo.dispose();
    super.dispose();
  }

  void _enviar() => context.read<AccesoCubit>().entrarComoInvitado(_apodo.text);

  @override
  Widget build(BuildContext context) {
    return PlantillaPantalla(
      titulo: '¿Cómo te llamas?',
      hijo: BlocBuilder<AccesoCubit, EstadoAcceso>(
        builder: (context, estado) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Center(
              child: AstronautaGenios(pose: PoseAstronauta.saludo, alto: 170),
            ),
            const SizedBox(height: Espaciado.l),
            Text(
              'Escribe tu nombre o un apodo para despegar.',
              textAlign: TextAlign.center,
              style: Tipografia.texto(20, peso: 800),
            ),
            const SizedBox(height: Espaciado.l),
            CampoGenios(
              controlador: _apodo,
              etiqueta: 'Tu nombre o apodo',
              icono: Icons.face_rounded,
              habilitado: !estado.ocupado,
              longitudMaxima: ValidacionApodo.largoMaximo,
              alEnviar: _enviar,
            ),
            const SizedBox(height: Espaciado.xl),
            Center(
              child: BotonPrincipalJuego(
                texto: '¡DESPEGAR!',
                icono: Icons.rocket_launch_rounded,
                ocupado: estado.ocupado,
                alPulsar: _enviar,
              ),
            ),
            MensajeErrorAcceso(mensaje: estado.mensajeError),
            const SizedBox(height: Espaciado.l),
            Text(
              'No necesitas correo ni contraseña. Tu progreso de invitado no se guarda en una cuenta.',
              textAlign: TextAlign.center,
              style: Tipografia.texto(14, color: ColoresGenios.textoSuave),
            ),
          ],
        ),
      ),
    );
  }
}
