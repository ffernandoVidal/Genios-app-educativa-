import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../app/tema/tema_genios.dart';
import '../../../core/estado/estado_carga.dart';
import '../../../core/widgets/fondo_espacial.dart';
import '../../../core/widgets/vistas_estado.dart';
import '../dominio/modelos_catalogo.dart';
import '../dominio/repositorio_catalogo.dart';
import 'catalogo_cubits.dart';
import 'estilo_materia.dart';

/// Misiones de una materia, con el estado de cada una y lo que falta para desbloquearla.
class MapaMateriaPantalla extends StatelessWidget {
  const MapaMateriaPantalla({super.key, required this.asignaturaId});

  final int asignaturaId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          MapaMateriaCubit(context.read<RepositorioCatalogo>(), asignaturaId)
            ..cargar(),
      child: BlocBuilder<MapaMateriaCubit, EstadoCarga<MapaMateria>>(
        builder: (context, estado) {
          final titulo = estado is Cargado<MapaMateria>
              ? (EstiloMateria.de(estado.datos.asignatura.codigo).nombre ??
                    estado.datos.asignatura.nombre)
              : 'Misiones';
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                tooltip: 'Volver al universo',
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: () => context.pop(),
              ),
              title: Text(titulo),
            ),
            body: FondoEspacial(
              hijo: SafeArea(
                child: switch (estado) {
                  Cargando() => const VistaCarga(
                    mensaje: 'Preparando las misiones…',
                  ),
                  Fallido(:final mensaje, :final sinConexion) => VistaError(
                    mensaje: mensaje,
                    sinConexion: sinConexion,
                    alReintentar: context.read<MapaMateriaCubit>().cargar,
                  ),
                  Cargado(:final datos) =>
                    datos.sinMisiones
                        ? const VistaVacia(
                            mensaje: 'Este planeta todavía no tiene misiones. ¡Pronto habrá aventuras!',
                          )
                        : _ListaMisiones(mapa: datos),
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ListaMisiones extends StatelessWidget {
  const _ListaMisiones({required this.mapa});

  final MapaMateria mapa;

  @override
  Widget build(BuildContext context) {
    final estilo = EstiloMateria.de(mapa.asignatura.codigo);
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            for (final nivel in mapa.niveles.where(
              (n) => n.misiones.isNotEmpty,
            )) ...[
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 12),
                child: Text(
                  nivel.nombre,
                  style: Theme.of(context).textTheme.titleLarge
                      ?.copyWith(color: ColoresGenios.textoSuave),
                ),
              ),
              for (final mision in nivel.misiones)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: TarjetaMision(mision: mision, color: estilo.color),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Una misión. El estado se comunica con icono y texto, no solo con color.
class TarjetaMision extends StatelessWidget {
  const TarjetaMision({super.key, required this.mision, required this.color});

  final Mision mision;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final (icono, colorEstado, etiqueta, detalle) = switch (mision.estado) {
      EstadoMision.bloqueada => (
        Icons.lock_rounded,
        ColoresGenios.textoSuave,
        'Bloqueada',
        mision.requiereNombre == null
            ? 'Aún no está disponible.'
            : 'Completa «${mision.requiereNombre}» para desbloquearla.',
      ),
      EstadoMision.disponible => (
        Icons.rocket_launch_rounded,
        ColoresGenios.acento,
        'Disponible',
        '¡Lista para empezar!',
      ),
      EstadoMision.enProgreso => (
        Icons.play_circle_rounded,
        ColoresGenios.aviso,
        'En progreso',
        'Tienes una partida empezada.',
      ),
      EstadoMision.completada => (
        Icons.check_circle_rounded,
        ColoresGenios.exito,
        'Completada',
        '¡Misión cumplida!',
      ),
    };

    return Semantics(
      label:
          'Misión ${mision.numeroOrden}: ${mision.nombre}. $etiqueta. $detalle',
      excludeSemantics: true,
      child: Card(
        color: ColoresGenios.tarjeta,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: mision.estado == EstadoMision.bloqueada
                ? Colors.transparent
                : color.withValues(alpha: 0.7),
            width: 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icono, size: 40, color: colorEstado),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${mision.numeroOrden}. ${mision.nombre}',
                      style: Theme.of(context).textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      detalle,
                      style: Theme.of(context).textTheme.bodyMedium
                          ?.copyWith(color: ColoresGenios.textoSuave),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                etiqueta,
                style: Theme.of(context).textTheme.labelLarge
                    ?.copyWith(color: colorEstado, fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
