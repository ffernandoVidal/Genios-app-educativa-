import '../../../core/sesion/sesion_app.dart';
import 'modelos_progreso.dart';

abstract class RepositorioProgreso {
  /// Insignias de la cabecera; depende de si juega un estudiante con cuenta o un invitado.
  Future<ResumenJugador> resumen(ModoSesion modo);

  Future<VistaProgreso> progreso(ModoSesion modo);
}
