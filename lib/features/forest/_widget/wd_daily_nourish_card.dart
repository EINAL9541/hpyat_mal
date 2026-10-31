import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hpyat_mal/core/extensions/context_extensions.dart';
import 'package:hpyat_mal/core/generate/locale_keys.g.dart';
import 'package:hpyat_mal/core/theme/app_color.dart';
import 'package:hpyat_mal/core/theme/app_text_style.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class DailyNourishCardWidget extends StatelessWidget {
  const DailyNourishCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        HapticFeedback.selectionClick();
        context.go('/breathing');
      },
      borderRadius: context.borderRadius(all: 14),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: context.w(16),
          vertical: context.h(14),
        ),
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          borderRadius: context.borderRadius(all: 14),
          border: Border.all(color: AppColors.borderSubtle),
          boxShadow: AppColors.cardShadow,
        ),
        child: Row(
          children: [
            Container(
              width: context.w(40),
              height: context.w(40),
              decoration: BoxDecoration(
                color: AppColors.leafSoft,
                shape: BoxShape.circle,
              ),
              child: Icon(
                LucideIcons.wind,
                color: AppColors.forestPrimary,
                size: context.w(18),
              ),
            ),
            SizedBox(width: context.w(12)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LocaleKeys.forest_cravingCardTitle.tr(),
                    style: AppTextStyle.bodySemiBold(context).copyWith(
                      color: AppColors.forestDeep,
                      fontSize: 14.5,
                    ),
                  ),
                  SizedBox(height: context.h(2)),
                  Text(
                    LocaleKeys.forest_cravingCardSubtitle.tr(),
                    style: AppTextStyle.captionSmall(context).copyWith(
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: context.w(8)),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: context.w(10),
                vertical: context.h(6),
              ),
              decoration: BoxDecoration(
                color: AppColors.emerald,
                borderRadius: context.borderRadius(all: 50),
              ),
              child: Icon(
                LucideIcons.arrowRight,
                color: AppColors.baseWhite,
                size: context.w(15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
