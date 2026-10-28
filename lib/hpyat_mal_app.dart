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
          surface: AppColors.surface,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.surface,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      routerConfig: appRouter,
    );
  }
}
