import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

import '../tokens/ds_colors.dart';

/// Indicador de carga estándar del design system.
class DsLoadingIndicator extends StatelessWidget {
  const DsLoadingIndicator({super.key, this.size = 24, this.strokeWidth = 2.5});

  final double size;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        color: DsColors.primary,
      ),
    );
  }
}

@Preview(name: 'DsLoadingIndicator', group: 'design_system')
Widget previewDsLoadingIndicator() {
  return const Center(child: DsLoadingIndicator());
}
