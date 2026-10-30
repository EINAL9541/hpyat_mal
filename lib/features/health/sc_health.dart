import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:hpyat_mal/core/extensions/context_extensions.dart';
import 'package:hpyat_mal/core/theme/app_color.dart';
import 'package:hpyat_mal/core/theme/app_text_style.dart';
import 'package:hpyat_mal/core/ui/widgets/wd_hero_card.dart';
import 'package:hpyat_mal/features/forest/_provider/forest_provider.dart';
import 'package:hpyat_mal/features/health/_provider/health_provider.dart';
import 'package:hpyat_mal/features/health/_widget/wd_health_milestone_card.dart';

class HealthScreen extends ConsumerWidget {
  const HealthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final forest = ref.watch(forestProvider);
    final milestones = ref.watch(healthMilestonesProvider);
    final completedCount =
        milestones.where((m) => m.isCompleted(forest.smokeFreeDuration)).length;
    final overallProgress =
        milestones.isEmpty ? 0.0 : completedCount / milestones.length;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: context.w(16),
            vertical: context.h(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Page Header with Starbucks Gold-outlined ceremony pill
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Body Recovery",
                          style: AppTextStyle.headingLarge(context).copyWith(
                            color: AppColors.forestPrimary,
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: context.h(2)),
                        Text(
                          "How your body heals itself, hour by hour",
                          style: AppTextStyle.captionMedium(context),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.w(12),
                      vertical: context.h(5),
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.amberLight,
                      borderRadius: context.borderRadius(all: 50),
                      border: Border.all(color: AppColors.amberWarm),
                    ),
                    child: Text(
                      "★ $completedCount of ${milestones.length} healed",
                      style: AppTextStyle.captionSmall(context).copyWith(
                        color: AppColors.forestDeep,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: context.h(16)),

              // Solid House Feature Band Overview Card (#1E3932 / #381824)
              AppHeroCardWidget(
                leading: Icon(
                  LucideIcons.heartPulse,
                  color: AppColors.leafSoft,
                  size: context.w(20),
                ),
                title: "Your body is repairing itself",
                subtitle:
                    "Every smoke-free hour lets pure oxygen reach your organs and gives your lungs time to clear out old residue.",
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: context.borderRadius(all: 50),
                      child: LinearProgressIndicator(
                        value: overallProgress.clamp(0.06, 1.0),
                        minHeight: context.h(6),
                        backgroundColor:
                            AppColors.baseWhite.withValues(alpha: 0.16),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.amberWarm,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: context.h(20)),

              Text(
                "RECOVERY TIMELINE",
                style: AppTextStyle.captionSmall(context).copyWith(
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.9,
                ),
              ),

              SizedBox(height: context.h(12)),

              // White 12px Card Wrapping the Connected Recovery Timeline
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(context.w(16)),
                decoration: BoxDecoration(
                  color: AppColors.surfaceCard,
                  borderRadius: context.borderRadius(all: 12),
                  border: Border.all(color: AppColors.borderSubtle),
                  boxShadow: AppColors.cardShadow,
                ),
                child: Column(
                  children: List.generate(milestones.length, (index) {
                    return HealthMilestoneCardWidget(
                      milestone: milestones[index],
                      smokeFreeDuration: forest.smokeFreeDuration,
                      isLast: index == milestones.length - 1,
                    );
                  }),
                ),
              ),

              SizedBox(height: context.h(24)),
            ],
          ),
        ),
      ),
    );
  }
}
