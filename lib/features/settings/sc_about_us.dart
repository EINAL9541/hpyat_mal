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
            color: AppColors.border.withValues(alpha: 0.65),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            context.w(20),
            context.h(16),
            context.w(20),
            context.h(32),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: context.h(16),
            children: [
              // 1. Hero Card: Logo on light circle, brand name, 2-line tagline, version badge
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(context.w(20)),
                decoration: BoxDecoration(
                  color: AppColors.forestPrimary,
                  borderRadius: context.borderRadius(all: 22),
                ),
                child: Column(
                  children: [
                    Container(
                      width: context.w(66),
                      height: context.w(66),
                      padding: EdgeInsets.all(context.w(10)),
                      decoration: BoxDecoration(
                        color: AppColors.leafBackground,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.forestDeep.withValues(alpha: 0.16),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
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
                            color: AppColors.leafSoft,
                            height: 1.55,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: context.h(10)),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.w(14),
                        vertical: context.h(5),
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.baseWhite.withValues(alpha: 0.16),
                        borderRadius: context.borderRadius(all: 14),
                      ),
                      child: Text(
                        LocaleKeys.splash_version.tr(),
                        style: AppTextStyle.captionMedium(context).copyWith(
                          color: AppColors.baseWhite,
                          fontWeight: FontWeight.w700,
                          fontSize: 13.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 2. Three Core Pillars (No duplicated links or popups)
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

              // 3. Soft-tinted medical disclaimer banner with icon
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: context.w(16),
                  vertical: context.h(14),
                ),
                decoration: BoxDecoration(
                  color: AppColors.leafBackground,
                  borderRadius: context.borderRadius(all: 18),
                  border: Border.all(
                    color: AppColors.emerald.withValues(alpha: 0.25),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: context.h(2)),
                      child: Icon(
                        LucideIcons.info,
                        size: context.w(18),
                        color: AppColors.forestPrimary,
                      ),
                    ),
                    SizedBox(width: context.w(12)),
                    Expanded(
                      child: Text(
                        LocaleKeys.settings_aboutMedicalDisclaimer.tr(),
                        style: AppTextStyle.captionMedium(context).copyWith(
                          color: AppColors.forestDeep.withValues(alpha: 0.85),
                          fontSize: 13,
                          height: 1.6,
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
