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
import 'package:hpyat_mal/features/journal/_provider/journal_provider.dart';
import 'package:hpyat_mal/features/journal/_widget/wd_add_craving_bottom_sheet.dart';
import 'package:hpyat_mal/features/journal/_widget/wd_craving_log_card.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

enum _JournalFilter { all, slips }

class JournalScreen extends ConsumerStatefulWidget {
  const JournalScreen({super.key});

  @override
  ConsumerState<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends ConsumerState<JournalScreen> {
  _JournalFilter _filter = _JournalFilter.all;

  void _openEntrySheet(BuildContext context, {CravingLog? existingLog}) {
    HapticFeedback.selectionClick();
    showAppBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => AddCravingBottomSheetWidget(
        initialLog: existingLog,
        onSave: ({
          required String trigger,
          required int intensity,
          required bool resisted,
          required String note,
        }) {
          if (existingLog != null) {
            ref
                .read(journalProvider.notifier)
                .updateCravingLog(
                  existing: existingLog,
                  trigger: trigger,
                  intensity: intensity,
                  resisted: resisted,
                  note: note,
                );
          } else {
            ref
                .read(journalProvider.notifier)
                .addCravingLog(
                  trigger: trigger,
                  intensity: intensity,
                  resisted: resisted,
                  note: note,
                );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    EasyLocalization.of(context);
    final journal = ref.watch(journalProvider);
    final topTrigger = journal.triggerCounts.isEmpty
        ? LocaleKeys.journal_noneYet.tr()
        : CravingTriggerOption.localize(
            (journal.triggerCounts.entries.toList()
                  ..sort((a, b) => b.value.compareTo(a.value)))
                .first
                .key,
          );

    final filteredLogs = _filter == _JournalFilter.slips
        ? journal.slipLogs
        : journal.logs;

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
                          LocaleKeys.journal_title.tr(),
                          style: AppTextStyle.headingLarge(context).copyWith(
                            color: AppColors.forestPrimary,
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: context.h(2)),
                        Text(
                          LocaleKeys.journal_subtitle.tr(),
                          style: AppTextStyle.captionMedium(context),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: context.w(12)),
                  ElevatedButton(
                    onPressed: () => _openEntrySheet(context),
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
                          LocaleKeys.journal_logUrgeBtn.tr(),
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

              // 2. Solid House Feature Band Hero Card
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
                            LocaleKeys.journal_urgesResistedHeader.tr(),
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
                                LucideIcons.shieldCheck,
                                size: context.w(12),
                                color: AppColors.amberWarm,
                              ),
                              SizedBox(width: context.w(4)),
                              Text(
                                LocaleKeys.journal_beatenBadge.tr(
                                  args: [
                                    journal.resistedCount.toString(),
                                    journal.totalCravings.toString(),
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
                      "${journal.resistanceRate.toStringAsFixed(0)}%",
                      style: AppTextStyle.numberDisplay(context)
                          .copyWith(color: AppColors.baseWhite, fontSize: 32),
                    ),
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
                            child: _JournalHeroStat(
                              label: LocaleKeys.journal_topTrigger.tr(),
                              value: topTrigger,
                            ),
                          ),
                          VerticalDivider(
                            width: context.w(16),
                            thickness: 1,
                            color: AppColors.baseWhite.withValues(alpha: 0.14),
                          ),
                          Expanded(
                            child: _JournalHeroStat(
                              label: LocaleKeys.journal_resistedStat.tr(),
                              value: "${journal.resistedCount}",
                            ),
                          ),
                          VerticalDivider(
                            width: context.w(16),
                            thickness: 1,
                            color: AppColors.baseWhite.withValues(alpha: 0.14),
                          ),
                          Expanded(
                            child: _JournalHeroStat(
                              label: LocaleKeys.journal_slipsStat.tr(),
                              value: "${journal.slipCount}",
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

              // 3. Section Header + Sliding Switch Toggle (All | Slips)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      LocaleKeys.journal_recentEntries.tr(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.headingSmall(context)
                          .copyWith(color: AppColors.forestDeep),
                    ),
                  ),
                  if (journal.logs.isNotEmpty) ...[
                    SizedBox(width: context.w(8)),
                    _JournalSwitchToggle(
                      selectedFilter: _filter,
                      onChanged: (next) => setState(() => _filter = next),
                    ),
                  ],
                ],
              ),

              SizedBox(height: context.h(14)),

              // 4. Empty State or Log Cards
              if (journal.logs.isEmpty)
                Container(
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
                          LucideIcons.feather,
                          color: AppColors.forestPrimary,
                          size: context.w(24),
                        ),
                      ),
                      SizedBox(height: context.h(14)),
                      Text(
                        LocaleKeys.journal_emptyTitle.tr(),
                        textAlign: TextAlign.center,
                        style: AppTextStyle.headingSmall(context)
                            .copyWith(color: AppColors.forestDeep),
                      ),
                      SizedBox(height: context.h(6)),
                      Text(
                        LocaleKeys.journal_emptySubtitle.tr(),
                        textAlign: TextAlign.center,
                        style: AppTextStyle.captionMedium(context),
                      ),
                      SizedBox(height: context.h(20)),
                      SizedBox(
                        width: double.infinity,
                        height: context.h(48),
                        child: ElevatedButton(
                          onPressed: () => _openEntrySheet(context),
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
                                LocaleKeys.journal_logFirstUrgeBtn.tr(),
                                textHeightBehavior: const TextHeightBehavior(
                                  applyHeightToFirstAscent: false,
                                  applyHeightToLastDescent: false,
                                ),
                                style: AppTextStyle.bodySemiBold(context)
                                    .copyWith(
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
                )
              else if (filteredLogs.isEmpty)
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
                        LucideIcons.shieldCheck,
                        size: context.w(24),
                        color: AppColors.forestPrimary,
                      ),
                      SizedBox(height: context.h(8)),
                      Text(
                        LocaleKeys.journal_noSlipsTitle.tr(),
                        style: AppTextStyle.bodySemiBold(context)
                            .copyWith(color: AppColors.forestDeep),
                      ),
                      SizedBox(height: context.h(4)),
                      Text(
                        LocaleKeys.journal_noSlipsSubtitle.tr(),
                        textAlign: TextAlign.center,
                        style: AppTextStyle.captionMedium(context),
                      ),
                    ],
                  ),
                )
              else
                ...filteredLogs.map(
                  (log) => CravingLogCardWidget(
                    log: log,
                    onEdit: () => _openEntrySheet(context, existingLog: log),
                    onDelete: () => ref
                        .read(journalProvider.notifier)
                        .deleteCravingLog(log.id),
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

class _JournalHeroStat extends StatelessWidget {
  final String label;
  final String value;
  final bool alignEnd;

  const _JournalHeroStat({
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

class _JournalSwitchToggle extends StatelessWidget {
  final _JournalFilter selectedFilter;
  final ValueChanged<_JournalFilter> onChanged;

  const _JournalSwitchToggle({
    required this.selectedFilter,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isSlips = selectedFilter == _JournalFilter.slips;

    return Container(
      width: context.w(152),
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
            alignment: isSlips ? Alignment.centerRight : Alignment.centerLeft,
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
                    if (isSlips) {
                      HapticFeedback.selectionClick();
                      onChanged(_JournalFilter.all);
                    }
                  },
                  child: Center(
                    child: Text(
                      LocaleKeys.journal_tabAll.tr(),
                      textAlign: TextAlign.center,
                      textHeightBehavior: const TextHeightBehavior(
                        applyHeightToFirstAscent: false,
                        applyHeightToLastDescent: false,
                      ),
                      style: AppTextStyle.captionSmall(context).copyWith(
                        color: !isSlips
                            ? AppColors.baseWhite
                            : AppColors.textSecondary,
                        fontWeight:
                            !isSlips ? FontWeight.w700 : FontWeight.w600,
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
                    if (!isSlips) {
                      HapticFeedback.selectionClick();
                      onChanged(_JournalFilter.slips);
                    }
                  },
                  child: Center(
                    child: Text(
                      LocaleKeys.journal_tabSlips.tr(),
                      textAlign: TextAlign.center,
                      textHeightBehavior: const TextHeightBehavior(
                        applyHeightToFirstAscent: false,
                        applyHeightToLastDescent: false,
                      ),
                      style: AppTextStyle.captionSmall(context).copyWith(
                        color: isSlips
                            ? AppColors.baseWhite
                            : AppColors.textSecondary,
                        fontWeight: isSlips ? FontWeight.w700 : FontWeight.w600,
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
