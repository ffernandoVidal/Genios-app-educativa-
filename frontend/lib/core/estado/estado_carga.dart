import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../red/excepcion_api.dart';

sealed class EstadoCarga<T> extends Equatable {
  const EstadoCarga();
}

class Cargando<T> extends EstadoCarga<T> {
  const Cargando();

  @override
  List<Object?> get props => [];
}

class Cargado<T> extends EstadoCarga<T> {
  const Cargado(this.datos);

  final T datos;

  @override
  List<Object?> get props => [datos];
}

class Fallido<T> extends EstadoCarga<T> {
  const Fallido(this.mensaje, {this.sinConexion = false});

  final String mensaje;
  final bool sinConexion;

  @override
  List<Object?> get props => [mensaje, sinConexion];
}

/// Base para las pantallas que cargan datos de la API: cargando, cargado o fallido (con reintento).
abstract class CubitCarga<T> extends Cubit<EstadoCarga<T>> {
  CubitCarga() : super(Cargando<T>());

  Future<T> obtener();

  Future<void> cargar() async {
    emit(Cargando<T>());
    try {
      final datos = await obtener();
      if (!isClosed) emit(Cargado(datos));
    } on ExcepcionApi catch (e) {
      if (!isClosed) emit(Fallido(e.mensaje, sinConexion: e.sinConexion));
    }
  }
}
