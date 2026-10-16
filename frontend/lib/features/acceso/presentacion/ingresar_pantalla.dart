import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../diseno/componentes/astronauta_genios.dart';
import '../../../diseno/componentes/botones_juego.dart';
import '../../../diseno/componentes/campo_genios.dart';
import '../../../diseno/componentes/plantilla_pantalla.dart';
import '../../../diseno/tokens/medidas.dart';
import '../../../diseno/tokens/tipografia.dart';
import 'acceso_cubit.dart';
import 'mensaje_error_acceso.dart';

/// Iniciar sesión de estudiante con usuario y contraseña. El botón «INICIAR SESIÓN GENIO»
/// lleva al acceso docente con Google, que es un flujo separado.
class IngresarPantalla extends StatefulWidget {
  const IngresarPantalla({super.key});

  @override
  State<IngresarPantalla> createState() => _IngresarPantallaState();
}

class _IngresarPantallaState extends State<IngresarPantalla> {
  final _usuario = TextEditingController();
  final _contrasena = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<AccesoCubit>().limpiarError();
    });
  }

  @override
  void dispose() {
    _usuario.dispose();
    _contrasena.dispose();
    super.dispose();
  }

  void _enviar() => context.read<AccesoCubit>().iniciarSesion(
    _usuario.text,
    _contrasena.text,
  );

  @override
  Widget build(BuildContext context) {
    return PlantillaPantalla(
      titulo: 'Iniciar sesión',
      hijo: BlocBuilder<AccesoCubit, EstadoAcceso>(
        builder: (context, estado) => AutofillGroup(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Center(
                child: AstronautaGenios(pose: PoseAstronauta.saludo, alto: 140),
              ),
              const SizedBox(height: Espaciado.m),
              Text(
                '¡Qué bueno verte de nuevo!',
                textAlign: TextAlign.center,
                style: Tipografia.titulo(26),
              ),
              const SizedBox(height: Espaciado.l),
              CampoGenios(
                controlador: _usuario,
                etiqueta: 'Tu usuario',
                icono: Icons.person_rounded,
                habilitado: !estado.ocupado,
                autocompletar: const [AutofillHints.username],
              ),
              const SizedBox(height: Espaciado.l),
              CampoGenios(
                controlador: _contrasena,
                etiqueta: 'Tu contraseña',
                icono: Icons.lock_rounded,
                habilitado: !estado.ocupado,
                oculto: true,
                autocompletar: const [AutofillHints.password],
                alEnviar: _enviar,
              ),
              const SizedBox(height: Espaciado.xl),
              Center(
                child: BotonPrincipalJuego(
                  texto: 'ENTRAR',
                  icono: Icons.login_rounded,
                  ocupado: estado.ocupado,
                  alPulsar: _enviar,
                ),
              ),
              MensajeErrorAcceso(mensaje: estado.mensajeError),
              const SizedBox(height: Espaciado.l),
              Center(
                child: BotonPrincipalJuego(
                  texto: 'INICIAR SESIÓN GENIO',
                  icono: Icons.school_rounded,
                  alPulsar: estado.ocupado
                      ? null
                      : () => context.push('/docente'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
