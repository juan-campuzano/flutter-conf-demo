import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

import '../tokens/ds_colors.dart';
import '../tokens/ds_spacing.dart';

/// Campo de texto estándar del design system.
///
/// v3.0.0: el parámetro `hintText` (v1/v2) fue renombrado a `placeholder`.
/// Ver docs/migrations/v2-to-v3.md.
class DsTextField extends StatelessWidget {
  const DsTextField({
    super.key,
    required this.label,
    this.placeholder,
    this.controller,
    this.obscureText = false,
    this.errorText,
  });

  final String label;
  final String? placeholder;
  final TextEditingController? controller;
  final bool obscureText;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        hintText: placeholder,
        errorText: errorText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: DsColors.border),
        ),
      ),
    );
  }
}

@Preview(name: 'DsTextField — estados', group: 'design_system')
Widget previewDsTextField() {
  return const Padding(
    padding: EdgeInsets.all(DsSpacing.md),
    child: SizedBox(
      width: 320,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DsTextField(label: 'Monto (USD)', placeholder: '0.00'),
          SizedBox(height: DsSpacing.sm),
          DsTextField(
            label: 'Correo',
            placeholder: 'tu@correo.com',
            errorText: 'Correo inválido',
          ),
        ],
      ),
    ),
  );
}
