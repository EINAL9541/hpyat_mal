import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hpyat_mal/core/models/app_currency.dart';
import 'package:hpyat_mal/core/services/storage_service.dart';
import 'package:hpyat_mal/core/theme/app_color.dart';

class LiveNowNotifier extends Notifier<DateTime> {
  @override
  DateTime build() {
    final timer = Timer.periodic(const Duration(seconds: 1), (_) {
      state = DateTime.now();
    });
    ref.onDispose(timer.cancel);
    return DateTime.now();
  }
}

final liveNowProvider =
    NotifierProvider<LiveNowNotifier, DateTime>(LiveNowNotifier.new);

class ForestState {
  final String userName;
  final String quitReason;
  final DateTime quitDate;
  final int cigsPerDay;
  final double packCost;
  final int cigsPerPack;
  final int forestVitality;
  final PlantThemeType plantTheme;
  final AppCurrency currency;

  const ForestState({
    required this.userName,
    required this.quitReason,
    required this.quitDate,
    required this.cigsPerDay,
    required this.packCost,
    required this.cigsPerPack,
    required this.forestVitality,
    required this.plantTheme,
    required this.currency,
  });

  String currencyUnit(String languageCode) => currency.unit(languageCode);
  String formatMoney(num amount, String languageCode) =>
      currency.format(amount, languageCode);

  Duration get smokeFreeDuration => smokeFreeDurationAt(DateTime.now());

  Duration smokeFreeDurationAt(DateTime current) {
    final diff = current.difference(quitDate);
    return diff.isNegative ? Duration.zero : diff;
  }

  int get days => smokeFreeDuration.inDays;
  int get hours => smokeFreeDuration.inHours % 24;
  int get minutes => smokeFreeDuration.inMinutes % 60;
  int get seconds => smokeFreeDuration.inSeconds % 60;

  double get exactDays => smokeFreeDuration.inSeconds / 86400.0;
  double get cigarettesAvoided => exactDays * cigsPerDay;
  double get moneySaved => (cigarettesAvoided / cigsPerPack) * packCost;
  double get lifeRegainedHours => (cigarettesAvoided * 11.0) / 60.0;

  String get stageName {
    if (plantTheme.isCherry) {
      if (days < 1) return 'Blooming Sakura Courtyard';
      if (days < 4) return 'Radiant Cherry Sapling';
      if (days < 10) return 'Flourishing Sakura Tree';
      if (days < 21) return 'Grand Imperial Sakura';
      return 'Sacred Sakura Sanctuary';
    } else {
      if (days < 1) return 'Awakening Forest Glade';
      if (days < 4) return 'Radiant Emerald Sapling';
      if (days < 10) return 'Flourishing Canopy Tree';
      if (days < 21) return 'Ancient Woodland Guardian';
      return 'Sacred Emerald Sanctuary';
    }
  }

  String get stageDescription {
    if (plantTheme.isCherry) {
      if (days < 1) {
        return 'Delicate pink cherry blossoms awakening in the morning dew.';
      }
      if (days < 4) {
        return 'Graceful branches blooming as roots anchor deep in pure soil.';
      }
      if (days < 10) {
        return 'Lush sakura clouds dancing in the warm spring breeze.';
      }
      if (days < 21) {
        return 'A majestic canopy showering fragrant petals across the valley.';
      }
      return 'An eternal cherry blossom sanctuary breathing crystal-clear air.';
    } else {
      if (days < 1) {
        return 'Fresh emerald leaves unfolding in the crisp morning sunlight.';
      }
      if (days < 4) {
        return 'Strong roots anchoring deep as vibrant green boughs reach skyward.';
      }
      if (days < 10) {
        return 'A lush jade canopy rustling softly in the mountain breeze.';
      }
      if (days < 21) {
        return 'Sunlit emerald foliage sheltering a thriving forest ecosystem.';
      }
      return 'An eternal emerald sanctuary breathing pure, revitalized air.';
    }
  }

  ForestState copyWith({
    String? userName,
    String? quitReason,
    DateTime? quitDate,
    int? cigsPerDay,
    double? packCost,
    int? cigsPerPack,
    int? forestVitality,
    PlantThemeType? plantTheme,
    AppCurrency? currency,
  }) {
    return ForestState(
      userName: userName ?? this.userName,
      quitReason: quitReason ?? this.quitReason,
      quitDate: quitDate ?? this.quitDate,
      cigsPerDay: cigsPerDay ?? this.cigsPerDay,
      packCost: packCost ?? this.packCost,
      cigsPerPack: cigsPerPack ?? this.cigsPerPack,
      forestVitality: forestVitality ?? this.forestVitality,
      plantTheme: plantTheme ?? this.plantTheme,
      currency: currency ?? this.currency,
    );
  }
}

class ForestNotifier extends Notifier<ForestState> {
  @override
  ForestState build() {
    final storage = ref.watch(storageServiceProvider);
    final savedTheme = storage.getPlantTheme();
    final savedCurrency = storage.getCurrency();
    AppColors.setTheme(savedTheme);

    return ForestState(
      userName: storage.getUserName(),
      quitReason: storage.getQuitReason(),
      quitDate: storage.getQuitDate(),
      cigsPerDay: storage.getCigsPerDay(),
      packCost: storage.getPackCost(),
      cigsPerPack: storage.getCigsPerPack(),
      forestVitality: storage.getForestVitality(),
      plantTheme: savedTheme,
      currency: savedCurrency,
    );
  }

  Future<void> reloadFromStorage() async {
    final storage = ref.read(storageServiceProvider);
    final savedTheme = storage.getPlantTheme();
    final savedCurrency = storage.getCurrency();
    AppColors.setTheme(savedTheme);
    state = state.copyWith(
      userName: storage.getUserName(),
      quitReason: storage.getQuitReason(),
      quitDate: storage.getQuitDate(),
      cigsPerDay: storage.getCigsPerDay(),
      cigsPerPack: storage.getCigsPerPack(),
      packCost: storage.getPackCost(),
      plantTheme: savedTheme,
      currency: savedCurrency,
    );
  }

  Future<void> setPlantTheme(PlantThemeType theme) async {
    final storage = ref.read(storageServiceProvider);
    await storage.setPlantTheme(theme);
    state = state.copyWith(plantTheme: theme);
  }

  Future<void> setCurrency(AppCurrency currency) async {
    final storage = ref.read(storageServiceProvider);
    await storage.setCurrency(currency);
    state = state.copyWith(currency: currency);
  }

  Future<void> togglePlantTheme() async {
    final nextTheme = state.plantTheme.isCherry
        ? PlantThemeType.emerald
        : PlantThemeType.cherry;
    await setPlantTheme(nextTheme);
  }

  Future<void> updateQuitReason(String newReason) async {
    final storage = ref.read(storageServiceProvider);
    await storage.setQuitReason(newReason);
    state = state.copyWith(quitReason: newReason);
  }

  Future<void> boostVitality() async {
    final storage = ref.read(storageServiceProvider);
    final newVitality = (state.forestVitality + 5).clamp(0, 100);
    await storage.setForestVitality(newVitality);

    state = state.copyWith(forestVitality: newVitality);
  }

  Future<void> recordSlip() async {
    final storage = ref.read(storageServiceProvider);
    final newVitality = (state.forestVitality - 20).clamp(20, 100);
    await storage.setForestVitality(newVitality);
    state = state.copyWith(forestVitality: newVitality);
  }

  Future<void> updateQuitDate(DateTime newDate) async {
    final storage = ref.read(storageServiceProvider);
    await storage.setQuitDate(newDate);
    state = state.copyWith(quitDate: newDate);
  }

  Future<void> updatePersonalInfo({
    required String userName,
    required int cigsPerDay,
    required int cigsPerPack,
    required double packCost,
    required String quitReason,
    required DateTime quitDate,
  }) async {
    final storage = ref.read(storageServiceProvider);
    await storage.setUserName(userName);
    await storage.setCigsPerDay(cigsPerDay);
    await storage.setCigsPerPack(cigsPerPack);
    await storage.setPackCost(packCost);
    await storage.setQuitReason(quitReason);
    await storage.setQuitDate(quitDate);

    state = state.copyWith(
      userName: userName,
      cigsPerDay: cigsPerDay,
      cigsPerPack: cigsPerPack,
      packCost: packCost,
      quitReason: quitReason,
      quitDate: quitDate,
    );
  }
}

final forestProvider =
    NotifierProvider<ForestNotifier, ForestState>(ForestNotifier.new);
