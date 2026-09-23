import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

import '../mock/mock_data.dart';

DsBadgeVariant _variantFor(MockOrderStatus status) => switch (status) {
      MockOrderStatus.paid => DsBadgeVariant.success,
      MockOrderStatus.pending => DsBadgeVariant.warning,
      MockOrderStatus.refunded => DsBadgeVariant.neutral,
      MockOrderStatus.cancelled => DsBadgeVariant.danger,
    };

String _labelFor(MockOrderStatus status) => switch (status) {
      MockOrderStatus.paid => 'Pagado',
      MockOrderStatus.pending => 'Pendiente',
      MockOrderStatus.refunded => 'Reembolsado',
      MockOrderStatus.cancelled => 'Cancelado',
    };

/// Pantalla de punto de venta: catálogo y órdenes del día.
class PosScreen extends StatelessWidget {
  const PosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final totalCents =
        MockOrder.all.where((o) => o.status == MockOrderStatus.paid).fold<int>(
              0,
              (sum, order) => sum + order.totalCents,
            );

    return Scaffold(
      appBar: const DsAppBar(title: 'Punto de venta'),
      body: ListView(
        padding: const EdgeInsets.all(DsSpacing.md),
        children: [
          const DsTextField(
            label: 'Buscar producto',
            placeholder: 'Café, croissant, jugo...',
          ),
          const SizedBox(height: DsSpacing.md),
          DsCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Cobrado hoy', style: DsTypography.label),
                const SizedBox(height: DsSpacing.xs),
                DsAmountLabel(amountCents: totalCents, emphasis: DsAmountEmphasis.positive),
              ],
            ),
          ),
          const SizedBox(height: DsSpacing.lg),
          Text('Catálogo', style: DsTypography.headingMedium),
          const SizedBox(height: DsSpacing.sm),
          for (final product in MockProduct.all)
            DsListTile(
              title: product.name,
              trailing: DsAmountLabel(
                amountCents: product.priceCents,
                emphasis: DsAmountEmphasis.neutral,
              ),
            ),
          const SizedBox(height: DsSpacing.lg),
          Text('Órdenes de hoy', style: DsTypography.headingMedium),
          const SizedBox(height: DsSpacing.sm),
          for (final order in MockOrder.all)
            Padding(
              padding: const EdgeInsets.only(bottom: DsSpacing.sm),
              child: Row(
                children: [
                  Expanded(child: Text(order.id)),
                  DsBadge(label: _labelFor(order.status), variant: _variantFor(order.status)),
                ],
              ),
            ),
          const SizedBox(height: DsSpacing.lg),
          SizedBox(
            width: double.infinity,
            child: DsButton(text: 'Cobrar', onPressed: () {}),
          ),
        ],
      ),
    );
  }
}
