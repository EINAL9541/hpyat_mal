import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hpyat_mal/core/extensions/context_extensions.dart';
import 'package:hpyat_mal/core/router/app_router_key.dart';
import 'package:hpyat_mal/core/theme/app_color.dart';
import 'package:hpyat_mal/features/forest/_provider/forest_provider.dart';
import 'package:hpyat_mal/features/forest/_widget/wd_daily_nourish_card.dart';
import 'package:hpyat_mal/features/forest/_widget/wd_forest_canvas.dart';
import 'package:hpyat_mal/features/forest/_widget/wd_forest_header.dart';
import 'package:hpyat_mal/features/forest/_widget/wd_forest_quick_stats.dart';
import 'package:hpyat_mal/features/forest/_widget/wd_motivation_anchor_card.dart';
import 'package:hpyat_mal/features/forest/_widget/wd_streak_counter.dart';

class ForestScreen extends ConsumerWidget {
  const ForestScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final forest = ref.watch(forestProvider);

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
              // 1. Header with "Hi, Name", Vitality, and Settings Button on the right
              ForestHeaderWidget(
                userName: forest.userName,
                vitality: forest.forestVitality,
                plantTheme: forest.plantTheme,
                onOpenSettings: () => context.push(RouteKeys.settings.path),
              ),

              SizedBox(height: context.h(14)),

              // 2. The Personal "Why" Anchor Card (Always visible for motivation)
              MotivationAnchorCardWidget(
                userName: forest.userName,
                quitReason: forest.quitReason,
                onUpdateReason: (newReason) {
                  ref.read(forestProvider.notifier).updateQuitReason(newReason);
                },
              ),

              SizedBox(height: context.h(14)),

              // 3. Animated Forest Canvas (adapts to Emerald Tree vs Cherry Blossom Tree)
              ForestCanvasWidget(
                days: forest.days,
                vitality: forest.forestVitality,
                plantTheme: forest.plantTheme,
              ),

              SizedBox(height: context.h(14)),

              // 4. Smoke-Free Streak Countdown
              StreakCounterWidget(
                quitDate: forest.quitDate,
                stageName: forest.stageName,
                stageDescription: forest.stageDescription,
              ),

              SizedBox(height: context.h(14)),

              // 5. Quick Recovery Metrics Row
              ForestQuickStatsWidget(
                cigarettesAvoided: forest.cigarettesAvoided,
                moneySaved: forest.moneySaved,
                lifeRegainedHours: forest.lifeRegainedHours,
                formattedMoney: forest.formatMoney(
                  forest.moneySaved,
                  context.locale.languageCode,
                ),
                currencyUnit: forest.currencyUnit(context.locale.languageCode),
              ),

              SizedBox(height: context.h(14)),

              // 6. SOS Emergency Craving Card
              const DailyNourishCardWidget(),

              SizedBox(height: context.h(85)), // Bottom bar clearance
            ],
          ),
        ),
      ),
    );
  }
}
