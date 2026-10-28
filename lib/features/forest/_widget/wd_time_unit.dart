import 'package:flutter/material.dart';
import 'package:hpyat_mal/core/extensions/context_extensions.dart';
import 'package:hpyat_mal/core/theme/app_color.dart';
import 'package:hpyat_mal/core/theme/app_text_style.dart';

class TimeUnitWidget extends StatelessWidget {
  final String value;
  final String label;

  const TimeUnitWidget({
    super.key,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: context.w(12),
            vertical: context.h(8),
          ),
          decoration: BoxDecoration(
            color: AppColors.leafBackground,
            borderRadius: context.borderRadius(all: 12),
            border: Border.all(color: AppColors.borderSubtle),
          ),
          child: Text(
            value,
            style: AppTextStyle.headingLarge(context).copyWith(
              color: AppColors.forestDeep,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        SizedBox(height: context.h(4)),
        Text(
          label,
          style: AppTextStyle.captionSmall(context).copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }
}
