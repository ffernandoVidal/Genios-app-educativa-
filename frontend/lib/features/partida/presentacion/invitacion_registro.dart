import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/estado/estado_carga.dart';
import '../../../core/sesion/sesion_app.dart';
import '../../../diseno/componentes/astronauta_genios.dart';
import '../../../diseno/componentes/botones_juego.dart';
import '../../../diseno/tokens/colores.dart';
import '../../../diseno/tokens/medidas.dart';
import '../../../diseno/tokens/tipografia.dart';
import '../../progreso/dominio/repositorio_progreso.dart';

/// ¿Hay que invitar a este invitado a crear su cuenta? Lo decide el servidor (tres partidas calificadas);
/// aquí solo se consulta su estado y se recuerda si ya se le mostró en esta sesión.
class InvitacionRegistroCubit extends CubitCarga<bool> {
  InvitacionRegistroCubit(this._repositorio, this._sesion);

  final RepositorioProgreso _repositorio;
  final FuenteModoSesion _sesion;

  @override
  Future<bool> obtener() async {
    if (_sesion.modo != ModoSesion.invitado || _sesion.invitacionDescartada) {
      return false;
    }
    return (await _repositorio.resumen(_sesion.modo)).invitarARegistrarse;
  }

  void descartar() => _sesion.descartarInvitacion();
}

/// Escucha al cubit y muestra, una sola vez, el modal amistoso de invitación. Envuelve a la pantalla de resultados.
class EscuchaInvitacionRegistro extends StatelessWidget {
  const EscuchaInvitacionRegistro({super.key, required this.hijo});

  final Widget hijo;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (c) => InvitacionRegistroCubit(
        c.read<RepositorioProgreso>(),
        c.read<FuenteModoSesion>(),
      )..cargar(),
      child: BlocListener<InvitacionRegistroCubit, EstadoCarga<bool>>(
        listenWhen: (anterior, actual) =>
            actual is Cargado<bool> && actual.datos,
        listener: (context, _) => _mostrar(context),
        child: hijo,
      ),
    );
  }

  Future<void> _mostrar(BuildContext context) async {
    final cubit = context.read<InvitacionRegistroCubit>();
    final crear = await showDialog<bool>(
      context: context,
      builder: (_) => const _DialogoInvitacion(),
    );
    cubit.descartar(); // se muestra una vez por sesión, la acepte o no: no es coercitivo
    if (crear == true && context.mounted) context.push('/registro');
  }
}

class _DialogoInvitacion extends StatelessWidget {
  const _DialogoInvitacion();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Column(
        children: [
          const AstronautaGenios(pose: PoseAstronauta.celebracion, alto: 120),
          const SizedBox(height: Espaciado.s),
          Text(
            '¡Lo estás haciendo genial!',
            textAlign: TextAlign.center,
            style: Tipografia.titulo(28, peso: 800),
          ),
        ],
      ),
      content: Text(
        'Ya puedes crear tu cuenta para guardar tu progreso desde ahora. '
        'Lo que jugaste como invitado no se pasa a la cuenta nueva.',
        textAlign: TextAlign.center,
        style: Tipografia.texto(18, color: ColoresGenios.blancoLunar),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actionsOverflowAlignment: OverflowBarAlignment.center,
      actionsOverflowDirection: VerticalDirection.down,
      actions: [
        BotonPrincipalJuego(
          texto: 'CREAR MI CUENTA',
          alPulsar: () => Navigator.of(context).pop(true),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Ahora no'),
        ),
      ],
    );
  }
}
