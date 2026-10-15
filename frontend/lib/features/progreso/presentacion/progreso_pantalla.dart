import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../app/tema/tema_genios.dart';
import '../../../core/estado/estado_carga.dart';
import '../../../core/sesion/sesion_app.dart';
import '../../../core/widgets/fondo_espacial.dart';
import '../../../core/widgets/vistas_estado.dart';
import '../../catalogo/presentacion/estilo_materia.dart';
import '../dominio/modelos_progreso.dart';
import '../dominio/repositorio_progreso.dart';
import 'progreso_cubits.dart';

/// "Mi progreso": puntos, aciertos al primer intento (aparte de los reintentos), materias y partidas recientes.
/// Para un invitado muestra cuánto falta para poder crear una cuenta.
class ProgresoPantalla extends StatelessWidget {
  const ProgresoPantalla({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (c) => ProgresoCubit(
        c.read<RepositorioProgreso>(),
        c.read<FuenteModoSesion>(),
      )..cargar(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            tooltip: 'Volver',
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => context.pop(),
          ),
          title: const Text('Mi progreso'),
        ),
        body: FondoEspacial(
          hijo: SafeArea(
            child: BlocBuilder<ProgresoCubit, EstadoCarga<VistaProgreso>>(
              builder: (context, estado) => switch (estado) {
                Cargando() => const VistaCarga(
                  mensaje: 'Contando tus estrellas…',
                ),
                Fallido(:final mensaje, :final sinConexion) => VistaError(
                  mensaje: mensaje,
                  sinConexion: sinConexion,
                  alReintentar: context.read<ProgresoCubit>().cargar,
                ),
                Cargado(:final datos) => Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 640),
                    child: switch (datos) {
                      ProgresoEstudiante() => _VistaEstudiante(progreso: datos),
                      ProgresoInvitado() => _VistaInvitado(progreso: datos),
                    },
                  ),
                ),
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _VistaEstudiante extends StatelessWidget {
  const _VistaEstudiante({required this.progreso});

  final ProgresoEstudiante progreso;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _Tarjeta(
          icono: Icons.star_rounded,
          color: ColoresGenios.acento,
          titulo: 'Tus puntos',
          valor: '${progreso.puntosTotales}',
          detalle: '${progreso.partidasCompletadas} partidas completadas',
        ),
        _Tarjeta(
          icono: Icons.bolt_rounded,
          color: ColoresGenios.exito,
          titulo: 'Aciertos a la primera',
          valor: '${progreso.porcentajePrimerIntento.toStringAsFixed(0)} %',
          detalle: 'Cuenta solo tu primer intento en cada pregunta.',
          detalle2: progreso.preguntasCorregidasConReintento == 0
              ? null
              : 'Además, corregiste ${progreso.preguntasCorregidasConReintento} preguntas al intentarlo otra vez.',
        ),
        if (progreso.partidasIncompletas > 0)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              '${progreso.partidasIncompletas} partidas quedaron sin terminar y no cuentan en tus aciertos.',
              style: textos.bodyMedium?.copyWith(
                color: ColoresGenios.textoSuave,
              ),
            ),
          ),
        const SizedBox(height: 8),
        Text(
          'Tus planetas',
          style: textos.titleLarge?.copyWith(fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 8),
        for (final materia in progreso.materias)
          _TarjetaMateria(materia: materia),
        const SizedBox(height: 16),
        Text(
          'Partidas recientes',
          style: textos.titleLarge?.copyWith(fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 8),
        if (progreso.recientes.isEmpty)
          Text(
            'Todavía no has jugado. ¡Elige una misión para empezar!',
            style: textos.bodyLarge?.copyWith(color: ColoresGenios.textoSuave),
          )
        else
          for (final partida in progreso.recientes)
            _FilaPartida(partida: partida),
      ],
    );
  }
}

class _Tarjeta extends StatelessWidget {
  const _Tarjeta({
    required this.icono,
    required this.color,
    required this.titulo,
    required this.valor,
    required this.detalle,
    this.detalle2,
  });

  final IconData icono;
  final Color color;
  final String titulo;
  final String valor;
  final String detalle;
  final String? detalle2;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    return Semantics(
      label: '$titulo: $valor. $detalle ${detalle2 ?? ''}',
      excludeSemantics: true,
      child: Card(
        color: ColoresGenios.tarjeta,
        margin: const EdgeInsets.only(bottom: 12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icono, size: 44, color: color),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(titulo, style: textos.titleMedium),
                    Text(
                      detalle,
                      style: textos.bodyMedium?.copyWith(
                        color: ColoresGenios.textoSuave,
                      ),
                    ),
                    if (detalle2 != null)
                      Text(
                        detalle2!,
                        style: textos.bodyMedium?.copyWith(
                          color: ColoresGenios.textoSuave,
                        ),
                      ),
                  ],
                ),
              ),
              Text(
                valor,
                style: textos.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TarjetaMateria extends StatelessWidget {
  const _TarjetaMateria({required this.materia});

  final ProgresoMateria materia;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final nombre = EstiloMateria.nombreVisible(materia.nombre);
    final sinMisiones = materia.categoriasTotales == 0;
    final detalle = sinMisiones
        ? 'Todavía no tiene misiones.'
        : '${materia.categoriasCompletadas} de ${materia.categoriasTotales} misiones completadas · ${materia.puntos} puntos';
    return Semantics(
      label: '$nombre. $detalle',
      excludeSemantics: true,
      child: Card(
        color: ColoresGenios.tarjeta,
        margin: const EdgeInsets.only(bottom: 10),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                nombre,
                style: textos.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: sinMisiones
                      ? 0
                      : materia.categoriasCompletadas /
                            materia.categoriasTotales,
                  minHeight: 10,
                  color: ColoresGenios.exito,
                  backgroundColor: ColoresGenios.espacioProfundo,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                detalle,
                style: textos.bodyMedium?.copyWith(
                  color: ColoresGenios.textoSuave,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilaPartida extends StatelessWidget {
  const _FilaPartida({required this.partida});

  final PartidaReciente partida;

  @override
  Widget build(BuildContext context) {
    final (icono, color, estado) = switch (partida.estado) {
      'completada' => (
        Icons.check_circle_rounded,
        ColoresGenios.exito,
        'Completada',
      ),
      'tiempo_agotado' => (
        Icons.local_fire_department_rounded,
        ColoresGenios.error,
        'Se acabó la mecha',
      ),
      'en_curso' => (
        Icons.play_circle_rounded,
        ColoresGenios.aviso,
        'En curso',
      ),
      _ => (
        Icons.pause_circle_rounded,
        ColoresGenios.textoSuave,
        'Sin terminar',
      ),
    };
    final completada = partida.estado == 'completada';
    return Semantics(
      label:
          '${partida.categoria}, ${EstiloMateria.nombreVisible(partida.asignatura)}. $estado.${completada ? ' ${partida.aciertosPrimerIntento} aciertos de ${partida.preguntasEvaluadas} a la primera.' : ''}',
      excludeSemantics: true,
      child: Card(
        color: ColoresGenios.tarjeta,
        margin: const EdgeInsets.only(bottom: 8),
        child: ListTile(
          leading: Icon(icono, color: color, size: 32),
          title: Text(
            '${partida.categoria} · ${EstiloMateria.nombreVisible(partida.asignatura)}',
          ),
          subtitle: Text(
            completada
                ? '$estado · ${partida.aciertosPrimerIntento} de ${partida.preguntasEvaluadas} a la primera'
                : estado,
          ),
          trailing: Text(
            '+${partida.puntos}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: ColoresGenios.acento,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}

class _VistaInvitado extends StatelessWidget {
  const _VistaInvitado({required this.progreso});

  final ProgresoInvitado progreso;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final falta = (progreso.partidasRequeridas - progreso.partidasQueCuentan)
        .clamp(0, progreso.partidasRequeridas);
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Semantics(
          label:
              'Llevas ${progreso.partidasQueCuentan} de ${progreso.partidasRequeridas} partidas buenas.',
          excludeSemantics: true,
          child: Card(
            color: ColoresGenios.tarjeta,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Estás jugando como invitado',
                    style: textos.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Partidas buenas: ${progreso.partidasQueCuentan} de ${progreso.partidasRequeridas}',
                    style: textos.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value:
                          progreso.partidasQueCuentan /
                          progreso.partidasRequeridas,
                      minHeight: 12,
                      color: ColoresGenios.acento,
                      backgroundColor: ColoresGenios.espacioProfundo,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    progreso.invitarARegistrarse
                        ? '¡Lo lograste! Ya puedes crear tu cuenta.'
                        : 'Te faltan $falta partidas buenas para poder crear tu cuenta. Una partida es buena cuando aciertas casi todo a la primera.',
                    style: textos.bodyLarge?.copyWith(
                      color: ColoresGenios.textoSuave,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          progreso.aviso,
          style: textos.bodyMedium?.copyWith(color: ColoresGenios.textoSuave),
        ),
        if (progreso.invitarARegistrarse) ...[
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => context.push('/registro'),
            icon: const Icon(Icons.rocket_launch_rounded),
            label: const Text('Crear mi cuenta'),
          ),
        ],
      ],
    );
  }
}
