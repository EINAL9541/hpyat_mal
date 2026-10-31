import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hpyat_mal/core/extensions/context_extensions.dart';
import 'package:hpyat_mal/core/generate/locale_keys.g.dart';
import 'package:hpyat_mal/core/theme/app_color.dart';
import 'package:hpyat_mal/core/theme/app_text_style.dart';
import 'package:hpyat_mal/core/ui/widgets/wd_app_page_app_bar.dart';
import 'package:hpyat_mal/features/forest/_provider/forest_provider.dart';
import 'package:hpyat_mal/features/settings/_widget/wd_theme_choice_card.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class ThemeScreen extends ConsumerWidget {
  const ThemeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plantTheme = ref.watch(forestProvider.select((s) => s.plantTheme));

    updateTheme(PlantThemeType type) {
      HapticFeedback.selectionClick();
      ref.read(forestProvider.notifier).setPlantTheme(type);
    }

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppPageAppBarWidget(title: LocaleKeys.settings_themeTitle.tr()),
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
                LocaleKeys.settings_themeSectionTitle.tr(),
                style: AppTextStyle.headingSmall(context)
                    .copyWith(color: AppColors.forestPrimary),
              ),
              SizedBox(height: context.h(4)),
              Text(
                LocaleKeys.settings_themeSectionDesc.tr(),
                style: AppTextStyle.captionMedium(context),
              ),
              SizedBox(height: context.h(16)),
              ThemeChoiceCardWidget(
                icon: LucideIcons.treeDeciduous,
                title: LocaleKeys.settings_emeraldTreeTitle.tr(),
                subtitle: LocaleKeys.settings_emeraldTreeSubtitle.tr(),
                isSelected: plantTheme.isEmerald,
                accentColor: AppThemePalette.emeraldForest.emerald,
                softColor: AppThemePalette.emeraldForest.leafSoft,
                onTap: () => updateTheme(PlantThemeType.emerald),
              ),
              SizedBox(height: context.h(12)),
              ThemeChoiceCardWidget(
                icon: LucideIcons.flower2,
                title: LocaleKeys.settings_cherryTreeTitle.tr(),
                subtitle: LocaleKeys.settings_cherryTreeSubtitle.tr(),
                isSelected: plantTheme.isCherry,
                accentColor: AppThemePalette.cherryBlossom.emerald,
                softColor: AppThemePalette.cherryBlossom.leafSoft,
                onTap: () => updateTheme(PlantThemeType.cherry),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
