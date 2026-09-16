import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lamm_kit/lamm_kit.dart';

/// WCAG relative luminance.
double _luminance(Color c) {
  double channel(double v) =>
      v <= 0.03928 ? v / 12.92 : math.pow((v + 0.055) / 1.055, 2.4).toDouble();
  return 0.2126 * channel(c.r) +
      0.7152 * channel(c.g) +
      0.0722 * channel(c.b);
}

double contrast(Color a, Color b) {
  final la = _luminance(a);
  final lb = _luminance(b);
  final hi = math.max(la, lb);
  final lo = math.min(la, lb);
  return (hi + 0.05) / (lo + 0.05);
}

void main() {
  // §4.2: "All text/background pairs must meet WCAG AA (4.5:1 for body text)."
  const aaBody = 4.5;
  const aaLarge = 3.0;

  for (final entry in {
    'light': LammColors.light(),
    'dark': LammColors.dark(),
  }.entries) {
    final name = entry.key;
    final c = entry.value;

    group('$name theme contrast', () {
      test('primary text on every background', () {
        for (final bg in {'bg': c.bg, 'elevated': c.bgElevated, 'sunken': c.bgSunken}.entries) {
          expect(
            contrast(c.textPrimary, bg.value),
            greaterThanOrEqualTo(aaBody),
            reason: 'textPrimary on ${bg.key}',
          );
        }
      });

      test('secondary text on every background', () {
        for (final bg in {'bg': c.bg, 'elevated': c.bgElevated, 'sunken': c.bgSunken}.entries) {
          expect(
            contrast(c.textSecondary, bg.value),
            greaterThanOrEqualTo(aaBody),
            reason: 'textSecondary on ${bg.key}',
          );
        }
      });

      test('tertiary text meets large-text AA (hints, captions)', () {
        expect(contrast(c.textTertiary, c.bg), greaterThanOrEqualTo(aaLarge));
      });

      test('onAccent text on accent fill', () {
        expect(contrast(c.onAccent, c.accent), greaterThanOrEqualTo(aaLarge));
      });

      test('status colors are distinguishable from background', () {
        for (final pair in {
          'success': c.success,
          'warning': c.warning,
          'danger': c.danger,
        }.entries) {
          expect(
            contrast(pair.value, c.bg),
            greaterThanOrEqualTo(aaLarge),
            reason: pair.key,
          );
        }
      });
    });
  }
}
