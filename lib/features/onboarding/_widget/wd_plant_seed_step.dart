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
          padding: EdgeInsets.symmetric(horizontal: context.w(24)),
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

                  // 2. Refined Hierarchy: Warm Name Pill + Bold Ready Heading
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.w(12),
                      vertical: context.h(4),
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.leafSoft,
                      borderRadius: context.borderRadius(all: 20),
                    ),
                    child: Text(
                      LocaleKeys.onboarding_readyGreeting
                          .tr(args: [displayName]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.captionMedium(context).copyWith(
                        color: AppColors.forestPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: 13.5,
                      ),
                    ),
                  ),
                  SizedBox(height: context.h(6)),
                  Text(
                    LocaleKeys.onboarding_readyToPlant.tr(),
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: AppTextStyle.headingLarge(context).copyWith(
                      color: AppColors.forestDeep,
                      fontSize: 25,
                      height: 1.4,
                    ),
                  ),

                  SizedBox(height: context.h(16)),

                  // 3. ONE HERO CARD: Yearly Savings (Estimated) + Divider + Daily | Monthly
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: context.w(20),
                      vertical: context.h(18),
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.forestDeep,
                          AppColors.forestPrimary,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: context.borderRadius(all: 22),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.forestDeep.withValues(alpha: 0.14),
                          blurRadius: 18,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          LocaleKeys.onboarding_yearlySaveCaption.tr(),
                          textAlign: TextAlign.center,
                          style: AppTextStyle.captionMedium(context).copyWith(
                            color: AppColors.leafSoft,
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
                          color: AppColors.baseWhite.withValues(alpha: 0.18),
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
                                  color: AppColors.leafSoft,
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
                                      .withValues(alpha: 0.35),
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

                  // 4. Quit Date Selector Pill ("Starting Today" vs "Quit Earlier")
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
                                  ? AppColors.leafSoft.withValues(alpha: 0.75)
                                  : AppColors.surfaceCard,
                              borderRadius: context.borderRadius(all: 14),
                              border: Border.all(
                                color: !isQuitEarlier
                                    ? AppColors.emerald
                                    : AppColors.border,
                                width: !isQuitEarlier ? 1.6 : 1.1,
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
                                  ? AppColors.leafSoft.withValues(alpha: 0.75)
                                  : AppColors.surfaceCard,
                              borderRadius: context.borderRadius(all: 14),
                              border: Border.all(
                                color: isQuitEarlier
                                    ? AppColors.emerald
                                    : AppColors.border,
                                width: isQuitEarlier ? 1.6 : 1.1,
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

                  SizedBox(height: context.h(18)),

                  // 5. Personal Reason Quote Block (Left accent bar, no box)
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          width: context.w(4),
                          decoration: BoxDecoration(
                            color: AppColors.emerald,
                            borderRadius: context.borderRadius(all: 4),
                          ),
                        ),
                        SizedBox(width: context.w(14)),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                LocaleKeys.onboarding_anchorReasonTitle.tr(),
                                style:
                                    AppTextStyle.captionMedium(context).copyWith(
                                  color: AppColors.forestPrimary,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                  height: 1.4,
                                ),
                              ),
                              SizedBox(height: context.h(3)),
                              Text(
                                effectiveWhy,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style:
                                    AppTextStyle.headingSmall(context).copyWith(
                                  color: AppColors.forestDeep,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16.5,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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

    // Circular medallion background adapting to Cherry vs Emerald
    final bgPaint = Paint()
      ..shader = LinearGradient(
        colors: isCherry
            ? const [
                Color(0xFFFDF0F5),
                Color(0xFFFCE4EE),
              ]
            : const [
                Color(0xFFF2F9F5),
                Color(0xFFD8F3DC),
              ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, bgPaint);

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = (isCherry
                ? const Color(0xFFFFB3C6)
                : const Color(0xFF74C69D))
            .withValues(alpha: 0.70)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4,
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
        ..color = const Color(0xFF5C4033)
        ..strokeWidth = 3.0
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke,
    );

    // Two green leaves at base of stem
    canvas.save();
    canvas.translate(center.dx - 7, center.dy + 6);
    canvas.rotate(-0.45);
    canvas.drawOval(
      Rect.fromCenter(center: Offset.zero, width: 12, height: 6.5),
      Paint()..color = const Color(0xFF40916C),
    );
    canvas.restore();

    canvas.save();
    canvas.translate(center.dx + 7, center.dy + 3);
    canvas.rotate(0.45);
    canvas.drawOval(
      Rect.fromCenter(center: Offset.zero, width: 12, height: 6.5),
      Paint()..color = const Color(0xFF52B788),
    );
    canvas.restore();

    // Crown at top of medallion (5-petal Sakura vs Radiant Emerald Crown)
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
        Paint()
          ..color = isCherry
              ? const Color(0xFFFF85A1)
              : const Color(0xFF40916C),
      );
      canvas.restore();
    }
    canvas.drawCircle(
      flowerCenter,
      2.6,
      Paint()
        ..color = isCherry
            ? const Color(0xFFD84B78)
            : const Color(0xFF1B4D3E),
    );
    canvas.drawCircle(
      flowerCenter,
      1.3,
      Paint()..color = const Color(0xFFFFD166),
    );
  }

  @override
  bool shouldRepaint(covariant _SakuraMedallionPainter oldDelegate) =>
      oldDelegate.isCherry != isCherry;
}
