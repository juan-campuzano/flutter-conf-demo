import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

import '../mock/mock_data.dart';

/// Pantalla de cuentas.
class AccountsScreen extends StatelessWidget {
  const AccountsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DsAppBar(title: 'Cuentas'),
      body: ListView.separated(
        padding: const EdgeInsets.all(DsSpacing.md),
        itemCount: MockAccount.all.length,
        separatorBuilder: (_, _) => const SizedBox(height: DsSpacing.md),
        itemBuilder: (context, index) {
          final account = MockAccount.all[index];
          return DsCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(account.name, style: DsTypography.bodyLarge),
                const SizedBox(height: DsSpacing.xs),
                DsAmountLabel(
                  amountCents: account.balanceCents,
                  emphasis: DsAmountEmphasis.positive,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
