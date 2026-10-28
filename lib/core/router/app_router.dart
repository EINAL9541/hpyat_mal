import 'package:go_router/go_router.dart';
import 'package:hpyat_mal/core/router/app_router_key.dart';
import 'package:hpyat_mal/core/ui/navbar/wd_main_shell_scaffold.dart';
import 'package:hpyat_mal/features/breathing/sc_breathing.dart';
import 'package:hpyat_mal/features/forest/sc_forest.dart';
import 'package:hpyat_mal/features/health/sc_health.dart';
import 'package:hpyat_mal/features/journal/sc_journal.dart';
import 'package:hpyat_mal/features/onboarding/sc_onboarding.dart';
import 'package:hpyat_mal/features/savings/sc_savings.dart';
import 'package:hpyat_mal/features/settings/sc_about_us.dart';
import 'package:hpyat_mal/features/settings/sc_feedback.dart';
import 'package:hpyat_mal/features/settings/sc_personal_info.dart';
import 'package:hpyat_mal/features/settings/sc_settings.dart';
import 'package:hpyat_mal/features/settings/sc_language.dart';
import 'package:hpyat_mal/features/settings/sc_theme.dart';
import 'package:hpyat_mal/features/splash/sc_splash.dart';

final appRouter = GoRouter(
  initialLocation: RouteKeys.splash.path,
  routes: [
    GoRoute(
      path: RouteKeys.splash.path,
      name: RouteKeys.splash.name,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: RouteKeys.onboarding.path,
      name: RouteKeys.onboarding.name,
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: RouteKeys.settings.path,
      name: RouteKeys.settings.name,
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: RouteKeys.settingsPersonalInfo.path,
      name: RouteKeys.settingsPersonalInfo.name,
      builder: (context, state) => const PersonalInfoScreen(),
    ),
    GoRoute(
      path: RouteKeys.settingsTheme.path,
      name: RouteKeys.settingsTheme.name,
      builder: (context, state) => const ThemeScreen(),
    ),
    GoRoute(
      path: RouteKeys.settingsLanguage.path,
      name: RouteKeys.settingsLanguage.name,
      builder: (context, state) => const LanguageScreen(),
    ),
    GoRoute(
      path: RouteKeys.settingsAboutUs.path,
      name: RouteKeys.settingsAboutUs.name,
      builder: (context, state) => const AboutUsScreen(),
    ),
    GoRoute(
      path: RouteKeys.settingsFeedback.path,
      name: RouteKeys.settingsFeedback.name,
      builder: (context, state) => const FeedbackScreen(),
    ),
    ShellRoute(
      builder: (context, state, child) {
        return MainShellScaffoldWidget(child: child);
      },
      routes: [
        GoRoute(
          path: RouteKeys.forest.path,
          name: RouteKeys.forest.name,
          builder: (context, state) => const ForestScreen(),
        ),
        GoRoute(
          path: RouteKeys.health.path,
          name: RouteKeys.health.name,
          builder: (context, state) => const HealthScreen(),
        ),
        GoRoute(
          path: RouteKeys.breathing.path,
          name: RouteKeys.breathing.name,
          builder: (context, state) => const BreathingScreen(),
        ),
        GoRoute(
          path: RouteKeys.journal.path,
          name: RouteKeys.journal.name,
          builder: (context, state) => const JournalScreen(),
        ),
        GoRoute(
          path: RouteKeys.savings.path,
          name: RouteKeys.savings.name,
          builder: (context, state) => const SavingsScreen(),
        ),
      ],
    ),
  ],
);
