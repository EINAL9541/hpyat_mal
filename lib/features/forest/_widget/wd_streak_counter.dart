import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:hpyat_mal/core/extensions/context_extensions.dart';
import 'package:hpyat_mal/core/theme/app_color.dart';
import 'package:hpyat_mal/core/theme/app_text_style.dart';
import 'package:hpyat_mal/features/forest/_provider/forest_provider.dart';
import 'package:hpyat_mal/features/forest/_widget/wd_time_unit.dart';

class StreakCounterWidget extends ConsumerWidget {
  final DateTime? quitDate;
  final int? days;
  final int? hours;
  final int? minutes;
  final int? seconds;
  final String stageName;
  final String stageDescription;

  const StreakCounterWidget({
    super.key,
    this.quitDate,
    this.days,
    this.hours,
    this.minutes,
    this.seconds,
    required this.stageName,
    required this.stageDescription,
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

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: context.w(18),
        vertical: context.h(16),
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: context.borderRadius(all: 20),
        border: Border.all(color: AppColors.border, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: AppColors.forestDeep.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                stageName,
                style: AppTextStyle.headingSmall(context).copyWith(
                  color: AppColors.forestPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: context.h(2)),
          Text(
            stageDescription,
            textAlign: TextAlign.center,
            style: AppTextStyle.captionMedium(context).copyWith(
              color: AppColors.textMuted,
            ),
          ),
          SizedBox(height: context.h(14)),

          // Time Grid
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TimeUnitWidget(value: displayDays.toString().padLeft(2, '0'), label: 'DAYS'),
              _buildDivider(context),
              TimeUnitWidget(value: displayHours.toString().padLeft(2, '0'), label: 'HRS'),
              _buildDivider(context),
              TimeUnitWidget(value: displayMinutes.toString().padLeft(2, '0'), label: 'MINS'),
              _buildDivider(context),
              TimeUnitWidget(value: displaySeconds.toString().padLeft(2, '0'), label: 'SECS'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.h(14)),
      child: Text(
        ":",
        style: TextStyle(
          fontSize: context.sp(22),
          fontWeight: FontWeight.w700,
          color: AppColors.textMuted,
        ),
      ),
    );
  }
}
