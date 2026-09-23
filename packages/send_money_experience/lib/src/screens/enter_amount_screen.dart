import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

import '../models/mock_recipient.dart';
import 'confirm_screen.dart';

/// Segunda pantalla del flujo: ingresar el monto a enviar.
class EnterAmountScreen extends StatefulWidget {
  const EnterAmountScreen({super.key, required this.recipient});

  final MockRecipient recipient;

  @override
  State<EnterAmountScreen> createState() => _EnterAmountScreenState();
}

class _EnterAmountScreenState extends State<EnterAmountScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DsAppBar(title: 'Monto a enviar'),
      body: Padding(
        padding: const EdgeInsets.all(DsSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Para ${widget.recipient.name}', style: DsTypography.bodyLarge),
            const SizedBox(height: DsSpacing.md),
            DsTextField(
              label: 'Monto (USD)',
              placeholder: '0.00',
              controller: _controller,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: DsButton(
                text: 'Continuar',
                onPressed: () {
                  final amount = double.tryParse(_controller.text) ?? 0;
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ConfirmScreen(
                        recipient: widget.recipient,
                        amountCents: (amount * 100).round(),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
