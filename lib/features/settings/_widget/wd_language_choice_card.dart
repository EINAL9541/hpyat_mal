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
      borderRadius: context.borderRadius(all: 12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.symmetric(
          horizontal: context.w(16),
          vertical: context.h(14),
        ),
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          borderRadius: context.borderRadius(all: 12),
          border: Border.all(
            color: isSelected ? AppColors.emerald : AppColors.borderSubtle,
            width: isSelected ? 2.0 : 1.0,
          ),
          boxShadow: AppColors.cardShadow,
        ),
        child: Row(
          children: [
            Container(
              width: context.w(68),
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(
                horizontal: context.w(8),
                vertical: context.h(6),
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.emerald
                    : AppColors.leafSoft,
                borderRadius: context.borderRadius(all: 50),
              ),
              child: Text(
                badge,
                textAlign: TextAlign.center,
                maxLines: 1,
                textHeightBehavior: const TextHeightBehavior(
                  applyHeightToFirstAscent: false,
                  applyHeightToLastDescent: false,
                ),
                style: AppTextStyle.captionSmall(context).copyWith(
                  color: isSelected
                      ? AppColors.baseWhite
                      : AppColors.forestPrimary,
                  fontWeight: FontWeight.w700,
                  height: 1.0,
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
                color: AppColors.emerald,
                size: context.w(20),
              ),
          ],
        ),
      ),
    );
  }
}
