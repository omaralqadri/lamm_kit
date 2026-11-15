import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lamm_kit/lamm_kit.dart';

void main() {
  for (final labels in [
    ['None', 'WEP', 'WPA/WPA2', 'WPA3'],
    ['512', '1024', '2048', '4096'],
  ]) {
    testWidgets('labels stay fully laid out at 2.0 text: $labels', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        MaterialApp(
          theme: LammTheme.light(const Locale('en')),
          home: MediaQuery(
            data: const MediaQueryData(
              size: Size(360, 800),
              textScaler: TextScaler.linear(2),
            ),
            child: Scaffold(
              body: LammSegmentedControl<String>(
                segments: [
                  for (final l in labels) LammSegment(value: l, label: l),
                ],
                selected: labels.first,
                onChanged: (_) {},
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
        // Full text laid out: no ellipsis, every glyph inside the box.
        expect(p.maxLines, isNull);
        expect(p.overflow, TextOverflow.clip);
      }
    });
  }
}
