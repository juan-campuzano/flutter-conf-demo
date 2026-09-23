import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

import 'screens/pos_screen.dart';

/// App de comercio demo: 100% visual, sin llamadas de red ni datos reales.
class MerchantApp extends StatelessWidget {
  const MerchantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'flutter-conf-demo — merchant',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: DsColors.primary,
        scaffoldBackgroundColor: DsColors.background,
        useMaterial3: true,
      ),
      home: const PosScreen(),
    );
  }
}
