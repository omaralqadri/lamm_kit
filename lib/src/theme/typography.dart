import 'package:flutter/material.dart';

/// Type scale — spec §4.3. Sizes are in logical pixels; line heights are
/// expressed as a ratio so [TextStyle.height] stays correct at any text scale.
///
/// Arabic line heights get +10% (Arabic glyphs need more vertical room).
@immutable
class LammTypography extends ThemeExtension<LammTypography> {
  const LammTypography({
    required this.display,
    required this.title1,
    required this.title2,
    required this.headline,
    required this.body,
    required this.callout,
    required this.footnote,
    required this.caption,
  });

  /// Builds the scale for [locale]. Latin uses Inter, Arabic uses
  /// IBM Plex Sans Arabic; the other always sits in `fontFamilyFallback`
  /// so mixed strings never show tofu.
  factory LammTypography.forLocale(Locale locale) {
    final isArabic = locale.languageCode == 'ar';
    final family = isArabic ? arabicFamily : latinFamily;
    final fallback = isArabic ? [latinFamily] : [arabicFamily];
    final lh = isArabic ? 1.10 : 1.0;

    TextStyle s(double size, double lineHeight, FontWeight weight) => TextStyle(
      fontFamily: family,
      fontFamilyFallback: fallback,
      fontSize: size,
      height: lineHeight / size * lh,
      fontWeight: weight,
      leadingDistribution: TextLeadingDistribution.even,
    );

    return LammTypography(
      display: s(32, 38, FontWeight.w700),
      title1: s(24, 30, FontWeight.w700),
      title2: s(20, 26, FontWeight.w600),
      headline: s(17, 22, FontWeight.w600),
      body: s(16, 23, FontWeight.w400),
      callout: s(15, 21, FontWeight.w400),
      footnote: s(13, 18, FontWeight.w400),
      caption: s(12, 16, FontWeight.w500),
    );
  }

  static const String latinFamily = 'Inter';
  static const String arabicFamily = 'IBMPlexSansArabic';

  final TextStyle display;
  final TextStyle title1;
  final TextStyle title2;
  final TextStyle headline;
  final TextStyle body;
  final TextStyle callout;
  final TextStyle footnote;
  final TextStyle caption;

  /// Maps the Lamm scale onto Material's [TextTheme] so stock widgets inherit it.
  TextTheme toTextTheme(Color primary, Color secondary) => TextTheme(
    displayLarge: display.copyWith(color: primary),
    displayMedium: display.copyWith(color: primary),
    displaySmall: title1.copyWith(color: primary),
    headlineLarge: title1.copyWith(color: primary),
    headlineMedium: title1.copyWith(color: primary),
    headlineSmall: title2.copyWith(color: primary),
    titleLarge: title2.copyWith(color: primary),
    titleMedium: headline.copyWith(color: primary),
    titleSmall: callout.copyWith(color: primary),
    bodyLarge: body.copyWith(color: primary),
    bodyMedium: body.copyWith(color: primary),
    bodySmall: footnote.copyWith(color: secondary),
    labelLarge: headline.copyWith(color: primary),
    labelMedium: callout.copyWith(color: secondary),
    labelSmall: caption.copyWith(color: secondary),
  );

  @override
  LammTypography copyWith() => this;

  @override
  LammTypography lerp(ThemeExtension<LammTypography>? other, double t) {
    if (other is! LammTypography) return this;
    return t < 0.5 ? this : other;
  }
}
