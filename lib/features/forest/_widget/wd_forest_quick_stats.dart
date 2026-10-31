import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hpyat_mal/core/extensions/context_extensions.dart';
import 'package:hpyat_mal/core/generate/locale_keys.g.dart';
import 'package:hpyat_mal/core/theme/app_color.dart';
import 'package:hpyat_mal/core/theme/app_text_style.dart';
import 'package:hpyat_mal/features/forest/_provider/forest_provider.dart';
import 'package:hpyat_mal/features/forest/_widget/wd_time_unit.dart';

class ForestQuickStatsWidget extends ConsumerWidget {
  final DateTime quitDate;
  final double cigarettesAvoided;
  final double moneySaved;
  final double lifeRegainedHours;
  final String currencyUnit;
  final String? formattedMoney;

  const ForestQuickStatsWidget({
    super.key,
    required this.quitDate,
    required this.cigarettesAvoided,
    required this.moneySaved,
    required this.lifeRegainedHours,
    this.currencyUnit = "MMK",
    this.formattedMoney,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = ref.watch(liveNowProvider);
    final diff = now.difference(quitDate);
    final duration = diff.isNegative ? Duration.zero : diff;

    final displayDays = duration.inDays;
    final displayHours = duration.inHours % 24;
    final displayMinutes = duration.inMinutes % 60;
    final displaySeconds = duration.inSeconds % 60;

    final String savedValue;
    if (formattedMoney != null) {
      savedValue = formattedMoney!;
    } else {
      final formattedSaved = NumberFormat('#,###').format(moneySaved.round());
      final isPrefix = currencyUnit == r'$' ||
          currencyUnit == '€' ||
          currencyUnit == '£' ||
          currencyUnit == 'RM' ||
          currencyUnit == r'S$';
      savedValue = isPrefix
          ? '$currencyUnit$formattedSaved'
          : '$formattedSaved $currencyUnit';
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: context.w(18),
        vertical: context.h(16),
      ),
      decoration: BoxDecoration(
        color: AppColors.forestDeep,
        borderRadius: context.borderRadius(all: 16),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        children: [
          // 1. 4-Column Live Smoke-Free Timer
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: TimeUnitWidget(
                    value: displayDays.toString().padLeft(2, '0'),
                    label: LocaleKeys.forest_unitDays.tr(),
                    valueColor: AppColors.baseWhite,
                    labelColor: AppColors.baseWhite.withValues(alpha: 0.68),
                  ),
                ),
                _buildTimerDivider(context),
                Expanded(
                  child: TimeUnitWidget(
                    value: displayHours.toString().padLeft(2, '0'),
                    label: LocaleKeys.forest_unitHrs.tr(),
                    valueColor: AppColors.baseWhite,
                    labelColor: AppColors.baseWhite.withValues(alpha: 0.68),
                  ),
                ),
                _buildTimerDivider(context),
                Expanded(
                  child: TimeUnitWidget(
                    value: displayMinutes.toString().padLeft(2, '0'),
                    label: LocaleKeys.forest_unitMins.tr(),
                    valueColor: AppColors.baseWhite,
                    labelColor: AppColors.baseWhite.withValues(alpha: 0.68),
                  ),
                ),
                _buildTimerDivider(context),
                Expanded(
                  child: TimeUnitWidget(
                    value: displaySeconds.toString().padLeft(2, '0'),
                    label: LocaleKeys.forest_unitSecs.tr(),
                    valueColor: AppColors.baseWhite,
                    labelColor: AppColors.baseWhite.withValues(alpha: 0.68),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: context.h(14)),
          Divider(
            height: 1,
            color: AppColors.baseWhite.withValues(alpha: 0.14),
          ),
          SizedBox(height: context.h(12)),

          // 2. 3-Column Sanctuary Summary Stats (matching Healing, Journal & Savings)
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: _ForestHeroStat(
                    label: LocaleKeys.forest_statAvoided.tr(),
                    value: cigarettesAvoided.toStringAsFixed(0),
                  ),
                ),
                VerticalDivider(
                  width: context.w(16),
                  thickness: 1,
                  color: AppColors.baseWhite.withValues(alpha: 0.14),
                ),
                Expanded(
                  child: _ForestHeroStat(
                    label: LocaleKeys.forest_statSaved.tr(),
                    value: savedValue,
                    onTap: () {
                      HapticFeedback.selectionClick();
                      context.go('/savings');
                    },
                  ),
                ),
                VerticalDivider(
                  width: context.w(16),
                  thickness: 1,
                  color: AppColors.baseWhite.withValues(alpha: 0.14),
                ),
                Expanded(
                  child: _ForestHeroStat(
                    label: LocaleKeys.forest_statLifeGained.tr(),
                    value: LocaleKeys.forest_hoursShort.tr(
                      args: [lifeRegainedHours.toStringAsFixed(1)],
                    ),
                    alignEnd: true,
                    onTap: () {
                      HapticFeedback.selectionClick();
                      context.go('/health');
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimerDivider(BuildContext context) {
    return Container(
      width: 1,
      margin: EdgeInsets.symmetric(vertical: context.h(6)),
      color: AppColors.baseWhite.withValues(alpha: 0.14),
    );
  }
}

class _ForestHeroStat extends StatelessWidget {
  final String label;
  final String value;
  final bool alignEnd;
  final VoidCallback? onTap;

  const _ForestHeroStat({
    required this.label,
    required this.value,
    this.alignEnd = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: alignEnd
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyle.captionSmall(context).copyWith(
              color: AppColors.baseWhite.withValues(alpha: 0.68),
              fontSize: 11,
            ),
          ),
          SizedBox(height: context.h(3)),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyle.bodySemiBold(context).copyWith(
              color: AppColors.baseWhite,
              fontSize: 13.5,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}
