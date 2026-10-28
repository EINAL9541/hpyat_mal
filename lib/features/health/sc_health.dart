import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:hpyat_mal/core/extensions/context_extensions.dart';
import 'package:hpyat_mal/core/theme/app_color.dart';
import 'package:hpyat_mal/core/theme/app_text_style.dart';
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

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: context.w(18),
            vertical: context.h(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Page Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Body Recovery",
                        style: AppTextStyle.headingMedium(context).copyWith(
                          color: AppColors.forestDeep,
                        ),
                      ),
                      SizedBox(height: context.h(2)),
                      Text(
                        "Evidence-based clinical healing timeline",
                        style: AppTextStyle.captionMedium(context),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.w(12),
                      vertical: context.h(6),
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.leafSoft,
                      borderRadius: context.borderRadius(all: 12),
                    ),
                    child: Text(
                      "$completedCount / ${milestones.length} Restored",
                      style: AppTextStyle.captionSmall(context).copyWith(
                        color: AppColors.forestPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: context.h(16)),

              // Overview Hero Card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(context.w(18)),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.forestPrimary,
                      AppColors.forestDeep,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: context.borderRadius(all: 20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.forestDeep.withValues(alpha: 0.15),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(context.w(8)),
                          decoration: BoxDecoration(
                            color: AppColors.baseWhite.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            LucideIcons.heartPulse,
                            color: AppColors.mintAccent,
                            size: context.w(20),
                          ),
                        ),
                        SizedBox(width: context.w(10)),
                        Text(
                          "Cellular Renewal Active",
                          style: AppTextStyle.headingSmall(context).copyWith(
                            color: AppColors.baseWhite,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: context.h(10)),
                    Text(
                      "Every smoke-free hour allows hemoglobin to transport pure oxygen to your organs. Your lungs are actively clearing cellular residue.",
                      style: AppTextStyle.bodyMedium(context).copyWith(
                        color: AppColors.leafSoft,
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: context.h(18)),

              Text(
                "Clinical Milestones",
                style: AppTextStyle.headingSmall(context).copyWith(
                  color: AppColors.forestDeep,
                  fontSize: 16,
                ),
              ),

              SizedBox(height: context.h(10)),

              // Milestones list
              ...milestones.map(
                (m) => HealthMilestoneCardWidget(
                  milestone: m,
                  smokeFreeDuration: forest.smokeFreeDuration,
                ),
              ),

              SizedBox(height: context.h(85)),
            ],
          ),
        ),
      ),
    );
  }
}
