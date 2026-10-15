import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/estado/estado_carga.dart';
import '../../../core/sesion/sesion_app.dart';
import '../../../diseno/componentes/astronauta_genios.dart';
import '../../../diseno/componentes/botones_juego.dart';
import '../../../diseno/componentes/cabecera_estudiante.dart';
import '../../../diseno/componentes/fondo_espacial.dart';
import '../../../diseno/componentes/menu_lateral_estudiante.dart';
import '../../../diseno/tokens/medidas.dart';
import '../../progreso/dominio/modelos_progreso.dart';
import '../../progreso/dominio/repositorio_progreso.dart';
import '../../progreso/presentacion/progreso_cubits.dart';
import 'ventana_cabina.dart';

/// Pantalla 2, el centro de la experiencia estudiantil: el astronauta en su cabina, el menú y un único botón grande JUGAR.
class CabinaPantalla extends StatelessWidget {
  const CabinaPantalla({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (c) => ResumenJugadorCubit(
        c.read<RepositorioProgreso>(),
        c.read<FuenteModoSesion>(),
      )..cargar(),
      child: const _VistaCabina(),
    );
  }
}

class _VistaCabina extends StatelessWidget {
  const _VistaCabina();

  Future<void> _abrir(BuildContext context, String ruta) async {
    await context.push(ruta);
    // Al volver se actualizan puntos y tiempo: el servidor pudo haber cambiado esas cifras.
    if (context.mounted) context.read<ResumenJugadorCubit>().cargar();
  }

  @override
  Widget build(BuildContext context) {
    final sesion = context.read<FuenteModoSesion>();
    final esInvitado = sesion.modo == ModoSesion.invitado;

    return Scaffold(
      drawer: MenuLateralEstudiante(
        nombre: sesion.nombre,
        esInvitado: esInvitado,
        alElegir: (opcion) {
          Navigator.of(context).pop(); // cierra el menú
          _abrir(context, switch (opcion) {
            OpcionMenu.perfil => '/perfil',
            OpcionMenu.salon => '/salon',
            OpcionMenu.ajustes => '/ajustes',
          });
        },
      ),
      body: FondoEspacial(
        variante: VarianteFondo.paisaje,
        hijo: SafeArea(
          child: Column(
            children: [
              BlocBuilder<ResumenJugadorCubit, EstadoCarga<ResumenJugador>>(
                builder: (context, estado) {
                  final resumen = estado is Cargado<ResumenJugador>
                      ? estado.datos
                      : null;
                  return Builder(
                    builder: (contextoMenu) => CabeceraEstudiante(
                      nombre: sesion.nombre,
                      puntos: resumen?.puntos,
                      minutosRestantes: resumen?.minutosRestantes,
                      limiteAlcanzado: resumen?.limiteAlcanzado ?? false,
                      etiquetaInvitado: resumen != null && resumen.esInvitado
                          ? 'Invitado ${resumen.partidasQueCuentan}/${resumen.partidasRequeridas}'
                          : null,
                      alAbrirMenu: () => Scaffold.of(contextoMenu).openDrawer(),
                      alAbrirProgreso: () => _abrir(context, '/perfil'),
                    ),
                  );
                },
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, restricciones) {
                    final alto = (restricciones.maxHeight * 0.82).clamp(
                      150.0,
                      420.0,
                    );
                    final diametro = (alto * 1.05).clamp(
                      0.0,
                      restricciones.maxWidth,
                    );
                    return Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          VentanaCabina(diametro: diametro),
                          AstronautaGenios(
                            pose: PoseAstronauta.saludo,
                            alto: alto,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  Espaciado.pantalla,
                  Espaciado.s,
                  Espaciado.pantalla,
                  Espaciado.xl,
                ),
                child: BotonPrincipalJuego(
                  texto: 'JUGAR',
                  icono: Icons.rocket_launch_rounded,
                  alPulsar: () => _abrir(context, '/materias'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
