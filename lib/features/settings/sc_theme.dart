import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hpyat_mal/core/extensions/context_extensions.dart';
import 'package:hpyat_mal/core/generate/locale_keys.g.dart';
import 'package:hpyat_mal/core/theme/app_color.dart';
import 'package:hpyat_mal/core/theme/app_text_style.dart';
import 'package:hpyat_mal/features/forest/_provider/forest_provider.dart';
import 'package:hpyat_mal/features/settings/_widget/wd_theme_choice_card.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class ThemeScreen extends ConsumerWidget {
  const ThemeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plantTheme = ref.watch(forestProvider.select((s) => s.plantTheme));

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
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
          LocaleKeys.settings_themeTitle.tr(),
          style: AppTextStyle.headingSmall(context)
              .copyWith(color: AppColors.forestDeep),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: context.w(22),
            vertical: context.h(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocaleKeys.settings_themeSectionTitle.tr(),
                style: AppTextStyle.headingSmall(context)
                    .copyWith(color: AppColors.forestDeep),
              ),
              SizedBox(height: context.h(4)),
              Text(
                LocaleKeys.settings_themeSectionDesc.tr(),
                style: AppTextStyle.captionMedium(context),
              ),
              SizedBox(height: context.h(14)),
              ThemeChoiceCardWidget(
                imageAsset: 'assets/images/deciduous_tree.png',
                title: LocaleKeys.settings_emeraldTreeTitle.tr(),
                subtitle: LocaleKeys.settings_emeraldTreeSubtitle.tr(),
                isSelected: plantTheme.isEmerald,
                accentColor: const Color(0xFF1B4D3E),
                softColor: const Color(0xFFD8F3DC),
                onTap: () {
                  HapticFeedback.selectionClick();
                  ref
                      .read(forestProvider.notifier)
                      .setPlantTheme(PlantThemeType.emerald);
                },
              ),
              SizedBox(height: context.h(12)),
              ThemeChoiceCardWidget(
                imageAsset: 'assets/images/cherry_blossom.png',
                title: LocaleKeys.settings_cherryTreeTitle.tr(),
                subtitle: LocaleKeys.settings_cherryTreeSubtitle.tr(),
                isSelected: plantTheme.isCherry,
                accentColor: const Color(0xFF9C2D56),
                softColor: const Color(0xFFFCE4EE),
                onTap: () {
                  HapticFeedback.selectionClick();
                  ref
                      .read(forestProvider.notifier)
                      .setPlantTheme(PlantThemeType.cherry);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
