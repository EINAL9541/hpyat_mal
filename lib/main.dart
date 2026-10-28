import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:hpyat_mal/hpyat_mal_app.dart';
import 'package:hpyat_mal/core/generate/codegen_loader.g.dart';
import 'package:hpyat_mal/core/services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await EasyLocalization.ensureInitialized();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  final storageService = await StorageService.init();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('my'), Locale('en')],
      path: 'assets/translations',
      fallbackLocale: const Locale('my'),
      startLocale: const Locale('my'),
      assetLoader: const CodegenLoader(),
      child: ProviderScope(
        overrides: [storageServiceProvider.overrideWithValue(storageService)],
        child: const ScreenUtilPlusInit(
          designSize: Size(390, 844),
          minTextAdapt: true,
          splitScreenMode: true,
          autoRebuild: false,
          child: HpyatMalApp(),
        ),
      ),
    ),
  );
}
