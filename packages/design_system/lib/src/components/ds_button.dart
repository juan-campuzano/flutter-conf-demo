import 'package:flutter/material.dart';

import '../tokens/ds_colors.dart';
import '../tokens/ds_spacing.dart';

enum DsButtonVariant { primary, secondary, text }

/// Botón estándar del design system.
class DsButton extends StatelessWidget {
  const DsButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = DsButtonVariant.primary,
    this.isLoading = false,
  });

  final String label;
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
        : Text(label);

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
