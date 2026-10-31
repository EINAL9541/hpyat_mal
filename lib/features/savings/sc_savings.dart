import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hpyat_mal/core/extensions/context_extensions.dart';
import 'package:hpyat_mal/core/generate/locale_keys.g.dart';
import 'package:hpyat_mal/core/services/storage_service.dart';
import 'package:hpyat_mal/core/theme/app_color.dart';
import 'package:hpyat_mal/core/theme/app_text_style.dart';
import 'package:hpyat_mal/core/ui/widgets/wd_bottom_sheet.dart';
import 'package:hpyat_mal/features/forest/_provider/forest_provider.dart';
import 'package:hpyat_mal/features/savings/_provider/savings_provider.dart';
import 'package:hpyat_mal/features/savings/_widget/wd_add_wishlist_dialog.dart';
import 'package:hpyat_mal/features/savings/_widget/wd_wishlist_card.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

enum _GoalFilter { active, claimed }

class SavingsScreen extends ConsumerStatefulWidget {
  const SavingsScreen({super.key});

  @override
  ConsumerState<SavingsScreen> createState() => _SavingsScreenState();
}

class _SavingsScreenState extends ConsumerState<SavingsScreen> {
  _GoalFilter _filter = _GoalFilter.active;

  void _openGoalSheet(
    BuildContext context,
    ForestState forest, {
    WishlistItem? existingItem,
    String? presetTitle,
    double? presetAmount,
    String? presetIconKey,
  }) {
    HapticFeedback.selectionClick();
    showAppBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => AddWishlistDialogWidget(
        currencyUnit: forest.currencyUnit(context.locale.languageCode),
        initialItem: existingItem,
        presetTitle: presetTitle,
        presetAmount: presetAmount,
        presetIconKey: presetIconKey,
        dailySavings:
            (forest.cigsPerDay / forest.cigsPerPack) * forest.packCost,
        onAdd: (title, targetAmount, iconKey, imagePath) {
          if (existingItem != null) {
            ref
                .read(savingsProvider.notifier)
                .updateWishlistItem(
                  id: existingItem.id,
                  title: title,
                  targetAmount: targetAmount,
                  iconKey: iconKey,
                  imagePath: imagePath,
                  isCompleted: existingItem.isCompleted,
                  claimedAt: existingItem.claimedAt,
                );
          } else {
            ref
                .read(savingsProvider.notifier)
                .addWishlistItem(
                  title: title,
                  targetAmount: targetAmount,
                  iconKey: iconKey,
                  imagePath: imagePath,
                );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    EasyLocalization.of(context);
    final forest = ref.watch(forestProvider);
    final savings = ref.watch(savingsProvider);
    final langCode = context.locale.languageCode;

    final dailySavings =
        (forest.cigsPerDay / forest.cigsPerPack) * forest.packCost;
    final monthlySavings = dailySavings * 30.0;
    final yearlySavings = dailySavings * 365.0;
    final packsAvoided = forest.cigarettesAvoided / forest.cigsPerPack;

    final totalSaved = forest.moneySaved;
    final claimedTotal = savings.claimedTotal;
    final availableSavings = (totalSaved - claimedTotal).clamp(
      0.0,
      double.infinity,
    );

    final List<WishlistItem> filteredGoals;
    switch (_filter) {
      case _GoalFilter.active:
        filteredGoals = savings.activeItems;
        break;
      case _GoalFilter.claimed:
        filteredGoals = savings.completedItems;
        break;
    }

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: context.w(16),
            vertical: context.h(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Page Header with 50px Full-Pill Primary CTA
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LocaleKeys.savings_title.tr(),
                          style: AppTextStyle.headingLarge(context).copyWith(
                            color: AppColors.forestPrimary,
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: context.h(2)),
                        Text(
                          LocaleKeys.savings_subtitle.tr(),
                          style: AppTextStyle.captionMedium(context),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: context.w(12)),
                  ElevatedButton(
                    onPressed: () => _openGoalSheet(context, forest),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.emerald,
                      foregroundColor: AppColors.baseWhite,
                      padding: EdgeInsets.symmetric(
                        horizontal: context.w(16),
                        vertical: context.h(10),
                      ),
                      shape: const StadiumBorder(),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(LucideIcons.plus, size: context.w(15)),
                        SizedBox(width: context.w(6)),
                        Text(
                          LocaleKeys.savings_newBtn.tr(),
                          textHeightBehavior: const TextHeightBehavior(
                            applyHeightToFirstAscent: false,
                            applyHeightToLastDescent: false,
                          ),
                          style: AppTextStyle.bodySemiBold(context).copyWith(
                            color: AppColors.baseWhite,
                            fontSize: 13.5,
                            height: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: context.h(16)),

              // 2. Solid House Feature Band Hero Card (#1E3932 / #381824)
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(context.w(18)),
                decoration: BoxDecoration(
                  color: AppColors.forestDeep,
                  borderRadius: context.borderRadius(all: 16),
                  boxShadow: AppColors.cardShadow,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            claimedTotal > 0
                                ? LocaleKeys.savings_availableForGoals.tr()
                                : LocaleKeys.savings_totalMoneySaved.tr(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyle.captionSmall(context).copyWith(
                              color: AppColors.baseWhite.withValues(
                                alpha: 0.72,
                              ),
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.6,
                            ),
                          ),
                        ),
                        SizedBox(width: context.w(8)),
                        // Gold-outlined Daily Rate Pill
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: context.w(10),
                            vertical: context.h(5),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: context.borderRadius(all: 50),
                            border: Border.all(color: AppColors.amberWarm),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                LucideIcons.trendingUp,
                                size: context.w(12),
                                color: AppColors.amberWarm,
                              ),
                              SizedBox(width: context.w(4)),
                              Text(
                                LocaleKeys.savings_perDayRate.tr(
                                  args: [
                                    forest.formatMoney(dailySavings, langCode),
                                  ],
                                ),
                                textHeightBehavior: const TextHeightBehavior(
                                  applyHeightToFirstAscent: false,
                                  applyHeightToLastDescent: false,
                                ),
                                style: AppTextStyle.captionSmall(context)
                                    .copyWith(
                                      color: AppColors.amberWarm,
                                      fontWeight: FontWeight.w700,
                                      height: 1.0,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: context.h(8)),
                    Text(
                      forest.formatMoney(
                        claimedTotal > 0 ? availableSavings : totalSaved,
                        langCode,
                      ),
                      style: AppTextStyle.numberDisplay(context)
                          .copyWith(color: AppColors.baseWhite, fontSize: 32),
                    ),
                    if (claimedTotal > 0) ...[
                      SizedBox(height: context.h(4)),
                      Text(
                        LocaleKeys.savings_savedAndClaimed.tr(
                          args: [
                            NumberFormat('#,###').format(totalSaved.round()),
                            forest.formatMoney(claimedTotal, langCode),
                          ],
                        ),
                        style: AppTextStyle.captionSmall(context).copyWith(
                          color: AppColors.leafSoft,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                    SizedBox(height: context.h(12)),
                    Divider(
                      height: 1,
                      color: AppColors.baseWhite.withValues(alpha: 0.14),
                    ),
                    SizedBox(height: context.h(10)),
                    IntrinsicHeight(
                      child: Row(
                        children: [
                          Expanded(
                            child: _HeroStatColumn(
                              label: LocaleKeys.savings_monthly.tr(),
                              value: forest.formatMoney(
                                monthlySavings,
                                langCode,
                              ),
                            ),
                          ),
                          VerticalDivider(
                            width: context.w(16),
                            thickness: 1,
                            color: AppColors.baseWhite.withValues(alpha: 0.14),
                          ),
                          Expanded(
                            child: _HeroStatColumn(
                              label: LocaleKeys.savings_yearly.tr(),
                              value: forest.formatMoney(
                                yearlySavings,
                                langCode,
                              ),
                            ),
                          ),
                          VerticalDivider(
                            width: context.w(16),
                            thickness: 1,
                            color: AppColors.baseWhite.withValues(alpha: 0.14),
                          ),
                          Expanded(
                            child: _HeroStatColumn(
                              label: LocaleKeys.savings_packsSkipped.tr(),
                              value: packsAvoided.toStringAsFixed(1),
                              alignEnd: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: context.h(18)),

              // 3. Goals Section Header + Sliding Switch Toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      LocaleKeys.savings_rewardGoals.tr(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.headingSmall(context)
                          .copyWith(color: AppColors.forestDeep),
                    ),
                  ),
                  if (savings.wishlist.isNotEmpty) ...[
                    SizedBox(width: context.w(8)),
                    _GoalSwitchToggle(
                      selectedFilter: _filter,
                      onChanged: (next) => setState(() => _filter = next),
                    ),
                  ],
                ],
              ),

              SizedBox(height: context.h(14)),

              // 4. Empty State or Goal Cards
              if (savings.wishlist.isEmpty)
                _EmptyGoalsCard(
                  onCreateCustom: () => _openGoalSheet(context, forest),
                )
              else if (filteredGoals.isEmpty)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: context.w(20),
                    vertical: context.h(28),
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceCard,
                    borderRadius: context.borderRadius(all: 14),
                    border: Border.all(color: AppColors.borderSubtle),
                    boxShadow: AppColors.cardShadow,
                  ),
                  child: Column(
                    children: [
                      Icon(
                        _filter == _GoalFilter.claimed
                            ? LucideIcons.award
                            : LucideIcons.target,
                        size: context.w(24),
                        color: AppColors.textMuted,
                      ),
                      SizedBox(height: context.h(8)),
                      Text(
                        _filter == _GoalFilter.claimed
                            ? LocaleKeys.savings_noClaimedTitle.tr()
                            : LocaleKeys.savings_noActiveTitle.tr(),
                        style: AppTextStyle.bodySemiBold(context)
                            .copyWith(color: AppColors.forestDeep),
                      ),
                      SizedBox(height: context.h(4)),
                      Text(
                        _filter == _GoalFilter.claimed
                            ? LocaleKeys.savings_noClaimedSubtitle.tr()
                            : LocaleKeys.savings_noActiveSubtitle.tr(),
                        textAlign: TextAlign.center,
                        style: AppTextStyle.captionMedium(context),
                      ),
                    ],
                  ),
                )
              else
                ...filteredGoals.map(
                  (item) => WishlistCardWidget(
                    item: item,
                    currentSavings: availableSavings,
                    dailySavingsRate: dailySavings,
                    formatMoney: (amount) =>
                        forest.formatMoney(amount, langCode),
                    onToggle: () =>
                        ref.read(savingsProvider.notifier).toggleItem(item.id),
                    onEdit: () =>
                        _openGoalSheet(context, forest, existingItem: item),
                    onChangePhoto: () =>
                        _openGoalSheet(context, forest, existingItem: item),
                    onDelete: () {
                      ref.read(savingsProvider.notifier).deleteItem(item.id);
                    },
                  ),
                ),

              SizedBox(height: context.h(85)),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroStatColumn extends StatelessWidget {
  final String label;
  final String value;
  final bool alignEnd;

  const _HeroStatColumn({
    required this.label,
    required this.value,
    this.alignEnd = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
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
    );
  }
}

class _GoalSwitchToggle extends StatelessWidget {
  final _GoalFilter selectedFilter;
  final ValueChanged<_GoalFilter> onChanged;

  const _GoalSwitchToggle({
    required this.selectedFilter,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isClaimed = selectedFilter == _GoalFilter.claimed;

    return Container(
      width: context.w(156),
      height: context.h(34),
      padding: EdgeInsets.all(context.w(3)),
      decoration: ShapeDecoration(
        color: AppColors.surfaceCard,
        shape: StadiumBorder(
          side: BorderSide(color: AppColors.border, width: 1),
        ),
        shadows: AppColors.cardShadow,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedAlign(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            alignment:
                isClaimed ? Alignment.centerRight : Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: 0.5,
              heightFactor: 1.0,
              child: DecoratedBox(
                decoration: ShapeDecoration(
                  color: AppColors.emerald,
                  shape: const StadiumBorder(),
                ),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    if (isClaimed) {
                      HapticFeedback.selectionClick();
                      onChanged(_GoalFilter.active);
                    }
                  },
                  child: Center(
                    child: Text(
                      LocaleKeys.savings_tabActive.tr(),
                      textAlign: TextAlign.center,
                      textHeightBehavior: const TextHeightBehavior(
                        applyHeightToFirstAscent: false,
                        applyHeightToLastDescent: false,
                      ),
                      style: AppTextStyle.captionSmall(context).copyWith(
                        color: !isClaimed
                            ? AppColors.baseWhite
                            : AppColors.textSecondary,
                        fontWeight:
                            !isClaimed ? FontWeight.w700 : FontWeight.w600,
                        height: 1.0,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    if (!isClaimed) {
                      HapticFeedback.selectionClick();
                      onChanged(_GoalFilter.claimed);
                    }
                  },
                  child: Center(
                    child: Text(
                      LocaleKeys.savings_tabClaimed.tr(),
                      textAlign: TextAlign.center,
                      textHeightBehavior: const TextHeightBehavior(
                        applyHeightToFirstAscent: false,
                        applyHeightToLastDescent: false,
                      ),
                      style: AppTextStyle.captionSmall(context).copyWith(
                        color: isClaimed
                            ? AppColors.baseWhite
                            : AppColors.textSecondary,
                        fontWeight:
                            isClaimed ? FontWeight.w700 : FontWeight.w600,
                        height: 1.0,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EmptyGoalsCard extends StatelessWidget {
  final VoidCallback onCreateCustom;

  const _EmptyGoalsCard({required this.onCreateCustom});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.w(20)),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: context.borderRadius(all: 16),
        border: Border.all(color: AppColors.borderSubtle),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        children: [
          Container(
            width: context.w(56),
            height: context.w(56),
            decoration: BoxDecoration(
              color: AppColors.leafSoft,
              shape: BoxShape.circle,
            ),
            child: Icon(
              LucideIcons.gift,
              color: AppColors.forestPrimary,
              size: context.w(24),
            ),
          ),
          SizedBox(height: context.h(14)),
          Text(
            LocaleKeys.savings_emptyTitle.tr(),
            textAlign: TextAlign.center,
            style: AppTextStyle.headingSmall(context)
                .copyWith(color: AppColors.forestDeep),
          ),
          SizedBox(height: context.h(6)),
          Text(
            LocaleKeys.savings_emptySubtitle.tr(),
            textAlign: TextAlign.center,
            style: AppTextStyle.captionMedium(context),
          ),
          SizedBox(height: context.h(20)),
          SizedBox(
            width: double.infinity,
            height: context.h(48),
            child: ElevatedButton(
              onPressed: onCreateCustom,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.emerald,
                foregroundColor: AppColors.baseWhite,
                elevation: 0,
                shape: const StadiumBorder(),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(LucideIcons.plus, size: context.w(16)),
                  SizedBox(width: context.w(8)),
                  Text(
                    LocaleKeys.savings_createGoalBtn.tr(),
                    textHeightBehavior: const TextHeightBehavior(
                      applyHeightToFirstAscent: false,
                      applyHeightToLastDescent: false,
                    ),
                    style: AppTextStyle.bodySemiBold(context).copyWith(
                      color: AppColors.baseWhite,
                      height: 1.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
