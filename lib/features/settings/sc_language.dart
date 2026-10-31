import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hpyat_mal/core/extensions/context_extensions.dart';
import 'package:hpyat_mal/core/generate/locale_keys.g.dart';
import 'package:hpyat_mal/core/theme/app_color.dart';
import 'package:hpyat_mal/core/theme/app_text_style.dart';
import 'package:hpyat_mal/core/ui/widgets/wd_app_page_app_bar.dart';
import 'package:hpyat_mal/features/settings/_widget/wd_language_choice_card.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentLang = context.locale.languageCode;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppPageAppBarWidget(
        title: LocaleKeys.settings_languageTitle.tr(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: context.w(16),
            vertical: context.h(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocaleKeys.settings_languageSectionTitle.tr(),
                style: AppTextStyle.headingSmall(context)
                    .copyWith(color: AppColors.forestPrimary),
              ),
              SizedBox(height: context.h(4)),
              Text(
                LocaleKeys.settings_languageSectionDesc.tr(),
                style: AppTextStyle.captionMedium(context),
              ),
              SizedBox(height: context.h(16)),
              LanguageChoiceCardWidget(
                badge: LocaleKeys.common_mm.tr(),
                title: LocaleKeys.settings_languageMyanmarTitle.tr(),
                isSelected: currentLang == 'my',
                onTap: () {
                  HapticFeedback.selectionClick();
                  context.setLocale(const Locale('my'));
                },
              ),
              SizedBox(height: context.h(12)),
              LanguageChoiceCardWidget(
                badge: LocaleKeys.common_en.tr(),
                title: LocaleKeys.settings_languageEnglishTitle.tr(),
                isSelected: currentLang == 'en',
                onTap: () {
                  HapticFeedback.selectionClick();
                  context.setLocale(const Locale('en'));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
