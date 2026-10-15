import 'package:flutter/material.dart';
import 'package:http/browser_client.dart';

import 'app/app.dart';
import 'app/configuracion.dart';
import 'core/red/cliente_api.dart';
import 'core/sesion/sesion_app.dart';
import 'features/acceso/datos/repositorio_acceso_api.dart';
import 'features/catalogo/datos/repositorio_catalogo_api.dart';
import 'features/partida/datos/repositorio_partida_api.dart';
import 'features/progreso/datos/repositorio_progreso_api.dart';
import 'features/salon/datos/repositorio_salon_api.dart';

void main() {
  final sesion = SesionApp();

  // Con credenciales, el navegador envía y guarda las cookies HttpOnly de la API (renovación e invitado).
  final cliente = ClienteApi(
    cliente: BrowserClient()..withCredentials = true,
    urlBase: Configuracion.urlBaseApi,
    sesion: sesion,
  );

  runApp(
    AppGenios(
      sesion: sesion,
      repositorioAcceso: RepositorioAccesoApi(cliente),
      repositorioCatalogo: RepositorioCatalogoApi(cliente),
      repositorioPartida: RepositorioPartidaApi(cliente),
      repositorioProgreso: RepositorioProgresoApi(cliente),
      repositorioSalon: RepositorioSalonApi(cliente),
      googleClientId: Configuracion.googleClientId,
    ),
  );
}
