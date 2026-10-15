import 'package:flutter/material.dart';

import '../../../../diseno/tokens/medidas.dart';
import '../../dominio/modelos_docente.dart';

/// Elige el período de consulta: 7 días, 30 días, mes actual o un rango personalizado.
class SelectorPeriodo extends StatefulWidget {
  const SelectorPeriodo({super.key, required this.alElegir});

  final ValueChanged<PeriodoConsulta> alElegir;

  @override
  State<SelectorPeriodo> createState() => _EstadoSelectorPeriodo();
}

class _EstadoSelectorPeriodo extends State<SelectorPeriodo> {
  String _actual = '30';

  Future<void> _elegir(String clave) async {
    final hoy = DateTime.now();
    switch (clave) {
      case '7':
        widget.alElegir(const PeriodoConsulta.ultimos(7));
      case '30':
        widget.alElegir(const PeriodoConsulta.ultimos(30));
      case 'mes':
        widget.alElegir(
          PeriodoConsulta.rango(DateTime(hoy.year, hoy.month, 1), hoy),
        );
      case 'rango':
        final r = await showDateRangePicker(
          context: context,
          firstDate: DateTime(2024),
          lastDate: hoy,
        );
        if (r == null) return;
        widget.alElegir(PeriodoConsulta.rango(r.start, r.end));
    }
    setState(() => _actual = clave);
  }

  @override
  Widget build(BuildContext context) {
    const opciones = {
      '7': 'Últimos 7 días',
      '30': 'Últimos 30 días',
      'mes': 'Mes actual',
      'rango': 'Rango personalizado',
    };
    return Wrap(
      spacing: Espaciado.s,
      runSpacing: Espaciado.s,
      children: [
        for (final o in opciones.entries)
          ChoiceChip(
            label: Text(o.value),
            selected: _actual == o.key,
            onSelected: (_) => _elegir(o.key),
          ),
      ],
    );
  }
}
