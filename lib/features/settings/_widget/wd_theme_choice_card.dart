import 'package:flutter/material.dart';
import 'package:hpyat_mal/core/extensions/context_extensions.dart';
import 'package:hpyat_mal/core/theme/app_color.dart';
import 'package:hpyat_mal/core/theme/app_text_style.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class ThemeChoiceCardWidget extends StatelessWidget {
  final String imageAsset;
  final String title;
  final String subtitle;
  final bool isSelected;
  final Color accentColor;
  final Color softColor;
  final VoidCallback onTap;

  const ThemeChoiceCardWidget({
    super.key,
    required this.imageAsset,
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
      borderRadius: context.borderRadius(all: 18),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(context.w(16)),
        decoration: BoxDecoration(
          color: isSelected
              ? softColor.withValues(alpha: 0.65)
              : AppColors.surfaceCard,
          borderRadius: context.borderRadius(all: 18),
          border: Border.all(
            color: isSelected ? accentColor : AppColors.border,
            width: isSelected ? 1.8 : 1.2,
          ),
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
              child: Image.asset(
                imageAsset,
                width: context.w(28),
                height: context.w(28),
                fit: BoxFit.contain,
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
                      color: accentColor,
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
