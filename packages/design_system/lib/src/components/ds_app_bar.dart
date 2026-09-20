import 'package:flutter/material.dart';

import '../tokens/ds_colors.dart';

/// AppBar estándar del design system.
class DsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DsAppBar({super.key, required this.title, this.leadingIcon, this.actions});

  final String title;
  final IconData? leadingIcon;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: DsColors.surface,
      foregroundColor: DsColors.textPrimary,
      elevation: 0,
      leading: leadingIcon != null ? Icon(leadingIcon) : null,
      title: Text(title),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
