import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
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
      savedUnit = "saved";
    } else {
      final formattedSaved = NumberFormat('#,###').format(moneySaved.round());
      final isPrefix = currencyUnit == r'$' ||
          currencyUnit == '€' ||
          currencyUnit == '£' ||
          currencyUnit == 'RM' ||
          currencyUnit == r'S$';
      savedValue = isPrefix ? '$currencyUnit$formattedSaved' : formattedSaved;
      savedUnit = isPrefix ? "saved" : "$currencyUnit saved";
    }

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            context: context,
            icon: LucideIcons.ban,
            iconColor: AppColors.emerald,
            value: cigarettesAvoided.toStringAsFixed(0),
            unit: "not smoked",
          ),
        ),
        SizedBox(width: context.w(10)),
        Expanded(
          child: _buildStatCard(
            context: context,
            icon: LucideIcons.piggyBank,
            iconColor: AppColors.amberWarm,
            value: savedValue,
            unit: savedUnit,
          ),
        ),
        SizedBox(width: context.w(10)),
        Expanded(
          child: _buildStatCard(
            context: context,
            icon: LucideIcons.heartPulse,
            iconColor: const Color(0xFFE11D48),
            value: "+${lifeRegainedHours.toStringAsFixed(1)}h",
            unit: "life added",
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String value,
    required String unit,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.w(10),
        vertical: context.h(12),
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: context.borderRadius(all: 16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.forestDeep.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: context.w(18), color: iconColor),
          SizedBox(height: context.h(6)),
          Text(
            value,
            style: AppTextStyle.headingSmall(context).copyWith(
              color: AppColors.forestDeep,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: context.h(2)),
          Text(
            unit,
            style: AppTextStyle.captionSmall(context),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
