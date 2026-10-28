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

/// Immutable color token set for each plant theme.
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

  /// Classic Emerald Forest theme (Green Tree)
  static const AppThemePalette emeraldForest = AppThemePalette(
    forestDeep: Color(0xFF0F291E),
    forestPrimary: Color(0xFF1B4D3E),
    forestMedium: Color(0xFF2D6A4F),
    emerald: Color(0xFF40916C),
    mintAccent: Color(0xFF52B788),
    sageLight: Color(0xFF74C69D),
    leafSoft: Color(0xFFD8F3DC),
    leafBackground: Color(0xFFF2F9F5),
    amberWarm: Color(0xFFE08A2B),
    amberLight: Color(0xFFFEF3C7),
    barkBrown: Color(0xFF5C4033),
    skyMist: Color(0xFFE3F2FD),
    skySoft: Color(0xFF90CAF9),
    surface: Color(0xFFF9FBFA),
    surfaceCard: Color(0xFFFFFFFF),
    surfaceCardMuted: Color(0xFFF4F7F5),
    border: Color(0xFFE2EBE5),
    borderSubtle: Color(0xFFEDF2EF),
    baseWhite: Color(0xFFFFFFFF),
    baseBlack: Color(0xFF14241D),
    textPrimary: Color(0xFF14241D),
    textSecondary: Color(0xFF3D554B),
    textMuted: Color(0xFF566E63),
    textLight: Color(0xFFFFFFFF),
    danger: Color(0xFFE55353),
    dangerSoft: Color(0xFFFDE8E8),
    warning: Color(0xFFF59E0B),
    warningSoft: Color(0xFFFEF3C7),
    success: Color(0xFF2E7D32),
    successSoft: Color(0xFFE8F5E9),
  );

  /// Soft Sakura Pink & Rosewood theme (Cherry Blossom Tree)
  static const AppThemePalette cherryBlossom = AppThemePalette(
    forestDeep: Color(0xFF3B1224),
    forestPrimary: Color(0xFF9C2D56),
    forestMedium: Color(0xFFB83B68),
    emerald: Color(0xFFD85A88),
    mintAccent: Color(0xFFF080A8),
    sageLight: Color(0xFFF7A8C4),
    leafSoft: Color(0xFFFCE4EE),
    leafBackground: Color(0xFFFDF2F6),
    amberWarm: Color(0xFFE07A45),
    amberLight: Color(0xFFFFF0E5),
    barkBrown: Color(0xFF5E3A3E),
    skyMist: Color(0xFFFDF0F5),
    skySoft: Color(0xFFF7B2C9),
    surface: Color(0xFFFCF8FA),
    surfaceCard: Color(0xFFFFFFFF),
    surfaceCardMuted: Color(0xFFF8EFF3),
    border: Color(0xFFEEDCE3),
    borderSubtle: Color(0xFFF6ECF0),
    baseWhite: Color(0xFFFFFFFF),
    baseBlack: Color(0xFF2B101C),
    textPrimary: Color(0xFF2B101C),
    textSecondary: Color(0xFF633B4D),
    textMuted: Color(0xFF7D5667),
    textLight: Color(0xFFFFFFFF),
    danger: Color(0xFFE55353),
    dangerSoft: Color(0xFFFDE8E8),
    warning: Color(0xFFF59E0B),
    warningSoft: Color(0xFFFEF3C7),
    success: Color(0xFF9C2D56),
    successSoft: Color(0xFFFCE4EE),
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

  // Semantic Sanctuary Tones (Green in Emerald mode, Sakura Pink in Cherry mode)
  static Color get forestDeep => palette.forestDeep;
  static Color get forestPrimary => palette.forestPrimary;
  static Color get forestMedium => palette.forestMedium;
  static Color get emerald => palette.emerald;
  static Color get mintAccent => palette.mintAccent;
  static Color get sageLight => palette.sageLight;
  static Color get leafSoft => palette.leafSoft;
  static Color get leafBackground => palette.leafBackground;

  // Warm Amber & Earth Accents
  static Color get amberWarm => palette.amberWarm;
  static Color get amberLight => palette.amberLight;
  static Color get barkBrown => palette.barkBrown;

  // Calming Sky & Mist
  static Color get skyMist => palette.skyMist;
  static Color get skySoft => palette.skySoft;

  // Neutral Foundations
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
  static const Color danger = Color(0xFFE55353);
  static const Color dangerSoft = Color(0xFFFDE8E8);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningSoft = Color(0xFFFEF3C7);
  static Color get success => palette.success;
  static Color get successSoft => palette.successSoft;
}
