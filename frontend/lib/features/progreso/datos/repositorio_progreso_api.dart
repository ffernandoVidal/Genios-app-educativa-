import '../../../core/red/cliente_api.dart';
import '../../../core/sesion/sesion_app.dart';
import '../dominio/modelos_progreso.dart';
import '../dominio/repositorio_progreso.dart';

class RepositorioProgresoApi implements RepositorioProgreso {
  RepositorioProgresoApi(this._api);

  final ClienteApi _api;

  @override
  Future<ResumenJugador> resumen(ModoSesion modo) async {
    if (modo == ModoSesion.invitado) {
      final invitado = await _estadoInvitado();
      return ResumenJugador(
        esInvitado: true,
        partidasQueCuentan: invitado.partidasQueCuentan,
        partidasRequeridas: invitado.partidasRequeridas,
        invitarARegistrarse: invitado.invitarARegistrarse,
      );
    }
    final puntos =
        await _api.obtener('/estudiantes/yo/puntos') as Map<String, dynamic>;
    final uso = await _api.obtener(
      '/estudiantes/yo/uso-diario',
    ) as Map<String, dynamic>;
    return ResumenJugador(
      esInvitado: false,
      puntos: (puntos['puntosTotales'] as num).toInt(),
      minutosRestantes: uso['minutosRestantes'] as int,
      limiteAlcanzado: uso['limiteAlcanzado'] as bool,
    );
  }

  @override
  Future<VistaProgreso> progreso(ModoSesion modo) async {
    if (modo == ModoSesion.invitado) return _estadoInvitado();

    final progreso =
        await _api.obtener('/estudiantes/yo/progreso') as Map<String, dynamic>;
    final estadisticas = await _api.obtener(
      '/estudiantes/yo/estadisticas',
    ) as Map<String, dynamic>;
    final puntos =
        await _api.obtener('/estudiantes/yo/puntos') as Map<String, dynamic>;

    return ProgresoEstudiante(
      puntosTotales: (puntos['puntosTotales'] as num).toInt(),
      porcentajePrimerIntento: (estadisticas['porcentajePrimerIntento'] as num)
          .toDouble(),
      preguntasCorregidasConReintento:
          (estadisticas['reintentos']
                  as Map<String, dynamic>)['preguntasCorregidasConReintento']
              as int,
      partidasCompletadas: estadisticas['partidasCompletadas'] as int,
      partidasIncompletas: estadisticas['partidasIncompletas'] as int,
      materias: (progreso['asignaturas'] as List<dynamic>).map((a) {
        final m = a as Map<String, dynamic>;
        return ProgresoMateria(
          nombre: m['nombre'] as String,
          categoriasTotales: m['categoriasTotales'] as int,
          categoriasCompletadas: m['categoriasCompletadas'] as int,
          porcentajeAciertos: (m['porcentajeAciertos'] as num).toDouble(),
          puntos: (m['puntos'] as num).toInt(),
        );
      }).toList(),
      recientes: (estadisticas['partidasRecientes'] as List<dynamic>).map((p) {
        final r = p as Map<String, dynamic>;
        return PartidaReciente(
          asignatura: r['asignatura'] as String,
          categoria: r['categoria'] as String,
          estado: r['estado'] as String,
          aciertosPrimerIntento: r['aciertosPrimerIntento'] as int,
          preguntasEvaluadas: r['preguntasEvaluadas'] as int,
          puntos: r['puntosObtenidos'] as int,
        );
      }).toList(),
    );
  }

  Future<ProgresoInvitado> _estadoInvitado() async {
    final j = await _api.obtener('/sesiones-juego/yo') as Map<String, dynamic>;
    return ProgresoInvitado(
      partidasValidas: j['partidasValidas'] as int,
      partidasQueCuentan: j['partidasQueCuentan'] as int,
      partidasRequeridas: j['partidasRequeridas'] as int,
      invitarARegistrarse: j['invitarARegistrarse'] as bool,
      aviso: j['avisoProgreso'] as String,
    );
  }
}
