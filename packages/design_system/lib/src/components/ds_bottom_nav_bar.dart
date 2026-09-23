import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

import '../tokens/ds_colors.dart';

/// Item de navegación inferior del design system.
class DsBottomNavItem {
  const DsBottomNavItem({required this.icon, required this.label});

  final IconData icon;
  final String label;
}

/// Barra de navegación inferior del design system.
class DsBottomNavBar extends StatelessWidget {
  const DsBottomNavBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  final List<DsBottomNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      selectedItemColor: DsColors.primary,
      unselectedItemColor: DsColors.textSecondary,
      type: BottomNavigationBarType.fixed,
      items: [
        for (final item in items)
          BottomNavigationBarItem(icon: Icon(item.icon), label: item.label),
      ],
    );
  }
}

@Preview(name: 'DsBottomNavBar', group: 'design_system')
Widget previewDsBottomNavBar() {
  return Scaffold(
    body: const SizedBox.shrink(),
    bottomNavigationBar: DsBottomNavBar(
      currentIndex: 0,
      onTap: (_) {},
      items: const [
        DsBottomNavItem(icon: Icons.home_outlined, label: 'Inicio'),
        DsBottomNavItem(icon: Icons.account_balance_wallet_outlined, label: 'Cuentas'),
        DsBottomNavItem(icon: Icons.credit_card_outlined, label: 'Tarjetas'),
      ],
    ),
  );
}
