import 'package:flutter/material.dart';

import '../tokens/ds_typography.dart';

/// List tile estándar del design system.
class DsListTile extends StatelessWidget {
  const DsListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading,
      title: Text(title, style: DsTypography.bodyLarge),
      subtitle: subtitle != null ? Text(subtitle!, style: DsTypography.bodyMedium) : null,
      trailing: trailing,
      onTap: onTap,
    );
  }
}
