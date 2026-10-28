import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:hpyat_mal/core/extensions/context_extensions.dart';
import 'package:hpyat_mal/core/theme/app_color.dart';
import 'package:hpyat_mal/core/theme/app_text_style.dart';

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
    return SafeArea(
      child: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: context.w(6),
              vertical: context.h(4),
            ),
            margin: EdgeInsets.symmetric(
              horizontal: context.w(16),
              vertical: context.h(8),
            ),
            decoration: BoxDecoration(
              color: AppColors.surfaceCard,
              borderRadius: context.borderRadius(all: 24),
              border: Border.all(color: AppColors.border, width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: AppColors.forestDeep.withValues(alpha: 0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(
                  icon: LucideIcons.trees,
                  label: "Forest",
                  isSelected: selectedIndex == 0,
                  onTap: () => onTap(0),
                ),
                _NavItem(
                  icon: LucideIcons.activity,
                  label: "Healing",
                  isSelected: selectedIndex == 1,
                  onTap: () => onTap(1),
                ),
                SizedBox(width: context.w(48)), // Space for center floating SOS button
                _NavItem(
                  icon: LucideIcons.bookOpen,
                  label: "Journal",
                  isSelected: selectedIndex == 2,
                  onTap: () => onTap(2),
                ),
                _NavItem(
                  icon: LucideIcons.piggyBank,
                  label: "Savings",
                  isSelected: selectedIndex == 3,
                  onTap: () => onTap(3),
                ),
              ],
            ),
          ),

          // Floating Center SOS Button
          Positioned(
            top: -16,
            child: GestureDetector(
              onTap: () => onTap(4), // Center SOS Breathing
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: context.w(52),
                    height: context.h(52),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.emerald,
                          AppColors.forestPrimary,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.surfaceCard, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.emerald.withValues(alpha: 0.4),
                          blurRadius: 14,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Icon(
                      LucideIcons.wind,
                      color: AppColors.baseWhite,
                      size: context.w(24),
                    ),
                  ),
                  SizedBox(height: context.h(2)),
                  Text(
                    "SOS",
                    style: AppTextStyle.captionSmall(context).copyWith(
                      color: selectedIndex == 4
                          ? AppColors.emerald
                          : AppColors.textSecondary,
                      fontWeight: FontWeight.w700,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: context.w(8),
          vertical: context.h(4),
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.leafSoft.withValues(alpha: 0.5)
              : AppColors.transparent,
          borderRadius: context.borderRadius(all: 12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? activeColor : inactiveColor,
              size: context.w(20),
            ),
            SizedBox(height: context.h(2)),
            Text(
              label,
              style: AppTextStyle.captionSmall(context).copyWith(
                color: isSelected ? activeColor : inactiveColor,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                fontSize: 10.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
