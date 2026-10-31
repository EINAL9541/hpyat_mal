import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hpyat_mal/core/extensions/context_extensions.dart';
import 'package:hpyat_mal/core/generate/locale_keys.g.dart';
import 'package:hpyat_mal/core/theme/app_color.dart';
import 'package:hpyat_mal/core/theme/app_text_style.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class BottomNavbarWidget extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const BottomNavbarWidget({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    EasyLocalization.of(context);
    final isBreathingSelected = selectedIndex == 4;

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          context.w(16),
          context.h(4),
          context.w(16),
          context.h(8),
        ),
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            // Main Navbar Dock
            Container(
              height: context.h(64),
              padding: EdgeInsets.symmetric(horizontal: context.w(8)),
              decoration: BoxDecoration(
                color: AppColors.surfaceCard,
                borderRadius: context.borderRadius(all: 36),
                border: Border.all(color: AppColors.borderSubtle, width: 1),
                boxShadow: AppColors.cardShadow,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _NavItem(
                      icon: LucideIcons.trees,
                      label: LocaleKeys.common_navForest.tr(),
                      isSelected: selectedIndex == 0,
                      onTap: () {
                        HapticFeedback.selectionClick();
                        onTap(0);
                      },
                    ),
                  ),
                  Expanded(
                    child: _NavItem(
                      icon: LucideIcons.activity,
                      label: LocaleKeys.common_navHealing.tr(),
                      isSelected: selectedIndex == 1,
                      onTap: () {
                        HapticFeedback.selectionClick();
                        onTap(1);
                      },
                    ),
                  ),

                  // Center spacer for the elevated circular emblem button
                  SizedBox(width: context.w(68)),

                  Expanded(
                    child: _NavItem(
                      icon: LucideIcons.bookOpen,
                      label: LocaleKeys.common_navJournal.tr(),
                      isSelected: selectedIndex == 2,
                      onTap: () {
                        HapticFeedback.selectionClick();
                        onTap(2);
                      },
                    ),
                  ),
                  Expanded(
                    child: _NavItem(
                      icon: LucideIcons.piggyBank,
                      label: LocaleKeys.common_navSavings.tr(),
                      isSelected: selectedIndex == 3,
                      onTap: () {
                        HapticFeedback.selectionClick();
                        onTap(3);
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Center Circular Medallion Button ("Breathe")
            Positioned(
              top: -context.h(12),
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.mediumImpact();
                  onTap(4);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.all(context.w(4)),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceCard,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isBreathingSelected
                              ? AppColors.emerald.withValues(alpha: 0.35)
                              : AppColors.borderSubtle,
                          width: 1,
                        ),
                        boxShadow: AppColors.cardShadow,
                      ),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        curve: Curves.easeOutCubic,
                        width: context.w(48),
                        height: context.w(48),
                        decoration: BoxDecoration(
                          color: isBreathingSelected
                              ? AppColors.forestDeep
                              : AppColors.emerald,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isBreathingSelected
                                ? AppColors.amberWarm
                                : AppColors.leafSoft.withValues(alpha: 0.45),
                            width: isBreathingSelected ? 2.0 : 1.5,
                          ),
                          boxShadow: AppColors.floatingShadow,
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          LucideIcons.wind,
                          color: AppColors.baseWhite,
                          size: context.w(22),
                        ),
                      ),
                    ),
                    SizedBox(height: context.h(2)),
                    Text(
                      LocaleKeys.common_navBreathe.tr(),
                      style: AppTextStyle.captionSmall(context).copyWith(
                        color: isBreathingSelected
                            ? AppColors.forestPrimary
                            : AppColors.textMuted,
                        fontWeight: isBreathingSelected
                            ? FontWeight.w700
                            : FontWeight.w500,
                        fontSize: 10,
                        letterSpacing: -0.1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = AppColors.forestPrimary;
    final inactiveColor = AppColors.textMuted;

    return InkWell(
      onTap: onTap,
      splashColor: AppColors.transparent,
      highlightColor: AppColors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            padding: EdgeInsets.symmetric(
              horizontal: context.w(12),
              vertical: context.h(4),
            ),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.leafSoft : AppColors.transparent,
              borderRadius: context.borderRadius(all: 50),
            ),
            child: Icon(
              icon,
              color: isSelected ? activeColor : inactiveColor,
              size: context.w(19),
            ),
          ),
          SizedBox(height: context.h(2)),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyle.captionSmall(context).copyWith(
              color: isSelected ? activeColor : inactiveColor,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              fontSize: 10,
              letterSpacing: -0.1,
            ),
          ),
        ],
      ),
    );
  }
}
