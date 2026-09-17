import 'package:flutter_test/flutter_test.dart';
import 'package:lamm_kit/lamm_kit.dart';

/// §3.2: the fake is what every gate is built against until the store keys
/// arrive, so it has to behave like a store that works.
void main() {
  test('a fresh install is not Pro', () {
    expect(FakeEntitlementService().status.isPro, isFalse);
    expect(ProStatus.free.isPro, isFalse);
  });

  test('buying a subscription makes the user Pro and renews', () async {
    final service = FakeEntitlementService();
    final annual = FakeEntitlementService.catalogue.first;

    final result = await service.purchase(annual);

    expect(result.isSuccess, isTrue);
    expect(service.status.isPro, isTrue);
    expect(service.status.source, ProSource.subscription);
    expect(service.status.willRenew, isTrue);
    expect(service.status.expiresAt, isNotNull);
  });

  test('a lifetime purchase never expires', () async {
    final service = FakeEntitlementService();
    final lifetime = FakeEntitlementService.catalogue.last;

    await service.purchase(lifetime);

    expect(service.status.isLifetime, isTrue);
    expect(service.status.expiresAt, isNull);
    expect(service.status.willRenew, isFalse);
  });

  test('status changes are broadcast', () async {
    final service = FakeEntitlementService();
    final seen = <bool>[];
    final subscription = service.changes.listen((s) => seen.add(s.isPro));

    await service.purchase(FakeEntitlementService.catalogue.first);
    await Future<void>.delayed(Duration.zero);
    await subscription.cancel();

    expect(seen, [true]);
  });

  test('the annual plan is the better deal, per real prices', () {
    final annual = FakeEntitlementService.catalogue.firstWhere(
      (p) => p.period == ProPeriod.annual,
    );
    final monthly = FakeEntitlementService.catalogue.firstWhere(
      (p) => p.period == ProPeriod.monthly,
    );

    expect(annual.monthlyEquivalent, lessThan(monthly.monthlyEquivalent));
    expect(annual.hasTrial, isTrue, reason: '§3.2: trial on annual only');
    expect(monthly.hasTrial, isFalse);
  });
}
