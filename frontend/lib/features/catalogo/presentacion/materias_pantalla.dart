import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/estado/estado_carga.dart';
import '../../../core/sesion/sesion_app.dart';
import '../../../diseno/componentes/icono_materia.dart';
import '../../../diseno/componentes/plantilla_pantalla.dart';
import '../../../diseno/componentes/tarjeta_materia.dart';
import '../../../diseno/componentes/vistas_estado.dart';
import '../../../diseno/tokens/medidas.dart';
import '../../progreso/dominio/modelos_progreso.dart';
import '../../progreso/dominio/repositorio_progreso.dart';
import '../../progreso/presentacion/progreso_cubits.dart';
import '../dominio/modelos_catalogo.dart';
import '../dominio/repositorio_catalogo.dart';
import 'catalogo_cubits.dart';

/// Pantalla 3: las materias del catálogo como cards. Los datos vienen de `GET /asignaturas`.
class MateriasPantalla extends StatelessWidget {
  const MateriasPantalla({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (c) => MateriasCubit(c.read<RepositorioCatalogo>())..cargar(),
        ),
        BlocProvider(
          create: (c) => ProgresoCubit(
            c.read<RepositorioProgreso>(),
            c.read<FuenteModoSesion>(),
          )..cargar(),
        ),
      ],
      child: PlantillaPantalla(
        titulo: 'Elige tu materia',
        desplazable: false,
        anchoMaximo: Anchos.cuadricula,
        hijo: BlocBuilder<MateriasCubit, EstadoCarga<List<Asignatura>>>(
          builder: (context, estado) => switch (estado) {
            Cargando() => const VistaCarga(mensaje: 'Buscando materias…'),
            Fallido(:final mensaje, :final sinConexion) => VistaError(
              mensaje: mensaje,
              sinConexion: sinConexion,
              alReintentar: context.read<MateriasCubit>().cargar,
            ),
            Cargado(:final datos) =>
              datos.isEmpty
                  ? const VistaVacia(
                      mensaje: 'Todavía no hay materias para explorar.',
                    )
                  : _Cuadricula(materias: datos),
          },
        ),
      ),
    );
  }
}

class _Cuadricula extends StatelessWidget {
  const _Cuadricula({required this.materias});

  final List<Asignatura> materias;

  @override
  Widget build(BuildContext context) {
    final progreso = context.watch<ProgresoCubit>().state;
    final materiasConProgreso =
        progreso is Cargado<VistaProgreso> &&
            progreso.datos is ProgresoEstudiante
        ? {
            for (final m in (progreso.datos as ProgresoEstudiante).materias)
              m.nombre: m,
          }
        : const <String, ProgresoMateria>{};

    return GridView.builder(
      padding: const EdgeInsets.all(Espaciado.pantalla),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 260,
        mainAxisExtent: 250,
        crossAxisSpacing: Espaciado.l,
        mainAxisSpacing: Espaciado.l,
      ),
      itemCount: materias.length,
      itemBuilder: (context, i) {
        final materia = materias[i];
        final avance = materiasConProgreso[materia.nombre];
        final tieneMisiones = avance != null && avance.categoriasTotales > 0;
        return TarjetaMateria(
          codigo: materia.codigo,
          nombre: EstiloMateria.nombreVisible(materia.nombre),
          progreso: tieneMisiones
              ? avance.categoriasCompletadas / avance.categoriasTotales
              : null,
          textoProgreso: tieneMisiones
              ? '${avance.categoriasCompletadas} de ${avance.categoriasTotales} misiones'
              : null,
          alPulsar: () async {
            await context.push('/materia/${materia.id}');
            if (context.mounted) context.read<ProgresoCubit>().cargar();
          },
        );
      },
    );
  }
}
