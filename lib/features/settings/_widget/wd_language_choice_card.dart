import 'package:flutter/material.dart';
import 'package:hpyat_mal/core/extensions/context_extensions.dart';
import 'package:hpyat_mal/core/theme/app_color.dart';
import 'package:hpyat_mal/core/theme/app_text_style.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class LanguageChoiceCardWidget extends StatelessWidget {
  final String badge;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const LanguageChoiceCardWidget({
    super.key,
    required this.badge,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: context.borderRadius(all: 16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.symmetric(
          horizontal: context.w(16),
          vertical: context.h(14),
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.leafSoft.withValues(alpha: 0.7)
              : AppColors.surfaceCard,
          borderRadius: context.borderRadius(all: 16),
          border: Border.all(
            color: isSelected ? AppColors.emerald : AppColors.border,
            width: 1.2,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: context.w(10),
                vertical: context.h(5),
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.forestPrimary
                    : AppColors.leafBackground,
                borderRadius: context.borderRadius(all: 10),
              ),
              child: Text(
                badge,
                style: AppTextStyle.captionSmall(context).copyWith(
                  color: isSelected
                      ? AppColors.baseWhite
                      : AppColors.forestPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(width: context.w(14)),
            Expanded(
              child: Text(
                title,
                style: AppTextStyle.bodySemiBold(context)
                    .copyWith(color: AppColors.forestDeep, fontSize: 15),
              ),
            ),
            if (isSelected)
              Icon(
                LucideIcons.circleCheck,
                color: AppColors.forestPrimary,
                size: context.w(20),
              ),
          ],
        ),
      ),
    );
  }
}
