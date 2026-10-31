import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hpyat_mal/core/extensions/context_extensions.dart';
import 'package:hpyat_mal/core/generate/locale_keys.g.dart';
import 'package:hpyat_mal/core/theme/app_color.dart';
import 'package:hpyat_mal/core/theme/app_text_style.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

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
    final trimmedName = userName.trim();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                trimmedName.isNotEmpty
                    ? LocaleKeys.forest_greetingNamed.tr(args: [trimmedName])
                    : LocaleKeys.forest_greetingDefault.tr(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyle.headingLarge(context).copyWith(
                  color: AppColors.forestPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: context.h(3)),
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: context.w(7),
                    height: context.w(7),
                    decoration: BoxDecoration(
                      color: AppColors.emerald,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: context.w(6)),
                  Flexible(
                    child: Text(
                      isCherry
                          ? LocaleKeys.forest_subtitleCherry.tr()
                          : LocaleKeys.forest_subtitleEmerald.tr(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textHeightBehavior: const TextHeightBehavior(
                        applyHeightToFirstAscent: false,
                        applyHeightToLastDescent: false,
                      ),
                      style: AppTextStyle.captionMedium(context).copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                        height: 1.0,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(width: context.w(12)),
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
              LucideIcons.settings,
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
