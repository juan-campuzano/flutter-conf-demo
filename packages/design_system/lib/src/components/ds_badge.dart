import 'package:flutter/material.dart';

import '../tokens/ds_colors.dart';
import '../tokens/ds_spacing.dart';

enum DsBadgeColor { success, warning, error, info }

/// Etiqueta pequeña de estado del design system.
class DsBadge extends StatelessWidget {
  const DsBadge({super.key, required this.label, this.color = DsBadgeColor.info});

  final String label;
  final DsBadgeColor color;

  Color get _color => switch (color) {
        DsBadgeColor.success => DsColors.success,
        DsBadgeColor.warning => DsColors.warning,
        DsBadgeColor.error => DsColors.error,
        DsBadgeColor.info => DsColors.info,
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DsSpacing.sm,
        vertical: DsSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(color: _color, fontWeight: FontWeight.w600, fontSize: 12),
      ),
    );
  }
}
