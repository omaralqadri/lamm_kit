import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lamm_kit/src/theme/tokens.dart';
import 'package:lamm_kit/src/theme/typography.dart';

/// Builds the Lamm [ThemeData] from tokens (§4).
///
/// Material 3 widgets on both platforms, themed with Lamm tokens, but
/// Cupertino page transitions on iOS (§4.7).
abstract final class LammTheme {
  static ThemeData light(Locale locale) => _build(
    colors: LammColors.light(),
    brightness: Brightness.light,
    locale: locale,
  );

  static ThemeData dark(Locale locale) => _build(
    colors: LammColors.dark(),
    brightness: Brightness.dark,
    locale: locale,
  );

  static ThemeData _build({
    required LammColors colors,
    required Brightness brightness,
    required Locale locale,
  }) {
    final type = LammTypography.forLocale(locale);
    final scheme = ColorScheme(
      brightness: brightness,
      primary: colors.accent,
      onPrimary: colors.onAccent,
      primaryContainer: colors.accentSoft,
      onPrimaryContainer: colors.accent,
      secondary: colors.accent,
      onSecondary: colors.onAccent,
      error: colors.danger,
      onError: colors.onAccent,
      surface: colors.bg,
      onSurface: colors.textPrimary,
      surfaceContainerHighest: colors.sunken,
      surfaceContainer: colors.surface,
      outline: colors.border,
      outlineVariant: colors.border,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: colors.bg,
      canvasColor: colors.bg,
      dividerColor: colors.border,
      splashFactory: InkSparkle.splashFactory,
      textTheme: type.toTextTheme(colors.textPrimary, colors.textSecondary),
      extensions: [colors, type],
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.android: ZoomPageTransitionsBuilder(),
        },
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colors.bg,
        foregroundColor: colors.textPrimary,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: type.headline.copyWith(color: colors.textPrimary),
      ),
      dividerTheme: DividerThemeData(
        color: colors.border,
        thickness: 1,
        space: 1,
      ),
      cardTheme: CardThemeData(
        color: colors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(borderRadius: LammRadius.mediumAll),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colors.bg,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        dragHandleColor: colors.border,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: LammRadius.large),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: colors.surface,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(borderRadius: LammRadius.mediumAll),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.sunken,
        border: const OutlineInputBorder(
          borderRadius: LammRadius.mediumAll,
          borderSide: BorderSide.none,
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: LammRadius.mediumAll,
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: LammRadius.mediumAll,
          borderSide: BorderSide(color: colors.accent, width: 2),
        ),
        contentPadding: const EdgeInsetsDirectional.symmetric(
          horizontal: LammSpacing.md,
          vertical: LammSpacing.sm,
        ),
        hintStyle: type.body.copyWith(color: colors.textTertiary),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colors.textPrimary,
        contentTextStyle: type.callout.copyWith(color: colors.bg),
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(borderRadius: LammRadius.mediumAll),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: colors.textSecondary,
        titleTextStyle: type.body.copyWith(color: colors.textPrimary),
        subtitleTextStyle: type.footnote.copyWith(color: colors.textSecondary),
        minVerticalPadding: LammSpacing.sm,
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(textStyle: WidgetStatePropertyAll(type.callout)),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colors.accent,
        linearTrackColor: colors.sunken,
        circularTrackColor: colors.sunken,
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: colors.accent,
        inactiveTrackColor: colors.sunken,
        thumbColor: colors.accent,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? colors.onAccent : null,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? colors.accent : null,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colors.accent,
        foregroundColor: colors.onAccent,
        elevation: 2,
        shape: const RoundedRectangleBorder(borderRadius: LammRadius.full),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          overlayColor: WidgetStateProperty.resolveWith(
            (s) =>
                s.contains(WidgetState.pressed) ? colors.accentPressed : null,
          ),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colors.bg,
        surfaceTintColor: Colors.transparent,
        indicatorColor: colors.accentSoft,
        elevation: 0,
        labelTextStyle: WidgetStatePropertyAll(
          type.caption.copyWith(color: colors.textSecondary),
        ),
      ),
    );
  }
}

/// Convenience accessors so widgets read `context.colors.accent`.
extension LammThemeContext on BuildContext {
  LammColors get colors => Theme.of(this).extension<LammColors>()!;
  LammTypography get type => Theme.of(this).extension<LammTypography>()!;
  bool get isRtl => Directionality.of(this) == TextDirection.rtl;
}
