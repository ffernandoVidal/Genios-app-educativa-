import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/estado/estado_carga.dart';
import '../../../diseno/componentes/icono_materia.dart';
import '../../../diseno/componentes/plantilla_pantalla.dart';
import '../../../diseno/componentes/vistas_estado.dart';
import '../../../diseno/tokens/colores.dart';
import '../../../diseno/tokens/medidas.dart';
import '../../../diseno/tokens/tipografia.dart';
import '../../partida/dominio/argumentos_mision.dart';
import '../dominio/modelos_catalogo.dart';
import '../dominio/repositorio_catalogo.dart';
import 'catalogo_cubits.dart';
import 'ruta_misiones.dart';

/// Pantalla 4: niveles y misiones de una materia, con el estado de cada una y lo que falta para desbloquearla.
class MisionesPantalla extends StatelessWidget {
  const MisionesPantalla({super.key, required this.asignaturaId});

  final int asignaturaId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (c) =>
          MisionesCubit(c.read<RepositorioCatalogo>(), asignaturaId)..cargar(),
      child: BlocBuilder<MisionesCubit, EstadoCarga<MapaMateria>>(
        builder: (context, estado) {
          final titulo = estado is Cargado<MapaMateria>
              ? EstiloMateria.nombreVisible(estado.datos.asignatura.nombre)
              : 'Misiones';
          return PlantillaPantalla(
            titulo: titulo,
            desplazable: false,
            anchoMaximo: Anchos.contenido,
            hijo: switch (estado) {
              Cargando() => const VistaCarga(
                mensaje: 'Preparando las misiones…',
              ),
              Fallido(:final mensaje, :final sinConexion) => VistaError(
                mensaje: mensaje,
                sinConexion: sinConexion,
                alReintentar: context.read<MisionesCubit>().cargar,
              ),
              Cargado(:final datos) =>
                datos.sinMisiones
                    ? const VistaVacia(
                        mensaje: 'Esta materia todavía no tiene misiones. ¡Pronto habrá aventuras!',
                      )
                    : _Contenido(mapa: datos),
            },
          );
        },
      ),
    );
  }
}

class _Contenido extends StatelessWidget {
  const _Contenido({required this.mapa});

  final MapaMateria mapa;

  @override
  Widget build(BuildContext context) {
    final estilo = EstiloMateria.de(mapa.asignatura.codigo);
    final misiones = mapa.niveles.expand((n) => n.misiones).toList();
    final completadas = misiones
        .where((m) => m.estado == EstadoMision.completada)
        .length;

    return ListView(
      padding: const EdgeInsets.all(Espaciado.pantalla),
      children: [
        _Cabecera(
          nombre: EstiloMateria.nombreVisible(mapa.asignatura.nombre),
          estilo: estilo,
          completadas: completadas,
          total: misiones.length,
        ),
        for (final nivel in mapa.niveles.where(
          (n) => n.misiones.isNotEmpty,
        )) ...[
          Padding(
            padding: const EdgeInsets.only(
              top: Espaciado.xl,
              bottom: Espaciado.s,
            ),
            child: Text(
              nivel.nombre,
              style: Tipografia.titulo(24, color: ColoresGenios.textoSuave),
            ),
          ),
          RutaMisiones(
            misiones: nivel.misiones,
            color: estilo.color,
            alPulsar: (m) => _abrir(context, m),
          ),
        ],
      ],
    );
  }

  Future<void> _abrir(BuildContext context, Mision mision) async {
    // Un nodo bloqueado solo explica qué falta; el servidor también rechazaría iniciarlo.
    if (mision.estado == EstadoMision.bloqueada) {
      await showDialog<void>(
        context: context,
        builder: (dialogo) => AlertDialog(
          icon: const Icon(
            Icons.lock_rounded,
            size: 44,
            color: ColoresGenios.amarilloEspacial,
          ),
          title: const Text('Misión bloqueada'),
          content: Text(
            mision.requiereNombre == null
                ? 'Todavía no puedes jugar esta misión.'
                : 'Completa «${mision.requiereNombre}» para desbloquearla.',
          ),
          actions: [
            FilledButton(
              onPressed: () => Navigator.of(dialogo).pop(),
              child: const Text('Entendido'),
            ),
          ],
        ),
      );
      return;
    }
    await context.push(
      '/mision/${mision.id}',
      extra: ArgumentosMision(
        nombre: mision.nombre,
        asignaturaId: mapa.asignatura.id,
      ),
    );
    if (!context.mounted) return;
    // Al volver se recarga el mapa: el servidor pudo desbloquear la siguiente misión.
    context.read<MisionesCubit>().cargar();
  }
}

class _Cabecera extends StatelessWidget {
  const _Cabecera({
    required this.nombre,
    required this.estilo,
    required this.completadas,
    required this.total,
  });

  final String nombre;
  final EstiloMateria estilo;
  final int completadas;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$nombre. $completadas de $total misiones completadas.',
      excludeSemantics: true,
      child: Row(
        children: [
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: estilo.color,
              boxShadow: Sombras.elevada(estilo.color),
            ),
            child: Center(child: IconoMateria(tipo: estilo.tipo, tamano: 46)),
          ),
          const SizedBox(width: Espaciado.l),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(nombre, style: Tipografia.titulo(26, peso: 800)),
                const SizedBox(height: Espaciado.s),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: total == 0 ? 0 : completadas / total,
                    minHeight: 12,
                    color: ColoresGenios.amarilloEspacial,
                    backgroundColor: ColoresGenios.superficieOscura,
                  ),
                ),
                const SizedBox(height: Espaciado.xs),
                Text(
                  '$completadas de $total misiones completadas',
                  style: Tipografia.texto(15, color: ColoresGenios.textoSuave),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
