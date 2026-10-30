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
      body: SafeArea(
        child: Padding(
          padding: context.edgeInsets(horizontal: 24),
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
                        Container(
                          width: context.w(116),
                          height: context.w(116),
                          padding: EdgeInsets.all(context.w(16)),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceCard,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.borderSubtle,
                              width: 1.5,
                            ),
                            boxShadow: AppColors.cardShadow,
                          ),
                          child: Image.asset(
                            "assets/images/app_icon_transparent.png",
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(height: context.h(22)),
                        Text(
                          "Hpyat Mal",
                          style: AppTextStyle.display(context).copyWith(
                            color: AppColors.forestPrimary,
                            letterSpacing: -0.5,
                          ),
                        ),
                        SizedBox(height: context.h(10)),
                        Text(
                          LocaleKeys.splash_tagLine.tr(),
                          textAlign: TextAlign.center,
                          style: AppTextStyle.bodyMedium(context).copyWith(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Version pill at the bottom
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: context.edgeInsets(bottom: 24),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.w(12),
                      vertical: context.h(4),
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceCardMuted,
                      borderRadius: context.borderRadius(all: 50),
                    ),
                    child: Text(
                      LocaleKeys.splash_version.tr(),
                      style: AppTextStyle.captionSmall(context),
                    ),
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
