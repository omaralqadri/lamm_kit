import 'package:shared_preferences/shared_preferences.dart';

/// The daily free allowance (§3.4).
///
/// A Pro action counts **only when the result is saved** — opening a tool or
/// looking at a preview is free, which is what makes the paywall land at the
/// moment of intent rather than as a toll gate.
class AllowanceService {
  AllowanceService({
    required this.prefs,
    this.dailyLimit = defaultDailyLimit,
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now;

  /// Remote Config `free_pro_actions_per_day` (§3.4).
  static const defaultDailyLimit = 2;

  static const _kDate = 'allowance.date';
  static const _kUsed = 'allowance.used';

  final SharedPreferences prefs;
  final DateTime Function() _now;

  final int dailyLimit;

  /// Local midnight resets the count, so "today" is the user's today.
  String get _today {
    final now = _now();
    return '${now.year}-${now.month}-${now.day}';
  }

  int get used {
    if (prefs.getString(_kDate) != _today) return 0;
    return prefs.getInt(_kUsed) ?? 0;
  }

  int get remaining => (dailyLimit - used).clamp(0, dailyLimit);

  bool get hasRemaining => remaining > 0;

  /// Time until the allowance refreshes, for "your free actions refresh
  /// tomorrow" (§3.4).
  Duration get untilReset {
    final now = _now();
    return DateTime(now.year, now.month, now.day + 1).difference(now);
  }

  /// Records one Pro action. Returns what is left afterwards.
  Future<int> consume() async {
    final next = used + 1;
    await prefs.setString(_kDate, _today);
    await prefs.setInt(_kUsed, next);
    return (dailyLimit - next).clamp(0, dailyLimit);
  }

  /// After a purchase there is nothing to count; also used by tests.
  Future<void> reset() async {
    await prefs.remove(_kDate);
    await prefs.remove(_kUsed);
  }

  /// A copy with a different limit, for when Remote Config changes it.
  AllowanceService withLimit(int limit) =>
      AllowanceService(prefs: prefs, dailyLimit: limit, now: _now);
}
