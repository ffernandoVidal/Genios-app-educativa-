import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../diseno/componentes/botones_juego.dart';
import '../../../diseno/componentes/campo_genios.dart';
import '../../../diseno/componentes/plantilla_pantalla.dart';
import '../../../diseno/tokens/colores.dart';
import '../../../diseno/tokens/medidas.dart';
import '../../../diseno/tokens/tipografia.dart';
import 'acceso_cubit.dart';
import 'mensaje_error_acceso.dart';

/// Crear una cuenta de estudiante. El código de aula (que da el docente) vincula la cuenta con su salón:
/// no es una contraseña ni reemplaza el usuario. La cuenta empieza desde cero.
class RegistroPantalla extends StatefulWidget {
  const RegistroPantalla({super.key});

  @override
  State<RegistroPantalla> createState() => _RegistroPantallaState();
}

class _RegistroPantallaState extends State<RegistroPantalla> {
  final _codigo = TextEditingController();
  final _nombre = TextEditingController();
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
    _codigo.dispose();
    _nombre.dispose();
    _usuario.dispose();
    _contrasena.dispose();
    super.dispose();
  }

  void _enviar() => context.read<AccesoCubit>().registrar(
    codigoAula: _codigo.text,
    nombreMostrar: _nombre.text,
    nombreUsuario: _usuario.text,
    contrasena: _contrasena.text,
  );

  @override
  Widget build(BuildContext context) {
    return PlantillaPantalla(
      titulo: 'Crear mi cuenta',
      hijo: BlocBuilder<AccesoCubit, EstadoAcceso>(
        builder: (context, estado) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Crea tu cuenta y juega. El código de aula es opcional.',
              textAlign: TextAlign.center,
              style: Tipografia.texto(20, peso: 800),
            ),
            const SizedBox(height: Espaciado.s),
            Text(
              'Tu cuenta empieza desde cero: lo que jugaste como invitado no se pasa a ella.',
              textAlign: TextAlign.center,
              style: Tipografia.texto(15, color: ColoresGenios.textoSuave),
            ),
            const SizedBox(height: Espaciado.xl),
            CampoGenios(
              controlador: _codigo,
              etiqueta: 'Código del aula, si tienes uno (opcional)',
              icono: Icons.meeting_room_rounded,
              habilitado: !estado.ocupado,
              mayusculas: true,
            ),
            const SizedBox(height: Espaciado.m),
            CampoGenios(
              controlador: _nombre,
              etiqueta: '¿Cómo te llamas?',
              icono: Icons.face_rounded,
              habilitado: !estado.ocupado,
            ),
            const SizedBox(height: Espaciado.m),
            CampoGenios(
              controlador: _usuario,
              etiqueta: 'Tu usuario: sin espacios, solo letras, números, . o _',
              icono: Icons.person_rounded,
              habilitado: !estado.ocupado,
            ),
            const SizedBox(height: Espaciado.m),
            CampoGenios(
              controlador: _contrasena,
              etiqueta: 'Tu contraseña (mínimo 6 caracteres)',
              icono: Icons.lock_rounded,
              habilitado: !estado.ocupado,
              oculto: true,
              alEnviar: _enviar,
            ),
            const SizedBox(height: Espaciado.xl),
            Center(
              child: BotonPrincipalJuego(
                texto: 'CREAR MI CUENTA',
                icono: Icons.rocket_launch_rounded,
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
