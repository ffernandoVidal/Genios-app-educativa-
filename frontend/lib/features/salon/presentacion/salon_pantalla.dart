import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/sesion/sesion_app.dart';
import '../../../diseno/componentes/astronauta_genios.dart';
import '../../../diseno/componentes/botones_juego.dart';
import '../../../diseno/componentes/campo_genios.dart';
import '../../../diseno/componentes/plantilla_pantalla.dart';
import '../../../diseno/componentes/vistas_estado.dart';
import '../../../diseno/tokens/colores.dart';
import '../../../diseno/tokens/medidas.dart';
import '../../../diseno/tokens/tipografia.dart';
import '../dominio/repositorio_salon.dart';
import 'salon_cubit.dart';

/// Salón: unirse a un aula con el código del docente y ver el aula asignada. Un invitado ve una explicación amistosa.
class SalonPantalla extends StatelessWidget {
  const SalonPantalla({super.key});

  @override
  Widget build(BuildContext context) {
    final esInvitado =
        context.read<FuenteModoSesion>().modo == ModoSesion.invitado;
    if (esInvitado) return const _ExplicacionInvitado();

    return BlocProvider(
      create: (c) => SalonCubit(c.read<RepositorioSalon>())..cargar(),
      child: const _VistaSalon(),
    );
  }
}

class _ExplicacionInvitado extends StatelessWidget {
  const _ExplicacionInvitado();

  @override
  Widget build(BuildContext context) {
    return PlantillaPantalla(
      titulo: 'Salón',
      hijo: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const AstronautaGenios(alto: 150),
          const SizedBox(height: Espaciado.l),
          Text(
            'Los salones son para quienes tienen una cuenta.',
            textAlign: TextAlign.center,
            style: Tipografia.titulo(26),
          ),
          const SizedBox(height: Espaciado.m),
          Text(
            'Con tu cuenta y el código que te da tu docente, podrás unirte a tu aula.',
            textAlign: TextAlign.center,
            style: Tipografia.texto(18, color: ColoresGenios.textoSuave),
          ),
          const SizedBox(height: Espaciado.xl),
          BotonPrincipalJuego(
            texto: 'CREAR MI CUENTA',
            icono: Icons.rocket_launch_rounded,
            alPulsar: () => context.push('/registro'),
          ),
        ],
      ),
    );
  }
}

class _VistaSalon extends StatefulWidget {
  const _VistaSalon();

  @override
  State<_VistaSalon> createState() => _VistaSalonState();
}

class _VistaSalonState extends State<_VistaSalon> {
  final _codigo = TextEditingController();

  @override
  void dispose() {
    _codigo.dispose();
    super.dispose();
  }

  void _unirse() => context.read<SalonCubit>().unirse(_codigo.text);

  @override
  Widget build(BuildContext context) {
    return PlantillaPantalla(
      titulo: 'Salón',
      hijo: BlocBuilder<SalonCubit, EstadoSalon>(
        builder: (context, estado) {
          if (estado.cargando) {
            return const SizedBox(
              height: 200,
              child: VistaCarga(mensaje: 'Buscando tu salón…'),
            );
          }
          if (estado.errorCarga != null) {
            return SizedBox(
              height: 320,
              child: VistaError(
                mensaje: estado.errorCarga!,
                alReintentar: context.read<SalonCubit>().cargar,
              ),
            );
          }
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Tu salón', style: Tipografia.titulo(26, peso: 800)),
              const SizedBox(height: Espaciado.s),
              if (estado.aulas.isEmpty)
                Text(
                  'Todavía no estás en un salón. Pídele el código a tu docente.',
                  style: Tipografia.texto(18, color: ColoresGenios.textoSuave),
                )
              else
                for (final aula in estado.aulas) _TarjetaAula(aula: aula),
              const SizedBox(height: Espaciado.xl),
              Text(
                'Unirme a un salón',
                style: Tipografia.titulo(26, peso: 800),
              ),
              const SizedBox(height: Espaciado.m),
              CampoGenios(
                controlador: _codigo,
                etiqueta: 'Código del aula (por ejemplo K4821)',
                icono: Icons.meeting_room_rounded,
                habilitado: !estado.uniendose,
                mayusculas: true,
                alEnviar: _unirse,
              ),
              const SizedBox(height: Espaciado.l),
              Center(
                child: BotonPrincipalJuego(
                  texto: 'UNIRME',
                  icono: Icons.login_rounded,
                  ocupado: estado.uniendose,
                  alPulsar: _unirse,
                ),
              ),
              if (estado.mensaje != null)
                Padding(
                  padding: const EdgeInsets.only(top: Espaciado.l),
                  child: Semantics(
                    liveRegion: true,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          estado.mensajeEsError
                              ? Icons.error_outline_rounded
                              : Icons.check_circle_rounded,
                          color: estado.mensajeEsError
                              ? ColoresGenios.error
                              : ColoresGenios.exito,
                        ),
                        const SizedBox(width: Espaciado.s),
                        Flexible(
                          child: Text(
                            estado.mensaje!,
                            style: Tipografia.texto(
                              18,
                              peso: 800,
                              color: estado.mensajeEsError
                                  ? ColoresGenios.error
                                  : ColoresGenios.exito,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _TarjetaAula extends StatelessWidget {
  const _TarjetaAula({required this.aula});

  final AulaSalon aula;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Aula ${aula.nombre}',
      excludeSemantics: true,
      child: Container(
        margin: const EdgeInsets.only(bottom: Espaciado.s),
        padding: const EdgeInsets.all(Espaciado.l),
        decoration: BoxDecoration(
          color: ColoresGenios.superficie,
          borderRadius: Radios.chip,
          border: Border.all(
            color: ColoresGenios.turquesa.withValues(alpha: 0.6),
            width: 2,
          ),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.meeting_room_rounded,
              size: 36,
              color: ColoresGenios.turquesa,
            ),
            const SizedBox(width: Espaciado.l),
            Expanded(
              child: Text(aula.nombre, style: Tipografia.titulo(22, peso: 800)),
            ),
          ],
        ),
      ),
    );
  }
}
