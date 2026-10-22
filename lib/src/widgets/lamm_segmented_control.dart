import 'package:flutter/material.dart';

import '../theme/theme.dart';
import '../theme/tokens.dart';

class LammSegment<T> {
  const LammSegment({
    required this.value,
    required this.label,
    this.icon,
    this.marker,
  });
  final T value;
  final String label;
  final IconData? icon;

  /// Optional trailing widget (e.g. a Pro badge).
  final Widget? marker;
}

/// Segmented control: sunken track, selected segment on a surface chip with
/// accent text. Accent only; never gold.
class LammSegmentedControl<T> extends StatelessWidget {
  const LammSegmentedControl({
    required this.segments,
    required this.selected,
    required this.onChanged,
    super.key,
  });

  final List<LammSegment<T>> segments;
  final T selected;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.type;
    return Container(
      padding: const EdgeInsets.all(LammSpacing.xxs),
      decoration: BoxDecoration(
        color: c.sunken,
        borderRadius: LammRadius.mediumAll,
      ),
      child: Row(
        children: [
          for (final s in segments)
            Expanded(
              child: Semantics(
                button: true,
                selected: s.value == selected,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onChanged(s.value),
                  child: AnimatedContainer(
                    duration: LammMotion.fast,
                    curve: LammMotion.enter,
                    constraints: const BoxConstraints(minHeight: LammTouch.ios),
                    padding: const EdgeInsetsDirectional.symmetric(
                      horizontal: LammSpacing.xs,
                    ),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: s.value == selected
                          ? c.surface
                          : Colors.transparent,
                      borderRadius: LammRadius.smallAll,
                      border: s.value == selected
                          ? Border.all(color: c.border)
                          : null,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (s.icon != null) ...[
                          Icon(
                            s.icon,
                            size: 18,
                            color: s.value == selected
                                ? c.accent
                                : c.textSecondary,
                          ),
                          const SizedBox(width: LammSpacing.xxs),
                        ],
                        Flexible(
                          child: Text(
                            s.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: t.callout.copyWith(
                              fontWeight: FontWeight.w600,
                              color: s.value == selected
                                  ? c.accent
                                  : c.textSecondary,
                            ),
                          ),
                        ),
                        if (s.marker != null) ...[
                          const SizedBox(width: LammSpacing.xxs),
                          s.marker!,
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
