import 'package:flutter/material.dart';

import '../tokens/tipografia.dart';

/// Campo de texto de los formularios. Etiqueta visible, icono, objetivo táctil amplio y letra de alta legibilidad.
class CampoGenios extends StatelessWidget {
  const CampoGenios({
    super.key,
    required this.controlador,
    required this.etiqueta,
    required this.icono,
    this.habilitado = true,
    this.oculto = false,
    this.mayusculas = false,
    this.alEnviar,
    this.longitudMaxima,
    this.autocompletar,
  });

  final TextEditingController controlador;
  final String etiqueta;
  final IconData icono;
  final bool habilitado;
  final bool oculto;
  final bool mayusculas;

  /// Si se indica, es el último campo: Enter envía el formulario.
  final VoidCallback? alEnviar;
  final int? longitudMaxima;
  final Iterable<String>? autocompletar;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controlador,
      enabled: habilitado,
      obscureText: oculto,
      maxLength: longitudMaxima,
      autofillHints: autocompletar,
      style: Tipografia.texto(20, peso: 700),
      textCapitalization: mayusculas
          ? TextCapitalization.characters
          : TextCapitalization.none,
      textInputAction: alEnviar == null
          ? TextInputAction.next
          : TextInputAction.done,
      onSubmitted: alEnviar == null ? null : (_) => alEnviar!(),
      decoration: InputDecoration(
        labelText: etiqueta,
        prefixIcon: Icon(icono),
        counterText: '',
      ),
    );
  }
}
