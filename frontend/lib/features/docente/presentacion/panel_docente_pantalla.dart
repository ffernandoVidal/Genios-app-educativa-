import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/sesion/sesion_app.dart';
import '../../../diseno/componentes/botones_juego.dart';
import '../../../diseno/componentes/campo_genios.dart';
import '../../../diseno/componentes/plantilla_pantalla.dart';
import '../../../diseno/componentes/vistas_estado.dart';
import '../../../diseno/tokens/colores.dart';
import '../../../diseno/tokens/medidas.dart';
import '../../../diseno/tokens/tipografia.dart';
import '../../acceso/presentacion/acceso_cubit.dart';
import '../../catalogo/dominio/repositorio_catalogo.dart';
import '../../../diseno/componentes/icono_materia.dart';
import '../dominio/repositorio_docente.dart';
import 'docente_cubit.dart';

/// Panel del docente: aulas, código de acceso, estudiantes y alta de estudiantes.
/// Está separado de la experiencia infantil. Toda la autorización la decide la API.
class PanelDocentePantalla extends StatelessWidget {
  const PanelDocentePantalla({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (c) => DocenteCubit(
        c.read<RepositorioDocente>(),
        c.read<RepositorioCatalogo>(),
      )..cargar(),
      child: const _VistaPanel(),
    );
  }
}

class _VistaPanel extends StatefulWidget {
  const _VistaPanel();

  @override
  State<_VistaPanel> createState() => _VistaPanelState();
}

class _VistaPanelState extends State<_VistaPanel> {
  final _nombreAula = TextEditingController();
  final _nombreEstudiante = TextEditingController();
  final _usuarioEstudiante = TextEditingController();

  @override
  void dispose() {
    _nombreAula.dispose();
    _nombreEstudiante.dispose();
    _usuarioEstudiante.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sesion = context.read<FuenteModoSesion>();
    return PlantillaPantalla(
      titulo: 'Panel docente',
      mostrarAtras: false,
      anchoMaximo: Anchos.contenido + 200,
      acciones: [
        TextButton.icon(
          onPressed: () async {
            await context.read<AccesoCubit>().salir();
            if (context.mounted) context.go('/');
          },
          icon: const Icon(Icons.logout_rounded),
          label: const Text('Cerrar sesión'),
        ),
      ],
      hijo: BlocConsumer<DocenteCubit, EstadoDocente>(
        // Se vacía el formulario al cambiar de aula o cuando el estudiante se agregó con éxito.
        listenWhen: (a, b) =>
            a.aulaActual?.id != b.aulaActual?.id ||
            a.estudiantes.length < b.estudiantes.length,
        listener: (_, _) {
          _nombreEstudiante.clear();
          _usuarioEstudiante.clear();
        },
        builder: (context, estado) {
          if (estado.cargando) {
            return const SizedBox(
              height: 240,
              child: VistaCarga(mensaje: 'Cargando tus aulas…'),
            );
          }
          if (estado.errorCarga != null) {
            return SizedBox(
              height: 320,
              child: VistaError(
                mensaje: estado.errorCarga!,
                alReintentar: context.read<DocenteCubit>().cargar,
              ),
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Hola, ${sesion.nombre}',
                style: Tipografia.titulo(28, peso: 800),
              ),
              const SizedBox(height: Espaciado.l),
              _SeccionAulas(
                estado: estado,
                controlador: _nombreAula,
                alCrear: () {
                  context.read<DocenteCubit>().crearAula(_nombreAula.text);
                  _nombreAula.clear();
                },
              ),
              if (estado.aulaActual != null) ...[
                const SizedBox(height: Espaciado.xl),
                _TarjetaCodigoAula(aula: estado.aulaActual!),
                const SizedBox(height: Espaciado.xl),
                _SeccionAgregar(
                  estado: estado,
                  nombre: _nombreEstudiante,
                  usuario: _usuarioEstudiante,
                  alAgregar: () {
                    context.read<DocenteCubit>().agregarEstudiante(
                      _nombreEstudiante.text,
                      _usuarioEstudiante.text,
                    );
                  },
                ),
                if (estado.codigo != null) ...[
                  const SizedBox(height: Espaciado.l),
                  _TarjetaActivacion(codigo: estado.codigo!),
                ],
                const SizedBox(height: Espaciado.xl),
                _ListaEstudiantes(estado: estado),
              ],
              if (estado.aulas.isNotEmpty) ...[
                const SizedBox(height: Espaciado.xl),
                _SeccionRanking(estado: estado),
              ],
              if (estado.mensajeError != null)
                Padding(
                  padding: const EdgeInsets.only(top: Espaciado.l),
                  child: Semantics(
                    liveRegion: true,
                    child: Row(
                      children: [
                        const Icon(
                          Icons.error_outline_rounded,
                          color: ColoresGenios.error,
                        ),
                        const SizedBox(width: Espaciado.s),
                        Flexible(
                          child: Text(
                            estado.mensajeError!,
                            style: Tipografia.texto(
                              18,
                              peso: 800,
                              color: ColoresGenios.error,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _Bloque extends StatelessWidget {
  const _Bloque({required this.titulo, required this.hijo});

  final String titulo;
  final Widget hijo;

  @override
  Widget build(BuildContext context) {
    // Material (no un contenedor con color): los ListTile y ExpansionTile pintan su toque sobre él.
    return Material(
      color: ColoresGenios.superficie,
      borderRadius: Radios.tarjeta,
      child: Padding(
        padding: const EdgeInsets.all(Espaciado.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Semantics(
              header: true,
              child: Text(titulo, style: Tipografia.titulo(22, peso: 800)),
            ),
            const SizedBox(height: Espaciado.m),
            hijo,
          ],
        ),
      ),
    );
  }
}

class _SeccionAulas extends StatelessWidget {
  const _SeccionAulas({
    required this.estado,
    required this.controlador,
    required this.alCrear,
  });

  final EstadoDocente estado;
  final TextEditingController controlador;
  final VoidCallback alCrear;

  @override
  Widget build(BuildContext context) {
    return _Bloque(
      titulo: 'Mis aulas',
      hijo: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (estado.aulas.isEmpty)
            Text(
              'Todavía no tienes aulas. Crea la primera para obtener su código.',
              style: Tipografia.texto(18, color: ColoresGenios.textoSuave),
            )
          else
            Wrap(
              spacing: Espaciado.s,
              runSpacing: Espaciado.s,
              children: [
                for (final aula in estado.aulas)
                  ChoiceChip(
                    label: Text(aula.nombre),
                    selected: aula.id == estado.aulaActual?.id,
                    onSelected: (_) =>
                        context.read<DocenteCubit>().elegirAula(aula),
                  ),
              ],
            ),
          const SizedBox(height: Espaciado.l),
          CampoGenios(
            controlador: controlador,
            etiqueta: 'Nombre del aula nueva (por ejemplo, 5.º A)',
            icono: Icons.meeting_room_rounded,
            habilitado: !estado.ocupado,
            alEnviar: alCrear,
          ),
          const SizedBox(height: Espaciado.m),
          Align(
            alignment: Alignment.centerLeft,
            child: BotonSecundarioJuego(
              texto: 'CREAR AULA',
              icono: Icons.add_rounded,
              alPulsar: estado.ocupado ? null : alCrear,
            ),
          ),
        ],
      ),
    );
  }
}

class _TarjetaCodigoAula extends StatelessWidget {
  const _TarjetaCodigoAula({required this.aula});

  final AulaDocente aula;

  @override
  Widget build(BuildContext context) {
    return _Bloque(
      titulo: 'Código de «${aula.nombre}»',
      hijo: Row(
        children: [
          Expanded(
            child: Semantics(
              label: 'Código del aula ${aula.codigoAcceso ?? ''}',
              excludeSemantics: true,
              child: SelectableText(
                aula.codigoAcceso ?? '—',
                style: Tipografia.titulo(
                  40,
                  peso: 800,
                  color: ColoresGenios.amarilloEspacial,
                ),
              ),
            ),
          ),
          if (aula.codigoAcceso != null)
            IconButton(
              tooltip: 'Copiar código',
              iconSize: 30,
              constraints: const BoxConstraints(minWidth: 56, minHeight: 56),
              icon: const Icon(Icons.copy_rounded),
              onPressed: () => _copiar(context, aula.codigoAcceso!),
            ),
        ],
      ),
    );
  }
}

Future<void> _copiar(BuildContext context, String texto) async {
  await Clipboard.setData(ClipboardData(text: texto));
  if (!context.mounted) return;
  ScaffoldMessenger.of(context)
      .showSnackBar(const SnackBar(content: Text('Copiado')));
}

class _SeccionAgregar extends StatelessWidget {
  const _SeccionAgregar({
    required this.estado,
    required this.nombre,
    required this.usuario,
    required this.alAgregar,
  });

  final EstadoDocente estado;
  final TextEditingController nombre;
  final TextEditingController usuario;
  final VoidCallback alAgregar;

  @override
  Widget build(BuildContext context) {
    return _Bloque(
      titulo: 'Agregar un estudiante',
      hijo: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Crea su cuenta dentro del aula. Recibirás un código para que el estudiante elija su propia contraseña. También puede unirse solo con el código del aula.',
            style: Tipografia.texto(16, color: ColoresGenios.textoSuave),
          ),
          const SizedBox(height: Espaciado.m),
          CampoGenios(
            controlador: nombre,
            etiqueta: 'Nombre del estudiante',
            icono: Icons.face_rounded,
            habilitado: !estado.ocupado,
          ),
          const SizedBox(height: Espaciado.m),
          CampoGenios(
            controlador: usuario,
            etiqueta: 'Usuario (letras, números, punto o guion bajo)',
            icono: Icons.person_rounded,
            habilitado: !estado.ocupado,
            alEnviar: alAgregar,
          ),
          const SizedBox(height: Espaciado.m),
          Align(
            alignment: Alignment.centerLeft,
            child: BotonPrincipalJuego(
              texto: 'AGREGAR',
              icono: Icons.person_add_alt_1_rounded,
              ocupado: estado.ocupado,
              alPulsar: alAgregar,
            ),
          ),
        ],
      ),
    );
  }
}

class _TarjetaActivacion extends StatelessWidget {
  const _TarjetaActivacion({required this.codigo});

  final CodigoActivacion codigo;

  @override
  Widget build(BuildContext context) {
    final minutos = codigo.expiraEn
        .difference(DateTime.now().toUtc())
        .inMinutes;
    return Semantics(
      liveRegion: true,
      child: Container(
        padding: const EdgeInsets.all(Espaciado.l),
        decoration: BoxDecoration(
          color: ColoresGenios.exito.withValues(alpha: 0.16),
          borderRadius: Radios.tarjeta,
          border: Border.all(color: ColoresGenios.exito, width: 2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Entrégale esto a ${codigo.nombreUsuario}:',
              style: Tipografia.titulo(20, peso: 800),
            ),
            const SizedBox(height: Espaciado.s),
            Row(
              children: [
                Expanded(
                  child: SelectableText(
                    codigo.codigo,
                    style: Tipografia.titulo(
                      36,
                      peso: 800,
                      color: ColoresGenios.amarilloEspacial,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'Copiar código de activación',
                  iconSize: 30,
                  constraints: const BoxConstraints(
                    minWidth: 56,
                    minHeight: 56,
                  ),
                  icon: const Icon(Icons.copy_rounded),
                  onPressed: () => _copiar(context, codigo.codigo),
                ),
              ],
            ),
            Text(
              'El estudiante entra en «Iniciar sesión → Tengo un código de mi docente». Es de un solo uso y vence en ${minutos < 1 ? 'unos minutos' : '$minutos minutos'}. No se vuelve a mostrar.',
              style: Tipografia.texto(15, color: ColoresGenios.textoSuave),
            ),
          ],
        ),
      ),
    );
  }
}

class _ListaEstudiantes extends StatelessWidget {
  const _ListaEstudiantes({required this.estado});

  final EstadoDocente estado;

  @override
  Widget build(BuildContext context) {
    return _Bloque(
      titulo:
          'Estudiantes de «${estado.aulaActual?.nombre ?? ''}» (${estado.estudiantes.length})',
      hijo: estado.cargandoEstudiantes
          ? const SizedBox(
              height: 100,
              child: VistaCarga(mensaje: 'Cargando estudiantes…'),
            )
          : estado.estudiantes.isEmpty
          ? Text(
              'Aún no hay estudiantes en esta aula.',
              style: Tipografia.texto(18, color: ColoresGenios.textoSuave),
            )
          : Column(
              children: [
                for (final e in estado.estudiantes)
                  _FilaEstudiante(estudiante: e, ocupado: estado.ocupado),
              ],
            ),
    );
  }
}

String _fecha(DateTime? f) {
  if (f == null) return 'Sin actividad';
  final l = f.toLocal();
  String dos(int n) => n.toString().padLeft(2, '0');
  return '${dos(l.day)}/${dos(l.month)}/${l.year}';
}

String _porcentaje(double p) =>
    '${p.toStringAsFixed(p == p.roundToDouble() ? 0 : 1)} %';

class _FilaEstudiante extends StatelessWidget {
  const _FilaEstudiante({required this.estudiante, required this.ocupado});

  final EstudianteDeAula estudiante;
  final bool ocupado;

  @override
  Widget build(BuildContext context) {
    final e = estudiante;
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        leading: const Icon(
          Icons.face_rounded,
          color: ColoresGenios.turquesa,
          size: 32,
        ),
        title: Text(e.nombreMostrar, style: Tipografia.titulo(20, peso: 700)),
        subtitle: Text(
          '${e.nombreUsuario == null ? '' : 'Usuario: ${e.nombreUsuario} · '}'
          '${e.puntos} puntos · ${_porcentaje(e.porcentajeAciertos)} aciertos · ${e.partidas} partidas',
          style: Tipografia.texto(15, color: ColoresGenios.textoSuave),
        ),
        childrenPadding: const EdgeInsets.only(bottom: Espaciado.m),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Última actividad: ${_fecha(e.ultimaActividad)}',
            style: Tipografia.texto(16),
          ),
          const SizedBox(height: Espaciado.s),
          if (e.porMateria.isEmpty)
            Text(
              'Todavía no ha jugado ninguna materia.',
              style: Tipografia.texto(16, color: ColoresGenios.textoSuave),
            )
          else
            for (final m in e.porMateria)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text(
                  '${EstiloMateria.nombreVisible(m.nombre)}: ${m.partidas} partidas · ${_porcentaje(m.porcentajeAciertos)} aciertos · ${m.puntos} puntos',
                  style: Tipografia.texto(16),
                ),
              ),
          const SizedBox(height: Espaciado.s),
          Align(
            alignment: Alignment.centerLeft,
            child: BotonSecundarioJuego(
              texto: 'CAMBIAR CONTRASEÑA',
              icono: Icons.vpn_key_rounded,
              alPulsar: ocupado
                  ? null
                  : () => context.read<DocenteCubit>().nuevoCodigo(e),
            ),
          ),
        ],
      ),
    );
  }
}

class _SeccionRanking extends StatelessWidget {
  const _SeccionRanking({required this.estado});

  final EstadoDocente estado;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DocenteCubit>();
    return _Bloque(
      titulo: 'Ranking de estudiantes',
      hijo: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: Espaciado.m,
            runSpacing: Espaciado.m,
            children: [
              _Filtro<String?>(
                etiqueta: 'Aula',
                valor: estado.filtroAulaId,
                opciones: [
                  const DropdownMenuItem(
                    value: null,
                    child: Text('Todas mis aulas'),
                  ),
                  for (final a in estado.aulas)
                    DropdownMenuItem(value: a.id, child: Text(a.nombre)),
                ],
                alCambiar: (v) => cubit.filtrarRanking(
                  aulaId: v,
                  materiaId: estado.filtroMateriaId,
                ),
              ),
              _Filtro<int?>(
                etiqueta: 'Materia',
                valor: estado.filtroMateriaId,
                opciones: [
                  const DropdownMenuItem(
                    value: null,
                    child: Text('Todas las materias'),
                  ),
                  for (final m in estado.materias)
                    DropdownMenuItem(
                      value: m.id,
                      child: Text(EstiloMateria.nombreVisible(m.nombre)),
                    ),
                ],
                alCambiar: (v) => cubit.filtrarRanking(
                  aulaId: estado.filtroAulaId,
                  materiaId: v,
                ),
              ),
            ],
          ),
          const SizedBox(height: Espaciado.l),
          if (estado.cargandoRanking)
            const SizedBox(
              height: 100,
              child: VistaCarga(mensaje: 'Calculando ranking…'),
            )
          else if (estado.ranking.isEmpty)
            Text(
              'Todavía no hay estudiantes para mostrar con estos filtros.',
              style: Tipografia.texto(18, color: ColoresGenios.textoSuave),
            )
          else
            for (final f in estado.ranking) _FilaPosicion(fila: f),
        ],
      ),
    );
  }
}

class _Filtro<T> extends StatelessWidget {
  const _Filtro({
    required this.etiqueta,
    required this.valor,
    required this.opciones,
    required this.alCambiar,
  });

  final String etiqueta;
  final T valor;
  final List<DropdownMenuItem<T>> opciones;
  final ValueChanged<T?> alCambiar;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 200, maxWidth: 300),
      child: Semantics(
        label: 'Filtrar por $etiqueta',
        child: DropdownButtonFormField<T>(
          initialValue: valor,
          isExpanded: true,
          decoration: InputDecoration(labelText: etiqueta),
          items: opciones,
          onChanged: alCambiar,
        ),
      ),
    );
  }
}

class _FilaPosicion extends StatelessWidget {
  const _FilaPosicion({required this.fila});

  final FilaRanking fila;

  @override
  Widget build(BuildContext context) {
    final medalla = switch (fila.posicion) {
      1 => ColoresGenios.amarilloEspacial,
      2 => const Color(0xFFC0C8CC),
      3 => const Color(0xFFCD7F32),
      _ => null,
    };
    return Semantics(
      label:
          'Puesto ${fila.posicion}, ${fila.nombreMostrar}, ${fila.puntos} puntos',
      excludeSemantics: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: medalla ?? ColoresGenios.azulPetroleo,
              child: Text(
                '${fila.posicion}',
                style: Tipografia.titulo(
                  18,
                  peso: 800,
                  color: medalla == null
                      ? ColoresGenios.blancoLunar
                      : ColoresGenios.textoSobreClaro,
                ),
              ),
            ),
            const SizedBox(width: Espaciado.m),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fila.nombreMostrar,
                    style: Tipografia.titulo(19, peso: 700),
                  ),
                  Text(
                    '${fila.aulas.join(', ')} · ${_porcentaje(fila.porcentajeAciertos)} aciertos · ${fila.partidas} partidas',
                    style: Tipografia.texto(
                      14,
                      color: ColoresGenios.textoSuave,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '${fila.puntos}',
              style: Tipografia.titulo(
                24,
                peso: 800,
                color: ColoresGenios.amarilloEspacial,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.star_rounded,
              color: ColoresGenios.amarilloEspacial,
            ),
          ],
        ),
      ),
    );
  }
}
