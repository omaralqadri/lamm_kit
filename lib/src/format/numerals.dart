import 'package:intl/intl.dart';

/// Numeral system for displayed numbers (§10.4). Western by default; the
/// mapping is explicit rather than locale-driven so the setting always wins.
enum Numerals { auto, western, arabicIndic }

abstract final class LammNumerals {
  static const _arabicIndic = [
    '٠',
    '١',
    '٢',
    '٣',
    '٤',
    '٥',
    '٦',
    '٧',
    '٨',
    '٩',
  ];

  /// Resolves [Numerals.auto] against the UI [languageCode].
  /// Auto stays Western even in Arabic — the spec's default (§10.4).
  static bool useArabicIndic(Numerals setting, String languageCode) =>
      switch (setting) {
        Numerals.arabicIndic => true,
        Numerals.western => false,
        Numerals.auto => false,
      };

  /// Maps ASCII digits in [input] to Arabic-Indic when [enabled].
  static String apply(String input, {required bool enabled}) {
    if (!enabled) return input;
    final buffer = StringBuffer();
    for (final rune in input.runes) {
      if (rune >= 0x30 && rune <= 0x39) {
        buffer.write(_arabicIndic[rune - 0x30]);
      } else {
        buffer.writeCharCode(rune);
      }
    }
    return buffer.toString();
  }

  /// Arabic-Indic (٠-٩) and Eastern Arabic-Indic (۰-۹) digits → ASCII.
  /// Used by the range parser (§6.9) and the search index (§10.5).
  static String toWestern(String input) {
    final buffer = StringBuffer();
    for (final rune in input.runes) {
      if (rune >= 0x0660 && rune <= 0x0669) {
        buffer.writeCharCode(0x30 + (rune - 0x0660));
      } else if (rune >= 0x06F0 && rune <= 0x06F9) {
        buffer.writeCharCode(0x30 + (rune - 0x06F0));
      } else {
        buffer.writeCharCode(rune);
      }
    }
    return buffer.toString();
  }
}

/// File sizes in base 1000 (§10.4): one decimal under 10, none above.
abstract final class LammFileSize {
  static const _unitsEn = ['B', 'KB', 'MB', 'GB', 'TB'];
  static const _unitsAr = ['بايت', 'ك.ب', 'م.ب', 'ج.ب', 'ت.ب'];

  static String format(
    int bytes, {
    required String languageCode,
    Numerals numerals = Numerals.auto,
  }) {
    final units = languageCode == 'ar' ? _unitsAr : _unitsEn;
    var value = bytes.toDouble();
    var unit = 0;
    while (value >= 1000 && unit < units.length - 1) {
      value /= 1000;
      unit++;
    }
    final text = unit == 0
        ? value.toStringAsFixed(0)
        : (value < 10 ? value.toStringAsFixed(1) : value.toStringAsFixed(0));
    final localized = NumberFormat.decimalPattern(languageCode)
        .format(double.parse(text));
    final digits = LammNumerals.apply(
      localized,
      enabled: LammNumerals.useArabicIndic(numerals, languageCode),
    );
    return '$digits ${units[unit]}';
  }
}
