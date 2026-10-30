import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:hpyat_mal/core/extensions/context_extensions.dart';
import 'package:hpyat_mal/core/theme/app_color.dart';
import 'package:hpyat_mal/core/theme/app_text_style.dart';

class ForestHeaderWidget extends StatelessWidget {
  final String userName;
  final int vitality;
  final PlantThemeType plantTheme;
  final VoidCallback onOpenSettings;

  const ForestHeaderWidget({
    super.key,
    required this.userName,
    required this.vitality,
    required this.plantTheme,
    required this.onOpenSettings,
  });

  @override
  Widget build(BuildContext context) {
    final isCherry = plantTheme.isCherry;
    final isThriving = vitality >= 80;
    final statusColor = isThriving ? AppColors.emerald : AppColors.amberWarm;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName.isNotEmpty ? "Hi, $userName" : "Your Sanctuary",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyle.headingLarge(context).copyWith(
                  color: AppColors.forestPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: context.h(2)),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: context.w(7),
                    height: context.w(7),
                    decoration: BoxDecoration(
                      color: statusColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: context.w(6)),
                  Text(
                    isThriving
                        ? "${isCherry ? 'Sakura Sanctuary' : 'Emerald Sanctuary'} • $vitality% Vitality"
                        : "Recovering • $vitality% Vitality",
                    style: AppTextStyle.captionSmall(context).copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceCard,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.borderSubtle),
            boxShadow: AppColors.cardShadow,
          ),
          child: IconButton(
            onPressed: onOpenSettings,
            icon: Icon(
              LucideIcons.slidersHorizontal,
              size: context.w(18),
              color: AppColors.forestDeep,
            ),
            constraints: BoxConstraints.tightFor(
              width: context.w(40),
              height: context.w(40),
            ),
            padding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }
}
