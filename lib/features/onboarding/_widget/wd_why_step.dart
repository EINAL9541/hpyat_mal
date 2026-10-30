import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hpyat_mal/core/extensions/context_extensions.dart';
import 'package:hpyat_mal/core/generate/locale_keys.g.dart';
import 'package:hpyat_mal/core/theme/app_color.dart';
import 'package:hpyat_mal/core/theme/app_text_style.dart';
import 'package:hpyat_mal/core/ui/widgets/wd_text_field.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class WhyStepWidget extends StatelessWidget {
  static const int customWhyOptionIndex = 5;

  final ValueNotifier<int?> selectedWhyIndex;
  final TextEditingController customWhyController;
  final FocusNode customWhyFocusNode;
  final List<String> whySuggestions;

  const WhyStepWidget({
    super.key,
    required this.selectedWhyIndex,
    required this.customWhyController,
    required this.customWhyFocusNode,
    required this.whySuggestions,
  });

  static const _suggestionIcons = [
    LucideIcons.users,
    LucideIcons.wind,
    LucideIcons.piggyBank,
    LucideIcons.heartPulse,
    LucideIcons.sparkles,
  ];

  @override
  Widget build(BuildContext context) {
    final isCustomSelected = selectedWhyIndex.value == customWhyOptionIndex;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: context.w(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: context.h(12)),
          Text(
            LocaleKeys.onboarding_whyTitle.tr(),
            style: AppTextStyle.headingLarge(context).copyWith(
              color: AppColors.forestPrimary,
              fontSize: 24,
              height: 1.4,
            ),
          ),
          SizedBox(height: context.h(8)),
          Text(
            LocaleKeys.onboarding_whySubtitle.tr(),
            style: AppTextStyle.bodyMedium(context).copyWith(
              color: AppColors.textSecondary,
              fontSize: 15,
              height: 1.6,
            ),
          ),
          SizedBox(height: context.h(18)),

          Text(
            LocaleKeys.onboarding_tapForSuggestions.tr(),
            style: AppTextStyle.bodySemiBold(context).copyWith(
              color: AppColors.forestDeep,
              fontSize: 14.5,
              height: 1.55,
            ),
          ),
          SizedBox(height: context.h(10)),

          // 1..5: Preset Vow Cards (12px white cards with Starbucks 2px active ring)
          ...List.generate(whySuggestions.length, (index) {
            final suggestion = whySuggestions[index];
            final iconData = _suggestionIcons[index % _suggestionIcons.length];
            final isSelected = selectedWhyIndex.value == index;

            return Padding(
              padding: EdgeInsets.only(bottom: context.h(9)),
              child: InkWell(
                onTap: () {
                  HapticFeedback.selectionClick();
                  selectedWhyIndex.value = index;
                  FocusScope.of(context).unfocus();
                },
                borderRadius: context.borderRadius(all: 12),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: context.w(14),
                    vertical: context.h(12),
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceCard,
                    borderRadius: context.borderRadius(all: 12),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.emerald
                          : AppColors.borderSubtle,
                      width: isSelected ? 2.0 : 1.0,
                    ),
                    boxShadow: AppColors.cardShadow,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: context.w(36),
                        height: context.h(36),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.emerald
                              : AppColors.leafSoft,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          iconData,
                          size: context.w(17),
                          color: isSelected
                              ? AppColors.baseWhite
                              : AppColors.forestPrimary,
                        ),
                      ),
                      SizedBox(width: context.w(12)),
                      Expanded(
                        child: Text(
                          suggestion,
                          style: AppTextStyle.bodyMedium(context).copyWith(
                            color: AppColors.forestDeep,
                            fontWeight:
                                isSelected ? FontWeight.w700 : FontWeight.w500,
                            fontSize: 14.5,
                            height: 1.5,
                          ),
                        ),
                      ),
                      if (isSelected) ...[
                        SizedBox(width: context.w(8)),
                        Icon(
                          LucideIcons.circleCheck,
                          size: context.w(19),
                          color: AppColors.emerald,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          }),

          // 6th Card: "Write my own reason"
          InkWell(
            onTap: () {
              HapticFeedback.selectionClick();
              selectedWhyIndex.value = customWhyOptionIndex;
              Future.microtask(customWhyFocusNode.requestFocus);
            },
            borderRadius: context.borderRadius(all: 12),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: context.w(14),
                vertical: context.h(12),
              ),
              decoration: BoxDecoration(
                color: AppColors.surfaceCard,
                borderRadius: context.borderRadius(all: 12),
                border: Border.all(
                  color: isCustomSelected
                      ? AppColors.emerald
                      : AppColors.borderSubtle,
                  width: isCustomSelected ? 2.0 : 1.0,
                ),
                boxShadow: AppColors.cardShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: context.w(36),
                        height: context.h(36),
                        decoration: BoxDecoration(
                          color: isCustomSelected
                              ? AppColors.emerald
                              : AppColors.leafSoft,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          LucideIcons.penLine,
                          size: context.w(17),
                          color: isCustomSelected
                              ? AppColors.baseWhite
                              : AppColors.forestPrimary,
                        ),
                      ),
                      SizedBox(width: context.w(12)),
                      Expanded(
                        child: Text(
                          LocaleKeys.onboarding_customWhyLabel.tr(),
                          style: AppTextStyle.bodyMedium(context).copyWith(
                            color: AppColors.forestDeep,
                            fontWeight: isCustomSelected
                                ? FontWeight.w700
                                : FontWeight.w500,
                            fontSize: 14.5,
                            height: 1.5,
                          ),
                        ),
                      ),
                      if (isCustomSelected) ...[
                        SizedBox(width: context.w(8)),
                        Icon(
                          LucideIcons.circleCheck,
                          size: context.w(19),
                          color: AppColors.emerald,
                        ),
                      ],
                    ],
                  ),
                  if (isCustomSelected) ...[
                    SizedBox(height: context.h(10)),
                    AppTextFieldWidget(
                      controller: customWhyController,
                      focusNode: customWhyFocusNode,
                      maxLines: 2,
                      textInputAction: TextInputAction.done,
                      hintText: LocaleKeys.onboarding_whyHint.tr(),
                      borderRadius: 12,
                      fillColor: AppColors.surfaceCardMuted,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: context.w(14),
                        vertical: context.h(12),
                      ),
                      style: AppTextStyle.bodyMedium(context).copyWith(
                        color: AppColors.forestDeep,
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        height: 1.6,
                      ),
                      hintStyle: AppTextStyle.bodyMedium(context).copyWith(
                        color: AppColors.textMuted,
                        fontSize: 14.5,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          SizedBox(height: context.h(16)),
        ],
      ),
    );
  }
}
