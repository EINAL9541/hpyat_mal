import 'package:flutter/material.dart';
import 'package:hpyat_mal/core/extensions/context_extensions.dart';
import 'package:hpyat_mal/core/theme/app_color.dart';
import 'package:hpyat_mal/core/theme/app_text_style.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class ThemeChoiceCardWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isSelected;
  final Color accentColor;
  final Color softColor;
  final VoidCallback onTap;

  const ThemeChoiceCardWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.accentColor,
    required this.softColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: context.borderRadius(all: 12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(context.w(16)),
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          borderRadius: context.borderRadius(all: 12),
          border: Border.all(
            color: isSelected ? accentColor : AppColors.borderSubtle,
            width: isSelected ? 2.0 : 1.0,
          ),
          boxShadow: AppColors.cardShadow,
        ),
        child: Row(
          children: [
            Container(
              width: context.w(46),
              height: context.h(46),
              decoration: BoxDecoration(
                color: softColor,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(
                icon,
                size: context.w(28),
                color: accentColor,
              ),
            ),
            SizedBox(width: context.w(14)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyle.bodySemiBold(context).copyWith(
                      color: isSelected ? accentColor : AppColors.forestDeep,
                      fontWeight: FontWeight.w700,
                      fontSize: 15.5,
                    ),
                  ),
                  SizedBox(height: context.h(2)),
                  Text(
                    subtitle,
                    style: AppTextStyle.captionSmall(context)
                        .copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                LucideIcons.circleCheck,
                color: accentColor,
                size: context.w(20),
              ),
          ],
        ),
      ),
    );
  }
}
