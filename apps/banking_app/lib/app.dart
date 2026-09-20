import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

import 'screens/accounts_screen.dart';
import 'screens/cards_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/movements_screen.dart';

/// App bancaria demo: 100% visual, sin llamadas de red ni datos reales.
class BankingApp extends StatelessWidget {
  const BankingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'flutter-conf-demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: DsColors.primary,
        scaffoldBackgroundColor: DsColors.background,
        useMaterial3: true,
      ),
      home: const _HomeShell(),
    );
  }
}

class _HomeShell extends StatefulWidget {
  const _HomeShell();

  @override
  State<_HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<_HomeShell> {
  int _index = 0;

  static const _screens = [
    DashboardScreen(),
    AccountsScreen(),
    CardsScreen(),
    MovementsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: DsBottomNavBar(
        currentIndex: _index,
        onTap: (index) => setState(() => _index = index),
        items: const [
          DsBottomNavItem(icon: Icons.home_outlined, label: 'Inicio'),
          DsBottomNavItem(icon: Icons.account_balance_wallet_outlined, label: 'Cuentas'),
          DsBottomNavItem(icon: Icons.credit_card_outlined, label: 'Tarjetas'),
          DsBottomNavItem(icon: Icons.receipt_long_outlined, label: 'Movimientos'),
        ],
      ),
    );
  }
}
