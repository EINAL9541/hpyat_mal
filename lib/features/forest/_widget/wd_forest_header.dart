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

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Left: App Identity & Vitality
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      "Hi, $userName",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.headingMedium(context).copyWith(
                        color: AppColors.forestDeep,
                      ),
                    ),
                  ),
                  SizedBox(width: context.w(6)),
                  Image.asset(
                    isCherry
                        ? "assets/images/cherry_blossom.png"
                        : "assets/images/deciduous_tree.png",
                    width: context.w(20),
                    height: context.w(20),
                    fit: BoxFit.contain,
                  ),
                ],
              ),
              SizedBox(height: context.h(2)),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: context.w(8),
                  vertical: context.h(3),
                ),
                decoration: BoxDecoration(
                  color: vitality >= 80
                      ? AppColors.leafSoft
                      : AppColors.warningSoft,
                  borderRadius: context.borderRadius(all: 8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      vitality >= 80
                          ? (isCherry ? LucideIcons.flower2 : LucideIcons.leaf)
                          : LucideIcons.cloudFog,
                      size: context.w(12),
                      color: vitality >= 80
                          ? AppColors.forestPrimary
                          : AppColors.amberWarm,
                    ),
                    SizedBox(width: context.w(4)),
                    Text(
                      vitality >= 80
                          ? "${isCherry ? 'Sakura' : 'Emerald'} • $vitality% Vital"
                          : "Recovering • $vitality% Vital",
                      style: AppTextStyle.captionSmall(context).copyWith(
                        color: vitality >= 80
                            ? AppColors.forestPrimary
                            : AppColors.amberWarm,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Right side of "Hi, Name": Settings Button
        IconButton(
          onPressed: onOpenSettings,
          icon: Icon(
            LucideIcons.settings,
            size: context.w(21),
            color: AppColors.forestPrimary,
          ),
          style: IconButton.styleFrom(
            backgroundColor: AppColors.surfaceCard,
            padding: EdgeInsets.all(context.w(10)),
            side: BorderSide(color: AppColors.border),
          ),
        ),
      ],
    );
  }
}
