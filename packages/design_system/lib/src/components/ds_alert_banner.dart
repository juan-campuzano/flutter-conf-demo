import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

import '../tokens/ds_colors.dart';
import '../tokens/ds_spacing.dart';

/// Severidad de un [DsAlertBanner].
///
/// v2.0.0: renombrado desde `DsAlertSeverity` (v1.0.0), y el valor `warning`
/// fue renombrado a `caution`. Ver docs/migrations/v1-to-v2.md.
enum DsAlertLevel { info, caution, error }

/// Banner de alerta del design system.
class DsAlertBanner extends StatelessWidget {
  const DsAlertBanner({
    super.key,
    required this.message,
    this.severity = DsAlertLevel.info,
    this.onDismiss,
  });

  final String message;
  final DsAlertLevel severity;
  final VoidCallback? onDismiss;

  Color get _color => switch (severity) {
    DsAlertLevel.info => DsColors.info,
    DsAlertLevel.caution => DsColors.warning,
    DsAlertLevel.error => DsColors.error,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(DsSpacing.md),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.1),
        border: Border.all(color: _color),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(message, style: TextStyle(color: _color)),
          ),
          if (onDismiss != null)
            IconButton(
              icon: Icon(Icons.close, color: _color, size: 18),
              onPressed: onDismiss,
            ),
        ],
      ),
    );
  }
}

@Preview(name: 'DsAlertBanner — niveles', group: 'design_system')
Widget previewDsAlertBanner() {
  return const Padding(
    padding: EdgeInsets.all(DsSpacing.md),
    child: SizedBox(
      width: 360,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DsAlertBanner(message: 'Nuevo movimiento disponible.'),
          SizedBox(height: DsSpacing.sm),
          DsAlertBanner(
            message: 'Tu tarjeta Gold vence este mes.',
            severity: DsAlertLevel.caution,
          ),
          SizedBox(height: DsSpacing.sm),
          DsAlertBanner(
            message: 'No pudimos procesar tu pago.',
            severity: DsAlertLevel.error,
          ),
        ],
      ),
    ),
  );
}
