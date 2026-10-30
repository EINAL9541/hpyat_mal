import 'dart:math' as math;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:hpyat_mal/core/extensions/context_extensions.dart';
import 'package:hpyat_mal/core/generate/locale_keys.g.dart';
import 'package:hpyat_mal/core/theme/app_color.dart';
import 'package:hpyat_mal/core/theme/app_text_style.dart';
import 'package:hpyat_mal/core/ui/widgets/wd_text_field.dart';

class NameStepWidget extends StatelessWidget {
  final TextEditingController controller;
  final PlantThemeType selectedPlant;
  final ValueChanged<PlantThemeType> onPlantChanged;

  const NameStepWidget({
    super.key,
    required this.controller,
    required this.selectedPlant,
    required this.onPlantChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isCherry = selectedPlant.isCherry;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: context.w(20)),
      child: ValueListenableBuilder<TextEditingValue>(
        valueListenable: controller,
        builder: (context, value, _) {
          final trimmed = value.text.trim();
          final hasName = trimmed.isNotEmpty;
          // 0.0 when empty -> 1.0 as user types 1..4 chars
          final bloomProgress = (trimmed.length / 4.0).clamp(0.0, 1.0);

          final activeSanctuaryLabel = isCherry
              ? LocaleKeys.onboarding_sanctuaryActiveCherry.tr(args: [trimmed])
              : LocaleKeys.onboarding_sanctuaryActiveEmerald
                  .tr(args: [trimmed]);

          final idleSanctuaryLabel = isCherry
              ? LocaleKeys.onboarding_sanctuaryIdleCherry.tr()
              : LocaleKeys.onboarding_sanctuaryIdleEmerald.tr();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: context.h(12)),

              // Bespoke Living Seedling Canvas Banner (12px Card Radius, 2px Active Ring)
              TweenAnimationBuilder<double>(
                tween: Tween<double>(
                  begin: 0.0,
                  end: hasName ? (0.35 + 0.65 * bloomProgress) : 0.0,
                ),
                duration: const Duration(milliseconds: 420),
                curve: Curves.easeOutBack,
                builder: (context, animValue, _) {
                  return Container(
                    width: double.infinity,
                    height: context.h(136),
                    decoration: BoxDecoration(
                      borderRadius: context.borderRadius(all: 12),
                      border: Border.all(
                        color: hasName ? AppColors.emerald : AppColors.border,
                        width: hasName ? 1.8 : 1.0,
                      ),
                      boxShadow: AppColors.cardShadow,
                    ),
                    child: ClipRRect(
                      borderRadius: context.borderRadius(all: 11),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: CustomPaint(
                              painter: _SeedlingAwakeningPainter(
                                progress: animValue.clamp(0.0, 1.0),
                                isCherry: isCherry,
                              ),
                            ),
                          ),
                          // 50px Full-Pill 1-tap theme toggle in top-right of canvas banner
                          Positioned(
                            top: context.h(10),
                            right: context.w(12),
                            child: GestureDetector(
                              onTap: () {
                                HapticFeedback.selectionClick();
                                onPlantChanged(
                                  isCherry
                                      ? PlantThemeType.emerald
                                      : PlantThemeType.cherry,
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: context.w(10),
                                  vertical: context.h(5),
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceCard,
                                  borderRadius: context.borderRadius(all: 50),
                                  border: Border.all(
                                    color: AppColors.emerald,
                                  ),
                                  boxShadow: AppColors.cardShadow,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.asset(
                                      isCherry
                                          ? "assets/images/cherry_blossom.png"
                                          : "assets/images/deciduous_tree.png",
                                      width: context.w(15),
                                      height: context.w(15),
                                      fit: BoxFit.contain,
                                    ),
                                    SizedBox(width: context.w(5)),
                                    Icon(
                                      LucideIcons.repeat,
                                      size: context.w(12),
                                      color: AppColors.forestPrimary,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: context.w(14),
                            bottom: context.h(12),
                            right: context.w(14),
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: context.w(10),
                                    vertical: context.h(4),
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.surfaceCard,
                                    borderRadius: context.borderRadius(all: 50),
                                    border: Border.all(
                                      color: hasName
                                          ? AppColors.emerald
                                          : AppColors.border,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        isCherry
                                            ? LucideIcons.flower2
                                            : LucideIcons.sprout,
                                        size: context.w(13),
                                        color: AppColors.forestPrimary,
                                      ),
                                      SizedBox(width: context.w(6)),
                                      ConstrainedBox(
                                        constraints: BoxConstraints(
                                          maxWidth: context.w(245),
                                        ),
                                        child: Text(
                                          hasName
                                              ? activeSanctuaryLabel
                                              : idleSanctuaryLabel,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: AppTextStyle.captionSmall(
                                            context,
                                          ).copyWith(
                                            color: AppColors.forestDeep,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              SizedBox(height: context.h(22)),

              // Unified Title
              Text(
                LocaleKeys.onboarding_welcomeTitle.tr(),
                style: AppTextStyle.headingLarge(context).copyWith(
                  color: AppColors.forestPrimary,
                ),
              ),

              SizedBox(height: context.h(8)),

              // Unified Subtitle
              Text(
                LocaleKeys.onboarding_welcomeSubtitle.tr(),
                style: AppTextStyle.bodyMedium(context).copyWith(
                  color: AppColors.textSecondary,
                ),
              ),

              SizedBox(height: context.h(22)),

              // Field Label & Name Input Field (12px radius)
              AppTextFieldWidget(
                label: LocaleKeys.onboarding_nameLabel.tr(),
                controller: controller,
                hintText: LocaleKeys.onboarding_nameHint.tr(),
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.done,
                autofocus: false,
                borderRadius: 12,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: context.w(16),
                  vertical: context.h(14),
                ),
                suffixIcon: hasName
                    ? IconButton(
                        onPressed: controller.clear,
                        icon: Icon(
                          LucideIcons.x,
                          size: context.w(18),
                          color: AppColors.textSecondary,
                        ),
                      )
                    : null,
              ),

              SizedBox(height: context.h(24)),
            ],
          );
        },
      ),
    );
  }
}

class _SeedlingAwakeningPainter extends CustomPainter {
  final double progress; // 0.0 -> 1.0
  final bool isCherry;

  _SeedlingAwakeningPainter({
    required this.progress,
    required this.isCherry,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    // 1. Solid Warm Botanical Wash (Starbucks Light Mint vs Sakura Light)
    final skyPaint = Paint()
      ..color = Color.lerp(
        AppColors.leafBackground,
        AppColors.leafSoft,
        progress * 0.65,
      )!;
    canvas.drawRect(rect, skyPaint);

    // 2. Rising Sun Halo on the right
    final sunCenter = Offset(
      size.width * 0.74,
      size.height * (0.50 - 0.14 * progress),
    );
    final sunRadius = 24.0 + 18.0 * progress;
    final sunGlow = Paint()
      ..shader = RadialGradient(
        colors: [
          AppColors.amberWarm.withValues(alpha: 0.35 + 0.25 * progress),
          AppColors.leafSoft.withValues(alpha: 0.20 * progress),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: sunCenter, radius: sunRadius * 2));
    canvas.drawCircle(sunCenter, sunRadius * 2, sunGlow);
    canvas.drawCircle(
      sunCenter,
      14.0 + 4.0 * progress,
      Paint()
        ..color = AppColors.amberLight.withValues(
          alpha: 0.85 + 0.15 * progress,
        ),
    );

    // 3. Soft Rolling Terraced Hills
    final backHill = Path()
      ..moveTo(0, size.height * 0.78)
      ..quadraticBezierTo(
        size.width * 0.35,
        size.height * 0.56,
        size.width * 0.72,
        size.height * 0.74,
      )
      ..quadraticBezierTo(
        size.width * 0.88,
        size.height * 0.82,
        size.width,
        size.height * 0.68,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(
      backHill,
      Paint()..color = AppColors.sageLight.withValues(alpha: 0.28),
    );

    final frontHill = Path()
      ..moveTo(0, size.height * 0.86)
      ..quadraticBezierTo(
        size.width * 0.55,
        size.height * 0.64,
        size.width,
        size.height * 0.82,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(
      frontHill,
      Paint()..color = AppColors.emerald.withValues(alpha: 0.22),
    );

    // 4. Awakening Sapling on the right-center mound
    final baseX = size.width * 0.74;
    final baseY = size.height * 0.76;
    final stemHeight = 22.0 + 18.0 * progress;

    final stemPaint = Paint()
      ..color = AppColors.forestPrimary
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final stemPath = Path()
      ..moveTo(baseX, baseY)
      ..quadraticBezierTo(
        baseX - 3,
        baseY - stemHeight * 0.5,
        baseX,
        baseY - stemHeight,
      );
    canvas.drawPath(stemPath, stemPaint);

    // Left Leaf
    final leafScale = 0.65 + 0.35 * progress;
    _drawLeaf(
      canvas,
      Offset(baseX - 1, baseY - stemHeight * 0.62),
      angle: -0.7 - 0.15 * progress,
      scale: leafScale,
      color: AppColors.emerald,
    );

    // Right Leaf
    _drawLeaf(
      canvas,
      Offset(baseX + 1, baseY - stemHeight * 0.78),
      angle: 0.65 + 0.15 * progress,
      scale: leafScale,
      color: AppColors.mintAccent,
    );

    // 5. Crown Bloom when user types their name
    if (progress > 0.05) {
      final flowerScale = progress.clamp(0.0, 1.0);
      final flowerCenter = Offset(baseX, baseY - stemHeight - 4);
      canvas.save();
      canvas.translate(flowerCenter.dx, flowerCenter.dy);
      canvas.scale(flowerScale);

      final petalPaint = Paint()..color = AppColors.emerald;
      for (int i = 0; i < 5; i++) {
        canvas.save();
        canvas.rotate(i * (math.pi * 2 / 5));
        canvas.drawOval(
          Rect.fromCenter(center: const Offset(0, -6), width: 6, height: 9),
          petalPaint,
        );
        canvas.restore();
      }
      canvas.drawCircle(
        Offset.zero,
        3.0,
        Paint()..color = AppColors.amberWarm,
      );
      canvas.restore();
    }
  }

  void _drawLeaf(
    Canvas canvas,
    Offset origin, {
    required double angle,
    required double scale,
    required Color color,
  }) {
    canvas.save();
    canvas.translate(origin.dx, origin.dy);
    canvas.rotate(angle);
    canvas.scale(scale);

    final path = Path()
      ..moveTo(0, 0)
      ..quadraticBezierTo(-6, -8, 0, -16)
      ..quadraticBezierTo(6, -8, 0, 0)
      ..close();

    canvas.drawPath(path, Paint()..color = color);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _SeedlingAwakeningPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.isCherry != isCherry;
}
