import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

import '../models/mock_recipient.dart';
import 'enter_amount_screen.dart';

/// Primera pantalla del flujo: elegir a quién se le envía dinero.
class SelectRecipientScreen extends StatelessWidget {
  const SelectRecipientScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DsAppBar(title: 'Enviar dinero'),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: DsSpacing.md),
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: DsSpacing.md),
            child: Text('Selecciona un destinatario', style: DsTypography.headingMedium),
          ),
          const SizedBox(height: DsSpacing.md),
          for (final recipient in MockRecipient.sample)
            DsListTile(
              leading: DsAvatar(initials: recipient.initials, size: DsAvatarSize.sm),
              title: recipient.name,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => EnterAmountScreen(recipient: recipient),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
