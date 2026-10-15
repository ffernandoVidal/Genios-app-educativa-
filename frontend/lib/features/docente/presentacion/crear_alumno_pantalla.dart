import 'colores_docente.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/estado/estado_carga.dart';
import '../../../core/red/excepcion_api.dart';
import '../../../diseno/componentes/botones_juego.dart';
import '../../../diseno/componentes/campo_genios.dart';
import '../../../diseno/componentes/vistas_estado.dart';
import '../../../diseno/tokens/medidas.dart';
import '../dominio/repositorio_docente.dart';
import 'componentes/componentes_docente.dart';
import 'cubits_docente.dart';

enum _Modalidad { existente, nuevo }

/// Crear alumno: dos modalidades independientes.
/// A) Invitar a un estudiante que ya tiene cuenta: comparte el código de la clase (entra directo con él).
/// B) Registrar a un estudiante nuevo: el docente no ve ni fija contraseñas; recibe un código de un solo uso.
class CrearAlumnoPantalla extends StatefulWidget {
  const CrearAlumnoPantalla({super.key});

  @override
  State<CrearAlumnoPantalla> createState() => _CrearAlumnoPantallaState();
}

class _CrearAlumnoPantallaState extends State<CrearAlumnoPantalla> {
  _Modalidad? _modalidad;
  String? _aulaId;
  final _nombre = TextEditingController();
  final _usuario = TextEditingController();
  bool _ocupado = false;
  String? _error;
  CodigoActivacion? _codigo;

  @override
  void dispose() {
    _nombre.dispose();
    _usuario.dispose();
    super.dispose();
  }

  Future<void> _registrar() async {
    if (_aulaId == null) {
      setState(() => _error = 'Elige la clase.');
      return;
    }
    if (_nombre.text.trim().isEmpty || _usuario.text.trim().isEmpty) {
      setState(() => _error = 'Escribe el nombre y el usuario del estudiante.');
      return;
    }
    setState(() {
      _ocupado = true;
      _error = null;
      _codigo = null;
    });
    try {
      final codigo = await context.read<RepositorioDocente>().agregarEstudiante(
        _aulaId!,
        nombreMostrar: _nombre.text.trim(),
        nombreUsuario: _usuario.text.trim(),
      );
      if (!mounted) return;
      context
          .read<AulasDocenteCubit>()
          .cargar(); // actualiza el número de alumnos
      _nombre.clear();
      _usuario.clear();
      setState(() => _codigo = codigo);
    } on ExcepcionApi catch (e) {
      if (mounted) setState(() => _error = mensajeDeError(e));
    } finally {
      if (mounted) setState(() => _ocupado = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AulasDocenteCubit, EstadoCarga<List<AulaDocente>>>(
      builder: (context, estado) => SingleChildScrollView(
        child: switch (estado) {
          Cargando() => const SizedBox(
            height: 200,
            child: VistaCarga(mensaje: 'Cargando tus clases…'),
          ),
          Fallido(:final mensaje, :final sinConexion) => SizedBox(
            height: 300,
            child: VistaError(
              mensaje: mensaje,
              sinConexion: sinConexion,
              alReintentar: context.read<AulasDocenteCubit>().cargar,
            ),
          ),
          Cargado(:final datos) => _contenido(datos),
        },
      ),
    );
  }

  Widget _contenido(List<AulaDocente> aulas) {
    if (aulas.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Crear alumno', style: TipografiaDocente.titulo(30, peso: 800)),
          const SizedBox(height: Espaciado.l),
          Text(
            'Primero necesitas una clase donde agregar a tus estudiantes.',
            style: TipografiaDocente.texto(
              18,
              color: ColoresDocente.textoSuave,
            ),
          ),
          const SizedBox(height: Espaciado.l),
          Align(
            alignment: Alignment.centerLeft,
            child: BotonPrincipalJuego(
              texto: 'CREAR CLASE',
              icono: Icons.add_circle_rounded,
              alPulsar: () => context.go('/docente/clases/nueva'),
            ),
          ),
        ],
      );
    }
    _aulaId ??= aulas.length == 1 ? aulas.first.id : null;
    final aula = aulas.where((a) => a.id == _aulaId).firstOrNull;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Crear alumno', style: TipografiaDocente.titulo(30, peso: 800)),
        const SizedBox(height: Espaciado.l),
        CuadriculaAdaptable(
          anchoMinimo: 320,
          hijos: [
            _Opcion(
              icono: Icons.link_rounded,
              titulo: 'Invitar estudiante existente',
              texto: 'El estudiante ya tiene cuenta. Comparte el código de tu clase y entrará con él desde «Salón».',
              elegida: _modalidad == _Modalidad.existente,
              alElegir: () => setState(() => _modalidad = _Modalidad.existente),
            ),
            _Opcion(
              icono: Icons.person_add_alt_1_rounded,
              titulo: 'Registrar estudiante nuevo',
              texto: 'Crea su cuenta dentro de la clase. Tú no ves ni eliges su contraseña: recibirá un código de un solo uso.',
              elegida: _modalidad == _Modalidad.nuevo,
              alElegir: () => setState(() => _modalidad = _Modalidad.nuevo),
            ),
          ],
        ),
        if (_modalidad != null) ...[
          const SizedBox(height: Espaciado.xl),
          Bloque(
            titulo: _modalidad == _Modalidad.existente
                ? 'Invitar estudiante existente'
                : 'Registrar estudiante nuevo',
            hijo: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DropdownButtonFormField<String>(
                  initialValue: _aulaId,
                  decoration: const InputDecoration(labelText: 'Clase'),
                  items: [
                    for (final a in aulas)
                      DropdownMenuItem(value: a.id, child: Text(a.nombre)),
                  ],
                  onChanged: _ocupado
                      ? null
                      : (v) => setState(() {
                          _aulaId = v;
                          _codigo = null;
                        }),
                ),
                const SizedBox(height: Espaciado.l),
                if (_modalidad == _Modalidad.existente)
                  _Invitacion(aula: aula)
                else ...[
                  CampoGenios(
                    controlador: _nombre,
                    etiqueta: 'Nombre o alias del estudiante',
                    icono: Icons.face_rounded,
                    habilitado: !_ocupado,
                  ),
                  const SizedBox(height: Espaciado.m),
                  CampoGenios(
                    controlador: _usuario,
                    etiqueta: 'Usuario (letras, números, punto o guion bajo)',
                    icono: Icons.person_rounded,
                    habilitado: !_ocupado,
                    alEnviar: _registrar,
                  ),
                  const SizedBox(height: Espaciado.m),
                  Text(
                    'No pedimos dirección, teléfono ni fecha de nacimiento del estudiante.',
                    style: TipografiaDocente.texto(
                      14,
                      color: ColoresDocente.textoSuave,
                    ),
                  ),
                  const SizedBox(height: Espaciado.m),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: BotonPrincipalJuego(
                      texto: 'REGISTRAR',
                      icono: Icons.person_add_alt_1_rounded,
                      ocupado: _ocupado,
                      alPulsar: _registrar,
                    ),
                  ),
                  if (_error != null)
                    Padding(
                      padding: const EdgeInsets.only(top: Espaciado.l),
                      child: MensajeAccion(mensaje: _error!),
                    ),
                  if (_codigo != null)
                    Padding(
                      padding: const EdgeInsets.only(top: Espaciado.l),
                      child: TarjetaActivacion(codigo: _codigo!),
                    ),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _Opcion extends StatelessWidget {
  const _Opcion({
    required this.icono,
    required this.titulo,
    required this.texto,
    required this.elegida,
    required this.alElegir,
  });

  final IconData icono;
  final String titulo;
  final String texto;
  final bool elegida;
  final VoidCallback alElegir;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: elegida,
      label: '$titulo. $texto',
      excludeSemantics: true,
      child: Material(
        color: ColoresDocente.superficie,
        shape: RoundedRectangleBorder(
          borderRadius: Radios.tarjeta,
          side: BorderSide(
            color: elegida ? ColoresDocente.acento : Colors.transparent,
            width: 3,
          ),
        ),
        child: InkWell(
          borderRadius: Radios.tarjeta,
          onTap: alElegir,
          child: Padding(
            padding: const EdgeInsets.all(Espaciado.l),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icono, color: ColoresDocente.acento, size: 32),
                    const SizedBox(width: Espaciado.m),
                    Expanded(
                      child: Text(
                        titulo,
                        style: TipografiaDocente.titulo(20, peso: 800),
                      ),
                    ),
                    if (elegida)
                      const Icon(
                        Icons.check_circle_rounded,
                        color: ColoresDocente.acento,
                      ),
                  ],
                ),
                const SizedBox(height: Espaciado.s),
                Text(
                  texto,
                  style: TipografiaDocente.texto(
                    15,
                    color: ColoresDocente.textoSuave,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Invitacion extends StatelessWidget {
  const _Invitacion({required this.aula});

  final AulaDocente? aula;

  @override
  Widget build(BuildContext context) {
    if (aula == null) {
      return Text(
        'Elige una clase para ver su código.',
        style: TipografiaDocente.texto(16, color: ColoresDocente.textoSuave),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Código de «${aula!.nombre}»:',
          style: TipografiaDocente.texto(17, peso: 700),
        ),
        Row(
          children: [
            Expanded(
              child: SelectableText(
                aula!.codigoAcceso ?? '—',
                style: TipografiaDocente.titulo(
                  40,
                  peso: 800,
                  color: ColoresDocente.destacado,
                ),
              ),
            ),
            if (aula!.codigoAcceso != null)
              IconButton(
                tooltip: 'Copiar código',
                iconSize: 30,
                constraints: const BoxConstraints(minWidth: 56, minHeight: 56),
                icon: const Icon(Icons.copy_rounded),
                onPressed: () => copiarTexto(context, aula!.codigoAcceso!),
              ),
          ],
        ),
        const SizedBox(height: Espaciado.s),
        Text(
          'El estudiante abre GENIOS con su cuenta, entra a «Salón», escribe este código y se une a tu clase. El código no da acceso a sus resultados por sí solo: los verás cuando ya sea parte de la clase.',
          style: TipografiaDocente.texto(15, color: ColoresDocente.textoSuave),
        ),
      ],
    );
  }
}
