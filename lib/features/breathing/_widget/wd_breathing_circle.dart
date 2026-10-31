import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hpyat_mal/core/extensions/context_extensions.dart';
import 'package:hpyat_mal/core/generate/locale_keys.g.dart';
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
    if (state.phase == BreathPhase.inhale || state.phase == BreathPhase.hold) {
      targetScale = 1.24;
    } else if (state.phase == BreathPhase.exhale) {
      targetScale = 1.0;
    }

    Duration animDuration = const Duration(milliseconds: 600);
    if (state.phase == BreathPhase.inhale) {
      animDuration = const Duration(seconds: 4);
    } else if (state.phase == BreathPhase.exhale) {
      animDuration = const Duration(seconds: 8);
    }

    // Reserve the full expanded diameter (190 * 1.24 * 1.12 ≈ 264) inside a
    // 280x280 layout box so the expanding rings never overlap adjacent widgets.
    return Center(
      child: GestureDetector(
        onTap: onToggle,
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          width: context.w(280),
          height: context.w(280),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer Solid Color-Block Ripple Ring (Light Mint / Sakura Wash)
              AnimatedScale(
                scale: targetScale * 1.12,
                duration: animDuration,
                curve: Curves.easeInOut,
                child: Container(
                  width: context.w(190),
                  height: context.w(190),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.leafSoft,
                    border: Border.all(color: AppColors.borderSubtle),
                  ),
                ),
              ),

              // Middle Solid Botanical Ring
              AnimatedScale(
                scale: targetScale * 1.06,
                duration: animDuration,
                curve: Curves.easeInOut,
                child: Container(
                  width: context.w(162),
                  height: context.w(162),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.sageLight.withValues(alpha: 0.42),
                  ),
                ),
              ),

              // Core Solid Color-Block Sphere (Starbucks House Green / Sakura Reserve)
              AnimatedScale(
                scale: targetScale,
                duration: animDuration,
                curve: Curves.easeInOut,
                child: Container(
                  width: context.w(134),
                  height: context.w(134),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: state.isRunning
                        ? AppColors.forestDeep
                        : AppColors.emerald,
                    boxShadow: AppColors.floatingShadow,
                  ),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: context.w(10)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _phaseTitle(state.phase),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyle.captionSmall(context).copyWith(
                              color: AppColors.leafSoft,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                            ),
                          ),
                          SizedBox(height: context.h(4)),
                          Text(
                            state.isRunning
                                ? LocaleKeys.breathing_secondsUnit.tr(
                                    args: [
                                      state.secondsLeftInPhase.toString(),
                                    ],
                                  )
                                : LocaleKeys.breathing_startSphereLabel.tr(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyle.headingLarge(context).copyWith(
                              color: AppColors.baseWhite,
                              fontSize: state.isRunning ? 26 : 20,
                              fontWeight: FontWeight.w700,
                              fontFeatures: const [
                                FontFeature.tabularFigures(),
                              ],
                            ),
                          ),
                        ],
                      ),
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
        return LocaleKeys.breathing_phaseReady.tr();
      case BreathPhase.inhale:
        return LocaleKeys.breathing_phaseInhale.tr();
      case BreathPhase.hold:
        return LocaleKeys.breathing_phaseHold.tr();
      case BreathPhase.exhale:
        return LocaleKeys.breathing_phaseExhale.tr();
      case BreathPhase.completed:
        return LocaleKeys.breathing_phaseDone.tr();
    }
  }
}
