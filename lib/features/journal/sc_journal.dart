import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
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
                        "Craving Journal",
                        style: AppTextStyle.headingMedium(context).copyWith(
                          color: AppColors.forestDeep,
                        ),
                      ),
                      SizedBox(height: context.h(2)),
                      Text(
                        "Track triggers & celebrate every urge conquered",
                        style: AppTextStyle.captionMedium(context),
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _openAddSheet(context, ref),
                    icon: Icon(LucideIcons.plus, size: context.w(15)),
                    label: Text(
                      "Log",
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

              // Stats Row
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(context.w(14)),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceCard,
                        borderRadius: context.borderRadius(all: 16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Resistance Rate",
                            style: AppTextStyle.captionSmall(context),
                          ),
                          SizedBox(height: context.h(4)),
                          Text(
                            "${journal.resistanceRate.toStringAsFixed(0)}%",
                            style: AppTextStyle.headingLarge(context).copyWith(
                              color: AppColors.forestPrimary,
                            ),
                          ),
                          SizedBox(height: context.h(2)),
                          Text(
                            "${journal.resistedCount} of ${journal.totalCravings} beaten",
                            style: AppTextStyle.captionSmall(context).copyWith(
                              color: AppColors.emerald,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: context.w(10)),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(context.w(14)),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceCard,
                        borderRadius: context.borderRadius(all: 16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Top Trigger",
                            style: AppTextStyle.captionSmall(context),
                          ),
                          SizedBox(height: context.h(4)),
                          Text(
                            journal.triggerCounts.isEmpty
                                ? "None"
                                : (journal.triggerCounts.entries.toList()
                                      ..sort((a, b) =>
                                          b.value.compareTo(a.value)))
                                    .first
                                    .key,
                            style: AppTextStyle.headingSmall(context).copyWith(
                              color: AppColors.forestDeep,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: context.h(2)),
                          Text(
                            "Know your danger zone",
                            style: AppTextStyle.captionSmall(context),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: context.h(20)),

              Text(
                "Craving History",
                style: AppTextStyle.headingSmall(context).copyWith(
                  color: AppColors.forestDeep,
                  fontSize: 16,
                ),
              ),

              SizedBox(height: context.h(10)),

              if (journal.logs.isEmpty)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(context.w(24)),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceCard,
                    borderRadius: context.borderRadius(all: 16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        const Text("📝", style: TextStyle(fontSize: 32)),
                        SizedBox(height: context.h(8)),
                        Text(
                          "No cravings logged yet",
                          style: AppTextStyle.bodySemiBold(context),
                        ),
                        SizedBox(height: context.h(4)),
                        Text(
                          "Log whenever you feel an urge to see your patterns over time.",
                          textAlign: TextAlign.center,
                          style: AppTextStyle.captionMedium(context),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ...journal.logs.map((log) => CravingLogCardWidget(log: log)),

              SizedBox(height: context.h(85)),
            ],
          ),
        ),
      ),
    );
  }
}
