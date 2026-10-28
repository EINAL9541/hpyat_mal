import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:hpyat_mal/core/extensions/context_extensions.dart';
import 'package:hpyat_mal/core/theme/app_color.dart';
import 'package:hpyat_mal/core/theme/app_text_style.dart';

class DailyNourishCardWidget extends StatelessWidget {
  const DailyNourishCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Craving SOS Emergency Card
    return GestureDetector(
      onTap: () => context.go('/breathing'),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: context.w(16),
          vertical: context.h(14),
        ),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFFFFF7ED),
              Color(0xFFFFEDD5),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: context.borderRadius(all: 18),
          border: Border.all(
            color: const Color(0xFFFDBA74),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.amberWarm.withValues(alpha: 0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: context.w(44),
              height: context.h(44),
              decoration: BoxDecoration(
                color: AppColors.amberWarm,
                shape: BoxShape.circle,
              ),
              child: Icon(
                LucideIcons.wind,
                color: AppColors.baseWhite,
                size: context.w(22),
              ),
            ),
            SizedBox(width: context.w(14)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Having a Craving Right Now?",
                    style: AppTextStyle.headingSmall(context).copyWith(
                      color: const Color(0xFF9A3412),
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(height: context.h(2)),
                  Text(
                    "Cravings peak in 3 minutes. Tap for guided calming breath.",
                    style: AppTextStyle.captionMedium(context).copyWith(
                      color: const Color(0xFFC2410C),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              LucideIcons.chevronRight,
              color: const Color(0xFF9A3412),
              size: context.w(20),
            ),
          ],
        ),
      ),
    );
  }
}
