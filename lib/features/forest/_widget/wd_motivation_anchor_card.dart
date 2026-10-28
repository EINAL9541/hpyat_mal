import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:hpyat_mal/core/extensions/context_extensions.dart';
import 'package:hpyat_mal/core/theme/app_color.dart';
import 'package:hpyat_mal/core/theme/app_text_style.dart';

class MotivationAnchorCardWidget extends StatelessWidget {
  final String userName;
  final String quitReason;
  final Function(String newReason) onUpdateReason;

  const MotivationAnchorCardWidget({
    super.key,
    required this.userName,
    required this.quitReason,
    required this.onUpdateReason,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: context.w(16),
        vertical: context.h(14),
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: context.borderRadius(all: 18),
        border: Border.all(color: AppColors.border, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: AppColors.forestDeep.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(context.w(6)),
                decoration: BoxDecoration(
                  color: AppColors.leafSoft,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  LucideIcons.anchor,
                  size: context.w(14),
                  color: AppColors.forestPrimary,
                ),
              ),
              SizedBox(width: context.w(8)),
              Text(
                "YOUR ANCHOR REASON",
                style: AppTextStyle.captionSmall(context).copyWith(
                  color: AppColors.forestPrimary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
          SizedBox(height: context.h(8)),
          Text(
            quitReason,
            style: AppTextStyle.bodyMedium(context).copyWith(
              color: AppColors.forestDeep,
              fontWeight: FontWeight.w600,
              height: 1.65,
            ),
          ),
        ],
      ),
    );
  }
}
