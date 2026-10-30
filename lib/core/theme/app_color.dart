import 'package:flutter/material.dart';

/// Single source of truth for the user's chosen sanctuary tree & app theme.
enum PlantThemeType {
  emerald('emerald'),
  cherry('cherry');

  final String storageKey;
  const PlantThemeType(this.storageKey);

  bool get isCherry => this == PlantThemeType.cherry;
  bool get isEmerald => this == PlantThemeType.emerald;

  static PlantThemeType fromStorage(String? value) {
    if (value == 'cherry') return PlantThemeType.cherry;
    return PlantThemeType.emerald;
  }
}

/// Immutable color token set for each plant theme, calibrated to the
/// Starbucks 4-tier botanical & warm-cream design system (see DESIGN.md).
class AppThemePalette {
  final Color forestDeep;
  final Color forestPrimary;
  final Color forestMedium;
  final Color emerald;
  final Color mintAccent;
  final Color sageLight;
  final Color leafSoft;
  final Color leafBackground;

  final Color amberWarm;
  final Color amberLight;
  final Color barkBrown;

  final Color skyMist;
  final Color skySoft;

  final Color surface;
  final Color surfaceCard;
  final Color surfaceCardMuted;

  final Color border;
  final Color borderSubtle;

  final Color baseWhite;
  final Color baseBlack;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color textLight;

  final Color danger;
  final Color dangerSoft;
  final Color warning;
  final Color warningSoft;
  final Color success;
  final Color successSoft;

  const AppThemePalette({
    required this.forestDeep,
    required this.forestPrimary,
    required this.forestMedium,
    required this.emerald,
    required this.mintAccent,
    required this.sageLight,
    required this.leafSoft,
    required this.leafBackground,
    required this.amberWarm,
    required this.amberLight,
    required this.barkBrown,
    required this.skyMist,
    required this.skySoft,
    required this.surface,
    required this.surfaceCard,
    required this.surfaceCardMuted,
    required this.border,
    required this.borderSubtle,
    required this.baseWhite,
    required this.baseBlack,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.textLight,
    required this.danger,
    required this.dangerSoft,
    required this.warning,
    required this.warningSoft,
    required this.success,
    required this.successSoft,
  });

  /// Theme 1: Emerald Forest — Classic Starbucks 4-tier green & warm cream canvas
  static const AppThemePalette emeraldForest = AppThemePalette(
    forestDeep: Color(0xFF1E3932), // House Green (deep feature bands & hero numbers)
    forestPrimary: Color(0xFF006241), // Starbucks Green (brand headings & active nav)
    forestMedium: Color(0xFF2B5148), // Green Uplift (secondary dark-surface tone)
    emerald: Color(0xFF00754A), // Green Accent (primary filled pill CTAs & rings)
    mintAccent: Color(0xFF3D9970), // Luminous botanical highlight
    sageLight: Color(0xFF6B9E88), // Muted botanical sage
    leafSoft: Color(0xFFD4E9E2), // Green Light (soft badge & valid-field wash)
    leafBackground: Color(0xFFEBF4F0), // Whisper green tint
    amberWarm: Color(0xFFCBA258), // Rewards Gold (reserved for ceremony/milestones)
    amberLight: Color(0xFFFAF6EE), // Gold Lightest (warm cream-gold ceremony wash)
    barkBrown: Color(0xFF4E3629), // Espresso earth
    skyMist: Color(0xFFF9F9F9), // Neutral Cool utility surface
    skySoft: Color(0xFFDFC49D), // Gold Light border ring
    surface: Color(0xFFF2F0EB), // Neutral Warm cream canvas
    surfaceCard: Color(0xFFFFFFFF), // Pure white card surface
    surfaceCardMuted: Color(0xFFEDEBE9), // Ceramic secondary zone
    border: Color(0xFFDFDCD5), // Warm hairline border
    borderSubtle: Color(0xFFE8E5DF), // Soft internal hairline
    baseWhite: Color(0xFFFFFFFF),
    baseBlack: Color(0xFF1F1F1F), // Warm 87% Text Black
    textPrimary: Color(0xFF1F1F1F), // Warm 87% Text Black
    textSecondary: Color(0xFF33433D), // Rewards Green muted slate
    textMuted: Color(0xFF6B6A65), // 58% Text Black Soft
    textLight: Color(0xFFFFFFFF),
    danger: Color(0xFFC82014), // Starbucks Red
    dangerSoft: Color(0xFFFBE9E7),
    warning: Color(0xFFD99B26),
    warningSoft: Color(0xFFFEF6E6),
    success: Color(0xFF00754A),
    successSoft: Color(0xFFD4E9E2),
  );

  /// Theme 2: Cherry Blossom — Sakura Reserve calibrated to Starbucks 4-tier tone
  static const AppThemePalette cherryBlossom = AppThemePalette(
    forestDeep: Color(0xFF381824), // Sakura House Reserve (deep rosewood-plum band)
    forestPrimary: Color(0xFF8C234B), // Sakura Brand Crimson (headings & active nav)
    forestMedium: Color(0xFF5E2A3D), // Sakura Uplift (mid-dark rosewood)
    emerald: Color(0xFFA8325D), // Sakura Accent Rose (primary filled pill CTAs & rings)
    mintAccent: Color(0xFFC85A82), // Luminous sakura highlight
    sageLight: Color(0xFFD88AA6), // Muted petal rose
    leafSoft: Color(0xFFF3DCE4), // Sakura Light (soft badge & selected wash)
    leafBackground: Color(0xFFF9EFF3), // Whisper sakura tint
    amberWarm: Color(0xFFCBA258), // Rewards Gold (reserved for ceremony/milestones)
    amberLight: Color(0xFFFAF6EE), // Gold Lightest (warm cream-gold ceremony wash)
    barkBrown: Color(0xFF54343A), // Warm rosewood bark
    skyMist: Color(0xFFFAF8F9), // Neutral Cool utility surface
    skySoft: Color(0xFFDFC49D), // Gold Light border ring
    surface: Color(0xFFF5F0F1), // Warm Rose-Cream canvas
    surfaceCard: Color(0xFFFFFFFF), // Pure white card surface
    surfaceCardMuted: Color(0xFFEFEAEC), // Sakura Ceramic secondary zone
    border: Color(0xFFE6DFE1), // Warm hairline border
    borderSubtle: Color(0xFFEFEAEB), // Soft internal hairline
    baseWhite: Color(0xFFFFFFFF),
    baseBlack: Color(0xFF241A1E), // Warm 87% Ink
    textPrimary: Color(0xFF241A1E), // Warm 87% Ink
    textSecondary: Color(0xFF4E3840), // Muted rose-slate secondary text
    textMuted: Color(0xFF75686C), // 58% Soft Ink
    textLight: Color(0xFFFFFFFF),
    danger: Color(0xFFC82014), // Starbucks Red
    dangerSoft: Color(0xFFFBE9E7),
    warning: Color(0xFFD99B26),
    warningSoft: Color(0xFFFEF6E6),
    success: Color(0xFF8C234B),
    successSoft: Color(0xFFF3DCE4),
  );
}

/// Centralized single source of truth for app colors.
/// Automatically resolves semantic tokens against the active [PlantThemeType].
class AppColors {
  AppColors._();

  static PlantThemeType _activeTheme = PlantThemeType.emerald;

  static PlantThemeType get activeTheme => _activeTheme;
  static bool get isCherry => _activeTheme == PlantThemeType.cherry;

  static void setTheme(PlantThemeType theme) {
    _activeTheme = theme;
  }

  static AppThemePalette get palette => _activeTheme == PlantThemeType.cherry
      ? AppThemePalette.cherryBlossom
      : AppThemePalette.emeraldForest;

  // Semantic Sanctuary Tones (4-tier Starbucks Green in Emerald mode, Sakura Reserve in Cherry mode)
  static Color get forestDeep => palette.forestDeep;
  static Color get forestPrimary => palette.forestPrimary;
  static Color get forestMedium => palette.forestMedium;
  static Color get emerald => palette.emerald;
  static Color get mintAccent => palette.mintAccent;
  static Color get sageLight => palette.sageLight;
  static Color get leafSoft => palette.leafSoft;
  static Color get leafBackground => palette.leafBackground;

  // Rewards Gold & Earth Accents
  static Color get amberWarm => palette.amberWarm;
  static Color get amberLight => palette.amberLight;
  static Color get barkBrown => palette.barkBrown;

  // Utility & Gold Ring Accents
  static Color get skyMist => palette.skyMist;
  static Color get skySoft => palette.skySoft;

  // Warm Cream & Ceramic Foundations
  static Color get surface => palette.surface;
  static Color get surfaceCard => palette.surfaceCard;
  static Color get surfaceCardMuted => palette.surfaceCardMuted;
  static const Color transparent = Colors.transparent;

  static Color get border => palette.border;
  static Color get borderSubtle => palette.borderSubtle;

  // Typography Colors
  static const Color baseWhite = Color(0xFFFFFFFF);
  static Color get baseBlack => palette.baseBlack;
  static Color get textPrimary => palette.textPrimary;
  static Color get textSecondary => palette.textSecondary;
  static Color get textMuted => palette.textMuted;
  static const Color textLight = Color(0xFFFFFFFF);

  // Status & Feedback
  static const Color danger = Color(0xFFC82014);
  static const Color dangerSoft = Color(0xFFFBE9E7);
  static const Color warning = Color(0xFFD99B26);
  static const Color warningSoft = Color(0xFFFEF6E6);
  static Color get success => palette.success;
  static Color get successSoft => palette.successSoft;

  /// Whisper-soft dual-layer card shadow from DESIGN.md
  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 1,
          offset: const Offset(0, 0.5),
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.06),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];

  /// Layered ambient shadow for floating pill/circular CTAs and bottom nav
  static List<BoxShadow> get floatingShadow => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.12),
          blurRadius: 6,
          offset: Offset.zero,
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.10),
          blurRadius: 14,
          offset: const Offset(0, 6),
        ),
      ];
}
