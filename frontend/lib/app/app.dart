import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../core/sesion/sesion_app.dart';
import '../features/acceso/dominio/repositorio_acceso.dart';
import '../features/acceso/presentacion/acceso_cubit.dart';
import '../features/catalogo/dominio/repositorio_catalogo.dart';
import '../features/partida/dominio/repositorio_partida.dart';
import '../features/progreso/dominio/repositorio_progreso.dart';
import 'enrutador.dart';
import 'tema/tema_genios.dart';

/// Raíz de la app. Recibe sus dependencias para poder probarla con repositorios falsos.
class AppGenios extends StatefulWidget {
  const AppGenios({
    super.key,
    required this.sesion,
    required this.repositorioAcceso,
    required this.repositorioCatalogo,
    required this.repositorioPartida,
    required this.repositorioProgreso,
  });

  final SesionApp sesion;
  final RepositorioAcceso repositorioAcceso;
  final RepositorioCatalogo repositorioCatalogo;
  final RepositorioPartida repositorioPartida;
  final RepositorioProgreso repositorioProgreso;

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
        RepositoryProvider<FuenteModoSesion>.value(
          value: FuenteModoSesion(widget.sesion),
        ),
        RepositoryProvider<RepositorioAcceso>.value(
          value: widget.repositorioAcceso,
        ),
        RepositoryProvider<RepositorioCatalogo>.value(
          value: widget.repositorioCatalogo,
        ),
        RepositoryProvider<RepositorioPartida>.value(
          value: widget.repositorioPartida,
        ),
        RepositoryProvider<RepositorioProgreso>.value(
          value: widget.repositorioProgreso,
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
