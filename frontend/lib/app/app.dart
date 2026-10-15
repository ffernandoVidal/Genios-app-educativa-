import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../core/sesion/sesion_app.dart';
import '../features/acceso/dominio/repositorio_acceso.dart';
import '../features/acceso/presentacion/acceso_cubit.dart';
import '../features/catalogo/dominio/repositorio_catalogo.dart';
import 'enrutador.dart';
import 'tema/tema_genios.dart';

/// Raíz de la app. Recibe sus dependencias para poder probarla con repositorios falsos.
class AppGenios extends StatefulWidget {
  const AppGenios({
    super.key,
    required this.sesion,
    required this.repositorioAcceso,
    required this.repositorioCatalogo,
  });

  final SesionApp sesion;
  final RepositorioAcceso repositorioAcceso;
  final RepositorioCatalogo repositorioCatalogo;

  @override
  State<AppGenios> createState() => _AppGeniosState();
}

class _AppGeniosState extends State<AppGenios> {
  late final GoRouter _enrutador = crearEnrutador(widget.sesion);

  @override
  void dispose() {
    _enrutador.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<RepositorioAcceso>.value(
          value: widget.repositorioAcceso,
        ),
        RepositoryProvider<RepositorioCatalogo>.value(
          value: widget.repositorioCatalogo,
        ),
      ],
      child: BlocProvider(
        create: (_) => AccesoCubit(widget.repositorioAcceso, widget.sesion),
        child: MaterialApp.router(
          title: 'GENIOS',
          debugShowCheckedModeBanner: false,
          theme: TemaGenios.construir(),
          routerConfig: _enrutador,
        ),
      ),
    );
  }
}
