import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

import '../tokens/ds_colors.dart';
import '../tokens/ds_spacing.dart';

enum DsButtonVariant { primary, secondary, text }

/// Botón estándar del design system.
///
/// v2.0.0: el parámetro `label` (v1.0.0) fue renombrado a `text`. Ver
/// docs/migrations/v1-to-v2.md.
class DsButton extends StatelessWidget {
  const DsButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = DsButtonVariant.primary,
    this.isLoading = false,
  });

  final String text;
  final VoidCallback? onPressed;
  final DsButtonVariant variant;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final child = isLoading
        ? const SizedBox(
            height: 18,
            width: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : Text(text);

    final onTap = isLoading ? null : onPressed;

    switch (variant) {
      case DsButtonVariant.primary:
        return ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: DsColors.primary,
            foregroundColor: DsColors.textOnPrimary,
            padding: const EdgeInsets.symmetric(
              horizontal: DsSpacing.lg,
              vertical: DsSpacing.md,
            ),
          ),
          child: child,
        );
      case DsButtonVariant.secondary:
        return OutlinedButton(
          onPressed: onTap,
          style: OutlinedButton.styleFrom(
            foregroundColor: DsColors.primary,
            side: const BorderSide(color: DsColors.primary),
            padding: const EdgeInsets.symmetric(
              horizontal: DsSpacing.lg,
              vertical: DsSpacing.md,
            ),
          ),
          child: child,
        );
      case DsButtonVariant.text:
        return TextButton(
          onPressed: onTap,
          style: TextButton.styleFrom(foregroundColor: DsColors.primary),
          child: child,
        );
    }
  }
}

@Preview(name: 'DsButton — variantes', group: 'design_system')
Widget previewDsButton() {
  return Padding(
    padding: const EdgeInsets.all(DsSpacing.md),
    child: SizedBox(
      width: 240,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DsButton(text: 'Primario', onPressed: () {}),
          const SizedBox(height: DsSpacing.sm),
          DsButton(
            text: 'Secundario',
            variant: DsButtonVariant.secondary,
            onPressed: () {},
          ),
          const SizedBox(height: DsSpacing.sm),
          DsButton(text: 'Texto', variant: DsButtonVariant.text, onPressed: () {}),
          const SizedBox(height: DsSpacing.sm),
          DsButton(text: 'Cargando', isLoading: true, onPressed: () {}),
        ],
      ),
    ),
  );
}
