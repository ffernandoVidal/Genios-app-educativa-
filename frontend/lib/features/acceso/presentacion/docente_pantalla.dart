import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/sesion/sesion_app.dart';
import '../../../diseno/componentes/astronauta_genios.dart';
import '../../../diseno/componentes/botones_juego.dart';
import '../../../diseno/componentes/plantilla_pantalla.dart';
import '../../../diseno/tokens/colores.dart';
import '../../../diseno/tokens/medidas.dart';
import '../../../diseno/tokens/tipografia.dart';
import 'acceso_cubit.dart';
import 'boton_google/boton_google.dart';
import 'mensaje_error_acceso.dart';

/// Punto de entrada separado para docentes: acceso con Google. El panel docente todavía no existe;
/// al entrar, la pantalla lo dice con claridad en lugar de simular datos.
class DocentePantalla extends StatelessWidget {
  const DocentePantalla({super.key, required this.googleClientId});

  /// Client ID público de Google. Vacío = acceso no disponible (falta configurarlo al compilar).
  final String googleClientId;

  @override
  Widget build(BuildContext context) {
    final sesion = context.read<FuenteModoSesion>();
    final dentro = sesion.modo == ModoSesion.docente;
    return PlantillaPantalla(
      titulo: 'Acceso docente',
      hijo: BlocBuilder<AccesoCubit, EstadoAcceso>(
        builder: (context, estado) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const AstronautaGenios(alto: 150),
            const SizedBox(height: Espaciado.l),
            Text(
              dentro
                  ? 'Hola, ${sesion.nombre}'
                  : 'Entra con tu cuenta de Google',
              textAlign: TextAlign.center,
              style: Tipografia.titulo(26),
            ),
            const SizedBox(height: Espaciado.m),
            Text(
              dentro
                  ? 'Tu cuenta docente está lista. El panel para crear aulas y consultar el progreso llegará pronto.'
                  : 'Podrás crear aulas y consultar el progreso de tus estudiantes.',
              textAlign: TextAlign.center,
              style: Tipografia.texto(18, color: ColoresGenios.textoSuave),
            ),
            const SizedBox(height: Espaciado.xl),
            if (dentro)
              BotonSecundarioJuego(
                texto: 'CERRAR SESIÓN',
                icono: Icons.logout_rounded,
                alPulsar: () async {
                  await context.read<AccesoCubit>().salir();
                  if (context.mounted) context.go('/');
                },
              )
            else if (googleClientId.isEmpty)
              Text(
                'El acceso con Google no está configurado todavía.',
                textAlign: TextAlign.center,
                style: Tipografia.texto(
                  18,
                  peso: 800,
                  color: ColoresGenios.aviso,
                ),
              )
            else if (estado.ocupado)
              const CircularProgressIndicator()
            else
              BotonGoogle(
                clientId: googleClientId,
                alCredencial: (idToken) =>
                    context.read<AccesoCubit>().ingresarConGoogle(idToken),
              ),
            MensajeErrorAcceso(mensaje: estado.mensajeError),
          ],
        ),
      ),
    );
  }
}
