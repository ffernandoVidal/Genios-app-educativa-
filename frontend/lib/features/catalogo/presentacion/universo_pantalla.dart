import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/estado/estado_carga.dart';
import '../../../core/widgets/fondo_espacial.dart';
import '../../../core/widgets/vistas_estado.dart';
import '../../../core/sesion/sesion_app.dart';
import '../../acceso/presentacion/acceso_cubit.dart';
import '../../progreso/dominio/repositorio_progreso.dart';
import '../../progreso/presentacion/insignias_jugador.dart';
import '../../progreso/presentacion/progreso_cubits.dart';
import '../dominio/modelos_catalogo.dart';
import '../dominio/repositorio_catalogo.dart';
import 'catalogo_cubits.dart';
import 'estilo_materia.dart';

/// Pantalla principal: los planetas (materias) que se pueden explorar.
class UniversoPantalla extends StatelessWidget {
  const UniversoPantalla({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (c) => UniversoCubit(c.read<RepositorioCatalogo>())..cargar(),
        ),
        BlocProvider(
          create: (c) => ResumenJugadorCubit(
            c.read<RepositorioProgreso>(),
            c.read<FuenteModoSesion>(),
          )..cargar(),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tu universo'),
          actions: [
            IconButton(
              tooltip: 'Mi progreso',
              icon: const Icon(Icons.insights_rounded),
              onPressed: () => context.push('/progreso'),
            ),
            IconButton(
              tooltip: 'Salir',
              icon: const Icon(Icons.logout_rounded),
              onPressed: () => context.read<AccesoCubit>().salir(),
            ),
          ],
        ),
        body: FondoEspacial(
          hijo: SafeArea(
            child: BlocBuilder<UniversoCubit, EstadoCarga<List<Asignatura>>>(
              builder: (context, estado) => switch (estado) {
                Cargando() => const VistaCarga(mensaje: 'Buscando planetas…'),
                Fallido(:final mensaje, :final sinConexion) => VistaError(
                  mensaje: mensaje,
                  sinConexion: sinConexion,
                  alReintentar: context.read<UniversoCubit>().cargar,
                ),
                Cargado(:final datos) =>
                  datos.isEmpty
                      ? const VistaVacia(
                          mensaje: 'Todavía no hay planetas para explorar.',
                        )
                      : _Planetas(asignaturas: datos),
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _Planetas extends StatelessWidget {
  const _Planetas({required this.asignaturas});

  final List<Asignatura> asignaturas;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1000),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 8, 20, 0),
              child: Align(
                alignment: Alignment.centerRight,
                child: InsigniasJugador(),
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(20),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 300,
                  mainAxisExtent: 270,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: asignaturas.length,
                itemBuilder: (context, i) =>
                    _Planeta(asignatura: asignaturas[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Planeta extends StatelessWidget {
  const _Planeta({required this.asignatura});

  final Asignatura asignatura;

  @override
  Widget build(BuildContext context) {
    final estilo = EstiloMateria.de(asignatura.codigo);
    final nombre = EstiloMateria.nombreVisible(asignatura.nombre);
    return Semantics(
      button: true,
      label: 'Planeta $nombre. Toca para ver sus misiones.',
      excludeSemantics: true,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () => context.push('/materia/${asignatura.id}'),
        child: LayoutBuilder(
          builder: (context, restricciones) {
            // El planeta se adapta al ancho de la tarjeta (en móvil caben dos por fila).
            final diametro = (restricciones.maxWidth * 0.8).clamp(96.0, 140.0);
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: diametro,
                  height: diametro,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      center: const Alignment(-0.4, -0.4),
                      colors: [
                        Color.lerp(estilo.color, Colors.white, 0.35)!,
                        estilo.color,
                        Color.lerp(estilo.color, Colors.black, 0.45)!,
                      ],
                      stops: const [0.0, 0.55, 1.0],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: estilo.color.withValues(alpha: 0.45),
                        blurRadius: 24,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Icon(
                    estilo.icono,
                    size: diametro * 0.45,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                // Flexible: si el nombre es largo o el texto está ampliado, se recorta en vez de desbordar
                // (el nombre completo sigue disponible para lectores de pantalla en la etiqueta semántica).
                Flexible(
                  child: Text(
                    nombre,
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.w800),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Ver misiones',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
