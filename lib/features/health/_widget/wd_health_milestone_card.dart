import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hpyat_mal/core/extensions/context_extensions.dart';
import 'package:hpyat_mal/core/theme/app_color.dart';
import 'package:hpyat_mal/core/theme/app_text_style.dart';
import 'package:hpyat_mal/features/health/_provider/health_provider.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class HealthMilestoneCardWidget extends StatelessWidget {
  final HealthMilestone milestone;
  final DateTime quitDate;
  final DateTime now;

  const HealthMilestoneCardWidget({
    super.key,
    required this.milestone,
    required this.quitDate,
    required this.now,
  });

  @override
  Widget build(BuildContext context) {
    final elapsed = now.difference(quitDate);
    final smokeFreeDuration = elapsed.isNegative ? Duration.zero : elapsed;
    final progress = milestone.progress(smokeFreeDuration);
    final percent = milestone.percentInt(smokeFreeDuration);
    final isDone = milestone.isCompleted(smokeFreeDuration);
    final etaLabel = milestone.formatEta(
      quitDate: quitDate,
      now: now,
      localeCode: context.locale.languageCode,
    );

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: context.h(12)),
      padding: EdgeInsets.symmetric(
        horizontal: context.w(18),
        vertical: context.h(16),
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: context.borderRadius(all: 14),
        border: Border.all(
          color: isDone
              ? AppColors.emerald.withValues(alpha: 0.28)
              : AppColors.borderSubtle,
        ),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Timeframe + Recovery Description
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '${milestone.timeKey.tr()} ',
                  style: AppTextStyle.bodySemiBold(context).copyWith(
                    color: AppColors.forestDeep,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    height: 1.45,
                  ),
                ),
                TextSpan(
                  text: milestone.descriptionKey.tr(),
                  style: AppTextStyle.bodyMedium(context).copyWith(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: context.h(14)),

          // 2. Centered Percentage
          Center(
            child: Text(
              '$percent%',
              style: AppTextStyle.bodySemiBold(context).copyWith(
                color: isDone ? AppColors.emerald : AppColors.forestDeep,
                fontSize: 15,
                fontWeight: FontWeight.w700,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),

          SizedBox(height: context.h(8)),

          // 3. Full-Width Rounded Pill Progress Bar
          Container(
            height: context.h(8),
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.surfaceCardMuted,
              borderRadius: context.borderRadius(all: 50),
            ),
            child: percent > 0
                ? Align(
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor: progress.clamp(0.04, 1.0),
                      heightFactor: 1.0,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: AppColors.emerald,
                          borderRadius: context.borderRadius(all: 50),
                        ),
                      ),
                    ),
                  )
                : null,
          ),

          SizedBox(height: context.h(10)),

          // 4. Centered Hourglass / Check + ETA / Target Date
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  isDone ? LucideIcons.circleCheck : LucideIcons.hourglass,
                  size: context.w(14),
                  color: isDone ? AppColors.emerald : AppColors.textMuted,
                ),
                SizedBox(width: context.w(6)),
                Text(
                  etaLabel,
                  textHeightBehavior: const TextHeightBehavior(
                    applyHeightToFirstAscent: false,
                    applyHeightToLastDescent: false,
                  ),
                  style: AppTextStyle.captionMedium(context).copyWith(
                    color: isDone ? AppColors.emerald : AppColors.textPrimary,
                    fontSize: 13.5,
                    fontWeight: isDone ? FontWeight.w600 : FontWeight.w500,
                    height: 1.0,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
