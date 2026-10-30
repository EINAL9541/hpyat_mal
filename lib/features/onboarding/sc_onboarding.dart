import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hpyat_mal/core/extensions/context_extensions.dart';
import 'package:hpyat_mal/core/generate/locale_keys.g.dart';
import 'package:hpyat_mal/core/router/app_router_key.dart';
import 'package:hpyat_mal/core/services/storage_service.dart';
import 'package:hpyat_mal/core/theme/app_color.dart';
import 'package:hpyat_mal/core/theme/app_text_style.dart';
import 'package:hpyat_mal/core/ui/widgets/language_switch_button.dart';
import 'package:hpyat_mal/features/forest/_provider/forest_provider.dart';
import 'package:hpyat_mal/features/onboarding/_widget/wd_habits_step.dart';
import 'package:hpyat_mal/features/onboarding/_widget/wd_name_step.dart';
import 'package:hpyat_mal/features/onboarding/_widget/wd_plant_seed_step.dart';
import 'package:hpyat_mal/features/onboarding/_widget/wd_why_step.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class OnboardingScreen extends HookConsumerWidget {
  const OnboardingScreen({super.key});

  static const int _defaultCigsPerDay = 15;
  static const int _defaultCigsPerPack = 20;
  static const double _defaultPackCost = 3500;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    EasyLocalization.of(context);
    final plantTheme = ref.watch(forestProvider.select((s) => s.plantTheme));
    final pageController = usePageController();
    final currentPage = useState<int>(0);

    // Screen 1: Name
    final nameController = useTextEditingController();

    // Screen 2: 3 Habit inputs (Cigs/day, Cigs/pack, Pack cost)
    final cigsPerDayController = useTextEditingController(text: '15');
    final cigsPerPackController = useTextEditingController(text: '20');
    final packCostController = useTextEditingController(text: '3500');

    // Screen 3: Index-based Why selection (0..4 = preset suggestions, 5 = custom text)
    final selectedWhyIndex = useState<int?>(null);
    final customWhyController = useTextEditingController();
    final customWhyFocusNode = useFocusNode();

    // Screen 4: Quit date (null = Starting Today, or user-picked past date)
    final customQuitDate = useState<DateTime?>(null);

    // Listen to controllers so button state and Step 4 preview update live
    useListenable(nameController);
    useListenable(cigsPerDayController);
    useListenable(cigsPerPackController);
    useListenable(packCostController);
    useListenable(customWhyController);

    final whySuggestions = [
      LocaleKeys.onboarding_whySuggestion1.tr(),
      LocaleKeys.onboarding_whySuggestion2.tr(),
      LocaleKeys.onboarding_whySuggestion3.tr(),
      LocaleKeys.onboarding_whySuggestion4.tr(),
      LocaleKeys.onboarding_whySuggestion5.tr(),
    ];

    final String effectiveWhy;
    final idx = selectedWhyIndex.value;
    if (idx == WhyStepWidget.customWhyOptionIndex) {
      effectiveWhy = customWhyController.text.trim();
    } else if (idx != null && idx >= 0 && idx < whySuggestions.length) {
      effectiveWhy = whySuggestions[idx];
    } else {
      effectiveWhy = '';
    }

    final bool canContinue;
    if (currentPage.value == 0) {
      canContinue = nameController.text.trim().isNotEmpty;
    } else if (currentPage.value == 1) {
      canContinue = cigsPerDayController.text.trim().isNotEmpty &&
          cigsPerPackController.text.trim().isNotEmpty &&
          packCostController.text.trim().isNotEmpty;
    } else if (currentPage.value == 2) {
      canContinue = effectiveWhy.isNotEmpty;
    } else {
      canContinue = true;
    }

    void goToNextStep() {
      FocusScope.of(context).unfocus();
      if (currentPage.value < 3) {
        pageController.nextPage(
          duration: const Duration(milliseconds: 320),
          curve: Curves.easeOutCubic,
        );
      } else {
        _finishOnboarding(
          context: context,
          ref: ref,
          name: nameController.text,
          cigsPerDay: cigsPerDayController.text,
          cigsPerPack: cigsPerPackController.text,
          packCost: packCostController.text,
          why: effectiveWhy,
          quitDate: customQuitDate.value,
          plantTheme: plantTheme,
        );
      }
    }

    void previousPage() {
      FocusScope.of(context).unfocus();
      if (currentPage.value > 0) {
        pageController.previousPage(
          duration: const Duration(milliseconds: 320),
          curve: Curves.easeOutCubic,
        );
      }
    }

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Fixed Non-Jumping Header: Chevron-Left | Centered Progress Dots | MM/EN
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.w(16),
                vertical: context.h(10),
              ),
              child: SizedBox(
                height: context.h(42),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: currentPage.value > 0
                          ? IconButton(
                              onPressed: previousPage,
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints.tightFor(
                                width: context.w(38),
                                height: context.h(38),
                              ),
                              icon: Icon(
                                LucideIcons.chevronLeft,
                                color: AppColors.forestPrimary,
                                size: context.w(24),
                              ),
                            )
                          : SizedBox(
                              width: context.w(38),
                              height: context.h(38),
                            ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(4, (index) {
                        final isActive = index == currentPage.value;
                        final isPassed = index < currentPage.value;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          margin: EdgeInsets.symmetric(
                            horizontal: context.w(3.5),
                          ),
                          width: isActive ? context.w(26) : context.w(8),
                          height: context.h(6),
                          decoration: BoxDecoration(
                            color: isActive
                                ? AppColors.emerald
                                : (isPassed
                                    ? AppColors.forestPrimary
                                    : AppColors.border),
                            borderRadius: context.borderRadius(all: 50),
                          ),
                        );
                      }),
                    ),
                    const Align(
                      alignment: Alignment.centerRight,
                      child: LanguageSwitchButton(isCompact: true),
                    ),
                  ],
                ),
              ),
            ),

            // PageView with 4 Separated Step Widgets
            Expanded(
              child: PageView(
                controller: pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (page) => currentPage.value = page,
                children: [
                  NameStepWidget(
                    controller: nameController,
                    selectedPlant: plantTheme,
                    onPlantChanged: (newPlant) {
                      ref
                          .read(forestProvider.notifier)
                          .setPlantTheme(newPlant);
                    },
                  ),
                  HabitsStepWidget(
                    cigsPerDayController: cigsPerDayController,
                    cigsPerPackController: cigsPerPackController,
                    packCostController: packCostController,
                  ),
                  WhyStepWidget(
                    selectedWhyIndex: selectedWhyIndex,
                    customWhyController: customWhyController,
                    customWhyFocusNode: customWhyFocusNode,
                    whySuggestions: whySuggestions,
                  ),
                  PlantSeedStepWidget(
                    displayName: nameController.text.trim(),
                    cigsPerDay: _parseCigsPerDay(cigsPerDayController.text),
                    cigsPerPack: _parseCigsPerPack(cigsPerPackController.text),
                    packCost: _parsePackCost(packCostController.text),
                    effectiveWhy: effectiveWhy,
                    customQuitDate: customQuitDate,
                    plantTheme: plantTheme,
                  ),
                ],
              ),
            ),

            // Fixed Bottom Action Button (50px Full Pill per Starbucks DESIGN.md)
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.w(20),
                vertical: context.h(16),
              ),
              child: SizedBox(
                width: double.infinity,
                height: context.h(52),
                child: ElevatedButton(
                  onPressed: canContinue ? goToNextStep : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.emerald,
                    foregroundColor: AppColors.baseWhite,
                    disabledBackgroundColor: AppColors.border,
                    disabledForegroundColor: AppColors.textMuted,
                    shape: const StadiumBorder(),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (currentPage.value == 3) ...[
                        Icon(
                          LucideIcons.sprout,
                          size: context.w(19),
                          color: AppColors.baseWhite,
                        ),
                        SizedBox(width: context.w(8)),
                      ],
                      Text(
                        currentPage.value == 3
                            ? LocaleKeys.onboarding_plantSeedling.tr()
                            : LocaleKeys.onboarding_continueBtn.tr(),
                        style: AppTextStyle.bodySemiBold(context).copyWith(
                          color: canContinue
                              ? AppColors.baseWhite
                              : AppColors.textMuted,
                          fontSize: 16,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _parseCigsPerDay(String text) {
    final v = int.tryParse(text.trim());
    return (v != null && v > 0) ? v : _defaultCigsPerDay;
  }

  int _parseCigsPerPack(String text) {
    final v = int.tryParse(text.trim());
    return (v != null && v > 0) ? v : _defaultCigsPerPack;
  }

  double _parsePackCost(String text) {
    final cleaned = text.replaceAll(',', '').trim();
    final v = double.tryParse(cleaned);
    return (v != null && v > 0) ? v : _defaultPackCost;
  }

  Future<void> _finishOnboarding({
    required BuildContext context,
    required WidgetRef ref,
    required String name,
    required String cigsPerDay,
    required String cigsPerPack,
    required String packCost,
    required String why,
    required DateTime? quitDate,
    required PlantThemeType plantTheme,
  }) async {
    final parsedCigsPerDay = _parseCigsPerDay(cigsPerDay);
    final parsedCigsPerPack = _parseCigsPerPack(cigsPerPack);
    final parsedPackCost = _parsePackCost(packCost);

    final storage = ref.read(storageServiceProvider);
    await storage.saveOnboardingProfile(
      name: name.trim(),
      cigsPerDay: parsedCigsPerDay,
      cigsPerPack: parsedCigsPerPack,
      packCost: parsedPackCost,
      quitReason: why.trim(),
      quitDate: quitDate ?? DateTime.now(),
      plantTheme: plantTheme,
    );

    await ref.read(forestProvider.notifier).reloadFromStorage();

    if (context.mounted) {
      context.go(RouteKeys.forest.path);
    }
  }
}
