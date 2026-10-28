import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:hpyat_mal/core/extensions/context_extensions.dart';
import 'package:hpyat_mal/core/theme/app_color.dart';
import 'package:hpyat_mal/core/theme/app_text_style.dart';
import 'package:hpyat_mal/features/breathing/_provider/breathing_provider.dart';

class BreathingCircleWidget extends StatelessWidget {
  final BreathingState state;
  final VoidCallback onToggle;

  const BreathingCircleWidget({
    super.key,
    required this.state,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    // Determine target scale based on phase
    double targetScale = 1.0;
    if (state.phase == BreathPhase.inhale) {
      targetScale = 1.35;
    } else if (state.phase == BreathPhase.hold) {
      targetScale = 1.35;
    } else if (state.phase == BreathPhase.exhale) {
      targetScale = 1.0;
    }

    Duration animDuration = const Duration(milliseconds: 600);
    if (state.phase == BreathPhase.inhale) {
      animDuration = const Duration(seconds: 4);
    } else if (state.phase == BreathPhase.exhale) {
      animDuration = const Duration(seconds: 8);
    }

    return Center(
      child: GestureDetector(
        onTap: onToggle,
        child: SizedBox(
          width: context.w(260),
          height: context.h(260),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer Ripple Ring
              AnimatedScale(
                scale: targetScale * 1.15,
                duration: animDuration,
                curve: Curves.easeInOut,
                child: Container(
                  width: context.w(230),
                  height: context.h(230),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.leafSoft.withValues(alpha: 0.35),
                  ),
                ),
              ),

              // Middle Soft Ring
              AnimatedScale(
                scale: targetScale * 1.08,
                duration: animDuration,
                curve: Curves.easeInOut,
                child: Container(
                  width: context.w(190),
                  height: context.h(190),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.sageLight.withValues(alpha: 0.4),
                  ),
                ),
              ),

              // Core Breathing Sphere
              AnimatedScale(
                scale: targetScale,
                duration: animDuration,
                curve: Curves.easeInOut,
                child: Container(
                  width: context.w(150),
                  height: context.h(150),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        AppColors.emerald,
                        AppColors.forestPrimary,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.emerald.withValues(alpha: 0.35),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _phaseTitle(state.phase),
                          style: AppTextStyle.captionSmall(context).copyWith(
                            color: AppColors.leafSoft,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                          ),
                        ),
                        SizedBox(height: context.h(2)),
                        Text(
                          state.isRunning
                              ? "${state.secondsLeftInPhase}s"
                              : "START",
                          style: AppTextStyle.headingLarge(context).copyWith(
                            color: AppColors.baseWhite,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _phaseTitle(BreathPhase phase) {
    switch (phase) {
      case BreathPhase.ready:
        return 'TAP';
      case BreathPhase.inhale:
        return 'INHALE';
      case BreathPhase.hold:
        return 'HOLD';
      case BreathPhase.exhale:
        return 'EXHALE';
      case BreathPhase.completed:
        return 'DONE';
    }
  }
}
