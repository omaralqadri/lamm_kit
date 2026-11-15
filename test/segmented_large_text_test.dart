import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lamm_kit/lamm_kit.dart';

void main() {
  for (final scale in [1.0, 2.0]) {
    for (final labels in [
      ['None', 'WEP', 'WPA/WPA2', 'WPA3'],
      ['512', '1024', '2048', '4096'],
    ]) {
      testWidgets('labels fully laid out at $scale text: $labels', (
        tester,
      ) async {
        tester.view.physicalSize = const Size(360, 800);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);
        await tester.pumpWidget(
          MaterialApp(
            theme: LammTheme.light(const Locale('en')),
            home: MediaQuery(
              data: MediaQueryData(
                size: const Size(360, 800),
                textScaler: TextScaler.linear(scale),
              ),
              child: Scaffold(
                // Unbounded height, like real usage.
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      LammSegmentedControl<String>(
                        segments: [
                          for (final l in labels)
                            LammSegment(value: l, label: l),
                        ],
                        selected: labels.first,
                        onChanged: (_) {},
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
        expect(tester.takeException(), isNull);
        for (final l in labels) {
          final p = tester.renderObject<RenderParagraph>(find.text(l));
          expect(p.didExceedMaxLines, isFalse);
          expect(p.text.toPlainText(), l);
          expect(p.maxLines, isNull);
          expect(p.overflow, TextOverflow.clip);
        }
        final h = tester
            .getSize(find.byType(LammSegmentedControl<String>))
            .height;
        if (scale == 1) {
          // Single line: min touch height plus track padding.
          expect(h, LammTouch.ios + 2 * LammSpacing.xxs);
        } else {
          expect(h, lessThan(200));
        }
      });
    }
  }
}
