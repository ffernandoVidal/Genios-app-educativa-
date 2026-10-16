import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../core/ajustes/ajustes_app.dart';
import '../core/sesion/sesion_app.dart';
import '../diseno/tema/tema_genios.dart';
import '../features/acceso/dominio/repositorio_acceso.dart';
import '../features/acceso/dominio/restaurador_sesion.dart';
import '../features/acceso/presentacion/acceso_cubit.dart';
import '../features/catalogo/dominio/repositorio_catalogo.dart';
import '../features/partida/dominio/repositorio_partida.dart';
import '../features/progreso/dominio/repositorio_progreso.dart';
import '../features/docente/dominio/repositorio_docente.dart';
import '../features/salon/dominio/repositorio_salon.dart';
import 'enrutador.dart';

/// Raíz de la app. Recibe sus dependencias para poder probarla con repositorios falsos.
class AppGenios extends StatefulWidget {
  const AppGenios({
    super.key,
    required this.sesion,
    required this.repositorioAcceso,
    required this.repositorioCatalogo,
    required this.repositorioPartida,
    required this.repositorioProgreso,
    required this.repositorioSalon,
    required this.repositorioDocente,
    this.ajustes,
    this.googleClientId = '',
    this.restaurarAlIniciar = false,
  });

  final SesionApp sesion;
  final RepositorioAcceso repositorioAcceso;
  final RepositorioCatalogo repositorioCatalogo;
  final RepositorioPartida repositorioPartida;
  final RepositorioProgreso repositorioProgreso;
  final RepositorioSalon repositorioSalon;
  final RepositorioDocente repositorioDocente;

  /// Preferencias visuales; si no se indican se usan las predeterminadas.
  final AjustesApp? ajustes;

  /// Client ID público de Google para el acceso docente.
  final String googleClientId;

  /// Al abrir, recupera la sesión existente (cookie de renovación o de invitado) antes de decidir la pantalla.
  final bool restaurarAlIniciar;

  @override
  State<AppGenios> createState() => _AppGeniosState();
}

class _AppGeniosState extends State<AppGenios> {
  late final RestauradorSesion _restaurador = RestauradorSesion(
    widget.repositorioAcceso,
    widget.sesion,
  );
  late final GoRouter _enrutador = crearEnrutador(
    widget.sesion,
    googleClientId: widget.googleClientId,
    restaurador: _restaurador,
  );
  late final AjustesApp _ajustes = widget.ajustes ?? AjustesApp();

  @override
  void initState() {
    super.initState();
    if (widget.restaurarAlIniciar) _restaurador.restaurar();
  }

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
        RepositoryProvider<RepositorioSalon>.value(
          value: widget.repositorioSalon,
        ),
        RepositoryProvider<RepositorioDocente>.value(
          value: widget.repositorioDocente,
        ),
      ],
      child: BlocProvider(
        create: (_) => AccesoCubit(widget.repositorioAcceso, widget.sesion),
        child: MaterialApp.router(
          title: 'GENIOS',
          debugShowCheckedModeBanner: false,
          theme: TemaGenios.construir(),
          routerConfig: _enrutador,
          // Los ajustes quedan por encima del Navigator: llegan a todas las pantallas y a los diálogos.
          builder: (context, hijo) => AjustesScope(
            ajustes: _ajustes,
            child: ListenableBuilder(
              listenable: _ajustes,
              builder: (context, _) => MediaQuery(
                data: MediaQuery.of(
                  context,
                ).copyWith(textScaler: TextScaler.linear(_ajustes.escalaTexto)),
                child: hijo!,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
