import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../diseno/componentes/botones_juego.dart';
import '../../../diseno/componentes/campo_genios.dart';
import '../../../diseno/componentes/plantilla_pantalla.dart';
import '../../../diseno/tokens/colores.dart';
import '../../../diseno/tokens/medidas.dart';
import '../../../diseno/tokens/tipografia.dart';
import 'acceso_cubit.dart';
import 'mensaje_error_acceso.dart';

/// El docente creó la cuenta del estudiante y le dio un código: aquí el estudiante elige su propia contraseña.
class ActivarPantalla extends StatefulWidget {
  const ActivarPantalla({super.key});

  @override
  State<ActivarPantalla> createState() => _ActivarPantallaState();
}

class _ActivarPantallaState extends State<ActivarPantalla> {
  final _usuario = TextEditingController();
  final _codigo = TextEditingController();
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
    _codigo.dispose();
    _contrasena.dispose();
    super.dispose();
  }

  Future<void> _enviar() async {
    final cubit = context.read<AccesoCubit>();
    final listo = await cubit.activarCuenta(
      nombreUsuario: _usuario.text,
      codigo: _codigo.text,
      contrasenaNueva: _contrasena.text,
    );
    if (listo && mounted) context.go('/ingresar');
  }

  @override
  Widget build(BuildContext context) {
    return PlantillaPantalla(
      titulo: 'Tengo un código',
      hijo: BlocBuilder<AccesoCubit, EstadoAcceso>(
        builder: (context, estado) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Tu docente te dio un usuario y un código. Elige tu contraseña para empezar.',
              textAlign: TextAlign.center,
              style: Tipografia.texto(20, peso: 800),
            ),
            const SizedBox(height: Espaciado.s),
            Text(
              'Después podrás entrar con tu usuario y tu contraseña.',
              textAlign: TextAlign.center,
              style: Tipografia.texto(15, color: ColoresGenios.textoSuave),
            ),
            const SizedBox(height: Espaciado.xl),
            CampoGenios(
              controlador: _usuario,
              etiqueta: 'Tu usuario',
              icono: Icons.person_rounded,
              habilitado: !estado.ocupado,
            ),
            const SizedBox(height: Espaciado.m),
            CampoGenios(
              controlador: _codigo,
              etiqueta: 'Código de tu docente',
              icono: Icons.vpn_key_rounded,
              habilitado: !estado.ocupado,
              mayusculas: true,
            ),
            const SizedBox(height: Espaciado.m),
            CampoGenios(
              controlador: _contrasena,
              etiqueta: 'Elige tu contraseña',
              icono: Icons.lock_rounded,
              habilitado: !estado.ocupado,
              oculto: true,
              alEnviar: _enviar,
            ),
            const SizedBox(height: Espaciado.xl),
            Center(
              child: BotonPrincipalJuego(
                texto: 'GUARDAR',
                icono: Icons.check_rounded,
                ocupado: estado.ocupado,
                alPulsar: _enviar,
              ),
            ),
            MensajeErrorAcceso(mensaje: estado.mensajeError),
          ],
        ),
      ),
    );
  }
}
