import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../app/tema/tema_genios.dart';
import '../../../core/widgets/fondo_espacial.dart';
import '../../../core/widgets/vistas_estado.dart';
import '../dominio/modelos_partida.dart';
import '../dominio/repositorio_partida.dart';
import 'partida_cubit.dart';

/// Una misión: diez preguntas. El servidor decide si cada respuesta es correcta, los puntos y el resultado.
class PartidaPantalla extends StatelessWidget {
  const PartidaPantalla({
    super.key,
    required this.categoriaId,
    this.nombreMision,
  });

  final int categoriaId;
  final String? nombreMision;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          PartidaCubit(context.read<RepositorioPartida>())
            ..iniciar(categoriaId),
      child: _VistaPartida(
        categoriaId: categoriaId,
        nombreMision: nombreMision,
      ),
    );
  }
}

class _VistaPartida extends StatefulWidget {
  const _VistaPartida({required this.categoriaId, this.nombreMision});

  final int categoriaId;
  final String? nombreMision;

  @override
  State<_VistaPartida> createState() => _VistaPartidaState();
}

class _VistaPartidaState extends State<_VistaPartida> {
  // Una vez confirmada la salida, el PopScope deja de bloquear para que el pop real no se vuelva a interceptar.
  bool _salidaConfirmada = false;

  bool _puedeSalirSinPreguntar(EstadoPartida e) =>
      _salidaConfirmada ||
      e.fase == FasePartida.terminada ||
      e.fase == FasePartida.error ||
      e.fase == FasePartida.cargando;

  Future<void> _preguntarYSalir() async {
    final cubit = context.read<PartidaCubit>();
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogo) => AlertDialog(
        title: const Text('¿Salir de la misión?'),
        content: const Text('Tu partida quedará sin terminar.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogo).pop(false),
            child: const Text('Seguir jugando'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogo).pop(true),
            child: const Text('Salir'),
          ),
        ],
      ),
    );
    if (confirmar != true || !mounted) return;
    await cubit.abandonar();
    if (!mounted) return;
    setState(() => _salidaConfirmada = true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.pop();
    });
  }

  void _alPulsarCerrar(EstadoPartida estado) {
    if (_puedeSalirSinPreguntar(estado)) {
      context.pop();
    } else {
      _preguntarYSalir();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PartidaCubit, EstadoPartida>(
      builder: (context, estado) => PopScope(
        canPop: _puedeSalirSinPreguntar(estado),
        onPopInvokedWithResult: (salio, _) {
          if (!salio) _preguntarYSalir();
        },
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              tooltip: 'Salir de la misión',
              icon: const Icon(Icons.close_rounded),
              onPressed: () => _alPulsarCerrar(estado),
            ),
            title: Text(widget.nombreMision ?? 'Misión'),
          ),
          body: FondoEspacial(
            hijo: SafeArea(
              child: switch (estado.fase) {
                FasePartida.cargando => const VistaCarga(
                  mensaje: 'Preparando tu misión…',
                ),
                FasePartida.error => _VistaFallo(estado: estado),
                FasePartida.terminada => _VistaResultado(
                  resultado: estado.resultado!,
                  categoriaId: widget.categoriaId,
                  nombreMision: widget.nombreMision,
                ),
                _ => _VistaPregunta(estado: estado),
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _VistaFallo extends StatelessWidget {
  const _VistaFallo({required this.estado});

  final EstadoPartida estado;

  @override
  Widget build(BuildContext context) {
    if (estado.puedeReintentarCarga) {
      return VistaError(
        mensaje: estado.mensajeError ?? 'Algo salió mal.',
        sinConexion: true,
        alReintentar: context.read<PartidaCubit>().reintentarCarga,
      );
    }
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.info_outline_rounded,
              size: 64,
              color: ColoresGenios.aviso,
            ),
            const SizedBox(height: 16),
            Text(
              estado.mensajeError ?? 'No pudimos empezar la misión.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.map_rounded),
              label: const Text('Volver al mapa'),
            ),
          ],
        ),
      ),
    );
  }
}

class _VistaPregunta extends StatelessWidget {
  const _VistaPregunta({required this.estado});

  final EstadoPartida estado;

  @override
  Widget build(BuildContext context) {
    final partida = estado.partida!;
    final pregunta = partida.pregunta!;
    final textos = Theme.of(context).textTheme;
    final respondida = estado.fase == FasePartida.retroalimentacion;
    final bloqueada = estado.fase != FasePartida.pregunta;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Semantics(
              label:
                  'Pregunta ${partida.numeroPregunta} de ${partida.totalPreguntas}',
              excludeSemantics: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pregunta ${partida.numeroPregunta} de ${partida.totalPreguntas}',
                    style: textos.titleMedium?.copyWith(
                      color: ColoresGenios.textoSuave,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value:
                          (partida.numeroPregunta - 1) / partida.totalPreguntas,
                      minHeight: 12,
                      color: ColoresGenios.acento,
                      backgroundColor: ColoresGenios.tarjeta,
                    ),
                  ),
                ],
              ),
            ),
            if (estado.segundosMecha != null) ...[
              const SizedBox(height: 16),
              _Mecha(segundos: estado.segundosMecha!),
            ],
            const SizedBox(height: 20),
            Card(
              color: ColoresGenios.tarjeta,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Semantics(
                  header: true,
                  child: Text(
                    pregunta.enunciado,
                    textAlign: TextAlign.center,
                    style: textos.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            for (final opcion in pregunta.opciones)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _BotonOpcion(
                  texto: opcion.texto,
                  estado: _estadoDe(opcion, estado),
                  alPulsar: bloqueada
                      ? null
                      : () => context.read<PartidaCubit>().responder(opcion.id),
                ),
              ),
            if (estado.aviso != null)
              Semantics(
                liveRegion: true,
                child: Text(
                  estado.aviso!,
                  textAlign: TextAlign.center,
                  style: textos.titleMedium?.copyWith(
                    color: ColoresGenios.aviso,
                  ),
                ),
              ),
            if (respondida) ...[
              const SizedBox(height: 8),
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

class _Mecha extends StatelessWidget {
  const _Mecha({required this.segundos});

  final int segundos;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label:
          'La mecha se acaba en $segundos segundos. Responde bien antes de que explote.',
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: ColoresGenios.error.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: ColoresGenios.error, width: 2),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.local_fire_department_rounded,
              color: ColoresGenios.error,
              size: 36,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '¡La mecha se acaba en $segundos s! Acierta antes de que explote.',
                style: Theme.of(context).textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w800),
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
    required this.texto,
    required this.estado,
    required this.alPulsar,
  });

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
        ColoresGenios.acento,
        Icons.hourglass_top_rounded,
        'Enviando',
      ),
      _ => (ColoresGenios.textoSuave, null, ''),
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
            minimumSize: const Size.fromHeight(68),
            side: BorderSide(color: color, width: 3),
            backgroundColor: ColoresGenios.tarjeta,
            disabledForegroundColor: ColoresGenios.texto,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  texto,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              if (icono != null) Icon(icono, color: color, size: 32),
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
    final textos = Theme.of(context).textTheme;
    final correcta = respuesta.esCorrecta;
    final color = correcta ? ColoresGenios.exito : ColoresGenios.aviso;
    final titulo = correcta ? '¡Correcto!' : 'Casi… ¡inténtalo otra vez!';
    final boton = !correcta
        ? 'Intentar de nuevo'
        : (respuesta.completaLaPartida
              ? 'Ver mi resultado'
              : 'Siguiente pregunta');

    return Semantics(
      liveRegion: true,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color, width: 2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(
                  correcta
                      ? Icons.celebration_rounded
                      : Icons.lightbulb_rounded,
                  color: color,
                  size: 36,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    titulo,
                    style: textos.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                if (correcta && respuesta.puntosOtorgados > 0)
                  Text(
                    '+${respuesta.puntosOtorgados} puntos',
                    style: textos.titleLarge?.copyWith(
                      color: ColoresGenios.acento,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => context.read<PartidaCubit>().continuar(),
              child: Text(boton),
            ),
          ],
        ),
      ),
    );
  }
}

class _VistaResultado extends StatelessWidget {
  const _VistaResultado({
    required this.resultado,
    required this.categoriaId,
    this.nombreMision,
  });

  final ResultadoPartida resultado;
  final int categoriaId;
  final String? nombreMision;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final porMecha = resultado.terminoPorMecha;
    final titulo = porMecha
        ? '¡Boom! Se acabó el tiempo'
        : (resultado.categoriaCompletada
              ? '¡Misión completada!'
              : '¡Buen intento!');
    final icono = porMecha
        ? Icons.local_fire_department_rounded
        : Icons.emoji_events_rounded;
    final color = porMecha ? ColoresGenios.error : ColoresGenios.acento;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: ListView(
          padding: const EdgeInsets.all(24),
          shrinkWrap: true,
          children: [
            ExcludeSemantics(child: Icon(icono, size: 96, color: color)),
            const SizedBox(height: 12),
            Semantics(
              header: true,
              liveRegion: true,
              child: Text(
                titulo,
                textAlign: TextAlign.center,
                style: textos.displaySmall?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(height: 8),
            if (porMecha)
              Text(
                'La mecha se agotó antes de acertar. ¡Puedes intentarlo otra vez!',
                textAlign: TextAlign.center,
                style: textos.titleMedium?.copyWith(
                  color: ColoresGenios.textoSuave,
                ),
              ),
            const SizedBox(height: 24),
            _Dato(
              icono: Icons.star_rounded,
              etiqueta: 'Puntos ganados',
              valor: '+${resultado.puntosObtenidos}',
            ),
            if (!porMecha) ...[
              _Dato(
                icono: Icons.bolt_rounded,
                etiqueta: 'Aciertos a la primera',
                valor:
                    '${resultado.aciertosPrimerIntento} de ${resultado.preguntasEvaluadas}  (${resultado.porcentajeAciertos.toStringAsFixed(0)} %)',
              ),
            ],
            const SizedBox(height: 28),
            FilledButton.icon(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.map_rounded),
              label: const Text('Volver al mapa'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => context.pushReplacement(
                '/mision/$categoriaId',
                extra: nombreMision,
              ),
              icon: const Icon(Icons.replay_rounded),
              label: const Text('Jugar otra vez'),
            ),
          ],
        ),
      ),
    );
  }
}

class _Dato extends StatelessWidget {
  const _Dato({
    required this.icono,
    required this.etiqueta,
    required this.valor,
  });

  final IconData icono;
  final String etiqueta;
  final String valor;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$etiqueta: $valor',
      excludeSemantics: true,
      child: Card(
        color: ColoresGenios.tarjeta,
        child: ListTile(
          leading: Icon(icono, color: ColoresGenios.acento, size: 36),
          title: Text(etiqueta),
          trailing: Text(
            valor,
            style: Theme.of(context).textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.w900),
          ),
        ),
      ),
    );
  }
}
