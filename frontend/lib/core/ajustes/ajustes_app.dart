import 'package:flutter/widgets.dart';

/// Preferencias visuales de la persona que juega. Viven en memoria durante la sesión del navegador.
class AjustesApp extends ChangeNotifier {
  AjustesApp({this._animaciones = true, this._textoGrande = false});

  bool _animaciones;
  bool _textoGrande;

  bool get animaciones => _animaciones;
  bool get textoGrande => _textoGrande;

  /// Factor de escala del texto cuando se activa "texto más grande".
  double get escalaTexto => _textoGrande ? 1.25 : 1.0;

  set animaciones(bool valor) {
    if (valor == _animaciones) return;
    _animaciones = valor;
    notifyListeners();
  }

  set textoGrande(bool valor) {
    if (valor == _textoGrande) return;
    _textoGrande = valor;
    notifyListeners();
  }
}

/// Pone los ajustes al alcance de cualquier widget y lo reconstruye cuando cambian.
class AjustesScope extends InheritedNotifier<AjustesApp> {
  const AjustesScope({
    super.key,
    required AjustesApp ajustes,
    required super.child,
  }) : super(notifier: ajustes);

  static final AjustesApp _porDefecto = AjustesApp();

  /// Sin ámbito (por ejemplo en una prueba aislada de un widget) se usan los valores por defecto.
  static AjustesApp of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AjustesScope>()?.notifier ??
      _porDefecto;
}

/// Las animaciones decorativas se apagan si la persona lo pidió en Ajustes o si el sistema pide movimiento reducido.
bool movimientoReducido(BuildContext context) =>
    MediaQuery.maybeDisableAnimationsOf(context) == true ||
    !AjustesScope.of(context).animaciones;
