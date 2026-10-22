import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lamm_kit/lamm_kit.dart';

Widget _app(Widget home) => MaterialApp(
  theme: LammTheme.light(const Locale('en')),
  home: Scaffold(body: home),
);

Future<void> _open(
  WidgetTester tester,
  Future<Object?> Function(BuildContext) open,
  void Function(Object?) onResult,
) async {
  await tester.pumpWidget(
    _app(
      Builder(
        builder: (c) => TextButton(
          onPressed: () async => onResult(await open(c)),
          child: const Text('open'),
        ),
      ),
    ),
  );
  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('picker pops the tapped value', (tester) async {
    Object? result;
    await _open(
      tester,
      (c) => showLammPicker<int>(
        c,
        title: 'T',
        selected: 1,
        options: const [
          LammPickerOption(value: 1, title: 'One', description: 'd'),
          LammPickerOption(value: 2, title: 'Two'),
        ],
      ),
      (r) => result = r,
    );
    await tester.tap(find.text('Two'));
    await tester.pumpAndSettle();
    expect(result, 2);
  });

  for (final yes in [true, false]) {
    testWidgets('confirm pops $yes', (tester) async {
      Object? result;
      await _open(
        tester,
        (c) => showLammConfirm(
          c,
          title: 'T',
          message: 'm',
          confirmLabel: 'Delete 3',
          cancelLabel: 'Cancel',
        ),
        (r) => result = r,
      );
      await tester.tap(find.text(yes ? 'Delete 3' : 'Cancel'));
      await tester.pumpAndSettle();
      expect(result, yes);
    });
  }

  testWidgets('action sheet pops the action id', (tester) async {
    Object? result;
    await _open(
      tester,
      (c) => showLammActions(
        c,
        title: 'Subject',
        groups: const [
          [LammSheetAction(id: 'share', icon: Ph.share, label: 'Share')],
        ],
        destructive: const [
          LammSheetAction(id: 'del', icon: Ph.trash, label: 'Delete'),
        ],
      ),
      (r) => result = r,
    );
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();
    expect(result, 'del');
  });

  testWidgets('close button dismisses the sheet', (tester) async {
    Object? result = 'unset';
    await _open(
      tester,
      (c) => showLammSheet<int>(
        c,
        builder: (_) => const LammSheet(title: 'T', child: SizedBox()),
      ),
      (r) => result = r,
    );
    await tester.tap(find.byType(IconButton));
    await tester.pumpAndSettle();
    expect(result, isNull);
  });

  testWidgets('segmented control reports taps', (tester) async {
    var sel = 'a';
    await tester.pumpWidget(
      _app(
        LammSegmentedControl<String>(
          selected: sel,
          onChanged: (v) => sel = v,
          segments: const [
            LammSegment(value: 'a', label: 'A'),
            LammSegment(value: 'b', label: 'B', marker: Text('Pro')),
          ],
        ),
      ),
    );
    await tester.tap(find.text('B'));
    expect(sel, 'b');
    expect(find.text('Pro'), findsOneWidget);
  });

  testWidgets('inset row fires onTap', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      _app(
        LammInsetGroup(
          children: [
            LammInsetRow(title: 'Row', value: 'v', onTap: () => taps++),
            const LammInsetRow(title: 'Other'),
          ],
        ),
      ),
    );
    await tester.tap(find.text('Row'));
    expect(taps, 1);
  });

  testWidgets('type tile renders every category', (tester) async {
    await tester.pumpWidget(
      _app(
        Row(
          children: [
            for (final cat in LammCategory.values)
              LammTypeTile(icon: Ph.link, category: cat),
          ],
        ),
      ),
    );
    expect(find.byType(LammTypeTile), findsNWidgets(5));
  });
}
