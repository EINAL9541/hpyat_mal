import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hpyat_mal/core/extensions/context_extensions.dart';
import 'package:hpyat_mal/core/services/storage_service.dart';
import 'package:hpyat_mal/core/theme/app_color.dart';
import 'package:hpyat_mal/core/theme/app_text_style.dart';
import 'package:hpyat_mal/features/forest/_provider/forest_provider.dart';
import 'package:hpyat_mal/features/savings/_provider/savings_provider.dart';
import 'package:hpyat_mal/features/savings/_widget/wd_add_wishlist_dialog.dart';
import 'package:hpyat_mal/features/savings/_widget/wd_wishlist_card.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

enum _GoalFilter { all, active, claimed }

class SavingsScreen extends ConsumerStatefulWidget {
  const SavingsScreen({super.key});

  @override
  ConsumerState<SavingsScreen> createState() => _SavingsScreenState();
}

class _SavingsScreenState extends ConsumerState<SavingsScreen> {
  _GoalFilter _filter = _GoalFilter.all;

  void _openGoalSheet(
    BuildContext context,
    ForestState forest, {
    WishlistItem? existingItem,
    String? presetTitle,
    double? presetAmount,
    String? presetIconKey,
  }) {
    HapticFeedback.selectionClick();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddWishlistDialogWidget(
        currencyUnit: forest.currencyUnit(context.locale.languageCode),
        initialItem: existingItem,
        presetTitle: presetTitle,
        presetAmount: presetAmount,
        presetIconKey: presetIconKey,
        onAdd: (title, targetAmount, iconKey, imagePath) {
          if (existingItem != null) {
            ref.read(savingsProvider.notifier).updateWishlistItem(
                  id: existingItem.id,
                  title: title,
                  targetAmount: targetAmount,
                  iconKey: iconKey,
                  imagePath: imagePath,
                  isCompleted: existingItem.isCompleted,
                );
          } else {
            ref.read(savingsProvider.notifier).addWishlistItem(
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
    final availableSavings =
        (totalSaved - claimedTotal).clamp(0.0, double.infinity);

    final List<WishlistItem> filteredGoals;
    switch (_filter) {
      case _GoalFilter.active:
        filteredGoals = savings.activeItems;
        break;
      case _GoalFilter.claimed:
        filteredGoals = savings.completedItems;
        break;
      case _GoalFilter.all:
        filteredGoals = [
          ...savings.activeItems,
          ...savings.completedItems,
        ];
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
                          "Savings & Goals",
                          style: AppTextStyle.headingLarge(context).copyWith(
                            color: AppColors.forestPrimary,
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: context.h(2)),
                        Text(
                          "Turn smoke-free days into real rewards",
                          style: AppTextStyle.captionMedium(context),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: context.w(12)),
                  ElevatedButton.icon(
                    onPressed: () => _openGoalSheet(context, forest),
                    icon: Icon(LucideIcons.plus, size: context.w(15)),
                    label: Text(
                      "New Goal",
                      style: AppTextStyle.bodySemiBold(context).copyWith(
                        color: AppColors.baseWhite,
                        fontSize: 13.5,
                      ),
                    ),
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
                  ),
                ],
              ),

              SizedBox(height: context.h(16)),

              // 2. Solid House Feature Band Hero Card (#1E3932 / #381824)
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(context.w(20)),
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
                        Text(
                          claimedTotal > 0
                              ? "AVAILABLE FOR GOALS"
                              : "TOTAL MONEY SAVED",
                          style: AppTextStyle.captionSmall(context).copyWith(
                            color: AppColors.baseWhite.withValues(alpha: 0.72),
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                          ),
                        ),
                        // Gold-outlined Daily Rate Pill
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: context.w(10),
                            vertical: context.h(4),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: context.borderRadius(all: 50),
                            border: Border.all(color: AppColors.amberWarm),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                LucideIcons.trendingUp,
                                size: context.w(12),
                                color: AppColors.amberWarm,
                              ),
                              SizedBox(width: context.w(4)),
                              Text(
                                "+${forest.formatMoney(dailySavings, langCode)}/day",
                                style:
                                    AppTextStyle.captionSmall(context).copyWith(
                                  color: AppColors.amberWarm,
                                  fontWeight: FontWeight.w700,
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
                      style: AppTextStyle.numberDisplay(context).copyWith(
                        color: AppColors.baseWhite,
                        fontSize: 38,
                      ),
                    ),
                    if (claimedTotal > 0) ...[
                      SizedBox(height: context.h(4)),
                      Text(
                        "Total saved: ${forest.formatMoney(totalSaved, langCode)}  •  Claimed: ${forest.formatMoney(claimedTotal, langCode)}",
                        style: AppTextStyle.captionSmall(context).copyWith(
                          color: AppColors.leafSoft,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                    SizedBox(height: context.h(16)),
                    Divider(
                      height: 1,
                      color: AppColors.baseWhite.withValues(alpha: 0.14),
                    ),
                    SizedBox(height: context.h(14)),
                    IntrinsicHeight(
                      child: Row(
                        children: [
                          Expanded(
                            child: _HeroStatColumn(
                              label: "Monthly Pace",
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
                              label: "Yearly Pace",
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
                              label: "Packs Skipped",
                              value: "${packsAvoided.toStringAsFixed(1)} packs",
                              alignEnd: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: context.h(22)),

              // 3. Goals Section Header + Filter Pills (when goals exist)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "REWARD GOALS",
                    style: AppTextStyle.captionSmall(context).copyWith(
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.9,
                    ),
                  ),
                  if (savings.wishlist.isNotEmpty)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _FilterChipPill(
                          label: "All (${savings.wishlist.length})",
                          isSelected: _filter == _GoalFilter.all,
                          onTap: () =>
                              setState(() => _filter = _GoalFilter.all),
                        ),
                        SizedBox(width: context.w(6)),
                        _FilterChipPill(
                          label: "Active (${savings.activeItems.length})",
                          isSelected: _filter == _GoalFilter.active,
                          onTap: () =>
                              setState(() => _filter = _GoalFilter.active),
                        ),
                        SizedBox(width: context.w(6)),
                        _FilterChipPill(
                          label: "Claimed (${savings.completedItems.length})",
                          isSelected: _filter == _GoalFilter.claimed,
                          onTap: () =>
                              setState(() => _filter = _GoalFilter.claimed),
                        ),
                      ],
                    ),
                ],
              ),

              SizedBox(height: context.h(12)),

              // 4. Empty State or Goal Cards
              if (savings.wishlist.isEmpty)
                _EmptyGoalsCard(
                  dailySavings: dailySavings,
                  formatMoney: (amount) =>
                      forest.formatMoney(amount, langCode),
                  onCreateCustom: () => _openGoalSheet(context, forest),
                  onSelectPreset: (title, multiplierDays, iconKey) {
                    final suggestedCost = (dailySavings * multiplierDays)
                        .clamp(1000.0, 10000000.0)
                        .roundToDouble();
                    _openGoalSheet(
                      context,
                      forest,
                      presetTitle: title,
                      presetAmount: suggestedCost,
                      presetIconKey: iconKey,
                    );
                  },
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
                            ? "No claimed rewards yet"
                            : "No active goals right now",
                        style: AppTextStyle.bodySemiBold(context).copyWith(
                          color: AppColors.forestDeep,
                        ),
                      ),
                      SizedBox(height: context.h(4)),
                      Text(
                        _filter == _GoalFilter.claimed
                            ? "Once a goal reaches 100%, claim it to celebrate your milestone."
                            : "Add a new reward goal to keep your momentum going.",
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
                    onEdit: () => _openGoalSheet(
                      context,
                      forest,
                      existingItem: item,
                    ),
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
      crossAxisAlignment:
          alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
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

class _FilterChipPill extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChipPill({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: EdgeInsets.symmetric(
          horizontal: context.w(10),
          vertical: context.h(4),
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.forestDeep : AppColors.surfaceCardMuted,
          borderRadius: context.borderRadius(all: 50),
          border: Border.all(
            color: isSelected ? AppColors.forestDeep : AppColors.borderSubtle,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyle.captionSmall(context).copyWith(
            color: isSelected ? AppColors.baseWhite : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            fontSize: 11,
          ),
        ),
      ),
    );
  }
}

class _EmptyGoalsCard extends StatelessWidget {
  final double dailySavings;
  final String Function(num amount) formatMoney;
  final VoidCallback onCreateCustom;
  final void Function(String title, int multiplierDays, String iconKey)
      onSelectPreset;

  const _EmptyGoalsCard({
    required this.dailySavings,
    required this.formatMoney,
    required this.onCreateCustom,
    required this.onSelectPreset,
  });

  @override
  Widget build(BuildContext context) {
    final presets = [
      (title: 'Specialty Coffee', days: 3, iconKey: 'coffee', icon: LucideIcons.coffee),
      (title: 'Favorite Meal', days: 7, iconKey: 'utensils', icon: LucideIcons.utensils),
      (title: 'Wireless Earbuds', days: 14, iconKey: 'headphones', icon: LucideIcons.headphones),
      (title: 'Running Shoes', days: 30, iconKey: 'footprints', icon: LucideIcons.footprints),
    ];

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
            "Set your first reward goal",
            style: AppTextStyle.headingSmall(context).copyWith(
              color: AppColors.forestDeep,
            ),
          ),
          SizedBox(height: context.h(6)),
          Text(
            "Give your smoke-free savings a purpose. Pick something you'd love to buy for yourself and watch every day fund it.",
            textAlign: TextAlign.center,
            style: AppTextStyle.captionMedium(context),
          ),
          SizedBox(height: context.h(18)),

          // Quick starter ideas
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "QUICK IDEAS",
              style: AppTextStyle.captionSmall(context).copyWith(
                color: AppColors.textMuted,
                fontWeight: FontWeight.w700,
                fontSize: 10.5,
                letterSpacing: 0.8,
              ),
            ),
          ),
          SizedBox(height: context.h(8)),
          Wrap(
            spacing: context.w(8),
            runSpacing: context.h(8),
            children: presets.map((preset) {
              return InkWell(
                onTap: () => onSelectPreset(
                  preset.title,
                  preset.days,
                  preset.iconKey,
                ),
                borderRadius: context.borderRadius(all: 50),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.w(12),
                    vertical: context.h(7),
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceCardMuted,
                    borderRadius: context.borderRadius(all: 50),
                    border: Border.all(color: AppColors.borderSubtle),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        preset.icon,
                        size: context.w(13),
                        color: AppColors.forestPrimary,
                      ),
                      SizedBox(width: context.w(6)),
                      Text(
                        "${preset.title} (${preset.days}d)",
                        style: AppTextStyle.captionSmall(context).copyWith(
                          color: AppColors.forestDeep,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),

          SizedBox(height: context.h(20)),

          SizedBox(
            width: double.infinity,
            height: context.h(48),
            child: ElevatedButton.icon(
              onPressed: onCreateCustom,
              icon: Icon(LucideIcons.plus, size: context.w(16)),
              label: Text(
                "Create Custom Goal",
                style: AppTextStyle.bodySemiBold(context).copyWith(
                  color: AppColors.baseWhite,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.emerald,
                foregroundColor: AppColors.baseWhite,
                elevation: 0,
                shape: const StadiumBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
