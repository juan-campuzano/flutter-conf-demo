import 'package:flutter/material.dart';

import '../tokens/ds_colors.dart';

/// Campo de texto estándar del design system.
class DsTextField extends StatelessWidget {
  const DsTextField({
    super.key,
    required this.label,
    this.hintText,
    this.controller,
    this.obscureText = false,
    this.errorText,
  });

  final String label;
  final String? hintText;
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
        hintText: hintText,
        errorText: errorText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: DsColors.border),
        ),
      ),
    );
  }
}
