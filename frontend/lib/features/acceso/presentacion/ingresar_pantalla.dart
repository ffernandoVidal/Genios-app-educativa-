import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../app/tema/tema_genios.dart';
import '../../../core/widgets/fondo_espacial.dart';
import 'acceso_cubit.dart';

class IngresarPantalla extends StatefulWidget {
  const IngresarPantalla({super.key});

  @override
  State<IngresarPantalla> createState() => _IngresarPantallaState();
}

class _IngresarPantallaState extends State<IngresarPantalla> {
  final _usuario = TextEditingController();
  final _contrasena = TextEditingController();

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
    final textos = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Volver',
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: const Text('Entrar'),
      ),
      extendBodyBehindAppBar: true,
      body: FondoEspacial(
        hijo: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: BlocBuilder<AccesoCubit, EstadoAcceso>(
                  builder: (context, estado) => AutofillGroup(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          '¡Qué bueno verte de nuevo!',
                          textAlign: TextAlign.center,
                          style: textos.headlineSmall,
                        ),
                        const SizedBox(height: 24),
                        TextField(
                          controller: _usuario,
                          enabled: !estado.ocupado,
                          autofillHints: const [AutofillHints.username],
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            labelText: 'Tu usuario',
                            prefixIcon: Icon(Icons.person_rounded),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _contrasena,
                          enabled: !estado.ocupado,
                          obscureText: true,
                          autofillHints: const [AutofillHints.password],
                          onSubmitted: (_) => _enviar(),
                          decoration: const InputDecoration(
                            labelText: 'Tu contraseña',
                            prefixIcon: Icon(Icons.lock_rounded),
                          ),
                        ),
                        const SizedBox(height: 24),
                        FilledButton(
                          onPressed: estado.ocupado ? null : _enviar,
                          child: Text(estado.ocupado ? 'Entrando…' : 'Entrar'),
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
      ),
    );
  }
}
