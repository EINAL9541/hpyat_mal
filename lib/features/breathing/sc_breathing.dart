import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
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
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Craving SOS • 4-7-8 Breath",
          style: AppTextStyle.headingSmall(context).copyWith(
            color: AppColors.forestDeep,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: context.w(20),
            vertical: context.h(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Top Calm Banner
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: context.w(16),
                  vertical: context.h(12),
                ),
                decoration: BoxDecoration(
                  color: AppColors.leafSoft.withValues(alpha: 0.4),
                  borderRadius: context.borderRadius(all: 16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    const Text("🌬️", style: TextStyle(fontSize: 22)),
                    SizedBox(width: context.w(12)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            breathing.instruction,
                            style: AppTextStyle.bodySemiBold(context).copyWith(
                              color: AppColors.forestDeep,
                            ),
                          ),
                          SizedBox(height: context.h(2)),
                          Text(
                            breathing.isRunning
                                ? "Cycle ${breathing.currentCycle} of ${breathing.totalCycles} • Stay focused on the rhythm"
                                : "Tap the sphere to begin your calming breath",
                            style: AppTextStyle.captionSmall(context),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: context.h(30)),

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

              SizedBox(height: context.h(30)),

              // Cycle Indicators & Controls
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(breathing.totalCycles, (index) {
                  final isDone = index + 1 < breathing.currentCycle ||
                      breathing.phase == BreathPhase.completed;
                  final isCurrent = index + 1 == breathing.currentCycle &&
                      breathing.isRunning;

                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: context.w(4)),
                    width: isCurrent ? context.w(24) : context.w(10),
                    height: context.h(8),
                    decoration: BoxDecoration(
                      color: isDone || isCurrent
                          ? AppColors.emerald
                          : AppColors.border,
                      borderRadius: context.borderRadius(all: 4),
                    ),
                  );
                }),
              ),

              SizedBox(height: context.h(16)),

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
                  size: context.w(16),
                ),
                label: Text(
                  breathing.isRunning ? "Stop Session" : "Start 4-7-8 Breathing",
                  style: AppTextStyle.bodySemiBold(context).copyWith(
                    color: AppColors.baseWhite,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: breathing.isRunning
                      ? AppColors.danger
                      : AppColors.forestPrimary,
                  foregroundColor: AppColors.baseWhite,
                  padding: EdgeInsets.symmetric(
                    horizontal: context.w(24),
                    vertical: context.h(12),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: context.borderRadius(all: 14),
                  ),
                  elevation: 0,
                ),
              ),

              SizedBox(height: context.h(24)),

              // Craving Science Tip
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(context.w(16)),
                decoration: BoxDecoration(
                  color: AppColors.surfaceCard,
                  borderRadius: context.borderRadius(all: 16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          LucideIcons.sparkles,
                          size: context.w(16),
                          color: AppColors.amberWarm,
                        ),
                        SizedBox(width: context.w(6)),
                        Text(
                          "Why this defuses nicotine cravings",
                          style: AppTextStyle.bodySemiBold(context).copyWith(
                            color: AppColors.forestDeep,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: context.h(6)),
                    Text(
                      "Physical cravings spike adrenaline and cause shallow breathing. The 4-7-8 ratio activates your vagus nerve, dropping your heart rate within 90 seconds and letting the urge pass naturally.",
                      style: AppTextStyle.captionMedium(context).copyWith(
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: context.h(10)),
                    Row(
                      children: [
                        Icon(
                          LucideIcons.checkCircle2,
                          size: context.w(14),
                          color: AppColors.emerald,
                        ),
                        SizedBox(width: context.w(6)),
                        Text(
                          "${breathing.completedSessions} breathing sessions completed",
                          style: AppTextStyle.captionSmall(context).copyWith(
                            color: AppColors.emerald,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
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
