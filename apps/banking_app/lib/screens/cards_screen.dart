import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

import '../mock/mock_data.dart';

/// Pantalla de tarjetas.
class CardsScreen extends StatelessWidget {
  const CardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DsAppBar(title: 'Tarjetas'),
      body: ListView.separated(
        padding: const EdgeInsets.all(DsSpacing.md),
        itemCount: MockCard.all.length,
        separatorBuilder: (_, _) => const SizedBox(height: DsSpacing.md),
        itemBuilder: (context, index) {
          final card = MockCard.all[index];
          return DsCard(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(card.label, style: DsTypography.bodyLarge),
                      const SizedBox(height: DsSpacing.xs),
                      Text('•••• ${card.lastDigits}', style: DsTypography.bodyMedium),
                    ],
                  ),
                ),
                if (card.limitCents > 0)
                  DsBadge(
                    label: 'Límite: \$${(card.limitCents / 100).toStringAsFixed(0)}',
                    color: DsBadgeColor.info,
                  )
                else
                  const DsBadge(label: 'Débito', color: DsBadgeColor.success),
              ],
            ),
          );
        },
      ),
    );
  }
}
