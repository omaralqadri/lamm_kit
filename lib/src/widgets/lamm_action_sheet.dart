import 'package:flutter/material.dart';

import '../theme/theme.dart';
import '../theme/tokens.dart';
import 'lamm_sheet.dart';

/// One row of an action sheet.
class LammSheetAction {
  const LammSheetAction({
    required this.id,
    required this.icon,
    required this.label,
  });
  final String id;
  final IconData icon;
  final String label;
}

/// Action sheet: subject header, then groups of action rows. Pops the chosen
/// action id. The destructive group renders in the danger colour.
Future<String?> showLammActions(
  BuildContext context, {
  required String title,
  required List<List<LammSheetAction>> groups,
  List<LammSheetAction> destructive = const [],
  String? subtitle,
  Widget? leading,
}) => showLammSheet<String>(
  context,
  builder: (_) => LammSheet(
    title: title,
    subtitle: subtitle,
    child: LammActionsBody(
      groups: groups,
      destructive: destructive,
      leading: leading,
    ),
  ),
);

class LammActionsBody extends StatelessWidget {
  const LammActionsBody({
    required this.groups,
    this.destructive = const [],
    this.leading,
    super.key,
  });
  final List<List<LammSheetAction>> groups;
  final List<LammSheetAction> destructive;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.type;
    Widget group(List<LammSheetAction> actions, {bool danger = false}) {
      final color = danger ? c.danger : c.textPrimary;
      return Container(
        decoration: BoxDecoration(
          color: c.sunken,
          borderRadius: LammRadius.mediumAll,
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            for (var i = 0; i < actions.length; i++) ...[
              if (i > 0) Divider(height: 1, thickness: 1, color: c.border),
              InkWell(
                onTap: () => Navigator.of(context).pop(actions[i].id),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: LammTouch.min),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.symmetric(
                      horizontal: LammSpacing.md,
                      vertical: LammSpacing.sm,
                    ),
                    child: Row(
                      children: [
                        Icon(actions[i].icon, color: color, size: 22),
                        const SizedBox(width: LammSpacing.sm),
                        Expanded(
                          child: Text(
                            actions[i].label,
                            style: t.body.copyWith(color: color),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(
        LammSpacing.screen,
        LammSpacing.xs,
        LammSpacing.screen,
        LammSpacing.md,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (leading != null)
            Padding(
              padding: const EdgeInsetsDirectional.only(bottom: LammSpacing.sm),
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: ClipRRect(
                  borderRadius: LammRadius.smallAll,
                  child: leading,
                ),
              ),
            ),
          for (final g in groups) ...[
            group(g),
            const SizedBox(height: LammSpacing.sm),
          ],
          if (destructive.isNotEmpty) group(destructive, danger: true),
        ],
      ),
    );
  }
}
