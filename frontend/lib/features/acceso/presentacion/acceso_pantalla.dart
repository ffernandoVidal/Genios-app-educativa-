import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../diseno/componentes/astronauta_genios.dart';
import '../../../diseno/componentes/plantilla_pantalla.dart';
import '../../../diseno/tokens/colores.dart';
import '../../../diseno/tokens/medidas.dart';
import '../../../diseno/tokens/tipografia.dart';

/// Elige cómo entrar. No cambia roles: Genio y Docente usan Google, Estudiante usa el usuario
/// y la contraseña que le dio su docente.
class AccesoPantalla extends StatelessWidget {
  const AccesoPantalla({super.key});

  @override
  Widget build(BuildContext context) {
    return PlantillaPantalla(
      titulo: 'Iniciar sesión',
      hijo: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Center(child: AstronautaGenios(alto: 120)),
          const SizedBox(height: Espaciado.m),
          Text(
            '¿Cómo quieres entrar?',
            textAlign: TextAlign.center,
            style: Tipografia.titulo(26),
          ),
          const SizedBox(height: Espaciado.l),
          _TarjetaAcceso(
            texto: 'GENIO',
            detalle: 'Juega por tu cuenta con Google',
            icono: Icons.rocket_launch_rounded,
            alPulsar: () => context.push('/genio'),
          ),
          const SizedBox(height: Espaciado.m),
          _TarjetaAcceso(
            texto: 'ESTUDIANTE',
            detalle: 'Con el usuario que te dio tu docente',
            icono: Icons.backpack_rounded,
            alPulsar: () => context.push('/ingresar'),
          ),
          const SizedBox(height: Espaciado.m),
          _TarjetaAcceso(
            texto: 'DOCENTE',
            detalle: 'Con Google, para tus clases',
            icono: Icons.school_rounded,
            alPulsar: () => context.push('/docente'),
          ),
        ],
      ),
    );
  }
}

class _TarjetaAcceso extends StatelessWidget {
  const _TarjetaAcceso({
    required this.texto,
    required this.detalle,
    required this.icono,
    required this.alPulsar,
  });

  final String texto;
  final String detalle;
  final IconData icono;
  final VoidCallback alPulsar;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '$texto. $detalle',
      excludeSemantics: true,
      child: Material(
        color: ColoresGenios.tarjeta,
        shape: RoundedRectangleBorder(
          borderRadius: Radios.tarjeta,
          side: const BorderSide(
            color: ColoresGenios.amarilloEspacial,
            width: 2,
          ),
        ),
        child: InkWell(
          borderRadius: Radios.tarjeta,
          onTap: alPulsar,
          child: Padding(
            padding: const EdgeInsets.all(Espaciado.l),
            child: Row(
              children: [
                Icon(icono, size: 40, color: ColoresGenios.amarilloEspacial),
                const SizedBox(width: Espaciado.l),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(texto, style: Tipografia.titulo(22)),
                      const SizedBox(height: Espaciado.xs),
                      Text(
                        detalle,
                        style: Tipografia.texto(
                          16,
                          color: ColoresGenios.textoSuave,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
