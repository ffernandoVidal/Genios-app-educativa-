import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/ajustes/ajustes_app.dart';
import '../../../core/sesion/sesion_app.dart';
import '../../../diseno/componentes/botones_juego.dart';
import '../../../diseno/tokens/colores.dart';
import '../../../diseno/tokens/medidas.dart';
import '../../../diseno/tokens/tipografia.dart';
import '../../acceso/presentacion/acceso_cubit.dart';
import 'componentes/componentes_docente.dart';

/// Ajustes del docente: texto más grande, información de la cuenta y cierre de sesión.
class AjustesDocentePantalla extends StatelessWidget {
  const AjustesDocentePantalla({super.key});

  @override
  Widget build(BuildContext context) {
    final ajustes = AjustesScope.of(context);
    final nombre = context.read<FuenteModoSesion>().nombre;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Ajustes', style: Tipografia.titulo(30, peso: 800)),
          const SizedBox(height: Espaciado.l),
          Bloque(
            titulo: 'Tu cuenta',
            hijo: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(nombre, style: Tipografia.titulo(22, peso: 700)),
                Text(
                  'Cuenta docente con Google',
                  style: Tipografia.texto(15, color: ColoresGenios.textoSuave),
                ),
                const SizedBox(height: Espaciado.m),
                BotonSecundarioJuego(
                  texto: 'CERRAR SESIÓN',
                  icono: Icons.logout_rounded,
                  alPulsar: () async {
                    await context.read<AccesoCubit>().salir();
                    if (context.mounted) context.go('/');
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: Espaciado.l),
          Bloque(
            titulo: 'Accesibilidad',
            hijo: ListenableBuilder(
              listenable: ajustes,
              builder: (context, _) => Column(
                children: [
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      'Texto más grande',
                      style: Tipografia.titulo(20, peso: 700),
                    ),
                    subtitle: Text(
                      'Hace las letras más fáciles de leer.',
                      style: Tipografia.texto(
                        15,
                        color: ColoresGenios.textoSuave,
                      ),
                    ),
                    value: ajustes.textoGrande,
                    onChanged: (v) => ajustes.textoGrande = v,
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      'Animaciones',
                      style: Tipografia.titulo(20, peso: 700),
                    ),
                    subtitle: Text(
                      'Movimiento de la mascota.',
                      style: Tipografia.texto(
                        15,
                        color: ColoresGenios.textoSuave,
                      ),
                    ),
                    value: ajustes.animaciones,
                    onChanged: (v) => ajustes.animaciones = v,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: Espaciado.l),
          Bloque(
            titulo: 'Privacidad',
            hijo: Text(
              'Solo ves a los estudiantes que pertenecen a tus clases. Los códigos de clase no dan acceso a resultados por sí solos. No puedes ver ni fijar contraseñas: solo emitir códigos de un solo uso.',
              style: Tipografia.texto(16, color: ColoresGenios.textoSuave),
            ),
          ),
        ],
      ),
    );
  }
}
