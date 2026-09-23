import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

import '../tokens/ds_colors.dart';
import '../tokens/ds_spacing.dart';

enum DsBadgeVariant { success, warning, danger, neutral }

/// Etiqueta pequeña de estado del design system.
///
/// v3.0.0: el parámetro `color` (v1/v2, tipo `DsBadgeColor`) fue renombrado a
/// `variant` (tipo `DsBadgeVariant`); los valores `error`/`info` fueron
/// renombrados a `danger`/`neutral` (`success`/`warning` sin cambio). Ver
/// docs/migrations/v2-to-v3.md.
class DsBadge extends StatelessWidget {
  const DsBadge({super.key, required this.label, this.variant = DsBadgeVariant.neutral});

  final String label;
  final DsBadgeVariant variant;

  Color get _color => switch (variant) {
        DsBadgeVariant.success => DsColors.success,
        DsBadgeVariant.warning => DsColors.warning,
        DsBadgeVariant.danger => DsColors.error,
        DsBadgeVariant.neutral => DsColors.info,
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

@Preview(name: 'DsBadge — variantes', group: 'design_system')
Widget previewDsBadge() {
  return const Padding(
    padding: EdgeInsets.all(DsSpacing.md),
    child: Wrap(
      spacing: DsSpacing.sm,
      runSpacing: DsSpacing.sm,
      children: [
        DsBadge(label: 'Pagado', variant: DsBadgeVariant.success),
        DsBadge(label: 'Pendiente', variant: DsBadgeVariant.warning),
        DsBadge(label: 'Cancelado', variant: DsBadgeVariant.danger),
        DsBadge(label: 'Reembolsado', variant: DsBadgeVariant.neutral),
      ],
    ),
  );
}
