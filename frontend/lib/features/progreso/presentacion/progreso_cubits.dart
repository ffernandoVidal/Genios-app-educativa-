import '../../../core/estado/estado_carga.dart';
import '../../../core/sesion/sesion_app.dart';
import '../dominio/modelos_progreso.dart';
import '../dominio/repositorio_progreso.dart';

class ResumenJugadorCubit extends CubitCarga<ResumenJugador> {
  ResumenJugadorCubit(this._repositorio, this._sesion);

  final RepositorioProgreso _repositorio;
  final FuenteModoSesion _sesion;

  @override
  Future<ResumenJugador> obtener() => _repositorio.resumen(_sesion.modo);
}

class ProgresoCubit extends CubitCarga<VistaProgreso> {
  ProgresoCubit(this._repositorio, this._sesion);

  final RepositorioProgreso _repositorio;
  final FuenteModoSesion _sesion;

  @override
  Future<VistaProgreso> obtener() => _repositorio.progreso(_sesion.modo);
}
