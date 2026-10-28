import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:hpyat_mal/core/extensions/context_extensions.dart';
import 'package:hpyat_mal/core/theme/app_color.dart';
import 'package:hpyat_mal/core/theme/app_text_style.dart';
import 'package:hpyat_mal/features/forest/_provider/forest_provider.dart';
import 'package:hpyat_mal/features/savings/_provider/savings_provider.dart';
import 'package:hpyat_mal/features/savings/_widget/wd_add_wishlist_dialog.dart';
import 'package:hpyat_mal/features/savings/_widget/wd_wishlist_card.dart';

class SavingsScreen extends ConsumerWidget {
  const SavingsScreen({super.key});

  void _showAddDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (_) => AddWishlistDialogWidget(
        onAdd: (title, targetAmount, iconKey) {
          ref.read(savingsProvider.notifier).addWishlistItem(
                title: title,
                targetAmount: targetAmount,
                iconKey: iconKey,
              );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final forest = ref.watch(forestProvider);
    final savings = ref.watch(savingsProvider);

    final yearlySavings = (forest.cigsPerDay / forest.cigsPerPack) *
        forest.packCost *
        365.0;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: context.w(18),
            vertical: context.h(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Money Saved",
                        style: AppTextStyle.headingMedium(context).copyWith(
                          color: AppColors.forestDeep,
                        ),
                      ),
                      SizedBox(height: context.h(2)),
                      Text(
                        "Realized cash staying in your pocket",
                        style: AppTextStyle.captionMedium(context),
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _showAddDialog(context, ref),
                    icon: Icon(LucideIcons.plus, size: context.w(15)),
                    label: Text(
                      "Add Goal",
                      style: AppTextStyle.bodySemiBold(context).copyWith(
                        color: AppColors.baseWhite,
                        fontSize: 13,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.forestPrimary,
                      foregroundColor: AppColors.baseWhite,
                      padding: EdgeInsets.symmetric(
                        horizontal: context.w(12),
                        vertical: context.h(8),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: context.borderRadius(all: 12),
                      ),
                      elevation: 0,
                    ),
                  ),
                ],
              ),

              SizedBox(height: context.h(16)),

              // Grand Total Hero Card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(context.w(20)),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF0F3D2C),
                      Color(0xFF1B5E43),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: context.borderRadius(all: 24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.forestDeep.withValues(alpha: 0.16),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total Saved To Date",
                          style: AppTextStyle.captionMedium(context).copyWith(
                            color: AppColors.leafSoft,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: context.w(8),
                            vertical: context.h(3),
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.baseWhite.withValues(alpha: 0.15),
                            borderRadius: context.borderRadius(all: 8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                LucideIcons.trendingUp,
                                size: context.w(12),
                                color: AppColors.mintAccent,
                              ),
                              SizedBox(width: context.w(4)),
                              Text(
                                "+${forest.formatMoney((forest.cigsPerDay / forest.cigsPerPack) * forest.packCost, context.locale.languageCode)}/day",
                                style: AppTextStyle.captionSmall(context).copyWith(
                                  color: AppColors.mintAccent,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: context.h(6)),
                    Text(
                      forest.formatMoney(forest.moneySaved, context.locale.languageCode),
                      style: AppTextStyle.numberDisplay(context).copyWith(
                        color: AppColors.baseWhite,
                      ),
                    ),
                    SizedBox(height: context.h(14)),
                    Divider(color: AppColors.baseWhite.withValues(alpha: 0.15)),
                    SizedBox(height: context.h(10)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Yearly Projection",
                              style: AppTextStyle.captionSmall(context).copyWith(
                                color: AppColors.leafSoft,
                              ),
                            ),
                            SizedBox(height: context.h(2)),
                            Text(
                              "${forest.formatMoney(yearlySavings, context.locale.languageCode)} / yr",
                              style: AppTextStyle.bodySemiBold(context).copyWith(
                                color: AppColors.baseWhite,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "Packs Avoided",
                              style: AppTextStyle.captionSmall(context).copyWith(
                                color: AppColors.leafSoft,
                              ),
                            ),
                            SizedBox(height: context.h(2)),
                            Text(
                              "${(forest.cigarettesAvoided / forest.cigsPerPack).toStringAsFixed(1)} packs",
                              style: AppTextStyle.bodySemiBold(context).copyWith(
                                color: AppColors.baseWhite,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: context.h(20)),

              Text(
                "Reward Wishlist",
                style: AppTextStyle.headingSmall(context).copyWith(
                  color: AppColors.forestDeep,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: context.h(4)),
              Text(
                "Celebrate your milestones with gifts you buy using your savings.",
                style: AppTextStyle.captionMedium(context),
              ),

              SizedBox(height: context.h(12)),

              ...savings.wishlist.map(
                (item) => WishlistCardWidget(
                  item: item,
                  currentSavings: forest.moneySaved,
                  formatMoney: (amount) => forest.formatMoney(
                    amount,
                    context.locale.languageCode,
                  ),
                  onToggle: () =>
                      ref.read(savingsProvider.notifier).toggleItem(item.id),
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
