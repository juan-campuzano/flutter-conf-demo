import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:send_money_experience/send_money_experience.dart';

import '../mock/mock_data.dart';

/// Pantalla principal: resumen de cuentas y accesos rápidos.
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final totalCents =
        MockAccount.all.fold<int>(0, (sum, account) => sum + account.balanceCents);

    return Scaffold(
      appBar: const DsAppBar(title: 'Hola, Diego'),
      body: ListView(
        padding: const EdgeInsets.all(DsSpacing.md),
        children: [
          const DsAlertBanner(
            message: 'Tu tarjeta Gold vence este mes.',
            severity: DsAlertLevel.caution,
          ),
          const SizedBox(height: DsSpacing.md),
          DsCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Saldo total', style: DsTypography.label),
                const SizedBox(height: DsSpacing.xs),
                DsAmountLabel(amountCents: totalCents, emphasis: DsAmountEmphasis.positive),
              ],
            ),
          ),
          const SizedBox(height: DsSpacing.md),
          SizedBox(
            width: double.infinity,
            child: DsButton(
              text: 'Enviar dinero',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SendMoneyFlow()),
                );
              },
            ),
          ),
          const SizedBox(height: DsSpacing.lg),
          Text('Movimientos recientes', style: DsTypography.headingMedium),
          const SizedBox(height: DsSpacing.sm),
          for (final movement in MockMovement.all)
            DsListTile(
              title: movement.title,
              subtitle: movement.date,
              trailing: DsAmountLabel(
                amountCents: movement.amountCents,
                emphasis: movement.amountCents >= 0
                    ? DsAmountEmphasis.positive
                    : DsAmountEmphasis.negative,
              ),
            ),
        ],
      ),
    );
  }
}
