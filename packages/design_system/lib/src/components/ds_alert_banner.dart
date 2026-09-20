import 'package:flutter/material.dart';

import '../tokens/ds_colors.dart';
import '../tokens/ds_spacing.dart';

/// Severidad de un [DsAlertBanner].
///
/// v1.0.0 API. En v2.0.0 este tipo se renombra a `DsAlertLevel` y el valor
/// `warning` se renombra a `caution` (ver docs/migrations/v1-to-v2.md).
enum DsAlertSeverity { info, warning, error }

/// Banner de alerta del design system.
class DsAlertBanner extends StatelessWidget {
  const DsAlertBanner({
    super.key,
    required this.message,
    this.severity = DsAlertSeverity.info,
    this.onDismiss,
  });

  final String message;
  final DsAlertSeverity severity;
  final VoidCallback? onDismiss;

  Color get _color => switch (severity) {
        DsAlertSeverity.info => DsColors.info,
        DsAlertSeverity.warning => DsColors.warning,
        DsAlertSeverity.error => DsColors.error,
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
          Expanded(child: Text(message, style: TextStyle(color: _color))),
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
