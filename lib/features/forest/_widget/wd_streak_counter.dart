import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hpyat_mal/core/extensions/context_extensions.dart';
import 'package:hpyat_mal/core/generate/locale_keys.g.dart';
import 'package:hpyat_mal/core/theme/app_color.dart';
import 'package:hpyat_mal/features/forest/_provider/forest_provider.dart';
import 'package:hpyat_mal/features/forest/_widget/wd_time_unit.dart';

class StreakCounterWidget extends ConsumerWidget {
  final DateTime? quitDate;
  final int? days;
  final int? hours;
  final int? minutes;
  final int? seconds;

  const StreakCounterWidget({
    super.key,
    this.quitDate,
    this.days,
    this.hours,
    this.minutes,
    this.seconds,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int displayDays;
    final int displayHours;
    final int displayMinutes;
    final int displaySeconds;

    if (quitDate != null) {
      final now = ref.watch(liveNowProvider);
      final diff = now.difference(quitDate!);
      final duration = diff.isNegative ? Duration.zero : diff;
      displayDays = duration.inDays;
      displayHours = duration.inHours % 24;
      displayMinutes = duration.inMinutes % 60;
      displaySeconds = duration.inSeconds % 60;
    } else {
      displayDays = days ?? 0;
      displayHours = hours ?? 0;
      displayMinutes = minutes ?? 0;
      displaySeconds = seconds ?? 0;
    }

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.w(4),
        vertical: context.h(4),
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: TimeUnitWidget(
                value: displayDays.toString().padLeft(2, '0'),
                label: LocaleKeys.forest_unitDays.tr(),
              ),
            ),
            _buildDivider(context),
            Expanded(
              child: TimeUnitWidget(
                value: displayHours.toString().padLeft(2, '0'),
                label: LocaleKeys.forest_unitHrs.tr(),
              ),
            ),
            _buildDivider(context),
            Expanded(
              child: TimeUnitWidget(
                value: displayMinutes.toString().padLeft(2, '0'),
                label: LocaleKeys.forest_unitMins.tr(),
              ),
            ),
            _buildDivider(context),
            Expanded(
              child: TimeUnitWidget(
                value: displaySeconds.toString().padLeft(2, '0'),
                label: LocaleKeys.forest_unitSecs.tr(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Container(
      width: 1,
      margin: EdgeInsets.symmetric(vertical: context.h(6)),
      color: AppColors.border,
    );
  }
}
