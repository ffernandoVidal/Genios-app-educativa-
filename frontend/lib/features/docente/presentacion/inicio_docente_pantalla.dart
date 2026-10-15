import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/estado/estado_carga.dart';
import '../../../core/sesion/sesion_app.dart';
import '../../../diseno/componentes/astronauta_genios.dart';
import '../../../diseno/componentes/botones_juego.dart';
import '../../../diseno/componentes/vistas_estado.dart';
import '../../../diseno/tokens/colores.dart';
import '../../../diseno/tokens/medidas.dart';
import '../../../diseno/tokens/tipografia.dart';
import '../../cabina/presentacion/ventana_cabina.dart';
import '../dominio/repositorio_docente.dart';
import 'componentes/componentes_docente.dart';
import 'cubits_docente.dart';

/// Cabina docente: saludo con la mascota, indicadores reales y accesos rápidos.
class InicioDocentePantalla extends StatelessWidget {
  const InicioDocentePantalla({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (c) => ResumenCubit(c.read<RepositorioDocente>())..cargar(),
      child: const _VistaInicio(),
    );
  }
}

class _VistaInicio extends StatelessWidget {
  const _VistaInicio();

  @override
  Widget build(BuildContext context) {
    final nombre = context.read<FuenteModoSesion>().nombre;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Cabina(nombre: nombre),
          const SizedBox(height: Espaciado.xl),
          BlocBuilder<ResumenCubit, EstadoCarga<ResumenDocente>>(
            builder: (context, estado) => switch (estado) {
              Cargando() => const SizedBox(
                height: 160,
                child: VistaCarga(mensaje: 'Cargando tu resumen…'),
              ),
              Fallido(:final mensaje, :final sinConexion) => SizedBox(
                height: 280,
                child: VistaError(
                  mensaje: mensaje,
                  sinConexion: sinConexion,
                  alReintentar: context.read<ResumenCubit>().cargar,
                ),
              ),
              Cargado(:final datos) => _Indicadores(datos: datos),
            },
          ),
          const SizedBox(height: Espaciado.xl),
          const _AccesosRapidos(),
        ],
      ),
    );
  }
}

class _Cabina extends StatelessWidget {
  const _Cabina({required this.nombre});

  final String nombre;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ColoresGenios.azulPetroleo,
      borderRadius: Radios.tarjeta,
      child: Padding(
        padding: const EdgeInsets.all(Espaciado.xl),
        child: Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: Espaciado.xl,
          runSpacing: Espaciado.l,
          children: [
            SizedBox(
              width: 180,
              height: 170,
              child: Stack(
                alignment: Alignment.center,
                children: const [
                  VentanaCabina(diametro: 170),
                  AstronautaGenios(pose: PoseAstronauta.saludo, alto: 150),
                ],
              ),
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '¡Hola, $nombre!',
                    style: Tipografia.titulo(32, peso: 800),
                  ),
                  const SizedBox(height: Espaciado.s),
                  Text(
                    'Esta es tu cabina de control. Aquí ves cómo avanzan tus estudiantes, con datos reales de sus partidas.',
                    style: Tipografia.texto(
                      18,
                      color: ColoresGenios.textoSuave,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Indicadores extends StatelessWidget {
  const _Indicadores({required this.datos});

  final ResumenDocente datos;

  @override
  Widget build(BuildContext context) {
    final sinActividad = datos.partidasCompletadas == 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CuadriculaAdaptable(
          hijos: [
            TarjetaIndicador(
              icono: Icons.school_rounded,
              titulo: 'Clases activas',
              valor: '${datos.clasesActivas}',
            ),
            TarjetaIndicador(
              icono: Icons.groups_rounded,
              titulo: 'Estudiantes asignados',
              valor: '${datos.estudiantesAsignados}',
              color: ColoresGenios.amarilloEspacial,
            ),
            TarjetaIndicador(
              icono: Icons.bolt_rounded,
              titulo: 'Con actividad reciente',
              valor: '${datos.estudiantesActivosRecientes}',
              detalle: 'Últimos 7 días',
              color: ColoresRendimiento.aprobado,
            ),
            TarjetaIndicador(
              icono: Icons.percent_rounded,
              titulo: 'Promedio de aciertos',
              valor: textoPorcentaje(datos.promedioAciertos),
              detalle: sinActividad
                  ? 'Sin actividad en este período'
                  : datos.rendimiento.etiqueta,
              color: datos.rendimiento.color,
            ),
            TarjetaIndicador(
              icono: Icons.sports_esports_rounded,
              titulo: 'Partidas completadas',
              valor: '${datos.partidasCompletadas}',
              detalle: 'Últimos 30 días',
              color: const Color(0xFFC084FC),
            ),
          ],
        ),
        if (datos.clasesActivas == 0)
          Padding(
            padding: const EdgeInsets.only(top: Espaciado.l),
            child: Text(
              'Todavía no tienes clases. Crea la primera para obtener su código y empezar a sumar estudiantes.',
              style: Tipografia.texto(18, color: ColoresGenios.textoSuave),
            ),
          ),
      ],
    );
  }
}

class _AccesosRapidos extends StatelessWidget {
  const _AccesosRapidos();

  @override
  Widget build(BuildContext context) {
    return Bloque(
      titulo: 'Accesos rápidos',
      hijo: Wrap(
        spacing: Espaciado.m,
        runSpacing: Espaciado.m,
        children: [
          BotonPrincipalJuego(
            texto: 'CREAR CLASE',
            icono: Icons.add_circle_rounded,
            alPulsar: () => context.go('/docente/clases/nueva'),
          ),
          BotonSecundarioJuego(
            texto: 'CREAR ALUMNO',
            icono: Icons.person_add_alt_1_rounded,
            alPulsar: () => context.go('/docente/alumnos/nuevo'),
          ),
          BotonSecundarioJuego(
            texto: 'VER ALUMNOS',
            icono: Icons.groups_rounded,
            alPulsar: () => context.go('/docente/alumnos'),
          ),
          BotonSecundarioJuego(
            texto: 'ESTADÍSTICAS',
            icono: Icons.bar_chart_rounded,
            alPulsar: () => context.go('/docente/estadisticas'),
          ),
        ],
      ),
    );
  }
}
