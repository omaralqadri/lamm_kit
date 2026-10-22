import 'package:flutter/material.dart';

import '../icons/phosphor.dart';
import '../theme/theme.dart';
import '../theme/tokens.dart';
import 'lamm_sheet.dart';

/// One row of a picker sheet.
class LammPickerOption<T> {
  const LammPickerOption({
    required this.value,
    required this.title,
    this.description,
  });
  final T value;
  final String title;
  final String? description;
}

/// Picker: tapping a row pops its value. No OK button.
Future<T?> showLammPicker<T>(
  BuildContext context, {
  required String title,
  required List<LammPickerOption<T>> options,
  required T? selected,
  String? subtitle,
}) => showLammSheet<T>(
  context,
  builder: (_) => LammSheet(
    title: title,
    subtitle: subtitle,
    child: LammPickerBody<T>(options: options, selected: selected),
  ),
);

class LammPickerBody<T> extends StatelessWidget {
  const LammPickerBody({
    required this.options,
    required this.selected,
    super.key,
  });
  final List<LammPickerOption<T>> options;
  final T? selected;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.type;
    return Padding(
      padding: const EdgeInsets.all(LammSpacing.sm),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final o in options)
            Padding(
              padding: const EdgeInsetsDirectional.only(
                bottom: LammSpacing.xxs,
              ),
              child: Material(
                color: o.value == selected ? c.accentSoft : Colors.transparent,
                borderRadius: LammRadius.mediumAll,
                child: InkWell(
                  borderRadius: LammRadius.mediumAll,
                  onTap: () => Navigator.of(context).pop(o.value),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: LammTouch.min),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.symmetric(
                        horizontal: LammSpacing.md,
                        vertical: LammSpacing.sm,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  o.title,
                                  style: t.body.copyWith(color: c.textPrimary),
                                ),
                                if (o.description != null)
                                  Text(
                                    o.description!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: t.footnote.copyWith(
                                      color: c.textSecondary,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          if (o.value == selected)
                            Icon(Ph.check, color: c.accent, size: 20),
                        ],
                      ),
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

/// Confirm: destructive button on top, an equally large Cancel below it
/// (nearer the thumb). Pops true / false (null if dismissed).
Future<bool?> showLammConfirm(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmLabel,
  required String cancelLabel,
}) => showLammSheet<bool>(
  context,
  builder: (_) => LammSheet(
    title: title,
    child: LammConfirmBody(
      message: message,
      confirmLabel: confirmLabel,
      cancelLabel: cancelLabel,
    ),
  ),
);

class LammConfirmBody extends StatelessWidget {
  const LammConfirmBody({
    required this.message,
    required this.confirmLabel,
    required this.cancelLabel,
    super.key,
  });
  final String message;
  final String confirmLabel;
  final String cancelLabel;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.type;
    const shape = RoundedRectangleBorder(borderRadius: LammRadius.mediumAll);
    const size = Size.fromHeight(LammTouch.min + 4);
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
          Text(message, style: t.body.copyWith(color: c.textSecondary)),
          const SizedBox(height: LammSpacing.lg),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: c.danger,
              foregroundColor: Colors.white,
              minimumSize: size,
              shape: shape,
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(confirmLabel, style: t.headline),
          ),
          const SizedBox(height: LammSpacing.sm),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: c.sunken,
              foregroundColor: c.textPrimary,
              minimumSize: size,
              shape: shape,
            ),
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelLabel, style: t.headline),
          ),
        ],
      ),
    );
  }
}
