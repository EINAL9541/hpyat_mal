import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:hpyat_mal/core/extensions/context_extensions.dart';
import 'package:hpyat_mal/core/theme/app_color.dart';
import 'package:hpyat_mal/core/theme/app_text_style.dart';
import 'package:hpyat_mal/features/journal/_provider/journal_provider.dart';
import 'package:hpyat_mal/features/journal/_widget/wd_add_craving_bottom_sheet.dart';
import 'package:hpyat_mal/features/journal/_widget/wd_craving_log_card.dart';

class JournalScreen extends ConsumerWidget {
  const JournalScreen({super.key});

  void _openAddSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddCravingBottomSheetWidget(
        onSave: ({
          required String trigger,
          required int intensity,
          required bool resisted,
          required String note,
        }) {
          ref.read(journalProvider.notifier).addCravingLog(
                trigger: trigger,
                intensity: intensity,
                resisted: resisted,
                note: note,
              );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final journal = ref.watch(journalProvider);
    final topTrigger = journal.triggerCounts.isEmpty
        ? "None yet"
        : (journal.triggerCounts.entries.toList()
              ..sort((a, b) => b.value.compareTo(a.value)))
            .first
            .key;

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
              // Header with 50px Full-Pill Primary CTA
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Craving Journal",
                          style: AppTextStyle.headingLarge(context).copyWith(
                            color: AppColors.forestPrimary,
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: context.h(2)),
                        Text(
                          "Spot your triggers and celebrate every win",
                          style: AppTextStyle.captionMedium(context),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: context.w(12)),
                  ElevatedButton.icon(
                    onPressed: () => _openAddSheet(context, ref),
                    icon: Icon(LucideIcons.plus, size: context.w(15)),
                    label: Text(
                      "Log Urge",
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

              // Unified Summary Card (12px White Card on Warm Cream Canvas)
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: context.w(16),
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "URGES RESISTED",
                              style: AppTextStyle.captionSmall(context).copyWith(
                                color: AppColors.textMuted,
                                fontWeight: FontWeight.w700,
                                fontSize: 10.5,
                                letterSpacing: 0.8,
                              ),
                            ),
                            SizedBox(height: context.h(4)),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  "${journal.resistanceRate.toStringAsFixed(0)}%",
                                  style:
                                      AppTextStyle.headingLarge(context).copyWith(
                                    color: AppColors.forestDeep,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(width: context.w(6)),
                                Flexible(
                                  child: Text(
                                    "(${journal.resistedCount}/${journal.totalCravings})",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextStyle.captionSmall(context)
                                        .copyWith(
                                      color: AppColors.emerald,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      VerticalDivider(
                        width: context.w(28),
                        thickness: 1,
                        color: AppColors.borderSubtle,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "MOST COMMON TRIGGER",
                              style: AppTextStyle.captionSmall(context).copyWith(
                                color: AppColors.textMuted,
                                fontWeight: FontWeight.w700,
                                fontSize: 10.5,
                                letterSpacing: 0.8,
                              ),
                            ),
                            SizedBox(height: context.h(6)),
                            Text(
                              topTrigger,
                              style:
                                  AppTextStyle.headingSmall(context).copyWith(
                                color: AppColors.forestDeep,
                                fontSize: 16,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: context.h(20)),

              Text(
                "RECENT ENTRIES",
                style: AppTextStyle.captionSmall(context).copyWith(
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.9,
                ),
              ),

              SizedBox(height: context.h(12)),

              if (journal.logs.isEmpty)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: context.w(20),
                    vertical: context.h(32),
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceCard,
                    borderRadius: context.borderRadius(all: 12),
                    border: Border.all(color: AppColors.borderSubtle),
                    boxShadow: AppColors.cardShadow,
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: context.w(52),
                        height: context.w(52),
                        decoration: BoxDecoration(
                          color: AppColors.leafSoft,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          LucideIcons.feather,
                          color: AppColors.forestPrimary,
                          size: context.w(22),
                        ),
                      ),
                      SizedBox(height: context.h(12)),
                      Text(
                        "No cravings logged yet",
                        style: AppTextStyle.bodySemiBold(context).copyWith(
                          color: AppColors.forestDeep,
                        ),
                      ),
                      SizedBox(height: context.h(4)),
                      Text(
                        "Whenever an urge hits, log it here to notice what triggers you most.",
                        textAlign: TextAlign.center,
                        style: AppTextStyle.captionMedium(context),
                      ),
                    ],
                  ),
                )
              else
                ...journal.logs.map((log) => CravingLogCardWidget(log: log)),

              SizedBox(height: context.h(24)),
            ],
          ),
        ),
      ),
    );
  }
}
