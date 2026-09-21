import 'dart:async';

import 'package:meta/meta.dart';

/// Pro entitlement, store-agnostic (§3.2).
///
/// The interface deliberately says nothing about RevenueCat, StoreKit or
/// Google Play: the newer apps use RevenueCat; Lamm Photo Cleaner is on
/// `in_app_purchase`, and both should be able to share this and the paywall
/// that reads it.

/// How the user came to be Pro — shown in Settings and used in analytics.
enum ProSource { none, subscription, lifetime, promo, sandbox }

/// The answer to "may this person use Pro features right now?".
@immutable
class ProStatus {
  const ProStatus({
    required this.isPro,
    this.source = ProSource.none,
    this.expiresAt,
    this.willRenew = false,
    this.productId,
  });

  static const free = ProStatus(isPro: false);

  final bool isPro;
  final ProSource source;

  /// Null for lifetime purchases.
  final DateTime? expiresAt;

  final bool willRenew;
  final String? productId;

  bool get isLifetime => source == ProSource.lifetime;

  @override
  bool operator ==(Object other) =>
      other is ProStatus &&
      other.isPro == isPro &&
      other.source == source &&
      other.expiresAt == expiresAt &&
      other.willRenew == willRenew &&
      other.productId == productId;

  @override
  int get hashCode =>
      Object.hash(isPro, source, expiresAt, willRenew, productId);
}

/// How long a subscription lasts. The paywall computes "save X%" from real
/// prices, so it needs to know what it is comparing.
enum ProPeriod { monthly, annual, lifetime }

/// A purchasable product, with the store's own localized price string —
/// §3.6 forbids formatting prices ourselves.
class ProProduct {
  const ProProduct({
    required this.id,
    required this.period,
    required this.priceString,
    required this.priceAmount,
    required this.currencyCode,
    this.trialDays = 0,
  });

  final String id;
  final ProPeriod period;

  /// Exactly as the store returned it, e.g. "$29.99" or "٢٩٫٩٩ US$".
  final String priceString;

  final double priceAmount;
  final String currencyCode;

  /// 0 when there is no introductory offer.
  final int trialDays;

  bool get hasTrial => trialDays > 0;

  /// Price per month, for comparing an annual plan with a monthly one.
  double get monthlyEquivalent => switch (period) {
    ProPeriod.monthly => priceAmount,
    ProPeriod.annual => priceAmount / 12,
    ProPeriod.lifetime => priceAmount,
  };
}

/// What happened when the user tried to buy.
enum PurchaseOutcome { purchased, restored, cancelled, pending, failed }

class PurchaseResult {
  const PurchaseResult(this.outcome, {this.status, this.message});

  final PurchaseOutcome outcome;
  final ProStatus? status;

  /// For [PurchaseOutcome.failed]: something to show, already localized by the
  /// caller or coming from the store.
  final String? message;

  bool get isSuccess =>
      outcome == PurchaseOutcome.purchased ||
      outcome == PurchaseOutcome.restored;
}

abstract interface class EntitlementService {
  /// Connects to the store. Safe to call more than once.
  Future<void> initialize();

  /// The current answer, available synchronously so a gate never has to wait.
  ProStatus get status;

  /// Changes over time: a purchase, a restore, an expiry.
  Stream<ProStatus> get changes;

  /// The offering to show on the paywall, in display order.
  Future<List<ProProduct>> products();

  Future<PurchaseResult> purchase(ProProduct product);

  /// §3.6: "Restore Purchases" is required on the paywall.
  Future<PurchaseResult> restore();

  Future<void> dispose();
}

/// The implementation used in development and in every test (§3.2 fake).
///
/// It behaves like a store that always succeeds, which is what lets every Pro
/// gate be built and tested long before any keys exist.
class FakeEntitlementService implements EntitlementService {
  FakeEntitlementService({ProStatus initial = ProStatus.free})
    : _status = initial;

  final _controller = StreamController<ProStatus>.broadcast();
  ProStatus _status;

  static const catalogue = [
    ProProduct(
      id: 'lamm_pro_annual',
      period: ProPeriod.annual,
      priceString: r'$29.99',
      priceAmount: 29.99,
      currencyCode: 'USD',
      trialDays: 7,
    ),
    ProProduct(
      id: 'lamm_pro_monthly',
      period: ProPeriod.monthly,
      priceString: r'$4.99',
      priceAmount: 4.99,
      currencyCode: 'USD',
    ),
    ProProduct(
      id: 'lamm_pro_lifetime',
      period: ProPeriod.lifetime,
      priceString: r'$59.99',
      priceAmount: 59.99,
      currencyCode: 'USD',
    ),
  ];

  @override
  ProStatus get status => _status;

  @override
  Stream<ProStatus> get changes => _controller.stream;

  @override
  Future<void> initialize() async {}

  @override
  Future<List<ProProduct>> products() async => catalogue;

  @override
  Future<PurchaseResult> purchase(ProProduct product) async {
    _set(
      ProStatus(
        isPro: true,
        source: product.period == ProPeriod.lifetime
            ? ProSource.lifetime
            : ProSource.subscription,
        productId: product.id,
        willRenew: product.period != ProPeriod.lifetime,
        expiresAt: product.period == ProPeriod.lifetime
            ? null
            : DateTime.now().add(
                Duration(days: product.period == ProPeriod.annual ? 365 : 30),
              ),
      ),
    );
    return PurchaseResult(PurchaseOutcome.purchased, status: _status);
  }

  @override
  Future<PurchaseResult> restore() async =>
      PurchaseResult(PurchaseOutcome.restored, status: _status);

  /// Test hook: become Pro, or stop being Pro, without a purchase.
  void setStatus(ProStatus status) => _set(status);

  void _set(ProStatus status) {
    _status = status;
    _controller.add(status);
  }

  @override
  Future<void> dispose() => _controller.close();
}
