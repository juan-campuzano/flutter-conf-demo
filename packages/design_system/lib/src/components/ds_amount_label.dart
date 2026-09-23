import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

import '../tokens/ds_colors.dart';
import '../tokens/ds_spacing.dart';

enum DsAmountEmphasis { positive, negative, neutral }

/// Etiqueta de monto monetario del design system, para saldos/movimientos.
class DsAmountLabel extends StatelessWidget {
  const DsAmountLabel({
    super.key,
    required this.amountCents,
    this.currency = 'USD',
    this.emphasis = DsAmountEmphasis.neutral,
  });

  final int amountCents;
  final String currency;
  final DsAmountEmphasis emphasis;

  Color get _color => switch (emphasis) {
        DsAmountEmphasis.positive => DsColors.success,
        DsAmountEmphasis.negative => DsColors.error,
        DsAmountEmphasis.neutral => DsColors.textPrimary,
      };

  String get _formatted {
    final sign = emphasis == DsAmountEmphasis.negative && amountCents > 0 ? '-' : '';
    final value = (amountCents.abs() / 100).toStringAsFixed(2);
    return '$sign\$$value $currency';
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _formatted,
      style: TextStyle(color: _color, fontWeight: FontWeight.w700, fontSize: 18),
    );
  }
}

@Preview(name: 'DsAmountLabel — énfasis', group: 'design_system')
Widget previewDsAmountLabel() {
  return const Padding(
    padding: EdgeInsets.all(DsSpacing.md),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DsAmountLabel(amountCents: 452030, emphasis: DsAmountEmphasis.positive),
        SizedBox(height: DsSpacing.xs),
        DsAmountLabel(amountCents: -8540, emphasis: DsAmountEmphasis.negative),
        SizedBox(height: DsSpacing.xs),
        DsAmountLabel(amountCents: 12500, emphasis: DsAmountEmphasis.neutral),
      ],
    ),
  );
}
