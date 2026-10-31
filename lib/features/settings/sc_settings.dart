import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hpyat_mal/core/extensions/context_extensions.dart';
import 'package:hpyat_mal/core/generate/locale_keys.g.dart';
import 'package:hpyat_mal/core/router/app_router_key.dart';
import 'package:hpyat_mal/core/theme/app_color.dart';
import 'package:hpyat_mal/core/ui/widgets/wd_app_page_app_bar.dart';
import 'package:hpyat_mal/features/forest/_provider/forest_provider.dart';
import 'package:hpyat_mal/features/settings/_widget/wd_currency_dropdown.dart';
import 'package:hpyat_mal/features/settings/_widget/wd_setting_group_card.dart';
import 'package:hpyat_mal/features/settings/_widget/wd_setting_primary_card.dart';
import 'package:hpyat_mal/features/settings/_widget/wd_settings_group_divider.dart';
import 'package:hpyat_mal/features/settings/_widget/wd_settings_tile.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    EasyLocalization.of(context);
    final forest = ref.watch(forestProvider);
    final isCherry = forest.plantTheme.isCherry;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppPageAppBarWidget(title: LocaleKeys.settings_title.tr()),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: context.w(16),
            vertical: context.h(12),
          ),
          child: Column(
            crossAxisAlignment: .start,
            spacing: context.h(16),
            children: [
              SettingPrimaryCardWidget(
                username: forest.userName,
                smokingFreeDays: forest.days,
                isCherry: isCherry,
              ),
              SettingsGroupCardWidget(
                children: [
                  SettingsGroupItemWidget(
                    icon: LucideIcons.userPen,
                    title: LocaleKeys.settings_personalInfoTitle.tr(),
                    onTap: () =>
                        context.push(RouteKeys.settingsPersonalInfo.path),
                  ),
                  const SettingsGroupDividerWidget(),
                  SettingsGroupItemWidget(
                    icon: LucideIcons.palette,
                    title: LocaleKeys.settings_themeTitle.tr(),
                    onTap: () => context.push(RouteKeys.settingsTheme.path),
                  ),
                  const SettingsGroupDividerWidget(),
                  SettingsGroupItemWidget(
                    icon: LucideIcons.languages,
                    title: LocaleKeys.settings_languageTitle.tr(),
                    onTap: () => context.push(RouteKeys.settingsLanguage.path),
                  ),
                  const SettingsGroupDividerWidget(),
                  SettingsGroupItemWidget(
                    icon: LucideIcons.coins,
                    title: LocaleKeys.settings_currencyTitle.tr(),
                    trailingWidget: CurrencyDropdownWidget(forest: forest),
                  ),
                  const SettingsGroupDividerWidget(),
                  SettingsGroupItemWidget(
                    icon: LucideIcons.info,
                    title: LocaleKeys.settings_aboutUsTitle.tr(),
                    onTap: () => context.push(RouteKeys.settingsAboutUs.path),
                  ),
                  const SettingsGroupDividerWidget(),
                  SettingsGroupItemWidget(
                    icon: LucideIcons.messageSquareHeart,
                    title: LocaleKeys.settings_feedbackTitle.tr(),
                    onTap: () => context.push(RouteKeys.settingsFeedback.path),
                  ),
                ],
              ),

              SizedBox(height: context.h(24)),
            ],
          ),
        ),
      ),
    );
  }
}
