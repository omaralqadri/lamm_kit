import 'package:flutter/material.dart';

import '../icons/phosphor.dart';
import '../theme/theme.dart';
import '../theme/tokens.dart';

/// iOS-style inset card holding [LammInsetRow]s with hairline dividers.
class LammInsetGroup extends StatelessWidget {
  const LammInsetGroup({required this.children, super.key});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: LammRadius.mediumAll,
        border: Border.all(color: c.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0)
              Divider(
                height: 1,
                thickness: 1,
                indent: LammSpacing.md,
                endIndent: 0,
                color: c.border,
              ),
            children[i],
          ],
        ],
      ),
    );
  }
}

class LammInsetRow extends StatelessWidget {
  const LammInsetRow({
    required this.title,
    this.leadingIcon,
    this.subtitle,
    this.value,
    this.trailing,
    this.onTap,
    super.key,
  });

  final String title;
  final IconData? leadingIcon;
  final String? subtitle;

  /// Trailing value text, e.g. the current setting.
  final String? value;

  /// Replaces the chevron when set.
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.type;
    final rtl = Directionality.of(context) == TextDirection.rtl;
    final end =
        trailing ??
        (onTap == null
            ? null
            : Icon(
                rtl ? Ph.caretLeft : Ph.caretRight,
                size: 16,
                color: c.textTertiary,
              ));
    return InkWell(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: LammTouch.min),
        child: Padding(
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: LammSpacing.md,
            vertical: LammSpacing.sm,
          ),
          child: Row(
            children: [
              if (leadingIcon != null) ...[
                Icon(leadingIcon, size: 22, color: c.accent),
                const SizedBox(width: LammSpacing.sm),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: t.body.copyWith(color: c.textPrimary)),
                    if (subtitle != null)
                      Text(
                        subtitle!,
                        style: t.footnote.copyWith(color: c.textSecondary),
                      ),
                  ],
                ),
              ),
              if (value != null) ...[
                const SizedBox(width: LammSpacing.xs),
                Flexible(
                  child: Text(
                    value!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: t.callout.copyWith(color: c.textSecondary),
                  ),
                ),
              ],
              if (end != null) ...[const SizedBox(width: LammSpacing.xs), end],
            ],
          ),
        ),
      ),
    );
  }
}
