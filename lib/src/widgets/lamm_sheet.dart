import 'package:flutter/material.dart';

import '../icons/phosphor.dart';
import '../theme/theme.dart';
import '../theme/tokens.dart';

/// Opens [builder] in a Lamm bottom sheet (brand §4: radius 22, spring
/// motion, scrim behind). Height snaps to content, capped at 90% of screen.
Future<T?> showLammSheet<T>(
  BuildContext context, {
  required WidgetBuilder builder,
}) {
  final reduce = MediaQuery.disableAnimationsOf(context);
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: false,
    backgroundColor: context.colors.surface,
    barrierColor: context.colors.scrim,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: LammRadius.large),
    ),
    constraints: BoxConstraints(
      maxHeight: MediaQuery.sizeOf(context).height * 0.9,
    ),
    // ponytail: easeOutBack stands in for a true spring; swap for a
    // SpringSimulation curve if the overshoot needs tuning.
    sheetAnimationStyle: reduce
        ? AnimationStyle.noAnimation
        : const AnimationStyle(
            duration: LammMotion.emphasized,
            curve: Curves.easeOutBack,
            reverseDuration: LammMotion.standard,
            reverseCurve: LammMotion.exit,
          ),
    builder: builder,
  );
}

/// Sheet chrome: drag handle, title (+ subtitle), close button, [child].
/// Content scrolls when taller than the 90% cap.
class LammSheet extends StatelessWidget {
  const LammSheet({
    required this.title,
    required this.child,
    this.subtitle,
    super.key,
  });

  final String title;
  final String? subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.type;
    return SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: LammSpacing.xs),
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: c.border,
                borderRadius: LammRadius.full,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.only(
              start: LammSpacing.screen,
              end: LammSpacing.xs,
              top: LammSpacing.xs,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: t.headline.copyWith(color: c.textPrimary),
                      ),
                      if (subtitle != null)
                        Text(
                          subtitle!,
                          style: t.footnote.copyWith(color: c.textSecondary),
                        ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                  constraints: const BoxConstraints.tightFor(
                    width: LammTouch.min,
                    height: LammTouch.min,
                  ),
                  icon: Icon(Ph.x, color: c.textSecondary),
                  onPressed: () => Navigator.of(context).maybePop(),
                ),
              ],
            ),
          ),
          Flexible(child: SingleChildScrollView(child: child)),
        ],
      ),
    );
  }
}
