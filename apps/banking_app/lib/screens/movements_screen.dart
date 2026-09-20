import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

import '../mock/mock_data.dart';

/// Pantalla de movimientos.
class MovementsScreen extends StatelessWidget {
  const MovementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DsAppBar(title: 'Movimientos'),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: DsSpacing.sm),
        children: [
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
