import 'package:flutter/material.dart';

import '../theme/theme.dart';
import '../theme/tokens.dart';

/// Brand §2 category tints.
enum LammCategory { organize, convert, edit, security, optimize }

/// Rounded-square icon tile: 12% tint background, full-strength glyph.
class LammTypeTile extends StatelessWidget {
  const LammTypeTile({
    required this.icon,
    required this.category,
    this.size = 44,
    super.key,
  });

  final IconData icon;
  final LammCategory category;
  final double size;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final tint = switch (category) {
      LammCategory.organize => c.categoryOrganize,
      LammCategory.convert => c.categoryConvert,
      LammCategory.edit => c.categoryEdit,
      LammCategory.security => c.categorySecurity,
      LammCategory.optimize => c.categoryOptimize,
    };
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: tint.withValues(alpha: 0.12),
        borderRadius: LammRadius.mediumAll,
      ),
      child: ExcludeSemantics(
        child: Icon(icon, color: tint, size: size * 0.5),
      ),
    );
  }
}
