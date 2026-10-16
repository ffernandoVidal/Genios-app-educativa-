import 'package:flutter/material.dart';

import '../../../core/sesion/sesion_app.dart';
import '../../../diseno/componentes/fondo_espacial.dart';
import '../../../diseno/componentes/vistas_estado.dart';
import '../dominio/restaurador_sesion.dart';

/// Pantalla de carga mientras se recupera la sesión. Si no hay conexión, deja reintentar o entrar sin sesión.
class RestaurandoPantalla extends StatelessWidget {
  const RestaurandoPantalla({
    super.key,
    required this.sesion,
    required this.restaurador,
  });

  final SesionApp sesion;
  final RestauradorSesion restaurador;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FondoEspacial(
        variante: VarianteFondo.paisaje,
        hijo: SafeArea(
          child: ListenableBuilder(
            listenable: sesion,
            builder: (context, _) =>
                sesion.restauracion == EstadoRestauracion.error
                ? Column(
                    children: [
                      Expanded(
                        child: VistaError(
                          mensaje: 'No pudimos conectar con GENIOS para recuperar tu sesión. Tu progreso está a salvo.',
                          sinConexion: true,
                          alReintentar: restaurador.restaurar,
                        ),
                      ),
                      TextButton(
                        onPressed: sesion.marcarRestauracionLista,
                        child: const Text('Entrar sin recuperar la sesión'),
                      ),
                    ],
                  )
                : const VistaCarga(mensaje: 'Abriendo GENIOS…'),
          ),
        ),
      ),
    );
  }
}
