import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../app/tema/tema_genios.dart';
import '../../../core/estado/estado_carga.dart';
import '../../../core/sesion/sesion_app.dart';
import '../../../core/widgets/fondo_espacial.dart';
import '../../../core/widgets/vistas_estado.dart';
import '../../progreso/dominio/repositorio_progreso.dart';
import '../../progreso/presentacion/insignias_jugador.dart';
import '../../progreso/presentacion/progreso_cubits.dart';
import '../dominio/modelos_catalogo.dart';
import '../dominio/repositorio_catalogo.dart';
import 'catalogo_cubits.dart';
import 'estilo_materia.dart';

/// Mapa de misiones de una materia: un camino con nodos que muestran su estado. El servidor decide cuáles se pueden jugar.
class MapaMateriaPantalla extends StatelessWidget {
  const MapaMateriaPantalla({super.key, required this.asignaturaId});

  final int asignaturaId;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (c) =>
              MapaMateriaCubit(c.read<RepositorioCatalogo>(), asignaturaId)
                ..cargar(),
        ),
        BlocProvider(
          create: (c) => ResumenJugadorCubit(
            c.read<RepositorioProgreso>(),
            c.read<FuenteModoSesion>(),
          )..cargar(),
        ),
      ],
      child: BlocBuilder<MapaMateriaCubit, EstadoCarga<MapaMateria>>(
        builder: (context, estado) {
          final titulo = estado is Cargado<MapaMateria>
              ? EstiloMateria.nombreVisible(estado.datos.asignatura.nombre)
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
                        : _Contenido(mapa: datos),
                },
              ),
            ),
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

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Align(
              alignment: Alignment.centerRight,
              child: InsigniasJugador(),
            ),
            const SizedBox(height: 8),
            _CabeceraPlaneta(
              nombre: EstiloMateria.nombreVisible(mapa.asignatura.nombre),
              estilo: estilo,
              completadas: completadas,
              total: misiones.length,
            ),
            for (final nivel in mapa.niveles.where(
              (n) => n.misiones.isNotEmpty,
            )) ...[
              Padding(
                padding: const EdgeInsets.only(top: 24, bottom: 8),
                child: Text(
                  nivel.nombre,
                  style: Theme.of(context).textTheme.titleLarge
                      ?.copyWith(color: ColoresGenios.textoSuave),
                ),
              ),
              _RutaMisiones(
                misiones: nivel.misiones,
                color: estilo.color,
                alAbrir: (m) => _abrir(context, m),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _abrir(BuildContext context, Mision mision) async {
    if (mision.estado == EstadoMision.bloqueada) {
      await showDialog<void>(
        context: context,
        builder: (_) => AlertDialog(
          icon: const Icon(Icons.lock_rounded, size: 40),
          title: const Text('Misión bloqueada'),
          content: Text(
            mision.requiereNombre == null
                ? 'Todavía no puedes jugar esta misión.'
                : 'Completa «${mision.requiereNombre}» para desbloquearla.',
          ),
          actions: [
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Entendido'),
            ),
          ],
        ),
      );
      return;
    }
    await context.push('/mision/${mision.id}', extra: mision.nombre);
    if (!context.mounted) return;
    // Al volver se recargan el mapa y las insignias: el servidor puede haber desbloqueado la siguiente misión.
    context.read<MapaMateriaCubit>().cargar();
    context.read<ResumenJugadorCubit>().cargar();
  }
}

class _CabeceraPlaneta extends StatelessWidget {
  const _CabeceraPlaneta({
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
    final textos = Theme.of(context).textTheme;
    return Semantics(
      label: '$nombre. $completadas de $total misiones completadas.',
      excludeSemantics: true,
      child: Row(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                center: const Alignment(-0.4, -0.4),
                colors: [
                  Color.lerp(estilo.color, Colors.white, 0.35)!,
                  estilo.color,
                  Color.lerp(estilo.color, Colors.black, 0.45)!,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: estilo.color.withValues(alpha: 0.45),
                  blurRadius: 18,
                ),
              ],
            ),
            child: Icon(estilo.icono, size: 36, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nombre,
                  style: textos.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: total == 0 ? 0 : completadas / total,
                    minHeight: 12,
                    color: estilo.color,
                    backgroundColor: ColoresGenios.tarjeta,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$completadas de $total misiones completadas',
                  style: textos.bodyMedium?.copyWith(
                    color: ColoresGenios.textoSuave,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Camino sinuoso que une los nodos. Es solo dibujo: la lógica de desbloqueo la decide la API.
class _RutaMisiones extends StatelessWidget {
  const _RutaMisiones({
    required this.misiones,
    required this.color,
    required this.alAbrir,
  });

  final List<Mision> misiones;
  final Color color;
  final void Function(Mision) alAbrir;

  static const double _altoFila = 180;
  static const double _diametro = 88;
  static const double _anchoNodo = 170;
  static const List<double> _desvios = [0, 0.7, 0, -0.7];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, restricciones) {
        final ancho = restricciones.maxWidth;
        final margen = _anchoNodo / 2;
        final centros = [
          for (var i = 0; i < misiones.length; i++)
            Offset(
              ancho / 2 + _desvios[i % _desvios.length] * (ancho / 2 - margen),
              16 + _diametro / 2 + i * _altoFila,
            ),
        ];
        return SizedBox(
          height: _altoFila * misiones.length + 16,
          child: Stack(
            children: [
              Positioned.fill(
                child: ExcludeSemantics(
                  child: CustomPaint(
                    painter: _PintorRuta(centros: centros, misiones: misiones),
                  ),
                ),
              ),
              for (var i = 0; i < misiones.length; i++)
                Positioned(
                  left: centros[i].dx - _anchoNodo / 2,
                  top: centros[i].dy - _diametro / 2,
                  width: _anchoNodo,
                  child: _NodoMision(
                    mision: misiones[i],
                    color: color,
                    alPulsar: () => alAbrir(misiones[i]),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _PintorRuta extends CustomPainter {
  _PintorRuta({required this.centros, required this.misiones});

  final List<Offset> centros;
  final List<Mision> misiones;

  @override
  void paint(Canvas lienzo, Size tamano) {
    for (var i = 0; i < centros.length - 1; i++) {
      final a = centros[i];
      final b = centros[i + 1];
      final dy = (b.dy - a.dy) * 0.6;
      final camino = Path()
        ..moveTo(a.dx, a.dy)
        ..cubicTo(a.dx, a.dy + dy, b.dx, b.dy - dy, b.dx, b.dy);

      final recorrido = misiones[i].estado == EstadoMision.completada;
      final pincel = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6
        ..strokeCap = StrokeCap.round
        ..color = recorrido
            ? ColoresGenios.exito
            : ColoresGenios.textoSuave.withValues(alpha: 0.55);

      if (recorrido) {
        lienzo.drawPath(camino, pincel);
      } else {
        for (final metrica in camino.computeMetrics()) {
          for (double d = 0; d < metrica.length; d += 26) {
            lienzo.drawPath(
              metrica.extractPath(d, min(d + 14, metrica.length)),
              pincel,
            );
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _PintorRuta anterior) =>
      anterior.misiones != misiones || anterior.centros != centros;
}

/// Un nodo del camino. El estado se comunica con icono y texto, no solo con color.
class _NodoMision extends StatelessWidget {
  const _NodoMision({
    required this.mision,
    required this.color,
    required this.alPulsar,
  });

  final Mision mision;
  final Color color;
  final VoidCallback alPulsar;

  @override
  Widget build(BuildContext context) {
    final (icono, colorNodo, etiqueta, detalle) = switch (mision.estado) {
      EstadoMision.bloqueada => (
        Icons.lock_rounded,
        const Color(0xFF59608F),
        'Bloqueada',
        mision.requiereNombre == null
            ? 'Aún no disponible'
            : 'Completa «${mision.requiereNombre}»',
      ),
      EstadoMision.disponible => (
        Icons.rocket_launch_rounded,
        color,
        'Disponible',
        '¡Lista para empezar!',
      ),
      EstadoMision.enProgreso => (
        Icons.play_arrow_rounded,
        ColoresGenios.aviso,
        'En progreso',
        'Sigue donde ibas',
      ),
      EstadoMision.completada => (
        Icons.star_rounded,
        ColoresGenios.exito,
        'Completada',
        '¡Misión cumplida!',
      ),
    };
    final textos = Theme.of(context).textTheme;

    return Semantics(
      button: true,
      label:
          'Misión ${mision.numeroOrden}: ${mision.nombre}. $etiqueta. $detalle',
      excludeSemantics: true,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: alPulsar,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: _RutaMisiones._diametro,
              height: _RutaMisiones._diametro,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  center: const Alignment(-0.4, -0.4),
                  colors: [
                    Color.lerp(colorNodo, Colors.white, 0.3)!,
                    colorNodo,
                    Color.lerp(colorNodo, Colors.black, 0.4)!,
                  ],
                ),
                border: Border.all(
                  color: Colors.white.withValues(
                    alpha: mision.estado == EstadoMision.bloqueada ? 0.2 : 0.8,
                  ),
                  width: 4,
                ),
                boxShadow: mision.estado == EstadoMision.bloqueada
                    ? null
                    : [
                        BoxShadow(
                          color: colorNodo.withValues(alpha: 0.5),
                          blurRadius: 20,
                        ),
                      ],
              ),
              child: Icon(icono, size: 44, color: Colors.white),
            ),
            const SizedBox(height: 6),
            Text(
              '${mision.numeroOrden}. ${mision.nombre}',
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: textos.titleSmall?.copyWith(fontWeight: FontWeight.w900),
            ),
            Text(
              etiqueta,
              style: textos.labelLarge?.copyWith(
                color: colorNodo == const Color(0xFF59608F)
                    ? ColoresGenios.textoSuave
                    : colorNodo,
                fontWeight: FontWeight.w800,
              ),
            ),
            if (mision.estado == EstadoMision.bloqueada)
              Text(
                detalle,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: textos.bodySmall?.copyWith(
                  color: ColoresGenios.textoSuave,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
