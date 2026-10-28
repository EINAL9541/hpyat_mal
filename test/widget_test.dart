import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hpyat_mal/hpyat_mal_app.dart';
import 'package:hpyat_mal/core/services/storage_service.dart';

void main() {
  testWidgets('App loads initial forest screen', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final storageService = await StorageService.init();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          storageServiceProvider.overrideWithValue(storageService),
        ],
        child: const ScreenUtilPlusInit(
          autoRebuild: false,
          child: HpyatMalApp(),
        ),
      ),
    );

    // Pump frames without pumpAndSettle since canvas has repeating particle animation
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('Hpyat Mal'), findsOneWidget);
  });
}
