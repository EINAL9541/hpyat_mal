import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hpyat_mal/core/extensions/context_extensions.dart';
import 'package:hpyat_mal/core/generate/locale_keys.g.dart';
import 'package:hpyat_mal/core/theme/app_color.dart';
import 'package:hpyat_mal/core/theme/app_text_style.dart';
import 'package:hpyat_mal/features/breathing/_provider/breathing_provider.dart';
import 'package:hpyat_mal/features/breathing/_widget/wd_breathing_circle.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class BreathingScreen extends ConsumerWidget {
  const BreathingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    EasyLocalization.of(context);
    final breathing = ref.watch(breathingProvider);
    final isCompleted = breathing.phase == BreathPhase.completed;

    final String subtitleGuidance;
    if (breathing.isRunning) {
      subtitleGuidance = LocaleKeys.breathing_subGuiding.tr(
        args: [
          breathing.currentCycle.toString(),
          breathing.totalCycles.toString(),
        ],
      );
    } else if (isCompleted) {
      subtitleGuidance = LocaleKeys.breathing_subCompleted.tr();
    } else {
      subtitleGuidance = LocaleKeys.breathing_subIdle.tr();
    }

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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 1. Clean Page Header (Left-aligned, no sessions badge)
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocaleKeys.breathing_title.tr(),
                      style: AppTextStyle.headingLarge(context).copyWith(
                        color: AppColors.forestPrimary,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: context.h(2)),
                    Text(
                      LocaleKeys.breathing_subtitle.tr(),
                      style: AppTextStyle.captionMedium(context),
                    ),
                  ],
                ),
              ),

              SizedBox(height: context.h(28)),

              // 2. Clean Typographic Phase Guidance
              Text(
                breathing.instruction,
                textAlign: TextAlign.center,
                style: AppTextStyle.headingSmall(context).copyWith(
                  color: AppColors.forestDeep,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: context.h(4)),
              Text(
                subtitleGuidance,
                textAlign: TextAlign.center,
                style: AppTextStyle.captionMedium(context).copyWith(
                  color: AppColors.textSecondary,
                ),
              ),

              SizedBox(height: context.h(16)),

              // 3. Expanding / Contracting Sphere (Contained inside 280x280 box)
              BreathingCircleWidget(
                state: breathing,
                onToggle: () {
                  if (breathing.isRunning) {
                    ref.read(breathingProvider.notifier).stopSession();
                  } else {
                    ref.read(breathingProvider.notifier).startSession();
                  }
                },
              ),

              SizedBox(height: context.h(16)),

              // 4. Cycle Indicators
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(breathing.totalCycles, (index) {
                  final isDone =
                      index + 1 < breathing.currentCycle ||
                      breathing.phase == BreathPhase.completed;
                  final isCurrent =
                      index + 1 == breathing.currentCycle &&
                      breathing.isRunning;

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    margin: EdgeInsets.symmetric(horizontal: context.w(4)),
                    width: isCurrent ? context.w(24) : context.w(8),
                    height: context.h(6),
                    decoration: BoxDecoration(
                      color: isDone || isCurrent
                          ? AppColors.emerald
                          : AppColors.border,
                      borderRadius: context.borderRadius(all: 50),
                    ),
                  );
                }),
              ),

              SizedBox(height: context.h(24)),

              // 5. Science Card on White Surface
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(context.w(16)),
                decoration: BoxDecoration(
                  color: AppColors.surfaceCard,
                  borderRadius: context.borderRadius(all: 14),
                  border: Border.all(color: AppColors.borderSubtle),
                  boxShadow: AppColors.cardShadow,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: context.w(36),
                      height: context.w(36),
                      decoration: BoxDecoration(
                        color: AppColors.leafSoft,
                        borderRadius: context.borderRadius(all: 10),
                      ),
                      child: Icon(
                        LucideIcons.heartPulse,
                        size: context.w(18),
                        color: AppColors.forestPrimary,
                      ),
                    ),
                    SizedBox(width: context.w(12)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            LocaleKeys.breathing_scienceTitle.tr(),
                            style: AppTextStyle.bodySemiBold(context).copyWith(
                              color: AppColors.forestDeep,
                              fontSize: 14.5,
                            ),
                          ),
                          SizedBox(height: context.h(3)),
                          Text(
                            LocaleKeys.breathing_scienceBody.tr(),
                            style: AppTextStyle.captionMedium(context).copyWith(
                              color: AppColors.textSecondary,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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
