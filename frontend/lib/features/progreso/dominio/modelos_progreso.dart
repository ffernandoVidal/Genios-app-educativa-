import 'package:equatable/equatable.dart';

/// Lo que se muestra en las insignias de la parte superior. Todas las cifras vienen calculadas del servidor.
class ResumenJugador extends Equatable {
  const ResumenJugador({
    required this.esInvitado,
    this.puntos,
    this.minutosRestantes,
    this.limiteAlcanzado = false,
    this.partidasQueCuentan = 0,
    this.partidasRequeridas = 3,
    this.invitarARegistrarse = false,
  });

  final bool esInvitado;
  final int? puntos;
  final int? minutosRestantes;
  final bool limiteAlcanzado;
  final int partidasQueCuentan;
  final int partidasRequeridas;
  final bool invitarARegistrarse;

  @override
  List<Object?> get props => [
    esInvitado,
    puntos,
    minutosRestantes,
    limiteAlcanzado,
    partidasQueCuentan,
    partidasRequeridas,
    invitarARegistrarse,
  ];
}

class ProgresoMateria extends Equatable {
  const ProgresoMateria({
    required this.nombre,
    required this.categoriasTotales,
    required this.categoriasCompletadas,
    required this.porcentajeAciertos,
    required this.puntos,
  });

  final String nombre;
  final int categoriasTotales;
  final int categoriasCompletadas;
  final double porcentajeAciertos;
  final int puntos;

  @override
  List<Object?> get props => [
    nombre,
    categoriasTotales,
    categoriasCompletadas,
    porcentajeAciertos,
    puntos,
  ];
}

class PartidaReciente extends Equatable {
  const PartidaReciente({
    required this.asignatura,
    required this.categoria,
    required this.estado,
    required this.aciertosPrimerIntento,
    required this.preguntasEvaluadas,
    required this.puntos,
  });

  final String asignatura;
  final String categoria;
  final String estado;
  final int aciertosPrimerIntento;
  final int preguntasEvaluadas;
  final int puntos;

  @override
  List<Object?> get props => [
    asignatura,
    categoria,
    estado,
    aciertosPrimerIntento,
    preguntasEvaluadas,
    puntos,
  ];
}

sealed class VistaProgreso extends Equatable {
  const VistaProgreso();
}

class ProgresoEstudiante extends VistaProgreso {
  const ProgresoEstudiante({
    required this.puntosTotales,
    required this.porcentajePrimerIntento,
    required this.preguntasCorregidasConReintento,
    required this.partidasCompletadas,
    required this.partidasIncompletas,
    required this.materias,
    required this.recientes,
  });

  final int puntosTotales;

  /// Aciertos al primer intento: la medida principal. Los reintentos se informan aparte.
  final double porcentajePrimerIntento;
  final int preguntasCorregidasConReintento;
  final int partidasCompletadas;
  final int partidasIncompletas;
  final List<ProgresoMateria> materias;
  final List<PartidaReciente> recientes;

  @override
  List<Object?> get props => [
    puntosTotales,
    porcentajePrimerIntento,
    preguntasCorregidasConReintento,
    partidasCompletadas,
    partidasIncompletas,
    materias,
    recientes,
  ];
}

class ProgresoInvitado extends VistaProgreso {
  const ProgresoInvitado({
    required this.partidasValidas,
    required this.partidasQueCuentan,
    required this.partidasRequeridas,
    required this.invitarARegistrarse,
    required this.aviso,
  });

  final int partidasValidas;
  final int partidasQueCuentan;
  final int partidasRequeridas;
  final bool invitarARegistrarse;
  final String aviso;

  @override
  List<Object?> get props => [
    partidasValidas,
    partidasQueCuentan,
    partidasRequeridas,
    invitarARegistrarse,
    aviso,
  ];
}
