import 'package:flutter/material.dart';

import '../tokens/ds_colors.dart';
import '../tokens/ds_spacing.dart';

/// Contenedor de tarjeta estándar del design system.
class DsCard extends StatelessWidget {
  const DsCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(DsSpacing.md),
    this.elevation = 1,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: DsColors.surface,
      elevation: elevation,
      borderRadius: BorderRadius.circular(16),
      child: Padding(padding: padding, child: child),
    );
  }
}
