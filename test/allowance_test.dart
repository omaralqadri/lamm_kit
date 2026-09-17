import 'package:flutter_test/flutter_test.dart';
import 'package:lamm_kit/lamm_kit.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// §3.4: the daily allowance is what stands between a free user and the
/// paywall, so its arithmetic and its midnight reset are worth pinning down.
void main() {
  late SharedPreferences prefs;
  var now = DateTime(2026, 9, 17, 10);

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    now = DateTime(2026, 9, 17, 10);
  });

  AllowanceService service({int limit = 2}) =>
      AllowanceService(prefs: prefs, dailyLimit: limit, now: () => now);

  test('a fresh day starts with the full allowance', () {
    expect(service().remaining, 2);
    expect(service().hasRemaining, isTrue);
  });

  test('each action spends one, and no more than the limit', () async {
    final allowance = service();
    expect(await allowance.consume(), 1);
    expect(await allowance.consume(), 0);
    expect(allowance.hasRemaining, isFalse);

    await allowance.consume();
    expect(allowance.remaining, 0, reason: 'never goes negative');
  });

  test('the count resets at local midnight, not after 24 hours', () async {
    final allowance = service();
    await allowance.consume();
    await allowance.consume();
    expect(allowance.remaining, 0);

    // Ten minutes past midnight is a new day, even though it is not 24 hours.
    now = DateTime(2026, 9, 18, 0, 10);
    expect(allowance.remaining, 2);
  });

  test('the time until reset counts down to midnight', () {
    now = DateTime(2026, 9, 17, 22, 30);
    final until = service().untilReset;
    expect(until.inHours, 1);
    expect(until.inMinutes, 90);
  });

  test('Remote Config can change the limit', () {
    expect(service().withLimit(5).remaining, 5);
    expect(service(limit: 0).hasRemaining, isFalse);
  });

  test('a purchase clears the counter', () async {
    final allowance = service();
    await allowance.consume();
    await allowance.reset();
    expect(allowance.remaining, 2);
  });
}
