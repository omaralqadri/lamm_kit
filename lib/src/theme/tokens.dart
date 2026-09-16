import 'package:flutter/material.dart';

/// Design tokens — spec §4.2 (color), §4.4 (spacing, radius, elevation).
///
/// Neutrals are shared across the Lamm family; the accent comes from the
/// app config so each app can carry its own.
@immutable
class LammColors extends ThemeExtension<LammColors> {
  const LammColors({
    required this.bg,
    required this.bgElevated,
    required this.bgSunken,
    required this.border,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.accent,
    required this.accentSoft,
    required this.onAccent,
    required this.success,
    required this.warning,
    required this.danger,
    required this.proGradient,
    required this.categoryOrganize,
    required this.categoryConvert,
    required this.categoryEdit,
    required this.categorySecurity,
    required this.categoryOptimize,
  });

  /// Light palette. [accent]/[accentSoft] default to Lamm PDF coral.
  ///
  /// `warning` deviates from spec §4.2 (#F5A524 → #9A6700): the spec value is
  /// 2.0:1 on white and fails the AA rule the same section requires.
  factory LammColors.light({
    Color accent = const Color(0xFFE5484D),
    Color accentSoft = const Color(0xFFFDECEC),
  }) {
    return LammColors(
      bg: const Color(0xFFFFFFFF),
      bgElevated: const Color(0xFFF6F6F8),
      bgSunken: const Color(0xFFEEEEF2),
      border: const Color(0xFFE4E4EA),
      textPrimary: const Color(0xFF0E0E12),
      textSecondary: const Color(0xFF5B5B66),
      textTertiary: const Color(0xFF8E8E99),
      accent: accent,
      accentSoft: accentSoft,
      onAccent: const Color(0xFFFFFFFF),
      success: const Color(0xFF30A46C),
      warning: const Color(0xFF9A6700),
      danger: const Color(0xFFD93036),
      proGradient: _proGradient,
      categoryOrganize: _organize,
      categoryConvert: _convert,
      categoryEdit: _edit,
      categorySecurity: _security,
      categoryOptimize: _optimize,
    );
  }

  /// Dark palette.
  factory LammColors.dark({
    Color accent = const Color(0xFFFF6369),
    Color accentSoft = const Color(0xFF3A1618),
  }) {
    return LammColors(
      bg: const Color(0xFF0B0B0D),
      bgElevated: const Color(0xFF16161A),
      bgSunken: const Color(0xFF1F1F25),
      border: const Color(0xFF2A2A31),
      textPrimary: const Color(0xFFF4F4F6),
      textSecondary: const Color(0xFFA0A0AB),
      textTertiary: const Color(0xFF6E6E78),
      accent: accent,
      accentSoft: accentSoft,
      // Spec §4.2 lists #FFFFFF, but white on the dark-mode accent is 2.9:1.
      // AA (§4.2's own rule) wins: dark ink on a light accent, as in Material dark.
      onAccent: const Color(0xFF2A0709),
      success: const Color(0xFF3DD68C),
      warning: const Color(0xFFFFC53D),
      danger: const Color(0xFFFF6369),
      proGradient: _proGradient,
      categoryOrganize: _organize,
      categoryConvert: _convert,
      categoryEdit: _edit,
      categorySecurity: _security,
      categoryOptimize: _optimize,
    );
  }

  static const _proGradient = LinearGradient(
    colors: [Color(0xFFFF8A4C), Color(0xFFE5484D)],
  );
  static const _organize = Color(0xFF3E63DD);
  static const _convert = Color(0xFF12A594);
  static const _edit = Color(0xFF8E4EC6);
  static const _security = Color(0xFFE5484D);
  static const _optimize = Color(0xFFF76B15);

  final Color bg;
  final Color bgElevated;
  final Color bgSunken;
  final Color border;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color accent;
  final Color accentSoft;
  final Color onAccent;
  final Color success;
  final Color warning;
  final Color danger;
  final LinearGradient proGradient;
  final Color categoryOrganize;
  final Color categoryConvert;
  final Color categoryEdit;
  final Color categorySecurity;
  final Color categoryOptimize;

  @override
  LammColors copyWith({Color? accent, Color? accentSoft}) => LammColors(
        bg: bg,
        bgElevated: bgElevated,
        bgSunken: bgSunken,
        border: border,
        textPrimary: textPrimary,
        textSecondary: textSecondary,
        textTertiary: textTertiary,
        accent: accent ?? this.accent,
        accentSoft: accentSoft ?? this.accentSoft,
        onAccent: onAccent,
        success: success,
        warning: warning,
        danger: danger,
        proGradient: proGradient,
        categoryOrganize: categoryOrganize,
        categoryConvert: categoryConvert,
        categoryEdit: categoryEdit,
        categorySecurity: categorySecurity,
        categoryOptimize: categoryOptimize,
      );

  @override
  LammColors lerp(ThemeExtension<LammColors>? other, double t) {
    if (other is! LammColors) return this;
    Color c(Color a, Color b) => Color.lerp(a, b, t)!;
    return LammColors(
      bg: c(bg, other.bg),
      bgElevated: c(bgElevated, other.bgElevated),
      bgSunken: c(bgSunken, other.bgSunken),
      border: c(border, other.border),
      textPrimary: c(textPrimary, other.textPrimary),
      textSecondary: c(textSecondary, other.textSecondary),
      textTertiary: c(textTertiary, other.textTertiary),
      accent: c(accent, other.accent),
      accentSoft: c(accentSoft, other.accentSoft),
      onAccent: c(onAccent, other.onAccent),
      success: c(success, other.success),
      warning: c(warning, other.warning),
      danger: c(danger, other.danger),
      proGradient: t < 0.5 ? proGradient : other.proGradient,
      categoryOrganize: c(categoryOrganize, other.categoryOrganize),
      categoryConvert: c(categoryConvert, other.categoryConvert),
      categoryEdit: c(categoryEdit, other.categoryEdit),
      categorySecurity: c(categorySecurity, other.categorySecurity),
      categoryOptimize: c(categoryOptimize, other.categoryOptimize),
    );
  }
}

/// 4-pt spacing grid (§4.4).
abstract final class LammSpacing {
  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 20;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 48;

  /// Screen side padding.
  static const double screen = 20;
}

/// Corner radii (§4.4).
abstract final class LammRadius {
  static const Radius small = Radius.circular(8);
  static const Radius medium = Radius.circular(14);
  static const Radius large = Radius.circular(22);

  static const BorderRadius smallAll = BorderRadius.all(small);
  static const BorderRadius mediumAll = BorderRadius.all(medium);
  static const BorderRadius largeAll = BorderRadius.all(large);
  static const BorderRadius full = BorderRadius.all(Radius.circular(999));
}

/// Motion durations and curves (§4.6).
abstract final class LammMotion {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration standard = Duration(milliseconds: 250);
  static const Duration emphasized = Duration(milliseconds: 400);

  static const Curve enter = Curves.easeOutCubic;
  static const Curve exit = Curves.easeInCubic;
}

/// Minimum touch targets (§4.4).
abstract final class LammTouch {
  static const double ios = 44;
  static const double android = 48;
  static const double min = 48;
}

/// Card/sheet shadow — light only; dark relies on [LammColors.bgElevated].
const List<BoxShadow> lammCardShadow = [
  BoxShadow(
    color: Color(0x0F000000),
    blurRadius: 12,
    offset: Offset(0, 2),
  ),
];
