import 'package:flutter_test/flutter_test.dart';
import 'package:lamm_kit/lamm_kit.dart';

void main() {
  final fsi = String.fromCharCode(0x2068);
  final pdi = String.fromCharCode(0x2069);

  test('wraps text in isolate marks', () {
    expect(bidiIsolate('report.pdf'), '${fsi}report.pdf$pdi');
  });

  test('keeps an Arabic name with a Latin extension in one piece', () {
    const name = 'عقد الصيانة.pdf';
    final isolated = name.isolated;

    expect(isolated.startsWith(fsi), isTrue);
    expect(isolated.endsWith(pdi), isTrue);
    // The name itself is untouched — only the wrapper is added.
    expect(isolated.substring(1, isolated.length - 1), name);
  });

  test('leaves an empty string alone', () {
    expect(bidiIsolate(''), '');
  });

  test('is safe to apply to text that already has other marks', () {
    expect('a‏b'.isolated, '${fsi}a‏b$pdi');
  });
}
