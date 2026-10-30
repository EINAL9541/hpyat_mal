import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hpyat_mal/core/theme/app_color.dart';

/// Typography scale following DESIGN.md (Starbucks tight negative tracking
/// and weight-driven hierarchy with full Myanmar script legibility).
class AppTextStyle {
  AppTextStyle._();

  static TextStyle display(BuildContext context) {
    return GoogleFonts.notoSansMyanmar(
      fontSize: 32,
      fontWeight: FontWeight.w700,
      color: AppColors.textPrimary,
      letterSpacing: -0.5,
      height: 1.25,
      fontFeatures: const [FontFeature.tabularFigures()],
    );
  }

  static TextStyle headingLarge(BuildContext context) {
    return GoogleFonts.notoSansMyanmar(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: AppColors.forestPrimary,
      letterSpacing: -0.2,
      height: 1.4,
      fontFeatures: const [FontFeature.tabularFigures()],
    );
  }

  static TextStyle headingMedium(BuildContext context) {
    return GoogleFonts.notoSansMyanmar(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
      letterSpacing: -0.16,
      height: 1.4,
    );
  }

  static TextStyle headingSmall(BuildContext context) {
    return GoogleFonts.notoSansMyanmar(
      fontSize: 17,
      fontWeight: FontWeight.w600,
      color: AppColors.forestDeep,
      letterSpacing: -0.16,
      height: 1.45,
    );
  }

  static TextStyle bodyLarge(BuildContext context) {
    return GoogleFonts.notoSansMyanmar(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: AppColors.textPrimary,
      letterSpacing: -0.16,
      height: 1.55,
    );
  }

  static TextStyle bodyMedium(BuildContext context) {
    return GoogleFonts.notoSansMyanmar(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      color: AppColors.textSecondary,
      letterSpacing: -0.16,
      height: 1.55,
    );
  }

  static TextStyle bodySemiBold(BuildContext context) {
    return GoogleFonts.notoSansMyanmar(
      fontSize: 15,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
      letterSpacing: -0.16,
      height: 1.45,
    );
  }

  static TextStyle captionMedium(BuildContext context) {
    return GoogleFonts.notoSansMyanmar(
      fontSize: 13.5,
      fontWeight: FontWeight.w500,
      color: AppColors.textSecondary,
      letterSpacing: -0.1,
      height: 1.45,
    );
  }

  static TextStyle captionSmall(BuildContext context) {
    return GoogleFonts.notoSansMyanmar(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: AppColors.textMuted,
      letterSpacing: 0.2,
      height: 1.4,
    );
  }

  static TextStyle numberDisplay(BuildContext context) {
    return GoogleFonts.notoSansMyanmar(
      fontSize: 44,
      fontWeight: FontWeight.w800,
      color: AppColors.forestDeep,
      letterSpacing: -1.0,
      height: 1.15,
      fontFeatures: const [FontFeature.tabularFigures()],
    );
  }
}
