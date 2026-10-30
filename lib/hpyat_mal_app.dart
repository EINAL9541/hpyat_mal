import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hpyat_mal/core/router/app_router.dart';
import 'package:hpyat_mal/core/theme/app_color.dart';
import 'package:hpyat_mal/features/forest/_provider/forest_provider.dart';

class HpyatMalApp extends ConsumerWidget {
  const HpyatMalApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plantTheme = ref.watch(forestProvider.select((s) => s.plantTheme));
    AppColors.setTheme(plantTheme);

    return MaterialApp.router(
      title: 'Hpyat Mal • Forest Quit Tracker',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      themeAnimationDuration: const Duration(milliseconds: 280),
      themeAnimationCurve: Curves.easeOutCubic,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.surface,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.forestPrimary,
          primary: AppColors.forestPrimary,
          secondary: AppColors.emerald,
          surface: AppColors.surface,
          onPrimary: AppColors.baseWhite,
          onSurface: AppColors.textPrimary,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.surface,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: AppColors.forestPrimary),
        ),
        cardTheme: CardThemeData(
          color: AppColors.surfaceCard,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: AppColors.borderSubtle),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.emerald,
            foregroundColor: AppColors.baseWhite,
            disabledBackgroundColor: AppColors.border,
            disabledForegroundColor: AppColors.textMuted,
            elevation: 0,
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.emerald,
            side: BorderSide(color: AppColors.emerald, width: 1.5),
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.textSecondary,
            shape: const StadiumBorder(),
          ),
        ),
        dividerTheme: DividerThemeData(
          color: AppColors.borderSubtle,
          thickness: 1,
          space: 1,
        ),
      ),
      routerConfig: appRouter,
    );
  }
}
