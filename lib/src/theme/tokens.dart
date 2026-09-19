import 'package:flutter/material.dart';

/// Design tokens — `docs/LAMM_BRAND.md` §2 (color), §4 (spacing, radius,
/// elevation). This overrides the old spec §4.2/§4.3 tokens.
///
/// The whole Lamm family shares one palette; apps are told apart by their
/// icon, not by a different accent color.
@immutable
class LammColors extends ThemeExtension<LammColors> {
  const LammColors({
    required this.bg,
    required this.surface,
    required this.sunken,
    required this.border,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.accent,
    required this.accentPressed,
    required this.accentSoft,
    required this.onAccent,
    required this.gold,
    required this.goldSoft,
    required this.onGold,
    required this.success,
    required this.warning,
    required this.danger,
    required this.scrim,
    required this.proGradient,
    required this.categoryOrganize,
    required this.categoryConvert,
    required this.categoryEdit,
    required this.categorySecurity,
    required this.categoryOptimize,
  });

  /// Light palette (brand §2).
  factory LammColors.light() => const LammColors(
    bg: Color(0xFFF7F8F6),
    surface: Color(0xFFFFFFFF),
    sunken: Color(0xFFEDF0EC),
    border: Color(0xFFDFE4DE),
    textPrimary: Color(0xFF16211D),
    textSecondary: Color(0xFF4E5A55),
    textTertiary: Color(0xFF7C8781),
    accent: Color(0xFF285B49),
    accentPressed: Color(0xFF1E4638),
    accentSoft: Color(0xFFE6EEEA),
    onAccent: Color(0xFFFFFFFF),
    gold: Color(0xFFC4AA6C),
    goldSoft: Color(0xFFF5EEDF),
    onGold: Color(0xFF16211D),
    success: Color(0xFF0F9184),
    // Brand §2 lists #C08A2E, but that is 2.85:1 on bg — under the brand's
    // own 3:1 rule for icon/large-text colors. Darkened to #AC7C29 (3.48:1),
    // same hue, smallest change that clears the bar.
    warning: Color(0xFFAC7C29),
    danger: Color(0xFFC53B33),
    scrim: Color(0x73000000),
    proGradient: _proGradient,
    categoryOrganize: Color(0xFF2F6D8C),
    categoryConvert: Color(0xFF0F9184),
    categoryEdit: Color(0xFF6B5BA6),
    categorySecurity: Color(0xFFC53B33),
    categoryOptimize: Color(0xFFC4863A),
  );

  /// Dark palette (brand §2). The brand green is too dark to read as an
  /// accent on dark surfaces, so dark mode uses the lighter `#5E9C85`; the
  /// app icon still keeps `#285B49` — icons are never re-themed.
  factory LammColors.dark() => const LammColors(
    bg: Color(0xFF0E1512),
    surface: Color(0xFF16211D),
    sunken: Color(0xFF101A16),
    border: Color(0xFF26332D),
    textPrimary: Color(0xFFEDF2EF),
    textSecondary: Color(0xFFA6B3AD),
    textTertiary: Color(0xFF7A8781),
    accent: Color(0xFF5E9C85),
    accentPressed: Color(0xFF74B29A),
    accentSoft: Color(0xFF17302A),
    onAccent: Color(0xFF0B1310),
    gold: Color(0xFFD9BE83),
    goldSoft: Color(0xFF2A2318),
    onGold: Color(0xFF16211D),
    success: Color(0xFF2BB3A3),
    warning: Color(0xFFE0A93F),
    danger: Color(0xFFE5645B),
    scrim: Color(0x99000000),
    proGradient: _proGradient,
    categoryOrganize: Color(0xFF5FA3BF),
    categoryConvert: Color(0xFF2BB3A3),
    categoryEdit: Color(0xFF9C8BD6),
    categorySecurity: Color(0xFFE5645B),
    categoryOptimize: Color(0xFFE0A93F),
  );

  /// The only gradient in the UI (brand §2 rule 5): the Pro ornament.
  static const _proGradient = LinearGradient(
    colors: [Color(0xFFD8B878), Color(0xFFC4AA6C)],
  );

  final Color bg;
  final Color surface;
  final Color sunken;
  final Color border;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color accent;
  final Color accentPressed;
  final Color accentSoft;
  final Color onAccent;
  final Color gold;
  final Color goldSoft;
  final Color onGold;
  final Color success;
  final Color warning;
  final Color danger;
  final Color scrim;
  final LinearGradient proGradient;
  final Color categoryOrganize;
  final Color categoryConvert;
  final Color categoryEdit;
  final Color categorySecurity;
  final Color categoryOptimize;

  @override
  LammColors copyWith() => this;

  @override
  LammColors lerp(ThemeExtension<LammColors>? other, double t) {
    if (other is! LammColors) return this;
    Color c(Color a, Color b) => Color.lerp(a, b, t)!;
    return LammColors(
      bg: c(bg, other.bg),
      surface: c(surface, other.surface),
      sunken: c(sunken, other.sunken),
      border: c(border, other.border),
      textPrimary: c(textPrimary, other.textPrimary),
      textSecondary: c(textSecondary, other.textSecondary),
      textTertiary: c(textTertiary, other.textTertiary),
      accent: c(accent, other.accent),
      accentPressed: c(accentPressed, other.accentPressed),
      accentSoft: c(accentSoft, other.accentSoft),
      onAccent: c(onAccent, other.onAccent),
      gold: c(gold, other.gold),
      goldSoft: c(goldSoft, other.goldSoft),
      onGold: c(onGold, other.onGold),
      success: c(success, other.success),
      warning: c(warning, other.warning),
      danger: c(danger, other.danger),
      scrim: c(scrim, other.scrim),
      proGradient: t < 0.5 ? proGradient : other.proGradient,
      categoryOrganize: c(categoryOrganize, other.categoryOrganize),
      categoryConvert: c(categoryConvert, other.categoryConvert),
      categoryEdit: c(categoryEdit, other.categoryEdit),
      categorySecurity: c(categorySecurity, other.categorySecurity),
      categoryOptimize: c(categoryOptimize, other.categoryOptimize),
    );
  }
}

/// 4-pt spacing grid (brand §4).
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

/// Corner radii (brand §4).
abstract final class LammRadius {
  static const Radius small = Radius.circular(8);
  static const Radius medium = Radius.circular(14);
  static const Radius large = Radius.circular(22);

  static const BorderRadius smallAll = BorderRadius.all(small);
  static const BorderRadius mediumAll = BorderRadius.all(medium);
  static const BorderRadius largeAll = BorderRadius.all(large);
  static const BorderRadius full = BorderRadius.all(Radius.circular(999));
}

/// Motion durations and curves (brand §4).
abstract final class LammMotion {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration standard = Duration(milliseconds: 250);
  static const Duration emphasized = Duration(milliseconds: 400);

  static const Curve enter = Curves.easeOutCubic;
  static const Curve exit = Curves.easeInCubic;
}

/// Minimum touch targets (brand §4).
abstract final class LammTouch {
  static const double ios = 44;
  static const double android = 48;
  static const double min = 48;
}

/// Card/sheet shadow — light only; dark relies on [LammColors.surface]
/// (brand §4: `0 2 12 rgba(20,35,28,.06)`).
const List<BoxShadow> lammCardShadow = [
  BoxShadow(color: Color(0x0F14231C), blurRadius: 12, offset: Offset(0, 2)),
];
