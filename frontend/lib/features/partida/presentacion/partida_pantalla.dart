import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../diseno/componentes/astronauta_genios.dart';
import '../../../diseno/componentes/botones_juego.dart';
import '../../../diseno/componentes/fondo_espacial.dart';
import '../../../diseno/componentes/vistas_estado.dart';
import '../../../diseno/tokens/colores.dart';
import '../../../diseno/tokens/medidas.dart';
import '../../../diseno/tokens/tipografia.dart';
import '../dominio/argumentos_mision.dart';
import '../dominio/repositorio_partida.dart';
import 'partida_cubit.dart';
import 'resumen_resultados.dart';
import 'vista_pregunta.dart';

/// Pantalla 5: una misión de diez preguntas. El servidor decide si cada respuesta es correcta, los puntos y cuándo termina.
class PartidaPantalla extends StatelessWidget {
  const PartidaPantalla({
    super.key,
    required this.categoriaId,
    this.argumentos,
  });

  final int categoriaId;
  final ArgumentosMision? argumentos;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          PartidaCubit(context.read<RepositorioPartida>())
            ..iniciar(categoriaId),
      child: _CarcasaPartida(categoriaId: categoriaId, argumentos: argumentos),
    );
  }
}

class _CarcasaPartida extends StatefulWidget {
  const _CarcasaPartida({required this.categoriaId, this.argumentos});

  final int categoriaId;
  final ArgumentosMision? argumentos;

  @override
  State<_CarcasaPartida> createState() => _CarcasaPartidaState();
}

class _CarcasaPartidaState extends State<_CarcasaPartida> {
  // Una vez confirmada la salida, el PopScope deja de bloquear para que el pop real no se vuelva a interceptar.
  bool _salidaConfirmada = false;

  bool _puedeSalirSinPreguntar(EstadoPartida e) =>
      _salidaConfirmada ||
      e.fase == FasePartida.terminada ||
      e.fase == FasePartida.error ||
      e.fase == FasePartida.cargando;

  Future<void> _preguntarYSalir() async {
    final cubit = context.read<PartidaCubit>();
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogo) => AlertDialog(
        title: const Text('¿Salir de la misión?'),
        content: const Text('Tu partida quedará sin terminar.'),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogo).pop(false),
            child: const Text('Seguir jugando'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogo).pop(true),
            child: const Text('Salir'),
          ),
        ],
      ),
    );
    if (confirmar != true || !mounted) return;
    await cubit.abandonar();
    if (!mounted) return;
    setState(() => _salidaConfirmada = true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.pop();
    });
  }

  void _alPulsarCerrar(EstadoPartida estado) {
    if (_puedeSalirSinPreguntar(estado)) {
      context.pop();
    } else {
      _preguntarYSalir();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PartidaCubit, EstadoPartida>(
      builder: (context, estado) => PopScope(
        canPop: _puedeSalirSinPreguntar(estado),
        onPopInvokedWithResult: (salio, _) {
          if (!salio) _preguntarYSalir();
        },
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: IconButton(
              tooltip: 'Salir de la misión',
              iconSize: 30,
              constraints: const BoxConstraints(minWidth: 56, minHeight: 56),
              icon: const Icon(Icons.close_rounded),
              onPressed: () => _alPulsarCerrar(estado),
            ),
            title: Text(
              widget.argumentos?.nombre ?? 'Misión',
              style: Tipografia.titulo(26, peso: 800),
            ),
          ),
          body: FondoEspacial(
            hijo: SafeArea(
              child: switch (estado.fase) {
                FasePartida.cargando => const VistaCarga(
                  mensaje: 'Preparando tu misión…',
                ),
                FasePartida.error => _VistaFallo(estado: estado),
                FasePartida.terminada => ResumenResultados(
                  resultado: estado.resultado!,
                  categoriaId: widget.categoriaId,
                  argumentos: widget.argumentos,
                ),
                _ => VistaPregunta(estado: estado),
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _VistaFallo extends StatelessWidget {
  const _VistaFallo({required this.estado});

  final EstadoPartida estado;

  @override
  Widget build(BuildContext context) {
    if (estado.puedeReintentarCarga) {
      return VistaError(
        mensaje: estado.mensajeError ?? 'Algo salió mal.',
        sinConexion: true,
        alReintentar: context.read<PartidaCubit>().reintentarCarga,
      );
    }
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(Espaciado.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AstronautaGenios(alto: 150),
            const SizedBox(height: Espaciado.l),
            Semantics(
              liveRegion: true,
              child: Text(
                estado.mensajeError ?? 'No pudimos empezar la misión.',
                textAlign: TextAlign.center,
                style: Tipografia.texto(
                  22,
                  peso: 800,
                  color: ColoresGenios.blancoLunar,
                ),
              ),
            ),
            const SizedBox(height: Espaciado.xl),
            BotonPrincipalJuego(
              texto: 'VOLVER',
              icono: Icons.map_rounded,
              alPulsar: () => context.pop(),
            ),
          ],
        ),
      ),
    );
  }
}
