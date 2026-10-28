import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hpyat_mal/core/extensions/context_extensions.dart';
import 'package:hpyat_mal/core/generate/locale_keys.g.dart';
import 'package:hpyat_mal/core/theme/app_color.dart';
import 'package:hpyat_mal/core/theme/app_text_style.dart';
import 'package:hpyat_mal/core/ui/widgets/wd_text_field.dart';

class HabitsStepWidget extends StatelessWidget {
  final TextEditingController cigsPerDayController;
  final TextEditingController cigsPerPackController;
  final TextEditingController packCostController;

  const HabitsStepWidget({
    super.key,
    required this.cigsPerDayController,
    required this.cigsPerPackController,
    required this.packCostController,
  });

  @override
  Widget build(BuildContext context) {
    final inputStyle = AppTextStyle.headingSmall(context).copyWith(
      color: AppColors.forestDeep,
      fontWeight: FontWeight.w600,
      fontSize: 17,
      height: 1.5,
    );
    final hintStyle = AppTextStyle.headingSmall(context).copyWith(
      color: AppColors.textMuted.withValues(alpha: 0.6),
      fontWeight: FontWeight.w500,
      fontSize: 17,
      height: 1.5,
    );

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: context.w(22)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: context.h(12)),
          Text(
            LocaleKeys.onboarding_habitsTitle.tr(),
            style: AppTextStyle.headingLarge(context).copyWith(
              color: AppColors.forestDeep,
              fontSize: 25,
              height: 1.5,
            ),
          ),
          SizedBox(height: context.h(8)),
          Text(
            LocaleKeys.onboarding_habitsSubtitle.tr(),
            style: AppTextStyle.bodyMedium(context).copyWith(
              color: AppColors.textSecondary,
              fontSize: 15,
              height: 1.65,
            ),
          ),
          SizedBox(height: context.h(22)),

          // 1. Cigs Per Day
          AppTextFieldWidget(
            label: LocaleKeys.onboarding_cigsPerDayLabel.tr(),
            controller: cigsPerDayController,
            hintText: '15',
            unit: LocaleKeys.onboarding_cigsPerDayUnit.tr(),
            isNumber: true,
            style: inputStyle,
            hintStyle: hintStyle,
          ),

          SizedBox(height: context.h(18)),

          // 2. Cigs Per Pack
          AppTextFieldWidget(
            label: LocaleKeys.onboarding_cigsPerPackLabel.tr(),
            controller: cigsPerPackController,
            hintText: '20',
            unit: LocaleKeys.onboarding_cigsPerPackUnit.tr(),
            isNumber: true,
            style: inputStyle,
            hintStyle: hintStyle,
          ),

          SizedBox(height: context.h(18)),

          // 3. Pack Cost in Kyat
          AppTextFieldWidget(
            label: LocaleKeys.onboarding_packCostLabel.tr(),
            controller: packCostController,
            hintText: '3500',
            unit: LocaleKeys.onboarding_packCostUnit.tr(),
            isNumber: true,
            style: inputStyle,
            hintStyle: hintStyle,
          ),

          SizedBox(height: context.h(16)),
        ],
      ),
    );
  }
}
