import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../tokens/medidas.dart';
import '../tokens/tipografia.dart';
import 'fondo_espacial.dart';

/// Estructura común de las pantallas de formulario y lectura: fondo espacial, barra superior transparente con
/// botón de volver, y contenido centrado con ancho máximo (no se estira en pantallas grandes).
class PlantillaPantalla extends StatelessWidget {
  const PlantillaPantalla({
    super.key,
    required this.hijo,
    this.titulo,
    this.mostrarAtras = true,
    this.variante = VarianteFondo.suave,
    this.anchoMaximo = Anchos.formulario,
    this.desplazable = true,
    this.acciones,
  });

  final Widget hijo;
  final String? titulo;
  final bool mostrarAtras;
  final VarianteFondo variante;
  final double anchoMaximo;

  /// Si es false, el hijo debe gestionar su propio desplazamiento (por ejemplo, una lista).
  final bool desplazable;
  final List<Widget>? acciones;

  @override
  Widget build(BuildContext context) {
    final contenido = ConstrainedBox(
      constraints: BoxConstraints(maxWidth: anchoMaximo),
      child: hijo,
    );
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: mostrarAtras
            ? IconButton(
                tooltip: 'Volver',
                iconSize: 30,
                constraints: const BoxConstraints(minWidth: 56, minHeight: 56),
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: () =>
                    context.canPop() ? context.pop() : context.go('/'),
              )
            : null,
        title: titulo == null
            ? null
            : Text(titulo!, style: Tipografia.titulo(26, peso: 800)),
        actions: acciones,
      ),
      body: FondoEspacial(
        variante: variante,
        hijo: SafeArea(
          child: Center(
            child: desplazable
                ? SingleChildScrollView(
                    padding: const EdgeInsets.all(Espaciado.pantalla),
                    child: contenido,
                  )
                : contenido,
          ),
        ),
      ),
    );
  }
}
