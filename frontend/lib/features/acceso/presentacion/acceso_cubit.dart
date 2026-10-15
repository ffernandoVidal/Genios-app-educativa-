import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/red/excepcion_api.dart';
import '../../../core/sesion/sesion_app.dart';
import '../dominio/repositorio_acceso.dart';

class EstadoAcceso extends Equatable {
  const EstadoAcceso({this.ocupado = false, this.mensajeError});

  final bool ocupado;
  final String? mensajeError;

  @override
  List<Object?> get props => [ocupado, mensajeError];
}

class AccesoCubit extends Cubit<EstadoAcceso> {
  AccesoCubit(this._repositorio, this._sesion) : super(const EstadoAcceso());

  final RepositorioAcceso _repositorio;
  final SesionApp _sesion;

  Future<void> entrarComoInvitado() => _ejecutar(() async {
    await _repositorio.crearSesionInvitado();
    _sesion.iniciarInvitado();
  });

  Future<void> iniciarSesion(String nombreUsuario, String contrasena) async {
    if (nombreUsuario.trim().isEmpty || contrasena.isEmpty) {
      emit(
        const EstadoAcceso(mensajeError: 'Escribe tu usuario y tu contraseña.'),
      );
      return;
    }
    await _ejecutar(() async {
      final resultado = await _repositorio.iniciarSesionEstudiante(
        nombreUsuario.trim(),
        contrasena,
      );
      _sesion.iniciarCuenta(
        tokenAcceso: resultado.tokenAcceso,
        roles: resultado.roles,
      );
    });
  }

  /// Cierra la sesión. Si el servidor no responde, igual se sale de la app: el token vence solo.
  Future<void> salir() async {
    if (_sesion.tieneCuenta) {
      try {
        await _repositorio.cerrarSesion();
      } on ExcepcionApi {
        // Se ignora: la salida local no depende del servidor.
      }
    }
    _sesion.cerrar();
  }

  Future<void> _ejecutar(Future<void> Function() accion) async {
    emit(const EstadoAcceso(ocupado: true));
    try {
      await accion();
      if (!isClosed) emit(const EstadoAcceso());
    } on ExcepcionApi catch (e) {
      if (!isClosed) emit(EstadoAcceso(mensajeError: _traducir(e)));
    }
  }

  String _traducir(ExcepcionApi e) => e.codigo == 'credenciales_invalidas'
      ? 'Usuario o contraseña incorrectos.'
      : e.mensaje;
}
