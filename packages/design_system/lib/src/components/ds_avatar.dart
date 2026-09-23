import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

import '../tokens/ds_colors.dart';
import '../tokens/ds_spacing.dart';

enum DsAvatarSize { sm, md, lg }

/// Avatar circular con iniciales o imagen, del design system.
class DsAvatar extends StatelessWidget {
  const DsAvatar({
    super.key,
    required this.initials,
    this.imageUrl,
    this.size = DsAvatarSize.md,
  });

  final String initials;
  final String? imageUrl;
  final DsAvatarSize size;

  double get _diameter => switch (size) {
        DsAvatarSize.sm => 32,
        DsAvatarSize.md => 48,
        DsAvatarSize.lg => 64,
      };

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: _diameter / 2,
      backgroundColor: DsColors.primary,
      backgroundImage: imageUrl != null ? AssetImage(imageUrl!) : null,
      child: imageUrl == null
          ? Text(
              initials,
              style: TextStyle(
                color: DsColors.textOnPrimary,
                fontWeight: FontWeight.w700,
                fontSize: _diameter / 2.6,
              ),
            )
          : null,
    );
  }
}

@Preview(name: 'DsAvatar — tamaños', group: 'design_system')
Widget previewDsAvatar() {
  return const Padding(
    padding: EdgeInsets.all(DsSpacing.md),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        DsAvatar(initials: 'DC', size: DsAvatarSize.sm),
        SizedBox(width: DsSpacing.sm),
        DsAvatar(initials: 'DC', size: DsAvatarSize.md),
        SizedBox(width: DsSpacing.sm),
        DsAvatar(initials: 'DC', size: DsAvatarSize.lg),
      ],
    ),
  );
}
