import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hpyat_mal/core/extensions/context_extensions.dart';
import 'package:hpyat_mal/core/generate/locale_keys.g.dart';
import 'package:hpyat_mal/core/theme/app_color.dart';
import 'package:hpyat_mal/core/theme/app_text_style.dart';
import 'package:hpyat_mal/core/ui/widgets/wd_text_field.dart';
import 'package:hpyat_mal/features/forest/_provider/forest_provider.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class PersonalInfoScreen extends HookConsumerWidget {
  const PersonalInfoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    EasyLocalization.of(context);
    final forest = ref.watch(forestProvider);

    final nameController = useTextEditingController(text: forest.userName);
    final cigsPerDayController = useTextEditingController(
      text: forest.cigsPerDay.toString(),
    );
    final cigsPerPackController = useTextEditingController(
      text: forest.cigsPerPack.toString(),
    );
    final packCostController = useTextEditingController(
      text: forest.packCost.round().toString(),
    );
    final reasonController = useTextEditingController(text: forest.quitReason);
    final quitDateState = useState<DateTime>(forest.quitDate);

    Future<void> pickQuitDate() async {
      final now = DateTime.now();
      final selected = await showDatePicker(
        context: context,
        initialDate: quitDateState.value,
        firstDate: DateTime(2020),
        lastDate: now,
        builder: (ctx, child) {
          return Theme(
            data: Theme.of(ctx).copyWith(
              colorScheme: ColorScheme.light(
                primary: AppColors.forestPrimary,
                onPrimary: AppColors.baseWhite,
                onSurface: AppColors.textPrimary,
              ),
            ),
            child: child!,
          );
        },
      );
      if (selected != null) {
        quitDateState.value = DateTime(
          selected.year,
          selected.month,
          selected.day,
          quitDateState.value.hour,
          quitDateState.value.minute,
        );
      }
    }

    Future<void> saveChanges() async {
      final name = nameController.text.trim().isEmpty
          ? forest.userName
          : nameController.text.trim();
      final cigsPerDay =
          int.tryParse(cigsPerDayController.text.trim()) ?? forest.cigsPerDay;
      final cigsPerPack =
          int.tryParse(cigsPerPackController.text.trim()) ?? forest.cigsPerPack;
      final packCost =
          double.tryParse(packCostController.text.replaceAll(',', '').trim()) ??
              forest.packCost;
      final reason = reasonController.text.trim().isEmpty
          ? forest.quitReason
          : reasonController.text.trim();

      await ref.read(forestProvider.notifier).updatePersonalInfo(
            userName: name,
            cigsPerDay: cigsPerDay > 0 ? cigsPerDay : forest.cigsPerDay,
            cigsPerPack: cigsPerPack > 0 ? cigsPerPack : forest.cigsPerPack,
            packCost: packCost > 0 ? packCost : forest.packCost,
            quitReason: reason,
            quitDate: quitDateState.value,
          );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(LocaleKeys.settings_personalInfoSaved.tr()),
            backgroundColor: AppColors.forestPrimary,
            behavior: SnackBarBehavior.floating,
          ),
        );
        context.pop();
      }
    }

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
          LocaleKeys.settings_sectionPersonalInfo.tr(),
          style: AppTextStyle.headingSmall(context).copyWith(
            color: AppColors.forestDeep,
          ),
        ),
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
              AppTextFieldWidget(
                label: LocaleKeys.settings_personalInfoNameLabel.tr(),
                controller: nameController,
                hintText: LocaleKeys.onboarding_nameHint.tr(),
                borderRadius: 12,
              ),
              SizedBox(height: context.h(16)),

              // Quit Date Picker Card (12px White Surface)
              Text(
                LocaleKeys.onboarding_quitStartLabel.tr(),
                style: AppTextStyle.bodySemiBold(context).copyWith(
                  color: AppColors.forestDeep,
                  fontSize: 14.5,
                ),
              ),
              SizedBox(height: context.h(8)),
              InkWell(
                onTap: pickQuitDate,
                borderRadius: context.borderRadius(all: 12),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.w(16),
                    vertical: context.h(14),
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceCard,
                    borderRadius: context.borderRadius(all: 12),
                    border: Border.all(color: AppColors.border, width: 1.0),
                    boxShadow: AppColors.cardShadow,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat('MMMM d, yyyy').format(quitDateState.value),
                        style: AppTextStyle.bodySemiBold(context).copyWith(
                          color: AppColors.forestDeep,
                          fontSize: 16,
                        ),
                      ),
                      Icon(
                        LucideIcons.calendarDays,
                        size: context.w(19),
                        color: AppColors.forestPrimary,
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: context.h(16)),

              AppTextFieldWidget(
                label: LocaleKeys.settings_personalInfoCigsPerDayLabel.tr(),
                controller: cigsPerDayController,
                hintText: '15',
                isNumber: true,
                borderRadius: 12,
                unit: LocaleKeys.onboarding_cigsPerDayUnit.tr(),
              ),
              SizedBox(height: context.h(16)),

              AppTextFieldWidget(
                label: LocaleKeys.settings_personalInfoCigsPerPackLabel.tr(),
                controller: cigsPerPackController,
                hintText: '20',
                isNumber: true,
                borderRadius: 12,
                unit: LocaleKeys.onboarding_cigsPerPackUnit.tr(),
              ),
              SizedBox(height: context.h(16)),

              AppTextFieldWidget(
                label: LocaleKeys.settings_personalInfoPackCostLabel.tr(),
                controller: packCostController,
                hintText: '3500',
                isNumber: true,
                borderRadius: 12,
                unit: forest.currencyUnit(context.locale.languageCode),
              ),
              SizedBox(height: context.h(16)),

              AppTextFieldWidget(
                label: LocaleKeys.settings_personalInfoReasonLabel.tr(),
                controller: reasonController,
                hintText: LocaleKeys.onboarding_whyHint.tr(),
                maxLines: 2,
                borderRadius: 12,
              ),

              SizedBox(height: context.h(28)),

              // 50px Full-Pill Primary Save Button
              SizedBox(
                width: double.infinity,
                height: context.h(52),
                child: ElevatedButton(
                  onPressed: saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.emerald,
                    foregroundColor: AppColors.baseWhite,
                    shape: const StadiumBorder(),
                    elevation: 0,
                  ),
                  child: Text(
                    LocaleKeys.settings_saveChanges.tr(),
                    style: AppTextStyle.bodySemiBold(context).copyWith(
                      color: AppColors.baseWhite,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              SizedBox(height: context.h(24)),
            ],
          ),
        ),
      ),
    );
  }
}
