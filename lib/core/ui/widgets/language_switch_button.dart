import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:hpyat_mal/core/extensions/context_extensions.dart';
import 'package:hpyat_mal/core/theme/app_color.dart';
import 'package:hpyat_mal/core/theme/app_text_style.dart';

class LanguageSwitchButton extends StatelessWidget {
  final bool isCompact;

  const LanguageSwitchButton({
    super.key,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final currentCode = context.locale.languageCode;
    final isMyanmar = currentCode == 'my';

    return Container(
      padding: EdgeInsets.all(context.w(3)),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: context.borderRadius(all: 50),
        border: Border.all(
          color: AppColors.border,
          width: 1,
        ),
        boxShadow: AppColors.cardShadow,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildItem(
            context: context,
            label: isCompact ? "MM" : "🇲🇲 မြန်မာ",
            isSelected: isMyanmar,
            onTap: () {
              if (!isMyanmar) {
                context.setLocale(const Locale('my'));
              }
            },
          ),
          SizedBox(width: context.w(2)),
          _buildItem(
            context: context,
            label: isCompact ? "EN" : "🇬🇧 ENG",
            isSelected: !isMyanmar,
            onTap: () {
              if (isMyanmar) {
                context.setLocale(const Locale('en'));
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildItem({
    required BuildContext context,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: context.w(isCompact ? 9 : 11),
          vertical: context.h(4),
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.emerald : Colors.transparent,
          borderRadius: context.borderRadius(all: 50),
        ),
        child: Text(
          label,
          style: AppTextStyle.captionSmall(context).copyWith(
            color: isSelected ? AppColors.baseWhite : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            fontSize: isCompact ? 11 : 12,
          ),
        ),
      ),
    );
  }
}
