import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hpyat_mal/core/models/app_currency.dart';
import 'package:hpyat_mal/core/theme/app_color.dart';
import 'package:shared_preferences/shared_preferences.dart';

final storageServiceProvider = Provider<StorageService>((ref) {
  throw UnimplementedError('StorageService must be initialized in main');
});

class CravingLog {
  final String id;
  final DateTime timestamp;
  final String trigger;
  final int intensity; // 1 - 5
  final bool resisted;
  final String note;

  const CravingLog({
    required this.id,
    required this.timestamp,
    required this.trigger,
    required this.intensity,
    required this.resisted,
    required this.note,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'timestamp': timestamp.toIso8601String(),
        'trigger': trigger,
        'intensity': intensity,
        'resisted': resisted,
        'note': note,
      };

  factory CravingLog.fromJson(Map<String, dynamic> json) => CravingLog(
        id: json['id'] as String,
        timestamp: DateTime.parse(json['timestamp'] as String),
        trigger: json['trigger'] as String,
        intensity: json['intensity'] as int,
        resisted: json['resisted'] as bool,
        note: (json['note'] as String?) ?? '',
      );
}

class WishlistItem {
  final String id;
  final String title;
  final double targetAmount;
  final String iconKey;
  final String? imagePath;
  final bool isCompleted;

  const WishlistItem({
    required this.id,
    required this.title,
    required this.targetAmount,
    required this.iconKey,
    this.imagePath,
    this.isCompleted = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'targetAmount': targetAmount,
        'iconKey': iconKey,
        'imagePath': imagePath,
        'isCompleted': isCompleted,
      };

  factory WishlistItem.fromJson(Map<String, dynamic> json) => WishlistItem(
        id: json['id'] as String,
        title: json['title'] as String,
        targetAmount: (json['targetAmount'] as num).toDouble(),
        iconKey: (json['iconKey'] as String?) ?? 'gift',
        imagePath: json['imagePath'] as String?,
        isCompleted: (json['isCompleted'] as bool?) ?? false,
      );

  WishlistItem copyWith({
    String? title,
    double? targetAmount,
    String? iconKey,
    String? imagePath,
    bool clearImagePath = false,
    bool? isCompleted,
  }) =>
      WishlistItem(
        id: id,
        title: title ?? this.title,
        targetAmount: targetAmount ?? this.targetAmount,
        iconKey: iconKey ?? this.iconKey,
        imagePath: clearImagePath ? null : (imagePath ?? this.imagePath),
        isCompleted: isCompleted ?? this.isCompleted,
      );
}

class StorageService {
  static const String _keyQuitDate = 'quit_date';
  static const String _keyUserName = 'user_name';
  static const String _keyQuitReason = 'quit_reason';
  static const String _keyOnboardingCompleted = 'onboarding_completed';
  static const String _keyCigsPerDay = 'cigs_per_day';
  static const String _keyPackCost = 'pack_cost';
  static const String _keyCigsPerPack = 'cigs_per_pack';
  static const String _keyForestVitality = 'forest_vitality'; // 0 - 100
  static const String _keyCravingLogs = 'craving_logs';
  static const String _keyWishlist = 'wishlist_items';
  static const String _keyBreathingCount = 'breathing_count';
  static const String _keyPlantTheme = 'plant_theme';
  static const String _keyCurrency = 'app_currency';

  final SharedPreferences _prefs;

  StorageService(this._prefs);

  static Future<StorageService> init() async {
    final prefs = await SharedPreferences.getInstance();
    final service = StorageService(prefs);
    AppColors.setTheme(service.getPlantTheme());
    return service;
  }

  // Plant & Theme Preference (Single Source of Truth)
  PlantThemeType getPlantTheme() =>
      PlantThemeType.fromStorage(_prefs.getString(_keyPlantTheme));

  Future<void> setPlantTheme(PlantThemeType theme) async {
    AppColors.setTheme(theme);
    await _prefs.setString(_keyPlantTheme, theme.storageKey);
  }

  // App Currency Preference
  AppCurrency getCurrency() =>
      AppCurrency.fromStorage(_prefs.getString(_keyCurrency));

  Future<void> setCurrency(AppCurrency currency) async {
    await _prefs.setString(_keyCurrency, currency.code);
  }

  // Onboarding status
  bool isOnboardingCompleted() =>
      _prefs.getBool(_keyOnboardingCompleted) ?? false;

  Future<void> setOnboardingCompleted(bool value) async {
    await _prefs.setBool(_keyOnboardingCompleted, value);
  }

  // User Profile & Reason
  String getUserName() => _prefs.getString(_keyUserName) ?? 'Friend';
  Future<void> setUserName(String name) async {
    await _prefs.setString(_keyUserName, name);
  }

  String getQuitReason() =>
      _prefs.getString(_keyQuitReason) ??
      'To breathe freely, protect my health, and be there for my loved ones.';

  Future<void> setQuitReason(String reason) async {
    await _prefs.setString(_keyQuitReason, reason);
  }

  Future<void> saveOnboardingProfile({
    required String name,
    required int cigsPerDay,
    required int cigsPerPack,
    required double packCost,
    required String quitReason,
    DateTime? quitDate,
    PlantThemeType? plantTheme,
  }) async {
    if (plantTheme != null) {
      await setPlantTheme(plantTheme);
    }
    await setUserName(name);
    await setCigsPerDay(cigsPerDay);
    await setCigsPerPack(cigsPerPack);
    await setPackCost(packCost);
    await setQuitReason(quitReason);
    await setQuitDate(quitDate ?? DateTime.now());
    await setOnboardingCompleted(true);
  }

  // Quit Date
  DateTime getQuitDate() {
    final iso = _prefs.getString(_keyQuitDate);
    if (iso != null) {
      return DateTime.tryParse(iso) ?? _defaultQuitDate();
    }
    final defaultDate = _defaultQuitDate();
    setQuitDate(defaultDate);
    return defaultDate;
  }

  static DateTime _defaultQuitDate() =>
      DateTime.now().subtract(const Duration(days: 3, hours: 14));

  Future<void> setQuitDate(DateTime date) async {
    await _prefs.setString(_keyQuitDate, date.toIso8601String());
  }

  // Habits Configuration
  int getCigsPerDay() => _prefs.getInt(_keyCigsPerDay) ?? 15;
  Future<void> setCigsPerDay(int value) => _prefs.setInt(_keyCigsPerDay, value);

  double getPackCost() => _prefs.getDouble(_keyPackCost) ?? 3500.0;
  Future<void> setPackCost(double value) => _prefs.setDouble(_keyPackCost, value);

  int getCigsPerPack() => _prefs.getInt(_keyCigsPerPack) ?? 20;
  Future<void> setCigsPerPack(int value) =>
      _prefs.setInt(_keyCigsPerPack, value);

  // Forest Vitality
  int getForestVitality() => _prefs.getInt(_keyForestVitality) ?? 95;
  Future<void> setForestVitality(int value) =>
      _prefs.setInt(_keyForestVitality, value.clamp(10, 100));

  // Breathing sessions
  int getBreathingSessions() => _prefs.getInt(_keyBreathingCount) ?? 4;
  Future<void> incrementBreathingSessions() async {
    final count = getBreathingSessions() + 1;
    await _prefs.setInt(_keyBreathingCount, count);
  }

  // Craving Logs
  List<CravingLog> getCravingLogs() {
    final rawList = _prefs.getStringList(_keyCravingLogs);
    if (rawList == null || rawList.isEmpty) {
      return _initialDefaultLogs();
    }
    return rawList
        .map((str) => CravingLog.fromJson(jsonDecode(str) as Map<String, dynamic>))
        .toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  Future<void> saveCravingLog(CravingLog log) async {
    final logs = getCravingLogs();
    logs.insert(0, log);
    final rawList = logs.map((e) => jsonEncode(e.toJson())).toList();
    await _prefs.setStringList(_keyCravingLogs, rawList);
  }

  // Wishlist
  static bool _isLegacySeedGoal(WishlistItem item) {
    return (item.id == '1' && item.title == 'Premium Running Shoes') ||
        (item.id == '2' && item.title == 'Weekend Cabin Trip') ||
        (item.id == '3' && item.title == 'Noise Cancelling Earbuds');
  }

  List<WishlistItem> getWishlist() {
    final rawList = _prefs.getStringList(_keyWishlist);
    if (rawList == null || rawList.isEmpty) {
      return [];
    }
    final items = rawList
        .map((str) =>
            WishlistItem.fromJson(jsonDecode(str) as Map<String, dynamic>))
        .toList();
    final filtered = items.where((item) => !_isLegacySeedGoal(item)).toList();
    if (filtered.length != items.length) {
      _prefs.setStringList(
        _keyWishlist,
        filtered.map((e) => jsonEncode(e.toJson())).toList(),
      );
    }
    return filtered;
  }

  Future<void> saveWishlistItem(WishlistItem item) async {
    final items = getWishlist();
    items.insert(0, item);
    final rawList = items.map((e) => jsonEncode(e.toJson())).toList();
    await _prefs.setStringList(_keyWishlist, rawList);
  }

  Future<void> updateWishlistItem(WishlistItem updatedItem) async {
    final items = getWishlist().map((item) {
      if (item.id == updatedItem.id) {
        return updatedItem;
      }
      return item;
    }).toList();
    final rawList = items.map((e) => jsonEncode(e.toJson())).toList();
    await _prefs.setStringList(_keyWishlist, rawList);
  }

  Future<void> deleteWishlistItem(String id) async {
    final items = getWishlist().where((item) => item.id != id).toList();
    final rawList = items.map((e) => jsonEncode(e.toJson())).toList();
    await _prefs.setStringList(_keyWishlist, rawList);
  }

  Future<void> toggleWishlistItem(String id) async {
    final items = getWishlist().map((item) {
      if (item.id == id) {
        return item.copyWith(isCompleted: !item.isCompleted);
      }
      return item;
    }).toList();
    final rawList = items.map((e) => jsonEncode(e.toJson())).toList();
    await _prefs.setStringList(_keyWishlist, rawList);
  }

  List<CravingLog> _initialDefaultLogs() {
    final now = DateTime.now();
    return [
      CravingLog(
        id: '1',
        timestamp: now.subtract(const Duration(hours: 4)),
        trigger: 'Post-Meal',
        intensity: 3,
        resisted: true,
        note: 'Had strong urge after lunch. Did 3 mins breathing instead.',
      ),
      CravingLog(
        id: '2',
        timestamp: now.subtract(const Duration(hours: 18)),
        trigger: 'Stress',
        intensity: 4,
        resisted: true,
        note: 'Work deadline was tense. Drank a cold glass of water.',
      ),
      CravingLog(
        id: '3',
        timestamp: now.subtract(const Duration(days: 1, hours: 2)),
        trigger: 'Morning Coffee',
        intensity: 4,
        resisted: true,
        note: 'Switched coffee to green herbal tea.',
      ),
    ];
  }
}
