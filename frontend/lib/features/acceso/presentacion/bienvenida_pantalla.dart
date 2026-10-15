import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../app/tema/tema_genios.dart';
import '../../../core/widgets/fondo_espacial.dart';
import 'acceso_cubit.dart';

class BienvenidaPantalla extends StatelessWidget {
  const BienvenidaPantalla({super.key});

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    return Scaffold(
      body: FondoEspacial(
        hijo: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: BlocBuilder<AccesoCubit, EstadoAcceso>(
                  builder: (context, estado) => Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const ExcludeSemantics(
                        child: Icon(
                          Icons.rocket_launch_rounded,
                          size: 96,
                          color: ColoresGenios.acento,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'GENIOS',
                        textAlign: TextAlign.center,
                        style: textos.displayMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                          letterSpacing: 4,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Explora el universo del saber',
                        textAlign: TextAlign.center,
                        style: textos.titleLarge?.copyWith(
                          color: ColoresGenios.textoSuave,
                        ),
                      ),
                      const SizedBox(height: 40),
                      FilledButton.icon(
                        onPressed: estado.ocupado
                            ? null
                            : () => context
                                  .read<AccesoCubit>()
                                  .entrarComoInvitado(),
                        icon: estado.ocupado
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                ),
                              )
                            : const Icon(Icons.play_arrow_rounded),
                        label: const Text('Jugar como invitado'),
                      ),
                      const SizedBox(height: 16),
                      OutlinedButton.icon(
                        onPressed: estado.ocupado
                            ? null
                            : () => context.push('/ingresar'),
                        icon: const Icon(Icons.login_rounded),
                        label: const Text('Ya tengo mi usuario'),
                      ),
                      const SizedBox(height: 16),
                      TextButton.icon(
                        onPressed: estado.ocupado
                            ? null
                            : () => context.push('/registro'),
                        icon: const Icon(Icons.meeting_room_rounded),
                        label: const Text('Tengo un código de aula'),
                      ),
                      if (estado.mensajeError != null) ...[
                        const SizedBox(height: 20),
                        Semantics(
                          liveRegion: true,
                          child: Text(
                            estado.mensajeError!,
                            textAlign: TextAlign.center,
                            style: textos.titleMedium?.copyWith(
                              color: ColoresGenios.error,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
