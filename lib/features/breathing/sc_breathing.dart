import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:hpyat_mal/core/extensions/context_extensions.dart';
import 'package:hpyat_mal/core/theme/app_color.dart';
import 'package:hpyat_mal/core/theme/app_text_style.dart';
import 'package:hpyat_mal/features/breathing/_provider/breathing_provider.dart';
import 'package:hpyat_mal/features/breathing/_widget/wd_breathing_circle.dart';

class BreathingScreen extends ConsumerWidget {
  const BreathingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final breathing = ref.watch(breathingProvider);

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
              // Consistent Tab Header with Starbucks Gold-outlined ceremony pill
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Calm Breath",
                          style: AppTextStyle.headingLarge(context).copyWith(
                            color: AppColors.forestPrimary,
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: context.h(2)),
                        Text(
                          "4-7-8 rhythm to let cravings pass",
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
                      "★ ${breathing.completedSessions} sessions",
                      style: AppTextStyle.captionSmall(context).copyWith(
                        color: AppColors.forestDeep,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: context.h(28)),

              // Clean Typographic Phase Guidance
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
                breathing.isRunning
                    ? "Cycle ${breathing.currentCycle} of ${breathing.totalCycles} • Follow the sphere"
                    : "Tap the circle below whenever an urge peaks",
                textAlign: TextAlign.center,
                style: AppTextStyle.captionMedium(context).copyWith(
                  color: AppColors.textSecondary,
                ),
              ),

              SizedBox(height: context.h(28)),

              // Expanding / Contracting Sphere
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

              SizedBox(height: context.h(28)),

              // Cycle Indicators
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(breathing.totalCycles, (index) {
                  final isDone = index + 1 < breathing.currentCycle ||
                      breathing.phase == BreathPhase.completed;
                  final isCurrent = index + 1 == breathing.currentCycle &&
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

              SizedBox(height: context.h(18)),

              // 50px Full-Pill Primary CTA (Starbucks Green Accent / Sakura Accent)
              ElevatedButton.icon(
                onPressed: () {
                  if (breathing.isRunning) {
                    ref.read(breathingProvider.notifier).stopSession();
                  } else {
                    ref.read(breathingProvider.notifier).startSession();
                  }
                },
                icon: Icon(
                  breathing.isRunning ? LucideIcons.square : LucideIcons.play,
                  size: context.w(15),
                ),
                label: Text(
                  breathing.isRunning ? "Pause Session" : "Begin 4-7-8 Breath",
                  style: AppTextStyle.bodySemiBold(context).copyWith(
                    color: AppColors.baseWhite,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: breathing.isRunning
                      ? AppColors.forestDeep
                      : AppColors.emerald,
                  foregroundColor: AppColors.baseWhite,
                  padding: EdgeInsets.symmetric(
                    horizontal: context.w(28),
                    vertical: context.h(13),
                  ),
                  shape: const StadiumBorder(),
                  elevation: 0,
                ),
              ),

              SizedBox(height: context.h(24)),

              // Subtle Science Card on White Surface
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(context.w(16)),
                decoration: BoxDecoration(
                  color: AppColors.surfaceCard,
                  borderRadius: context.borderRadius(all: 12),
                  border: Border.all(color: AppColors.borderSubtle),
                  boxShadow: AppColors.cardShadow,
                ),
                child: Text(
                  "Inhaling for 4s, holding for 7s, and exhaling for 8s slows your heart rate within 90 seconds—giving the craving wave time to pass.",
                  textAlign: TextAlign.center,
                  style: AppTextStyle.captionMedium(context).copyWith(
                    color: AppColors.textSecondary,
                    height: 1.55,
                  ),
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
