import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hpyat_mal/core/extensions/context_extensions.dart';
import 'package:hpyat_mal/core/router/app_router_key.dart';
import 'package:hpyat_mal/core/theme/app_color.dart';
import 'package:hpyat_mal/features/forest/_provider/forest_provider.dart';
import 'package:hpyat_mal/features/forest/_widget/wd_forest_canvas.dart';
import 'package:hpyat_mal/features/forest/_widget/wd_forest_header.dart';
import 'package:hpyat_mal/features/forest/_widget/wd_forest_quick_stats.dart';
import 'package:hpyat_mal/features/forest/_widget/wd_motivation_anchor_card.dart';

class ForestScreen extends ConsumerWidget {
  const ForestScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    EasyLocalization.of(context);
    final forest = ref.watch(forestProvider);
    final now = ref.watch(liveNowProvider);
    final langCode = context.locale.languageCode;
    final liveMoneySaved = forest.moneySavedAt(now);

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
              // 1. Header with Greeting, Sanctuary Subtitle, and Settings Button
              ForestHeaderWidget(
                userName: forest.userName,
                vitality: forest.forestVitality,
                plantTheme: forest.plantTheme,
                onOpenSettings: () => context.push(RouteKeys.settings.path),
              ),

              SizedBox(height: context.h(16)),

              // 2. Animated Sanctuary Canvas (focal point right at the top)
              ForestCanvasWidget(
                days: forest.smokeFreeDurationAt(now).inDays,
                vitality: forest.forestVitality,
                plantTheme: forest.plantTheme,
              ),

              SizedBox(height: context.h(16)),

              // 3. Solid House Feature Band (#1E3932 / #381824): Live Timer + 3 Stats
              ForestQuickStatsWidget(
                quitDate: forest.quitDate,
                cigarettesAvoided: forest.cigarettesAvoidedAt(now),
                moneySaved: liveMoneySaved,
                lifeRegainedHours: forest.lifeRegainedHoursAt(now),
                formattedMoney: forest.formatMoney(liveMoneySaved, langCode),
                currencyUnit: forest.currencyUnit(langCode),
              ),

              SizedBox(height: context.h(14)),

              // 4. Personal Promise Ceremony Card (#FAF6EE Gold Lightest + #CBA258 Gold)
              MotivationAnchorCardWidget(
                userName: forest.userName,
                quitReason: forest.quitReason,
                onUpdateReason: (newReason) {
                  ref.read(forestProvider.notifier).updateQuitReason(newReason);
                },
              ),

              SizedBox(height: context.h(32)),
            ],
          ),
        ),
      ),
    );
  }
}
