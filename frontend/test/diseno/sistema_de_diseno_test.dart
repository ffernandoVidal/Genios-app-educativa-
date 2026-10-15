import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genios_app/core/ajustes/ajustes_app.dart';
import 'package:genios_app/diseno/componentes/astronauta_genios.dart';
import 'package:genios_app/diseno/componentes/botones_juego.dart';
import 'package:genios_app/diseno/componentes/fondo_espacial.dart';
import 'package:genios_app/diseno/componentes/icono_materia.dart';
import 'package:genios_app/diseno/componentes/tarjeta_materia.dart';
import 'package:genios_app/diseno/componentes/tarjeta_mision.dart';
import 'package:genios_app/diseno/tema/tema_genios.dart';
import 'package:genios_app/diseno/tokens/colores.dart';
import 'package:genios_app/diseno/tokens/tipografia.dart';
import 'package:genios_app/features/acceso/dominio/validacion_apodo.dart';

Widget _en(Widget hijo) => AjustesScope(
  ajustes: AjustesApp(animaciones: false),
  child: MaterialApp(
    theme: TemaGenios.construir(),
    home: Scaffold(body: Center(child: hijo)),
  ),
);

void main() {
  group('paleta y tipografía oficiales', () {
    test('la paleta principal es la definida', () {
      expect(ColoresGenios.espacioProfundo, const Color(0xFF0B2332));
      expect(ColoresGenios.azulPetroleo, const Color(0xFF103E54));
      expect(ColoresGenios.turquesa, const Color(0xFF28C7D2));
      expect(ColoresGenios.amarilloEspacial, const Color(0xFFFFD62A));
      expect(ColoresGenios.blancoLunar, const Color(0xFFF4F1E8));
    });

    test('cada materia tiene su color', () {
      expect(ColoresMaterias.matematicas, const Color(0xFF319A9B));
      expect(ColoresMaterias.lenguaje, const Color(0xFFA36C35));
      expect(ColoresMaterias.cienciasNaturales, const Color(0xFF70BF35));
      expect(ColoresMaterias.cienciasSociales, const Color(0xFF00B8DC));
      expect(
        EstiloMateria.de('MATEMATICAS').color,
        ColoresMaterias.matematicas,
      );
      expect(EstiloMateria.de('LENGUAJE').color, ColoresMaterias.lenguaje);
      expect(
        EstiloMateria.de('CIENCIAS_NATURALES').color,
        ColoresMaterias.cienciasNaturales,
      );
      expect(
        EstiloMateria.de('CIENCIAS_SOCIALES').color,
        ColoresMaterias.cienciasSociales,
      );
    });

    test('una materia desconocida usa el estilo genérico sin romper', () {
      expect(EstiloMateria.de('ARTES_NUEVAS').color, ColoresMaterias.generico);
    });

    test(
      'los nombres visibles corrigen tildes y usan Comunicación y Lenguaje',
      () {
        expect(EstiloMateria.nombreVisible('Matematicas'), 'Matemáticas');
        expect(
          EstiloMateria.nombreVisible('Lenguaje'),
          'Comunicación y Lenguaje',
        );
        expect(
          EstiloMateria.nombreVisible('Ciencias Sociales'),
          'Ciencias Sociales',
        );
      },
    );

    test('títulos en Baloo 2 (redondeada) y texto en Nunito (legible)', () {
      expect(Tipografia.titulo(20).fontFamily, 'Baloo2');
      expect(Tipografia.texto(20).fontFamily, 'Nunito');
      expect(
        TemaGenios.construir().textTheme.titleMedium!.fontFamily,
        'Nunito',
      );
    });

    test('el texto claro sobre el fondo oscuro tiene contraste suficiente (WCAG AA, 4.5:1)', () {
      double luminancia(Color c) => c.computeLuminance();
      double contraste(Color a, Color b) {
        final claro = luminancia(a) > luminancia(b) ? a : b;
        final oscuro = claro == a ? b : a;
        return (luminancia(claro) + 0.05) / (luminancia(oscuro) + 0.05);
      }

      expect(
        contraste(ColoresGenios.blancoLunar, ColoresGenios.espacioProfundo),
        greaterThan(4.5),
      );
      expect(
        contraste(ColoresGenios.blancoLunar, ColoresGenios.superficie),
        greaterThan(4.5),
      );
      expect(
        contraste(ColoresGenios.textoSuave, ColoresGenios.espacioProfundo),
        greaterThan(4.5),
      );
      expect(
        contraste(
          ColoresGenios.textoSobreClaro,
          ColoresGenios.amarilloEspacial,
        ),
        greaterThan(4.5),
      ); // texto del botón principal
    });
  });

  group('componentes', () {
    testWidgets('el astronauta se dibuja en sus cuatro poses sin errores', (
      t,
    ) async {
      for (final pose in PoseAstronauta.values) {
        await t.pumpWidget(_en(AstronautaGenios(pose: pose, alto: 200)));
        expect(
          find.byType(AstronautaGenios),
          findsOneWidget,
          reason: pose.name,
        );
      }
      expect(t.takeException(), isNull);
    });

    testWidgets('el astronauta conserva su proporción (no se deforma)', (
      t,
    ) async {
      await t.pumpWidget(_en(const AstronautaGenios(alto: 250)));
      final tamano = t.getSize(
        find
            .descendant(
              of: find.byType(AstronautaGenios),
              matching: find.byType(SizedBox),
            )
            .first,
      );
      expect(tamano.width / tamano.height, closeTo(0.8, 0.001));
    });

    testWidgets(
      'el botón principal responde al toque y se bloquea mientras está ocupado',
      (t) async {
        var toques = 0;
        await t.pumpWidget(
          _en(BotonPrincipalJuego(texto: 'JUGAR', alPulsar: () => toques++)),
        );
        await t.tap(find.text('JUGAR'));
        expect(toques, 1);

        await t.pumpWidget(
          _en(
            BotonPrincipalJuego(
              texto: 'JUGAR',
              ocupado: true,
              alPulsar: () => toques++,
            ),
          ),
        );
        await t.tap(find.byType(BotonPrincipalJuego), warnIfMissed: false);
        expect(toques, 1);
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      },
    );

    testWidgets('la tarjeta de materia muestra el progreso solo si se conoce', (
      t,
    ) async {
      await t.pumpWidget(
        _en(
          SizedBox(
            width: 240,
            height: 250,
            child: TarjetaMateria(
              codigo: 'MATEMATICAS',
              nombre: 'Matemáticas',
              alPulsar: () {},
            ),
          ),
        ),
      );
      expect(find.byType(LinearProgressIndicator), findsNothing);

      await t.pumpWidget(
        _en(
          SizedBox(
            width: 240,
            height: 250,
            child: TarjetaMateria(
              codigo: 'MATEMATICAS',
              nombre: 'Matemáticas',
              progreso: 0.5,
              textoProgreso: '2 de 4 misiones',
              alPulsar: () {},
            ),
          ),
        ),
      );
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
      expect(find.text('2 de 4 misiones'), findsOneWidget);
    });

    testWidgets(
      'la tarjeta de misión dibuja cada estado con su icono y texto',
      (t) async {
        for (final (estado, icono, texto) in [
          (EstadoNodo.bloqueada, Icons.lock_rounded, 'Bloqueada'),
          (EstadoNodo.disponible, Icons.rocket_launch_rounded, 'Disponible'),
          (EstadoNodo.enProgreso, Icons.play_arrow_rounded, 'En progreso'),
          (EstadoNodo.completada, Icons.star_rounded, 'Completada'),
        ]) {
          await t.pumpWidget(
            _en(
              TarjetaMision(
                numero: 1,
                nombre: 'Sumas',
                estado: estado,
                color: Colors.teal,
                alPulsar: () {},
              ),
            ),
          );
          expect(find.byIcon(icono), findsOneWidget, reason: texto);
          expect(find.text(texto), findsOneWidget, reason: texto);
        }
      },
    );

    testWidgets('cada icono de materia se dibuja', (t) async {
      for (final tipo in TipoIconoMateria.values) {
        await t.pumpWidget(_en(IconoMateria(tipo: tipo)));
      }
      expect(t.takeException(), isNull);
    });
  });

  group('fondo espacial', () {
    testWidgets('sin imagen dibuja el paisaje vectorial en las dos variantes', (
      t,
    ) async {
      for (final variante in VarianteFondo.values) {
        await t.pumpWidget(
          _en(
            SizedBox(
              width: 400,
              height: 700,
              child: FondoEspacial(
                variante: variante,
                vectorial: true,
                hijo: const SizedBox(),
              ),
            ),
          ),
        );
        expect(find.byType(Image), findsNothing);
      }
    });

    testWidgets(
      'si se entrega la ilustración definitiva, se usa con BoxFit.cover (sin estirarla)',
      (t) async {
        final png = base64Decode(
          'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg==',
        );
        await t.pumpWidget(
          _en(
            SizedBox(
              width: 400,
              height: 700,
              child: FondoEspacial(
                imagen: MemoryImage(png),
                hijo: const SizedBox(),
              ),
            ),
          ),
        );

        final imagen = t.widget<Image>(find.byType(Image));
        expect(imagen.fit, BoxFit.cover);
      },
    );
  });

  group('apodo del invitado', () {
    test('acepta nombres normales, con tildes, ñ, números y espacios', () {
      for (final valido in [
        'Luna',
        'Ana María',
        'Muñoz',
        'Nico_10',
        'Sol-3',
        'Al',
      ]) {
        expect(ValidacionApodo.validar(valido), isNull, reason: valido);
      }
    });

    test('rechaza vacío, muy corto, muy largo y símbolos', () {
      expect(ValidacionApodo.validar(''), isNotNull);
      expect(ValidacionApodo.validar('   '), isNotNull);
      expect(ValidacionApodo.validar('A'), isNotNull);
      expect(ValidacionApodo.validar('A' * 21), isNotNull);
      for (final malo in [
        '<script>',
        'ana@correo.com',
        'a/b',
        'hola!!',
        '😀😀',
      ]) {
        expect(ValidacionApodo.validar(malo), isNotNull, reason: malo);
      }
    });

    test('ignora espacios en los extremos', () {
      expect(ValidacionApodo.validar('  Luna  '), isNull);
    });
  });
}
