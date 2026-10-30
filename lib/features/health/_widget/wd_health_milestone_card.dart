import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:hpyat_mal/core/extensions/context_extensions.dart';
import 'package:hpyat_mal/core/theme/app_color.dart';
import 'package:hpyat_mal/core/theme/app_text_style.dart';
import 'package:hpyat_mal/features/health/_provider/health_provider.dart';

class HealthMilestoneCardWidget extends StatelessWidget {
  final HealthMilestone milestone;
  final Duration smokeFreeDuration;
  final bool isLast;

  const HealthMilestoneCardWidget({
    super.key,
    required this.milestone,
    required this.smokeFreeDuration,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final progress = milestone.progress(smokeFreeDuration);
    final isDone = milestone.isCompleted(smokeFreeDuration);
    final percent = (progress * 100).toInt();

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Left Timeline Track & Node (Starbucks 2px active ring)
          SizedBox(
            width: context.w(32),
            child: Column(
              children: [
                Container(
                  width: context.w(28),
                  height: context.w(28),
                  decoration: BoxDecoration(
                    color: isDone ? AppColors.emerald : AppColors.surfaceCard,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDone
                          ? AppColors.emerald
                          : (progress > 0.05
                              ? AppColors.emerald
                              : AppColors.border),
                      width: progress > 0.05 && !isDone ? 2.0 : 1.4,
                    ),
                  ),
                  child: Icon(
                    isDone
                        ? LucideIcons.check
                        : _resolveIcon(milestone.iconKey),
                    size: context.w(14),
                    color: isDone
                        ? AppColors.baseWhite
                        : (progress > 0.05
                            ? AppColors.forestPrimary
                            : AppColors.textMuted),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 1.5,
                      color:
                          isDone ? AppColors.emerald : AppColors.borderSubtle,
                    ),
                  ),
              ],
            ),
          ),

          SizedBox(width: context.w(12)),

          // Right Content Column
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : context.h(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Expanded(
                        child: Text(
                          milestone.title,
                          style: AppTextStyle.headingSmall(context).copyWith(
                            color: AppColors.forestDeep,
                            fontSize: 15.5,
                          ),
                        ),
                      ),
                      SizedBox(width: context.w(8)),
                      Text(
                        isDone
                            ? "Healed"
                            : "$percent% • ${milestone.timeRemainingFormatted(smokeFreeDuration)}",
                        style: AppTextStyle.captionSmall(context).copyWith(
                          color: isDone
                              ? AppColors.emerald
                              : AppColors.textMuted,
                          fontWeight: FontWeight.w700,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: context.h(4)),
                  Text(
                    milestone.description,
                    style: AppTextStyle.bodyMedium(context).copyWith(
                      fontSize: 13.5,
                      color: AppColors.textSecondary,
                      height: 1.45,
                    ),
                  ),
                  if (!isDone) ...[
                    SizedBox(height: context.h(10)),
                    ClipRRect(
                      borderRadius: context.borderRadius(all: 50),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: context.h(5),
                        backgroundColor: AppColors.surfaceCardMuted,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.emerald,
                        ),
                      ),
                    ),
                  ],
                  SizedBox(height: context.h(8)),
                  Row(
                    children: [
                      Icon(
                        LucideIcons.sparkles,
                        size: context.w(12),
                        color: isDone
                            ? AppColors.amberWarm
                            : AppColors.textMuted,
                      ),
                      SizedBox(width: context.w(5)),
                      Text(
                        milestone.forestReward,
                        style: AppTextStyle.captionSmall(context).copyWith(
                          color: isDone
                              ? AppColors.forestPrimary
                              : AppColors.textMuted,
                          fontWeight:
                              isDone ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  if (!isLast) ...[
                    SizedBox(height: context.h(14)),
                    Divider(height: 1, color: AppColors.borderSubtle),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _resolveIcon(String key) {
    switch (key) {
      case 'heart':
        return LucideIcons.heartPulse;
      case 'wind':
        return LucideIcons.wind;
      case 'shield':
        return LucideIcons.shieldCheck;
      case 'sparkles':
        return LucideIcons.sun;
      case 'feather':
        return LucideIcons.feather;
      case 'activity':
        return LucideIcons.activity;
      case 'trees':
        return LucideIcons.trees;
      default:
        return LucideIcons.check;
    }
  }
}
