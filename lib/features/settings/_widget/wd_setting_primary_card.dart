import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hpyat_mal/core/extensions/context_extensions.dart';
import 'package:hpyat_mal/core/generate/locale_keys.g.dart';
import 'package:hpyat_mal/core/theme/app_color.dart';
import 'package:hpyat_mal/core/theme/app_text_style.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class SettingPrimaryCardWidget extends StatelessWidget {
  final String username;
  final int smokingFreeDays;
  final bool isCherry;

  const SettingPrimaryCardWidget({
    super.key,
    required this.username,
    required this.smokingFreeDays,
    required this.isCherry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: context.edgeInsets(all: 20),
      decoration: BoxDecoration(
        color: AppColors.forestDeep,
        borderRadius: context.borderRadius(all: 16),
        boxShadow: AppColors.cardShadow,
      ),
      child: Row(
        children: [
          Container(
            width: context.w(50),
            height: context.w(50),
            decoration: BoxDecoration(
              color: AppColors.leafSoft,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(
              isCherry ? LucideIcons.flower2 : LucideIcons.treeDeciduous,
              size: context.w(24),
              color: AppColors.forestPrimary,
            ),
          ),
          SizedBox(width: context.w(14)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  username,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.headingSmall(context).copyWith(
                    color: AppColors.baseWhite,
                    fontSize: context.sp(18),
                    fontWeight: FontWeight.w700,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: context.h(4)),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.w(10),
                    vertical: context.h(4),
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.baseWhite.withValues(alpha: 0.10),
                    borderRadius: context.borderRadius(all: 50),
                    border: Border.all(
                      color: AppColors.amberWarm.withValues(alpha: 0.45),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '★',
                        style: TextStyle(
                          color: AppColors.amberWarm,
                          fontSize: context.sp(11),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: context.w(5)),
                      Flexible(
                        child: Text(
                          LocaleKeys.settings_profileSummary.tr(
                            args: [smokingFreeDays.toString()],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyle.captionSmall(context).copyWith(
                            color: AppColors.baseWhite,
                            fontWeight: FontWeight.w600,
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
