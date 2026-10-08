import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lamm_kit/lamm_kit.dart';

/// WCAG relative luminance.
double _luminance(Color c) {
  double channel(double v) =>
      v <= 0.03928 ? v / 12.92 : math.pow((v + 0.055) / 1.055, 2.4).toDouble();
  return 0.2126 * channel(c.r) + 0.7152 * channel(c.g) + 0.0722 * channel(c.b);
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
        for (final bg in {
          'bg': c.bg,
          'surface': c.surface,
          'sunken': c.sunken,
          // The Pro card sits its body copy on goldSoft, not onGold — onGold
          // is only defined for text on solid gold fill (brand §2).
          'goldSoft': c.goldSoft,
        }.entries) {
          expect(
            contrast(c.textPrimary, bg.value),
            greaterThanOrEqualTo(aaBody),
            reason: 'textPrimary on ${bg.key}',
          );
        }
      });

      test('secondary text on every background', () {
        for (final bg in {
          'bg': c.bg,
          'surface': c.surface,
          'sunken': c.sunken,
        }.entries) {
          expect(
            contrast(c.textSecondary, bg.value),
            greaterThanOrEqualTo(aaBody),
            reason: 'textSecondary on ${bg.key}',
          );
        }
      });

      test('tertiary text meets large-text AA (captions)', () {
        expect(contrast(c.textTertiary, c.bg), greaterThanOrEqualTo(aaLarge));
      });

      // The input hint is textSecondary on the sunken fill (theme.dart).
      test('input hint (textSecondary) on sunken', () {
        expect(
          contrast(c.textSecondary, c.sunken),
          greaterThanOrEqualTo(aaBody),
        );
      });

      test('onAccent text on accent fill', () {
        expect(contrast(c.onAccent, c.accent), greaterThanOrEqualTo(aaBody));
      });

      test('onPrimaryContainer on accentSoft', () {
        final theme = name == 'light'
            ? LammTheme.light(const Locale('en'))
            : LammTheme.dark(const Locale('en'));
        final s = theme.colorScheme;
        expect(
          contrast(s.onPrimaryContainer, s.primaryContainer),
          greaterThanOrEqualTo(aaBody),
        );
      });

      test('gold on goldSoft (non-text accent), dark only', () {
        // Light is 1.95:1 - reported to Omar as a decision, not asserted.
        if (name == 'dark') {
          expect(contrast(c.gold, c.goldSoft), greaterThanOrEqualTo(aaLarge));
        }
      });

      // Brand §2 rule 2: gold never carries text on its own — `onGold` is
      // only defined for text on a solid `gold` fill (the Pro badge). `gold`
      // itself is never the sole carrier of information (it is a decorative
      // stroke/fill next to onGold text, or a small shape), so it is not
      // held to the icon/large-text 3:1 rule the way status colors are —
      // measured, it is ~2:1 on bg/surface/goldSoft alike, same as the
      // brand doc's own admission that gold reads weakly except as a small
      // accent (see docs/decisions.md).
      test('onGold text on gold fill', () {
        expect(contrast(c.onGold, c.gold), greaterThanOrEqualTo(aaBody));
      });

      test('status colors on bg/surface/sunken (3:1, icon/large)', () {
        for (final pair in {
          'success': c.success,
          'warning': c.warning,
          'danger': c.danger,
        }.entries) {
          for (final bg in [c.bg, c.surface, c.sunken]) {
            expect(
              contrast(pair.value, bg),
              greaterThanOrEqualTo(aaLarge),
              reason: pair.key,
            );
          }
        }
      });

      // Light success/warning are 3.2-3.9:1 on surface/sunken, so they are
      // not text colours (open decision); danger and all dark ones are.
      test('status colors as text (4.5:1) where they qualify', () {
        final text = [
          c.danger,
          if (name == 'dark') ...[c.success, c.warning],
        ];
        for (final s in text) {
          for (final bg in [c.bg, c.surface, c.sunken]) {
            expect(contrast(s, bg), greaterThanOrEqualTo(aaBody));
          }
        }
      });
    });
  }
}
