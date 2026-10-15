import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/red/excepcion_api.dart';
import '../../../core/sesion/sesion_app.dart';
import '../dominio/repositorio_acceso.dart';
import '../dominio/validacion_apodo.dart';

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

  /// Entrar como invitado: solo hace falta un nombre o apodo, que se queda en el cliente.
  /// La sesión segura la crea el servidor (cookie HttpOnly); el apodo no la identifica ni la sustituye.
  Future<void> entrarComoInvitado(String apodo) async {
    final error = ValidacionApodo.validar(apodo);
    if (error != null) {
      emit(EstadoAcceso(mensajeError: error));
      return;
    }
    await _ejecutar(() async {
      await _repositorio.crearSesionInvitado();
      _sesion.iniciarInvitado(nombre: apodo.trim());
    });
  }

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
        nombre: resultado.nombreMostrar,
      );
    });
  }

  /// Devuelve true si la contraseña quedó guardada.
  Future<bool> activarCuenta({
    required String nombreUsuario,
    required String codigo,
    required String contrasenaNueva,
  }) async {
    if (nombreUsuario.trim().isEmpty ||
        codigo.trim().isEmpty ||
        contrasenaNueva.isEmpty) {
      emit(const EstadoAcceso(mensajeError: 'Completa todos los datos.'));
      return false;
    }
    var listo = false;
    await _ejecutar(() async {
      await _repositorio.activarCuenta(
        nombreUsuario: nombreUsuario.trim(),
        codigo: codigo.trim(),
        contrasenaNueva: contrasenaNueva,
      );
      listo = true;
    });
    return listo;
  }

  /// Acceso docente: la API valida la credencial de Google y crea o recupera la cuenta.
  Future<void> ingresarConGoogle(String idToken) async {
    await _ejecutar(() async {
      final resultado = await _repositorio.iniciarSesionGoogle(idToken);
      _sesion.iniciarCuenta(
        tokenAcceso: resultado.tokenAcceso,
        roles: resultado.roles,
        nombre: resultado.nombreMostrar,
      );
    });
  }

  Future<void> registrar({
    required String codigoAula,
    required String nombreMostrar,
    required String nombreUsuario,
    required String contrasena,
  }) async {
    if (nombreMostrar.trim().isEmpty ||
        nombreUsuario.trim().isEmpty ||
        contrasena.isEmpty) {
      emit(const EstadoAcceso(mensajeError: 'Completa todos los datos.'));
      return;
    }
    await _ejecutar(() async {
      final resultado = await _repositorio.registrarEstudiante(
        codigoAula: codigoAula.trim(),
        nombreMostrar: nombreMostrar.trim(),
        nombreUsuario: nombreUsuario.trim(),
        contrasena: contrasena,
      );
      _sesion.iniciarCuenta(
        tokenAcceso: resultado.tokenAcceso,
        roles: resultado.roles,
        nombre: resultado.nombreMostrar,
      );
    });
  }

  /// Las pantallas de acceso comparten este Cubit: al abrirlas se borra el mensaje de la anterior.
  void limpiarError() {
    if (state.mensajeError != null) emit(const EstadoAcceso());
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

  String _traducir(ExcepcionApi e) => switch (e.codigo) {
    'credenciales_invalidas' => 'Usuario o contraseña incorrectos.',
    'aula_no_encontrada' =>
      'No encontramos ese código de aula. Revisa que esté bien escrito.',
    'nombre_usuario_en_uso' => 'Ese usuario ya existe. Prueba con otro.',
    'codigo_invalido' =>
      'El código no es válido o ya venció. Pídele uno nuevo a tu docente.',
    'google_token_invalido' =>
      'No pudimos validar tu cuenta de Google. Inténtalo de nuevo.',
    'google_no_configurado' =>
      'El acceso con Google no está disponible por ahora.',
    'google_correo_no_verificado' => 'Tu correo de Google no está verificado.',
    'correo_ya_registrado' => 'Ese correo ya está asociado a otra cuenta.',
    'cuenta_no_activa' => 'Esta cuenta no está activa.',
    _ => e.mensaje,
  };
}
