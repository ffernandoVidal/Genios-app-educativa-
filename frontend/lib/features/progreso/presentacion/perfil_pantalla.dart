import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/estado/estado_carga.dart';
import '../../../core/sesion/sesion_app.dart';
import '../../../diseno/componentes/astronauta_genios.dart';
import '../../../diseno/componentes/botones_juego.dart';
import '../../../diseno/componentes/icono_materia.dart';
import '../../../diseno/componentes/plantilla_pantalla.dart';
import '../../../diseno/componentes/vistas_estado.dart';
import '../../../diseno/tokens/colores.dart';
import '../../../diseno/tokens/medidas.dart';
import '../../../diseno/tokens/tipografia.dart';
import '../dominio/modelos_progreso.dart';
import '../dominio/repositorio_progreso.dart';
import 'progreso_cubits.dart';

/// Perfil: nombre, puntos, aciertos a la primera (aparte de los reintentos), progreso por materia y partidas recientes.
/// Para un invitado muestra cuánto falta para poder crear una cuenta.
class PerfilPantalla extends StatelessWidget {
  const PerfilPantalla({super.key});

  @override
  Widget build(BuildContext context) {
    final nombre = context.read<FuenteModoSesion>().nombre;
    return BlocProvider(
      create: (c) => ProgresoCubit(
        c.read<RepositorioProgreso>(),
        c.read<FuenteModoSesion>(),
      )..cargar(),
      child: PlantillaPantalla(
        titulo: 'Perfil',
        desplazable: false,
        anchoMaximo: Anchos.contenido,
        hijo: BlocBuilder<ProgresoCubit, EstadoCarga<VistaProgreso>>(
          builder: (context, estado) => switch (estado) {
            Cargando() => const VistaCarga(mensaje: 'Contando tus estrellas…'),
            Fallido(:final mensaje, :final sinConexion) => VistaError(
              mensaje: mensaje,
              sinConexion: sinConexion,
              alReintentar: context.read<ProgresoCubit>().cargar,
            ),
            Cargado(:final datos) => switch (datos) {
              ProgresoEstudiante() => _VistaEstudiante(
                nombre: nombre,
                progreso: datos,
              ),
              ProgresoInvitado() => _VistaInvitado(
                nombre: nombre,
                progreso: datos,
              ),
            },
          },
        ),
      ),
    );
  }
}

class _Encabezado extends StatelessWidget {
  const _Encabezado({required this.nombre, required this.subtitulo});

  final String nombre;
  final String subtitulo;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const AstronautaGenios(alto: 110),
        const SizedBox(width: Espaciado.l),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Semantics(
                header: true,
                child: Text(
                  nombre,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Tipografia.titulo(32, peso: 800),
                ),
              ),
              Text(
                subtitulo,
                style: Tipografia.texto(16, color: ColoresGenios.textoSuave),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _VistaEstudiante extends StatelessWidget {
  const _VistaEstudiante({required this.nombre, required this.progreso});

  final String nombre;
  final ProgresoEstudiante progreso;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(Espaciado.pantalla),
      children: [
        _Encabezado(
          nombre: nombre,
          subtitulo: '${progreso.partidasCompletadas} partidas completadas',
        ),
        const SizedBox(height: Espaciado.l),
        _Tarjeta(
          icono: Icons.star_rounded,
          color: ColoresGenios.amarilloEspacial,
          titulo: 'Tus puntos',
          valor: '${progreso.puntosTotales}',
          detalle: 'Los puntos los calcula el servidor.',
        ),
        _Tarjeta(
          icono: Icons.bolt_rounded,
          color: ColoresGenios.turquesa,
          titulo: 'Aciertos a la primera',
          valor: '${progreso.porcentajePrimerIntento.toStringAsFixed(0)} %',
          detalle: 'Cuenta solo tu primer intento en cada pregunta.',
          detalle2: progreso.preguntasCorregidasConReintento == 0
              ? null
              : 'Con reintentos corregiste ${progreso.preguntasCorregidasConReintento} preguntas.',
        ),
        if (progreso.partidasIncompletas > 0)
          Padding(
            padding: const EdgeInsets.only(bottom: Espaciado.m),
            child: Text(
              '${progreso.partidasIncompletas} partidas quedaron sin terminar y no cuentan en tus aciertos.',
              style: Tipografia.texto(15, color: ColoresGenios.textoSuave),
            ),
          ),
        const SizedBox(height: Espaciado.s),
        Text('Tus materias', style: Tipografia.titulo(26, peso: 800)),
        const SizedBox(height: Espaciado.s),
        for (final materia in progreso.materias)
          _TarjetaMateria(materia: materia),
        const SizedBox(height: Espaciado.l),
        Text('Partidas recientes', style: Tipografia.titulo(26, peso: 800)),
        const SizedBox(height: Espaciado.s),
        if (progreso.recientes.isEmpty)
          Text(
            'Todavía no has jugado. ¡Elige una misión para empezar!',
            style: Tipografia.texto(18, color: ColoresGenios.textoSuave),
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
    return Semantics(
      label: '$titulo: $valor. $detalle ${detalle2 ?? ''}',
      excludeSemantics: true,
      child: Container(
        margin: const EdgeInsets.only(bottom: Espaciado.m),
        padding: const EdgeInsets.all(Espaciado.l),
        decoration: BoxDecoration(
          color: ColoresGenios.superficie,
          borderRadius: Radios.chip,
          border: Border.all(color: color.withValues(alpha: 0.6), width: 2),
        ),
        child: Row(
          children: [
            Icon(icono, size: 44, color: color),
            const SizedBox(width: Espaciado.l),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(titulo, style: Tipografia.texto(18, peso: 900)),
                  Text(
                    detalle,
                    style: Tipografia.texto(
                      14,
                      color: ColoresGenios.textoSuave,
                    ),
                  ),
                  if (detalle2 != null)
                    Text(
                      detalle2!,
                      style: Tipografia.texto(
                        14,
                        color: ColoresGenios.textoSuave,
                      ),
                    ),
                ],
              ),
            ),
            Text(valor, style: Tipografia.titulo(34, peso: 800, color: color)),
          ],
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
    final nombre = EstiloMateria.nombreVisible(materia.nombre);
    final sinMisiones = materia.categoriasTotales == 0;
    final detalle = sinMisiones
        ? 'Todavía no tiene misiones.'
        : '${materia.categoriasCompletadas} de ${materia.categoriasTotales} misiones completadas · ${materia.puntos} puntos';
    return Semantics(
      label: '$nombre. $detalle',
      excludeSemantics: true,
      child: Container(
        margin: const EdgeInsets.only(bottom: Espaciado.s),
        padding: const EdgeInsets.all(Espaciado.l),
        decoration: BoxDecoration(
          color: ColoresGenios.superficie,
          borderRadius: Radios.chip,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(nombre, style: Tipografia.titulo(22, peso: 800)),
            const SizedBox(height: Espaciado.s),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: sinMisiones
                    ? 0
                    : materia.categoriasCompletadas / materia.categoriasTotales,
                minHeight: 10,
                color: ColoresGenios.exito,
                backgroundColor: ColoresGenios.espacioProfundo,
              ),
            ),
            const SizedBox(height: Espaciado.xs),
            Text(
              detalle,
              style: Tipografia.texto(14, color: ColoresGenios.textoSuave),
            ),
          ],
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
    final materia = EstiloMateria.nombreVisible(partida.asignatura);
    return Semantics(
      label:
          '${partida.categoria}, $materia. $estado.${completada ? ' ${partida.aciertosPrimerIntento} aciertos de ${partida.preguntasEvaluadas} a la primera.' : ''}',
      excludeSemantics: true,
      child: Padding(
        padding: const EdgeInsets.only(bottom: Espaciado.s),
        // Material (no un contenedor con color): el ListTile pinta su fondo y su efecto de toque sobre él.
        child: Material(
          color: ColoresGenios.superficie,
          borderRadius: Radios.chip,
          clipBehavior: Clip.antiAlias,
          child: ListTile(
            leading: Icon(icono, color: color, size: 34),
            title: Text(
              '${partida.categoria} · $materia',
              style: Tipografia.texto(17, peso: 900),
            ),
            subtitle: Text(
              completada
                  ? '$estado · ${partida.aciertosPrimerIntento} de ${partida.preguntasEvaluadas} a la primera'
                  : estado,
              style: Tipografia.texto(14, color: ColoresGenios.textoSuave),
            ),
            trailing: Text(
              '+${partida.puntos}',
              style: Tipografia.titulo(
                22,
                peso: 800,
                color: ColoresGenios.amarilloEspacial,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _VistaInvitado extends StatelessWidget {
  const _VistaInvitado({required this.nombre, required this.progreso});

  final String nombre;
  final ProgresoInvitado progreso;

  @override
  Widget build(BuildContext context) {
    final falta = (progreso.partidasRequeridas - progreso.partidasQueCuentan)
        .clamp(0, progreso.partidasRequeridas);
    return ListView(
      padding: const EdgeInsets.all(Espaciado.pantalla),
      children: [
        _Encabezado(nombre: nombre, subtitulo: 'Jugando como invitado'),
        const SizedBox(height: Espaciado.l),
        Semantics(
          label:
              'Llevas ${progreso.partidasQueCuentan} de ${progreso.partidasRequeridas} partidas buenas.',
          excludeSemantics: true,
          child: Container(
            padding: const EdgeInsets.all(Espaciado.xl),
            decoration: BoxDecoration(
              color: ColoresGenios.superficie,
              borderRadius: Radios.tarjeta,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Partidas buenas: ${progreso.partidasQueCuentan} de ${progreso.partidasRequeridas}',
                  style: Tipografia.titulo(24, peso: 800),
                ),
                const SizedBox(height: Espaciado.m),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value:
                        progreso.partidasQueCuentan /
                        progreso.partidasRequeridas,
                    minHeight: 14,
                    color: ColoresGenios.amarilloEspacial,
                    backgroundColor: ColoresGenios.espacioProfundo,
                  ),
                ),
                const SizedBox(height: Espaciado.m),
                Text(
                  progreso.invitarARegistrarse
                      ? '¡Lo lograste! Ya puedes crear tu cuenta.'
                      : 'Te faltan $falta partidas buenas para poder crear tu cuenta. Una partida es buena cuando aciertas casi todo a la primera.',
                  style: Tipografia.texto(17, color: ColoresGenios.textoSuave),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: Espaciado.m),
        Text(
          progreso.aviso,
          style: Tipografia.texto(15, color: ColoresGenios.textoSuave),
        ),
        if (progreso.invitarARegistrarse) ...[
          const SizedBox(height: Espaciado.xl),
          Center(
            child: BotonPrincipalJuego(
              texto: 'CREAR MI CUENTA',
              icono: Icons.rocket_launch_rounded,
              alPulsar: () => context.push('/registro'),
            ),
          ),
        ],
      ],
    );
  }
}
