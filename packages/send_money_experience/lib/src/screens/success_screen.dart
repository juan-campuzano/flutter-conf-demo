import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

/// Cuarta pantalla del flujo: confirmación de éxito.
class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(DsSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const DsBadge(label: '¡Enviado!', color: DsBadgeColor.success),
              const SizedBox(height: DsSpacing.md),
              Text('Tu envío se procesó correctamente', style: DsTypography.headingMedium),
              const SizedBox(height: DsSpacing.lg),
              DsButton(
                text: 'Volver al inicio',
                onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
