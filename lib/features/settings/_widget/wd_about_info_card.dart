import 'package:flutter/material.dart';
import 'package:hpyat_mal/core/extensions/context_extensions.dart';
import 'package:hpyat_mal/core/theme/app_color.dart';
import 'package:hpyat_mal/core/theme/app_text_style.dart';

class AboutInfoCardWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const AboutInfoCardWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.w(16)),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: context.borderRadius(all: 18),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: context.w(40),
            height: context.h(40),
            decoration: BoxDecoration(
              color: AppColors.leafSoft,
              borderRadius: context.borderRadius(all: 12),
            ),
            child: Icon(
              icon,
              size: context.w(20),
              color: AppColors.forestPrimary,
            ),
          ),
          SizedBox(width: context.w(14)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyle.bodySemiBold(context).copyWith(
                    color: AppColors.forestDeep,
                    fontSize: 15,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: context.h(3)),
                Text(
                  description,
                  style: AppTextStyle.captionMedium(context).copyWith(
                    color: AppColors.forestDeep.withValues(alpha: 0.85),
                    height: 1.6,
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
