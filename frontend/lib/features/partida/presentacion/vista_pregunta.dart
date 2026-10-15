import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../diseno/componentes/astronauta_genios.dart';
import '../../../diseno/componentes/botones_juego.dart';
import '../../../diseno/tokens/colores.dart';
import '../../../diseno/tokens/medidas.dart';
import '../../../diseno/tokens/tipografia.dart';
import '../dominio/modelos_partida.dart';
import 'partida_cubit.dart';

/// Una pregunta a la vez: progreso de las diez, mecha si corresponde, enunciado, opciones grandes y la
/// retroalimentación que decide el servidor.
class VistaPregunta extends StatelessWidget {
  const VistaPregunta({super.key, required this.estado});

  final EstadoPartida estado;

  @override
  Widget build(BuildContext context) {
    final partida = estado.partida!;
    final pregunta = partida.pregunta!;
    final respondida = estado.fase == FasePartida.retroalimentacion;
    final bloqueada = estado.fase != FasePartida.pregunta;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: Anchos.contenido + 80),
        child: ListView(
          padding: const EdgeInsets.all(Espaciado.pantalla),
          children: [
            _Progreso(
              numero: partida.numeroPregunta,
              total: partida.totalPreguntas,
            ),
            if (estado.segundosMecha != null) ...[
              const SizedBox(height: Espaciado.l),
              Mecha(segundos: estado.segundosMecha!),
            ],
            const SizedBox(height: Espaciado.xl),
            Container(
              padding: const EdgeInsets.all(Espaciado.xl),
              decoration: BoxDecoration(
                color: ColoresGenios.superficie,
                borderRadius: Radios.tarjeta,
                boxShadow: Sombras.suave,
              ),
              child: Semantics(
                header: true,
                child: Text(
                  pregunta.enunciado,
                  textAlign: TextAlign.center,
                  style: Tipografia.texto(30, peso: 900),
                ),
              ),
            ),
            const SizedBox(height: Espaciado.xl),
            for (var i = 0; i < pregunta.opciones.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: Espaciado.m),
                child: _BotonOpcion(
                  letra: String.fromCharCode(65 + i),
                  texto: pregunta.opciones[i].texto,
                  estado: _estadoDe(pregunta.opciones[i], estado),
                  alPulsar: bloqueada
                      ? null
                      : () => context.read<PartidaCubit>().responder(
                          pregunta.opciones[i].id,
                        ),
                ),
              ),
            if (estado.aviso != null)
              Padding(
                padding: const EdgeInsets.only(top: Espaciado.s),
                child: Semantics(
                  liveRegion: true,
                  child: Text(
                    estado.aviso!,
                    textAlign: TextAlign.center,
                    style: Tipografia.texto(
                      18,
                      peso: 800,
                      color: ColoresGenios.aviso,
                    ),
                  ),
                ),
              ),
            if (respondida) ...[
              const SizedBox(height: Espaciado.m),
              _Retroalimentacion(respuesta: estado.respuesta!),
            ],
          ],
        ),
      ),
    );
  }

  _EstadoOpcion _estadoDe(Opcion opcion, EstadoPartida e) {
    if (e.opcionElegidaId != opcion.id) {
      return e.fase == FasePartida.pregunta
          ? _EstadoOpcion.normal
          : _EstadoOpcion.apagada;
    }
    if (e.fase == FasePartida.enviando) return _EstadoOpcion.enviando;
    return e.respuesta!.esCorrecta
        ? _EstadoOpcion.correcta
        : _EstadoOpcion.incorrecta;
  }
}

class _Progreso extends StatelessWidget {
  const _Progreso({required this.numero, required this.total});

  final int numero;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Pregunta $numero de $total',
      excludeSemantics: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pregunta $numero de $total',
            style: Tipografia.titulo(22, color: ColoresGenios.textoSuave),
          ),
          const SizedBox(height: Espaciado.s),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: (numero - 1) / total,
              minHeight: 14,
              color: ColoresGenios.amarilloEspacial,
              backgroundColor: ColoresGenios.superficieOscura,
            ),
          ),
        ],
      ),
    );
  }
}

/// La mecha: cuenta regresiva visible. El servidor decide cuándo termina de verdad la partida.
class Mecha extends StatelessWidget {
  const Mecha({super.key, required this.segundos});

  final int segundos;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label:
          'La mecha se acaba en $segundos segundos. Acierta antes de que explote.',
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.all(Espaciado.l),
        decoration: BoxDecoration(
          color: ColoresGenios.error.withValues(alpha: 0.18),
          borderRadius: Radios.chip,
          border: Border.all(color: ColoresGenios.error, width: 2.5),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.local_fire_department_rounded,
              color: ColoresGenios.error,
              size: 40,
            ),
            const SizedBox(width: Espaciado.m),
            Expanded(
              child: Text(
                '¡La mecha se acaba en $segundos s! Acierta antes de que explote.',
                style: Tipografia.texto(18, peso: 900),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum _EstadoOpcion { normal, enviando, correcta, incorrecta, apagada }

/// Opción de respuesta. El resultado se indica con icono y texto, no solo con color.
class _BotonOpcion extends StatelessWidget {
  const _BotonOpcion({
    required this.letra,
    required this.texto,
    required this.estado,
    required this.alPulsar,
  });

  final String letra;
  final String texto;
  final _EstadoOpcion estado;
  final VoidCallback? alPulsar;

  @override
  Widget build(BuildContext context) {
    final (color, icono, etiqueta) = switch (estado) {
      _EstadoOpcion.correcta => (
        ColoresGenios.exito,
        Icons.check_circle_rounded,
        'Correcta',
      ),
      _EstadoOpcion.incorrecta => (
        ColoresGenios.error,
        Icons.cancel_rounded,
        'Incorrecta',
      ),
      _EstadoOpcion.enviando => (
        ColoresGenios.amarilloEspacial,
        Icons.hourglass_top_rounded,
        'Enviando',
      ),
      _ => (ColoresGenios.turquesa, null, ''),
    };

    return Semantics(
      button: true,
      enabled: alPulsar != null,
      label: etiqueta.isEmpty ? texto : '$texto. $etiqueta',
      excludeSemantics: true,
      child: Opacity(
        opacity: estado == _EstadoOpcion.apagada ? 0.5 : 1,
        child: OutlinedButton(
          onPressed: alPulsar,
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(72),
            side: BorderSide(color: color, width: 3),
            backgroundColor: ColoresGenios.superficie,
            disabledForegroundColor: ColoresGenios.texto,
            padding: const EdgeInsets.symmetric(
              horizontal: Espaciado.l,
              vertical: Espaciado.m,
            ),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: color.withValues(alpha: 0.25),
                child: Text(letra, style: Tipografia.titulo(20, peso: 800)),
              ),
              const SizedBox(width: Espaciado.l),
              Expanded(
                child: Text(texto, style: Tipografia.texto(24, peso: 900)),
              ),
              if (icono != null) Icon(icono, color: color, size: 34),
            ],
          ),
        ),
      ),
    );
  }
}

class _Retroalimentacion extends StatelessWidget {
  const _Retroalimentacion({required this.respuesta});

  final RespuestaServidor respuesta;

  @override
  Widget build(BuildContext context) {
    final correcta = respuesta.esCorrecta;
    final color = correcta ? ColoresGenios.exito : ColoresGenios.aviso;
    final titulo = correcta ? '¡Correcto!' : 'Casi… ¡inténtalo otra vez!';
    final boton = !correcta
        ? 'INTENTAR DE NUEVO'
        : (respuesta.completaLaPartida
              ? 'VER MI RESULTADO'
              : 'SIGUIENTE PREGUNTA');

    return Semantics(
      liveRegion: true,
      child: Container(
        padding: const EdgeInsets.all(Espaciado.l),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.16),
          borderRadius: Radios.tarjeta,
          border: Border.all(color: color, width: 2.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                AstronautaGenios(
                  pose: correcta
                      ? PoseAstronauta.celebracion
                      : PoseAstronauta.espera,
                  alto: 84,
                ),
                const SizedBox(width: Espaciado.m),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(titulo, style: Tipografia.titulo(28, peso: 800)),
                      if (correcta && respuesta.puntosOtorgados > 0)
                        Text(
                          '+${respuesta.puntosOtorgados} puntos',
                          style: Tipografia.titulo(
                            24,
                            peso: 800,
                            color: ColoresGenios.amarilloEspacial,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: Espaciado.m),
            Center(
              child: BotonPrincipalJuego(
                texto: boton,
                alPulsar: () => context.read<PartidaCubit>().continuar(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
