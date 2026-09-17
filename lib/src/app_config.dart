import 'package:flutter/material.dart';

/// One benefit line on the paywall (§3.6: max 5).
@immutable
class PaywallBenefit {
  const PaywallBenefit({required this.icon, required this.labelKey});

  final IconData icon;

  /// Key resolved by the host app's localizations, not a literal string.
  final String labelKey;
}

/// Everything that differs between Lamm apps (§9). Lamm Kit itself is
/// app-agnostic: it reads the app's identity, accent and store links from here.
@immutable
class LammAppConfig {
  const LammAppConfig({
    required this.appId,
    required this.displayName,
    required this.accentLight,
    required this.accentDark,
    required this.accentSoftLight,
    required this.accentSoftDark,
    required this.entitlementId,
    required this.privacyUrl,
    required this.termsUrl,
    required this.supportEmail,
    required this.appStoreUrl,
    required this.playStoreUrl,
    this.revenueCatApiKeyIos = '',
    this.revenueCatApiKeyAndroid = '',
    this.benefits = const [],
  });

  /// 'pdf' | 'qr' | 'photocleaner'
  final String appId;
  final String displayName;
  final Color accentLight;
  final Color accentDark;
  final Color accentSoftLight;
  final Color accentSoftDark;

  /// RevenueCat keys. Empty means "no billing backend configured" — the app
  /// falls back to the fake entitlement service (dev/tests).
  final String revenueCatApiKeyIos;
  final String revenueCatApiKeyAndroid;
  final String entitlementId;

  final Uri privacyUrl;
  final Uri termsUrl;
  final String supportEmail;
  final Uri appStoreUrl;
  final Uri playStoreUrl;
  final List<PaywallBenefit> benefits;
}

/// Provides [LammAppConfig] to the widget tree.
class LammConfigScope extends InheritedWidget {
  const LammConfigScope({
    required this.config,
    required super.child,
    super.key,
  });

  final LammAppConfig config;

  static LammAppConfig of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<LammConfigScope>();
    assert(scope != null, 'No LammConfigScope found in context');
    return scope!.config;
  }

  @override
  bool updateShouldNotify(LammConfigScope oldWidget) =>
      oldWidget.config != config;
}
