import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../diseno/componentes/astronauta_genios.dart';
import '../../../diseno/componentes/plantilla_pantalla.dart';
import '../../../diseno/tokens/colores.dart';
import '../../../diseno/tokens/medidas.dart';
import '../../../diseno/tokens/tipografia.dart';
import 'acceso_cubit.dart';
import 'boton_google/boton_google.dart';
import 'mensaje_error_acceso.dart';

/// Punto de entrada separado para docentes: acceso con Google. Al entrar, el enrutador los lleva al Centro de Control.
class DocentePantalla extends StatelessWidget {
  const DocentePantalla({super.key, required this.googleClientId});

  /// Client ID público de Google. Vacío = acceso no disponible (falta configurarlo al compilar).
  final String googleClientId;

  @override
  Widget build(BuildContext context) {
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
              'Entra con tu cuenta de Google',
              textAlign: TextAlign.center,
              style: Tipografia.titulo(26),
            ),
            const SizedBox(height: Espaciado.m),
            Text(
              'Podrás crear clases y consultar el progreso de tus estudiantes.',
              textAlign: TextAlign.center,
              style: Tipografia.texto(18, color: ColoresGenios.textoSuave),
            ),
            const SizedBox(height: Espaciado.xl),
            if (googleClientId.isEmpty)
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
                alCredencial: (idToken) => context
                    .read<AccesoCubit>()
                    .ingresarConGoogle(idToken, rolDeseado: 'docente'),
              ),
            MensajeErrorAcceso(mensaje: estado.mensajeError),
          ],
        ),
      ),
    );
  }
}
