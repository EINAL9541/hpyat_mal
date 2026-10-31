import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hpyat_mal/core/extensions/context_extensions.dart';
import 'package:hpyat_mal/core/generate/locale_keys.g.dart';
import 'package:hpyat_mal/core/theme/app_color.dart';
import 'package:hpyat_mal/core/theme/app_text_style.dart';
import 'package:hpyat_mal/features/forest/_provider/forest_provider.dart';
import 'package:hpyat_mal/features/health/_provider/health_provider.dart';
import 'package:hpyat_mal/features/health/_widget/wd_health_milestone_card.dart';

class HealthScreen extends ConsumerWidget {
  const HealthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    EasyLocalization.of(context);
    final forest = ref.watch(forestProvider);
    final now = ref.watch(liveNowProvider);
    final milestones = ref.watch(healthMilestonesProvider);
    final smokeFreeDuration = forest.smokeFreeDurationAt(now);
    final langCode = context.locale.languageCode;

    final completedCount = milestones
        .where((m) => m.isCompleted(smokeFreeDuration))
        .length;
    final remainingCount = milestones.length - completedCount;

    HealthMilestone? nextMilestone;
    for (final m in milestones) {
      if (!m.isCompleted(smokeFreeDuration)) {
        nextMilestone = m;
        break;
      }
    }

    final stageProgress = nextMilestone?.progress(smokeFreeDuration) ?? 0.0;
    final overallRatio = milestones.isEmpty
        ? 0.0
        : ((completedCount + stageProgress) / milestones.length).clamp(
            0.0,
            1.0,
          );
    final overallPercent = (overallRatio * 100).round();

    final nextEta = nextMilestone != null
        ? nextMilestone.formatEta(
            quitDate: forest.quitDate,
            now: now,
            localeCode: langCode,
          )
        : LocaleKeys.health_statAllDone.tr();

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
              // 1. Page Header
              Text(
                LocaleKeys.health_title.tr(),
                style: AppTextStyle.headingLarge(context).copyWith(
                  color: AppColors.forestPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: context.h(2)),
              Text(
                LocaleKeys.health_subtitle.tr(),
                style: AppTextStyle.captionMedium(context),
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
                    Text(
                      LocaleKeys.health_heroEyebrow.tr(),
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
                    SizedBox(height: context.h(8)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '$overallPercent%',
                          style: AppTextStyle.numberDisplay(context).copyWith(
                            color: AppColors.baseWhite,
                            fontSize: 32,
                          ),
                        ),
                        SizedBox(
                          width: context.w(108),
                          height: context.h(32),
                          child: CustomPaint(
                            painter: _EcgPulsePainter(
                              lineColor: AppColors.leafSoft.withValues(
                                alpha: 0.85,
                              ),
                            ),
                          ),
                        ),
                      ],
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
                            child: _HealthHeroStat(
                              label: LocaleKeys.health_statHealed.tr(),
                              value: '$completedCount / ${milestones.length}',
                            ),
                          ),
                          VerticalDivider(
                            width: context.w(16),
                            thickness: 1,
                            color: AppColors.baseWhite.withValues(alpha: 0.14),
                          ),
                          Expanded(
                            child: _HealthHeroStat(
                              label: LocaleKeys.health_statNextGoal.tr(),
                              value: nextEta,
                            ),
                          ),
                          VerticalDivider(
                            width: context.w(16),
                            thickness: 1,
                            color: AppColors.baseWhite.withValues(alpha: 0.14),
                          ),
                          Expanded(
                            child: _HealthHeroStat(
                              label: LocaleKeys.health_statRemaining.tr(),
                              value: '$remainingCount',
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

              // 3. Section Header
              Text(
                LocaleKeys.health_sectionTitle.tr(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyle.headingSmall(context)
                    .copyWith(color: AppColors.forestDeep),
              ),

              SizedBox(height: context.h(14)),

              // 4. Individual White Milestone Cards on Warm Cream Canvas
              ...milestones.map(
                (milestone) => HealthMilestoneCardWidget(
                  milestone: milestone,
                  quitDate: forest.quitDate,
                  now: now,
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

class _HealthHeroStat extends StatelessWidget {
  final String label;
  final String value;
  final bool alignEnd;

  const _HealthHeroStat({
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

class _EcgPulsePainter extends CustomPainter {
  final Color lineColor;

  const _EcgPulsePainter({required this.lineColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final midY = size.height * 0.55;
    final w = size.width;

    final path = Path()
      ..moveTo(0, midY)
      ..lineTo(w * 0.30, midY)
      ..lineTo(w * 0.36, midY - size.height * 0.14)
      ..lineTo(w * 0.42, midY + size.height * 0.18)
      ..lineTo(w * 0.49, size.height * 0.08)
      ..lineTo(w * 0.56, size.height * 0.92)
      ..lineTo(w * 0.62, midY - size.height * 0.24)
      ..lineTo(w * 0.68, midY)
      ..lineTo(w, midY);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _EcgPulsePainter oldDelegate) {
    return oldDelegate.lineColor != lineColor;
  }
}
