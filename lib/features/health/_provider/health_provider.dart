import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hpyat_mal/core/generate/locale_keys.g.dart';

class HealthMilestone {
  final String id;
  final String timeKey;
  final String descriptionKey;
  final Duration targetDuration;

  const HealthMilestone({
    required this.id,
    required this.timeKey,
    required this.descriptionKey,
    required this.targetDuration,
  });

  double progress(Duration currentDuration) {
    if (targetDuration.inSeconds == 0) return 1.0;
    final ratio = currentDuration.inSeconds / targetDuration.inSeconds;
    return ratio.clamp(0.0, 1.0);
  }

  int percentInt(Duration currentDuration) {
    return (progress(currentDuration) * 100).floor().clamp(0, 100);
  }

  bool isCompleted(Duration currentDuration) {
    return currentDuration >= targetDuration;
  }

  String formatEta({
    required DateTime quitDate,
    required DateTime now,
    required String localeCode,
  }) {
    final elapsed = now.difference(quitDate);
    final currentDuration = elapsed.isNegative ? Duration.zero : elapsed;

    if (isCompleted(currentDuration)) {
      return LocaleKeys.health_completed.tr();
    }

    final remaining = targetDuration - currentDuration;
    if (remaining.inHours < 1) {
      final mins = remaining.inMinutes.clamp(1, 59);
      return LocaleKeys.health_inMinutes.tr(args: [mins.toString()]);
    }

    if (remaining.inHours < 24) {
      final hrs = remaining.inHours.clamp(1, 23);
      return LocaleKeys.health_inHours.tr(args: [hrs.toString()]);
    }

    final ceilDays = (remaining.inMinutes / (24 * 60)).ceil();
    if (ceilDays <= 5) {
      if (ceilDays <= 1) {
        return LocaleKeys.health_inOneDay.tr();
      }
      return LocaleKeys.health_inDays.tr(args: [ceilDays.toString()]);
    }

    final targetDate = quitDate.add(targetDuration);
    try {
      if (targetDate.year == now.year) {
        return DateFormat('MMMM d', localeCode).format(targetDate);
      }
      return DateFormat('MMMM d, y', localeCode).format(targetDate);
    } catch (_) {
      if (targetDate.year == now.year) {
        return DateFormat('MMMM d').format(targetDate);
      }
      return DateFormat('MMMM d, y').format(targetDate);
    }
  }
}

final healthMilestonesProvider = Provider<List<HealthMilestone>>((ref) {
  return const [
    HealthMilestone(
      id: 'm20m',
      timeKey: LocaleKeys.health_m20mTime,
      descriptionKey: LocaleKeys.health_m20mDesc,
      targetDuration: Duration(minutes: 20),
    ),
    HealthMilestone(
      id: 'm8h',
      timeKey: LocaleKeys.health_m8hTime,
      descriptionKey: LocaleKeys.health_m8hDesc,
      targetDuration: Duration(hours: 8),
    ),
    HealthMilestone(
      id: 'm24h',
      timeKey: LocaleKeys.health_m24hTime,
      descriptionKey: LocaleKeys.health_m24hDesc,
      targetDuration: Duration(hours: 24),
    ),
    HealthMilestone(
      id: 'm48h',
      timeKey: LocaleKeys.health_m48hTime,
      descriptionKey: LocaleKeys.health_m48hDesc,
      targetDuration: Duration(hours: 48),
    ),
    HealthMilestone(
      id: 'm72h',
      timeKey: LocaleKeys.health_m72hTime,
      descriptionKey: LocaleKeys.health_m72hDesc,
      targetDuration: Duration(hours: 72),
    ),
    HealthMilestone(
      id: 'm5d',
      timeKey: LocaleKeys.health_m5dTime,
      descriptionKey: LocaleKeys.health_m5dDesc,
      targetDuration: Duration(days: 5),
    ),
    HealthMilestone(
      id: 'm10d',
      timeKey: LocaleKeys.health_m10dTime,
      descriptionKey: LocaleKeys.health_m10dDesc,
      targetDuration: Duration(days: 10),
    ),
    HealthMilestone(
      id: 'm14d',
      timeKey: LocaleKeys.health_m14dTime,
      descriptionKey: LocaleKeys.health_m14dDesc,
      targetDuration: Duration(days: 14),
    ),
    HealthMilestone(
      id: 'm21d',
      timeKey: LocaleKeys.health_m21dTime,
      descriptionKey: LocaleKeys.health_m21dDesc,
      targetDuration: Duration(days: 21),
    ),
    HealthMilestone(
      id: 'm2m',
      timeKey: LocaleKeys.health_m2mTime,
      descriptionKey: LocaleKeys.health_m2mDesc,
      targetDuration: Duration(days: 61),
    ),
    HealthMilestone(
      id: 'm3m',
      timeKey: LocaleKeys.health_m3mTime,
      descriptionKey: LocaleKeys.health_m3mDesc,
      targetDuration: Duration(days: 91),
    ),
    HealthMilestone(
      id: 'm1y',
      timeKey: LocaleKeys.health_m1yTime,
      descriptionKey: LocaleKeys.health_m1yDesc,
      targetDuration: Duration(days: 365),
    ),
    HealthMilestone(
      id: 'm10y',
      timeKey: LocaleKeys.health_m10yTime,
      descriptionKey: LocaleKeys.health_m10yDesc,
      targetDuration: Duration(days: 3650),
    ),
  ];
});
