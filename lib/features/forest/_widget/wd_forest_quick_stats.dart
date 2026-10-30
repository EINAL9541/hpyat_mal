import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hpyat_mal/core/extensions/context_extensions.dart';
import 'package:hpyat_mal/core/theme/app_color.dart';
import 'package:hpyat_mal/core/theme/app_text_style.dart';

class ForestQuickStatsWidget extends StatelessWidget {
  final double cigarettesAvoided;
  final double moneySaved;
  final double lifeRegainedHours;
  final String currencyUnit;
  final String? formattedMoney;

  const ForestQuickStatsWidget({
    super.key,
    required this.cigarettesAvoided,
    required this.moneySaved,
    required this.lifeRegainedHours,
    this.currencyUnit = "MMK",
    this.formattedMoney,
  });

  @override
  Widget build(BuildContext context) {
    final String savedValue;
    final String savedUnit;

    if (formattedMoney != null) {
      savedValue = formattedMoney!;
      savedUnit = "Saved";
    } else {
      final formattedSaved = NumberFormat('#,###').format(moneySaved.round());
      final isPrefix = currencyUnit == r'$' ||
          currencyUnit == '€' ||
          currencyUnit == '£' ||
          currencyUnit == 'RM' ||
          currencyUnit == r'S$';
      savedValue = isPrefix ? '$currencyUnit$formattedSaved' : formattedSaved;
      savedUnit = isPrefix ? "Saved" : "$currencyUnit saved";
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.w(12),
        vertical: context.h(16),
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: context.borderRadius(all: 12),
        border: Border.all(color: AppColors.borderSubtle),
        boxShadow: AppColors.cardShadow,
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: _buildStatColumn(
                context: context,
                value: cigarettesAvoided.toStringAsFixed(0),
                label: "Avoided",
                accentColor: AppColors.forestDeep,
              ),
            ),
            VerticalDivider(
              width: 1,
              thickness: 1,
              indent: context.h(4),
              endIndent: context.h(4),
              color: AppColors.borderSubtle,
            ),
            Expanded(
              flex: 2,
              child: _buildStatColumn(
                context: context,
                value: savedValue,
                label: savedUnit,
                accentColor: AppColors.forestPrimary,
              ),
            ),
            VerticalDivider(
              width: 1,
              thickness: 1,
              indent: context.h(4),
              endIndent: context.h(4),
              color: AppColors.borderSubtle,
            ),
            Expanded(
              child: _buildStatColumn(
                context: context,
                value: "+${lifeRegainedHours.toStringAsFixed(1)}h",
                label: "Life Gained",
                accentColor: AppColors.emerald,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn({
    required BuildContext context,
    required String value,
    required String label,
    required Color accentColor,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.w(4)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyle.headingSmall(context).copyWith(
              color: accentColor,
              fontWeight: FontWeight.w700,
              fontSize: 16.5,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          SizedBox(height: context.h(2)),
          Text(
            label,
            style: AppTextStyle.captionSmall(context).copyWith(
              color: AppColors.textMuted,
              fontSize: 11.5,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
