import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:hpyat_mal/core/extensions/context_extensions.dart';
import 'package:hpyat_mal/core/theme/app_color.dart';
import 'package:hpyat_mal/core/theme/app_text_style.dart';
import 'package:hpyat_mal/features/health/_provider/health_provider.dart';

class HealthMilestoneCardWidget extends StatelessWidget {
  final HealthMilestone milestone;
  final Duration smokeFreeDuration;

  const HealthMilestoneCardWidget({
    super.key,
    required this.milestone,
    required this.smokeFreeDuration,
  });

  @override
  Widget build(BuildContext context) {
    final progress = milestone.progress(smokeFreeDuration);
    final isDone = milestone.isCompleted(smokeFreeDuration);
    final percent = (progress * 100).toInt();

    return Container(
      margin: EdgeInsets.only(bottom: context.h(12)),
      padding: EdgeInsets.all(context.w(16)),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: context.borderRadius(all: 18),
        border: Border.all(
          color: isDone ? AppColors.leafSoft : AppColors.border,
          width: isDone ? 1.4 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.forestDeep.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: context.w(38),
                height: context.h(38),
                decoration: BoxDecoration(
                  color: isDone ? AppColors.leafSoft : AppColors.leafBackground,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isDone ? LucideIcons.checkCheck : _resolveIcon(milestone.iconKey),
                  size: context.w(18),
                  color: isDone ? AppColors.forestPrimary : AppColors.emerald,
                ),
              ),
              SizedBox(width: context.w(12)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      milestone.title,
                      style: AppTextStyle.headingSmall(context).copyWith(
                        color: AppColors.forestDeep,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(height: context.h(2)),
                    Text(
                      milestone.timeRemainingFormatted(smokeFreeDuration),
                      style: AppTextStyle.captionSmall(context).copyWith(
                        color: isDone ? AppColors.emerald : AppColors.textMuted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: context.w(10),
                  vertical: context.h(4),
                ),
                decoration: BoxDecoration(
                  color: isDone ? AppColors.leafSoft : AppColors.surfaceCardMuted,
                  borderRadius: context.borderRadius(all: 10),
                ),
                child: Text(
                  "$percent%",
                  style: AppTextStyle.captionSmall(context).copyWith(
                    color: isDone ? AppColors.forestPrimary : AppColors.textSecondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: context.h(10)),

          Text(
            milestone.description,
            style: AppTextStyle.bodyMedium(context).copyWith(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),

          SizedBox(height: context.h(12)),

          // Progress Track
          ClipRRect(
            borderRadius: context.borderRadius(all: 6),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: context.h(6),
              backgroundColor: AppColors.borderSubtle,
              valueColor: AlwaysStoppedAnimation<Color>(
                isDone ? AppColors.emerald : AppColors.sageLight,
              ),
            ),
          ),

          SizedBox(height: context.h(10)),

          // Forest Unlock Tag
          Row(
            children: [
              Icon(
                LucideIcons.sparkles,
                size: context.w(13),
                color: AppColors.amberWarm,
              ),
              SizedBox(width: context.w(4)),
              Text(
                "Forest Reward: ${milestone.forestReward}",
                style: AppTextStyle.captionSmall(context).copyWith(
                  color: isDone ? AppColors.forestPrimary : AppColors.textMuted,
                  fontWeight: isDone ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ],
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
        return LucideIcons.sparkles;
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
