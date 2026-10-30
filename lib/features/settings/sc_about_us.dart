import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hpyat_mal/core/extensions/context_extensions.dart';
import 'package:hpyat_mal/core/generate/locale_keys.g.dart';
import 'package:hpyat_mal/core/theme/app_color.dart';
import 'package:hpyat_mal/core/theme/app_text_style.dart';
import 'package:hpyat_mal/features/settings/_widget/wd_about_info_card.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    EasyLocalization.of(context);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0.5,
        shadowColor: AppColors.border,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(
            LucideIcons.chevronLeft,
            color: AppColors.forestPrimary,
            size: context.w(24),
          ),
        ),
        title: Text(
          LocaleKeys.settings_aboutUsTitle.tr(),
          style: AppTextStyle.headingSmall(context).copyWith(
            color: AppColors.forestDeep,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(
            height: 1,
            thickness: 1,
            color: AppColors.borderSubtle,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            context.w(16),
            context.h(16),
            context.w(16),
            context.h(32),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: context.h(16),
            children: [
              // 1. Solid House Band Hero Card (#1E3932 / #381824)
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(context.w(20)),
                decoration: BoxDecoration(
                  color: AppColors.forestDeep,
                  borderRadius: context.borderRadius(all: 16),
                  boxShadow: AppColors.cardShadow,
                ),
                child: Column(
                  children: [
                    Container(
                      width: context.w(66),
                      height: context.w(66),
                      padding: EdgeInsets.all(context.w(10)),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceCard,
                        shape: BoxShape.circle,
                        boxShadow: AppColors.cardShadow,
                      ),
                      child: Image.asset(
                        "assets/images/app_icon_transparent.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(height: context.h(12)),
                    Text(
                      "Hpyat Mal",
                      style: AppTextStyle.headingMedium(context).copyWith(
                        color: AppColors.baseWhite,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: context.h(4)),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: context.h(44),
                      ),
                      child: Center(
                        child: Text(
                          LocaleKeys.settings_aboutTagline.tr(),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          style: AppTextStyle.captionMedium(context).copyWith(
                            color: AppColors.baseWhite.withValues(alpha: 0.72),
                            height: 1.55,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: context.h(10)),
                    // Gold-outlined version pill
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.w(14),
                        vertical: context.h(4),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: context.borderRadius(all: 50),
                        border: Border.all(color: AppColors.amberWarm),
                      ),
                      child: Text(
                        "★ ${LocaleKeys.splash_version.tr()}",
                        style: AppTextStyle.captionMedium(context).copyWith(
                          color: AppColors.amberWarm,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 2. Three Core Pillars
              Column(
                spacing: context.h(12),
                children: [
                  AboutInfoCardWidget(
                    icon: LucideIcons.compass,
                    title: LocaleKeys.settings_aboutMissionTitle.tr(),
                    description: LocaleKeys.settings_aboutMissionDesc.tr(),
                  ),
                  AboutInfoCardWidget(
                    icon: LucideIcons.shieldCheck,
                    title: LocaleKeys.settings_aboutPrivacyTitle.tr(),
                    description: LocaleKeys.settings_aboutPrivacyDesc.tr(),
                  ),
                  AboutInfoCardWidget(
                    icon: LucideIcons.stethoscope,
                    title: LocaleKeys.settings_aboutScienceTitle.tr(),
                    description: LocaleKeys.settings_aboutScienceDesc.tr(),
                  ),
                ],
              ),

              // 3. Gold Lightest (#FAF6EE) Medical Disclaimer Banner
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: context.w(16),
                  vertical: context.h(14),
                ),
                decoration: BoxDecoration(
                  color: AppColors.amberLight,
                  borderRadius: context.borderRadius(all: 12),
                  border: Border.all(color: AppColors.skySoft),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: context.h(2)),
                      child: Icon(
                        LucideIcons.info,
                        size: context.w(18),
                        color: AppColors.forestDeep,
                      ),
                    ),
                    SizedBox(width: context.w(12)),
                    Expanded(
                      child: Text(
                        LocaleKeys.settings_aboutMedicalDisclaimer.tr(),
                        style: AppTextStyle.captionMedium(context).copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                          height: 1.55,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
