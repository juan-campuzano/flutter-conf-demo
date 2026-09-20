import 'package:flutter/widgets.dart';

import 'screens/select_recipient_screen.dart';

/// Punto de entrada de la experiencia de envío de dinero.
///
/// La app principal la acopla montando este widget (por ejemplo, empujándolo
/// como una nueva ruta) sin conocer los detalles internos del flujo.
class SendMoneyFlow extends StatelessWidget {
  const SendMoneyFlow({super.key});

  @override
  Widget build(BuildContext context) => const SelectRecipientScreen();
}
