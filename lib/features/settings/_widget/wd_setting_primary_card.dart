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
      padding: context.edgeInsets(all: 16),
      decoration: BoxDecoration(
        color: AppColors.forestPrimary,
        borderRadius: context.borderRadius(all: 20),
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
                    fontSize: context.sp(17.5),
                    fontWeight: FontWeight.w600,
                    height: 1.45,
                  ),
                ),
                SizedBox(height: context.h(3)),
                Text(
                  LocaleKeys.settings_profileSummary.tr(
                    args: [smokingFreeDays.toString()],
                  ),
                  style: AppTextStyle.captionMedium(context).copyWith(
                    color: AppColors.leafSoft,
                    fontWeight: FontWeight.w600,
                    height: 1.5,
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
