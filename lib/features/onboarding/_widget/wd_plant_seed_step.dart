import 'dart:math' as math;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hpyat_mal/core/extensions/context_extensions.dart';
import 'package:hpyat_mal/core/generate/locale_keys.g.dart';
import 'package:hpyat_mal/core/theme/app_color.dart';
import 'package:hpyat_mal/core/theme/app_text_style.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class PlantSeedStepWidget extends StatelessWidget {
  final String displayName;
  final int cigsPerDay;
  final int cigsPerPack;
  final double packCost;
  final String effectiveWhy;
  final ValueNotifier<DateTime?> customQuitDate;
  final PlantThemeType plantTheme;

  const PlantSeedStepWidget({
    super.key,
    required this.displayName,
    required this.cigsPerDay,
    required this.cigsPerPack,
    required this.packCost,
    required this.effectiveWhy,
    required this.customQuitDate,
    required this.plantTheme,
  });

  String _formatKyat(num amount) {
    return NumberFormat('#,###').format(amount.round());
  }

  String _formatRoundedYearlyEstimate(double rawYearly) {
    if (rawYearly >= 10000) {
      final rounded = (rawYearly / 1000).round() * 1000;
      return NumberFormat('#,###').format(rounded);
    }
    if (rawYearly >= 1000) {
      final rounded = (rawYearly / 100).round() * 100;
      return NumberFormat('#,###').format(rounded);
    }
    return NumberFormat('#,###').format(rawYearly.round());
  }

  @override
  Widget build(BuildContext context) {
    final dailySpend = (cigsPerDay / cigsPerPack) * packCost;
    final monthlySpend = dailySpend * 30.0;
    final yearlySavings = dailySpend * 365.0;

    final isQuitEarlier = customQuitDate.value != null;
    final formattedQuitDate = customQuitDate.value != null
        ? DateFormat('MMM d, yyyy').format(customQuitDate.value!)
        : null;

    Future<void> pickPastQuitDate() async {
      final now = DateTime.now();
      final picked = await showDatePicker(
        context: context,
        initialDate:
            customQuitDate.value ?? now.subtract(const Duration(days: 1)),
        firstDate: DateTime(2020),
        lastDate: now,
        builder: (ctx, child) {
          return Theme(
            data: Theme.of(ctx).copyWith(
              colorScheme: ColorScheme.light(
                primary: AppColors.forestPrimary,
                onPrimary: AppColors.baseWhite,
                onSurface: AppColors.textPrimary,
              ),
            ),
            child: child!,
          );
        },
      );
      if (picked != null) {
        customQuitDate.value = DateTime(
          picked.year,
          picked.month,
          picked.day,
          now.hour,
          now.minute,
        );
      }
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: context.w(20)),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(),

                  // 1. Hand-Crafted Sanctuary Sapling Medallion (~64 px)
                  SizedBox(
                    width: context.w(64),
                    height: context.h(64),
                    child: CustomPaint(
                      painter: _SakuraMedallionPainter(
                        isCherry: plantTheme.isCherry,
                      ),
                    ),
                  ),

                  SizedBox(height: context.h(12)),

                  // 2. Refined Hierarchy: 50px Gold-Outlined Pill + Bold Ready Heading
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.w(12),
                      vertical: context.h(4),
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.amberLight,
                      borderRadius: context.borderRadius(all: 50),
                      border: Border.all(color: AppColors.amberWarm),
                    ),
                    child: Text(
                      "★ ${LocaleKeys.onboarding_readyGreeting.tr(args: [displayName])}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.captionMedium(context).copyWith(
                        color: AppColors.forestDeep,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  SizedBox(height: context.h(8)),
                  Text(
                    LocaleKeys.onboarding_readyToPlant.tr(),
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: AppTextStyle.headingLarge(context).copyWith(
                      color: AppColors.forestPrimary,
                      fontSize: 24,
                      height: 1.4,
                    ),
                  ),

                  SizedBox(height: context.h(16)),

                  // 3. Solid House Band Hero Card (#1E3932 / #381824 — No Gradients)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: context.w(20),
                      vertical: context.h(18),
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.forestDeep,
                      borderRadius: context.borderRadius(all: 16),
                      boxShadow: AppColors.cardShadow,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          LocaleKeys.onboarding_yearlySaveCaption.tr(),
                          textAlign: TextAlign.center,
                          style: AppTextStyle.captionMedium(context).copyWith(
                            color: AppColors.baseWhite.withValues(alpha: 0.72),
                            fontWeight: FontWeight.w600,
                            fontSize: 13.5,
                            height: 1.4,
                          ),
                        ),
                        SizedBox(height: context.h(6)),
                        Text(
                          LocaleKeys.onboarding_yearlySaveAmount.tr(
                            args: [_formatRoundedYearlyEstimate(yearlySavings)],
                          ),
                          textAlign: TextAlign.center,
                          style: AppTextStyle.display(context).copyWith(
                            color: AppColors.baseWhite,
                            fontSize: 31,
                            fontWeight: FontWeight.w800,
                            height: 1.3,
                          ),
                        ),
                        SizedBox(height: context.h(12)),
                        Divider(
                          height: 1,
                          thickness: 1,
                          color: AppColors.baseWhite.withValues(alpha: 0.14),
                        ),
                        SizedBox(height: context.h(10)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text(
                                LocaleKeys.onboarding_dailySpendPreview
                                    .tr(args: [_formatKyat(dailySpend)]),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style:
                                    AppTextStyle.bodySemiBold(context).copyWith(
                                  color: AppColors.amberWarm,
                                  fontSize: 13.5,
                                  height: 1.4,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: context.w(12),
                              ),
                              child: Text(
                                "|",
                                style: TextStyle(
                                  color: AppColors.baseWhite
                                      .withValues(alpha: 0.30),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Flexible(
                              child: Text(
                                LocaleKeys.onboarding_monthlySpendPreview
                                    .tr(args: [_formatKyat(monthlySpend)]),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style:
                                    AppTextStyle.bodySemiBold(context).copyWith(
                                  color: AppColors.leafSoft,
                                  fontSize: 13.5,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: context.h(16)),

                  // 4. Quit Date Selector Pills (50px Full-Pill Options with 2px Active Ring)
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            HapticFeedback.selectionClick();
                            customQuitDate.value = null;
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            padding: EdgeInsets.symmetric(
                              horizontal: context.w(12),
                              vertical: context.h(10),
                            ),
                            decoration: BoxDecoration(
                              color: !isQuitEarlier
                                  ? AppColors.leafSoft
                                  : AppColors.surfaceCard,
                              borderRadius: context.borderRadius(all: 50),
                              border: Border.all(
                                color: !isQuitEarlier
                                    ? AppColors.emerald
                                    : AppColors.border,
                                width: !isQuitEarlier ? 2.0 : 1.0,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  LucideIcons.sparkles,
                                  size: context.w(15),
                                  color: !isQuitEarlier
                                      ? AppColors.forestPrimary
                                      : AppColors.textSecondary,
                                ),
                                SizedBox(width: context.w(6)),
                                Flexible(
                                  child: Text(
                                    LocaleKeys.onboarding_quitStartNow.tr(),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextStyle.captionMedium(context)
                                        .copyWith(
                                      color: !isQuitEarlier
                                          ? AppColors.forestDeep
                                          : AppColors.textSecondary,
                                      fontWeight: !isQuitEarlier
                                          ? FontWeight.w700
                                          : FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: context.w(10)),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            HapticFeedback.selectionClick();
                            pickPastQuitDate();
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            padding: EdgeInsets.symmetric(
                              horizontal: context.w(12),
                              vertical: context.h(10),
                            ),
                            decoration: BoxDecoration(
                              color: isQuitEarlier
                                  ? AppColors.leafSoft
                                  : AppColors.surfaceCard,
                              borderRadius: context.borderRadius(all: 50),
                              border: Border.all(
                                color: isQuitEarlier
                                    ? AppColors.emerald
                                    : AppColors.border,
                                width: isQuitEarlier ? 2.0 : 1.0,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  LucideIcons.calendarDays,
                                  size: context.w(15),
                                  color: isQuitEarlier
                                      ? AppColors.forestPrimary
                                      : AppColors.textSecondary,
                                ),
                                SizedBox(width: context.w(6)),
                                Flexible(
                                  child: Text(
                                    formattedQuitDate ??
                                        LocaleKeys.onboarding_quitStartEarlier
                                            .tr(),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextStyle.captionMedium(context)
                                        .copyWith(
                                      color: isQuitEarlier
                                          ? AppColors.forestDeep
                                          : AppColors.textSecondary,
                                      fontWeight: isQuitEarlier
                                          ? FontWeight.w700
                                          : FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: context.h(16)),

                  // 5. Gold Ceremony Promise Card (#FAF6EE Gold Lightest + #CBA258 Gold)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: context.w(14),
                      vertical: context.h(12),
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.amberLight,
                      borderRadius: context.borderRadius(all: 12),
                      border: Border.all(color: AppColors.skySoft),
                    ),
                    child: IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            width: context.w(3.5),
                            decoration: BoxDecoration(
                              color: AppColors.amberWarm,
                              borderRadius: context.borderRadius(all: 4),
                            ),
                          ),
                          SizedBox(width: context.w(12)),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "★ ${LocaleKeys.onboarding_anchorReasonTitle.tr()}",
                                  style: AppTextStyle.captionMedium(context)
                                      .copyWith(
                                    color: AppColors.forestDeep,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12.5,
                                    height: 1.4,
                                  ),
                                ),
                                SizedBox(height: context.h(3)),
                                Text(
                                  effectiveWhy,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyle.headingSmall(context)
                                      .copyWith(
                                    color: AppColors.forestDeep,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15.5,
                                    height: 1.45,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const Spacer(),
                  SizedBox(height: context.h(14)),

                  // 6. Short Centered Privacy Line Just Above the Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        LucideIcons.shieldCheck,
                        size: context.w(16),
                        color: AppColors.forestPrimary,
                      ),
                      SizedBox(width: context.w(6)),
                      Flexible(
                        child: Text(
                          LocaleKeys.onboarding_privacyNote.tr(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: AppTextStyle.captionMedium(context).copyWith(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: context.h(4)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SakuraMedallionPainter extends CustomPainter {
  final bool isCherry;

  const _SakuraMedallionPainter({required this.isCherry});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.5, size.height * 0.5);
    final radius = size.width * 0.48;

    // Solid Botanical Medallion Background (Starbucks Green Light / Sakura Light)
    final bgPaint = Paint()..color = AppColors.leafSoft;
    canvas.drawCircle(center, radius, bgPaint);

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = AppColors.emerald
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6,
    );

    // Mini curved sapling stem
    final stemPath = Path()
      ..moveTo(center.dx, center.dy + radius * 0.55)
      ..quadraticBezierTo(
        center.dx - 4,
        center.dy + 4,
        center.dx,
        center.dy - radius * 0.22,
      );
    canvas.drawPath(
      stemPath,
      Paint()
        ..color = AppColors.barkBrown
        ..strokeWidth = 3.0
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke,
    );

    // Two botanical leaves at base of stem
    canvas.save();
    canvas.translate(center.dx - 7, center.dy + 6);
    canvas.rotate(-0.45);
    canvas.drawOval(
      Rect.fromCenter(center: Offset.zero, width: 12, height: 6.5),
      Paint()..color = AppColors.forestPrimary,
    );
    canvas.restore();

    canvas.save();
    canvas.translate(center.dx + 7, center.dy + 3);
    canvas.rotate(0.45);
    canvas.drawOval(
      Rect.fromCenter(center: Offset.zero, width: 12, height: 6.5),
      Paint()..color = AppColors.emerald,
    );
    canvas.restore();

    // Crown at top of medallion
    final flowerCenter = Offset(center.dx, center.dy - radius * 0.25);
    const flowerR = 11.5;
    for (int i = 0; i < 5; i++) {
      canvas.save();
      canvas.translate(flowerCenter.dx, flowerCenter.dy);
      canvas.rotate(i * (math.pi * 2 / 5));
      final petal = Path()
        ..moveTo(0, 0)
        ..quadraticBezierTo(
          -flowerR * 0.55,
          -flowerR * 0.55,
          -flowerR * 0.22,
          -flowerR,
        )
        ..lineTo(0, -flowerR * 0.76)
        ..lineTo(flowerR * 0.22, -flowerR)
        ..quadraticBezierTo(flowerR * 0.55, -flowerR * 0.55, 0, 0)
        ..close();
      canvas.drawPath(
        petal,
        Paint()..color = AppColors.emerald,
      );
      canvas.restore();
    }
    canvas.drawCircle(
      flowerCenter,
      2.6,
      Paint()..color = AppColors.forestDeep,
    );
    canvas.drawCircle(
      flowerCenter,
      1.3,
      Paint()..color = AppColors.amberWarm,
    );
  }

  @override
  bool shouldRepaint(covariant _SakuraMedallionPainter oldDelegate) =>
      oldDelegate.isCherry != isCherry;
}
