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
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: AppTextStyle.headingLarge(context).copyWith(
            color: AppColors.forestDeep,
            fontSize: 28,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
            height: 1.15,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
        SizedBox(height: context.h(3)),
        Text(
          label,
          style: AppTextStyle.captionSmall(context).copyWith(
            color: AppColors.textMuted,
            fontWeight: FontWeight.w700,
            fontSize: 10.5,
            letterSpacing: 0.9,
          ),
        ),
      ],
    );
  }
}
