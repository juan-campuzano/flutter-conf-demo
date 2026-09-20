import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

import '../models/mock_recipient.dart';
import 'success_screen.dart';

/// Tercera pantalla del flujo: confirmar el envío.
class ConfirmScreen extends StatelessWidget {
  const ConfirmScreen({super.key, required this.recipient, required this.amountCents});

  final MockRecipient recipient;
  final int amountCents;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DsAppBar(title: 'Confirmar envío'),
      body: Padding(
        padding: const EdgeInsets.all(DsSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DsCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Destinatario', style: DsTypography.label),
                  const SizedBox(height: DsSpacing.xs),
                  Text(recipient.name, style: DsTypography.bodyLarge),
                  const SizedBox(height: DsSpacing.md),
                  Text('Monto', style: DsTypography.label),
                  const SizedBox(height: DsSpacing.xs),
                  DsAmountLabel(amountCents: amountCents),
                ],
              ),
            ),
            const SizedBox(height: DsSpacing.md),
            const DsAlertBanner(
              message: 'Esta es una demo visual: no se realiza ninguna transacción real.',
              severity: DsAlertSeverity.info,
            ),
            const Spacer(),
            DsButton(
              label: 'Confirmar y enviar',
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const SuccessScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
