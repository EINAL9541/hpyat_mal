import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hpyat_mal/core/extensions/context_extensions.dart';
import 'package:hpyat_mal/core/generate/locale_keys.g.dart';
import 'package:hpyat_mal/core/router/app_router_key.dart';
import 'package:hpyat_mal/core/theme/app_color.dart';
import 'package:hpyat_mal/core/theme/app_text_style.dart';
import 'package:hpyat_mal/core/services/storage_service.dart';

class SplashScreen extends HookConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useAnimationController(
      duration: const Duration(milliseconds: 1200),
    );

    final scaleAnimation = useMemoized(
      () => CurvedAnimation(parent: controller, curve: Curves.easeOutBack),
      [controller],
    );

    final fadeAnimation = useMemoized(
      () => CurvedAnimation(parent: controller, curve: Curves.easeIn),
      [controller],
    );

    useEffect(() {
      controller.forward();

      final timer = Timer(const Duration(milliseconds: 2500), () {
        if (!context.mounted) return;
        final storage = ref.read(storageServiceProvider);
        final isDone = storage.isOnboardingCompleted();

        if (isDone) {
          context.go(RouteKeys.forest.path);
        } else {
          context.go(RouteKeys.onboarding.path);
        }
      });

      return timer.cancel;
    }, const []);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Container(
        width: double.infinity,
        padding: context.edgeInsets(horizontal: 24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.leafBackground,
              AppColors.surface,
              AppColors.skyMist.withValues(alpha: 0.35),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Center(
                child: FadeTransition(
                  opacity: fadeAnimation,
                  child: ScaleTransition(
                    scale: scaleAnimation,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          "assets/images/app_icon_transparent.png",
                          width: context.w(100),
                        ),
                        SizedBox(height: context.h(24)),
                        Text(
                          "Hpyat Mal",
                          style: AppTextStyle.display(context).copyWith(
                            color: AppColors.forestDeep,
                            letterSpacing: -0.5,
                          ),
                        ),
                        SizedBox(height: context.h(12)),
                        Text(
                          LocaleKeys.splash_tagLine.tr(),
                          textAlign: TextAlign.center,
                          style: AppTextStyle.bodyMedium(context).copyWith(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Version at the bottom
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: context.edgeInsets(bottom: 24),
                  child: Text(
                    LocaleKeys.splash_version.tr(),
                    style: AppTextStyle.captionSmall(context),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
