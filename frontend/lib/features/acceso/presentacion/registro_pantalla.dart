import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../app/tema/tema_genios.dart';
import '../../../core/widgets/fondo_espacial.dart';
import 'acceso_cubit.dart';

/// Crear una cuenta de estudiante con el código de aula que entrega el docente. La cuenta empieza desde cero.
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
    final textos = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Volver',
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: const Text('Crear mi cuenta'),
      ),
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
                      Text(
                        'Pídele a tu docente el código de tu aula.',
                        textAlign: TextAlign.center,
                        style: textos.titleMedium?.copyWith(
                          color: ColoresGenios.textoSuave,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tu cuenta empieza desde cero: lo que jugaste como invitado no se pasa a ella.',
                        textAlign: TextAlign.center,
                        style: textos.bodyMedium?.copyWith(
                          color: ColoresGenios.textoSuave,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _Campo(
                        controlador: _codigo,
                        etiqueta: 'Código del aula (por ejemplo K4821)',
                        icono: Icons.meeting_room_rounded,
                        habilitado: !estado.ocupado,
                        mayusculas: true,
                      ),
                      const SizedBox(height: 12),
                      _Campo(
                        controlador: _nombre,
                        etiqueta: '¿Cómo te llamas?',
                        icono: Icons.face_rounded,
                        habilitado: !estado.ocupado,
                      ),
                      const SizedBox(height: 12),
                      _Campo(
                        controlador: _usuario,
                        etiqueta: 'Inventa tu usuario',
                        icono: Icons.person_rounded,
                        habilitado: !estado.ocupado,
                      ),
                      const SizedBox(height: 12),
                      _Campo(
                        controlador: _contrasena,
                        etiqueta: 'Inventa tu contraseña',
                        icono: Icons.lock_rounded,
                        habilitado: !estado.ocupado,
                        oculto: true,
                        alEnviar: _enviar,
                      ),
                      const SizedBox(height: 24),
                      FilledButton(
                        onPressed: estado.ocupado ? null : _enviar,
                        child: Text(
                          estado.ocupado ? 'Creando…' : 'Crear mi cuenta',
                        ),
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

class _Campo extends StatelessWidget {
  const _Campo({
    required this.controlador,
    required this.etiqueta,
    required this.icono,
    required this.habilitado,
    this.oculto = false,
    this.mayusculas = false,
    this.alEnviar,
  });

  final TextEditingController controlador;
  final String etiqueta;
  final IconData icono;
  final bool habilitado;
  final bool oculto;
  final bool mayusculas;
  final VoidCallback? alEnviar;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controlador,
      enabled: habilitado,
      obscureText: oculto,
      textCapitalization: mayusculas
          ? TextCapitalization.characters
          : TextCapitalization.none,
      textInputAction: alEnviar == null
          ? TextInputAction.next
          : TextInputAction.done,
      onSubmitted: alEnviar == null ? null : (_) => alEnviar!(),
      decoration: InputDecoration(labelText: etiqueta, prefixIcon: Icon(icono)),
    );
  }
}
