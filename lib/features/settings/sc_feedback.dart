import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hpyat_mal/core/extensions/context_extensions.dart';
import 'package:hpyat_mal/core/generate/locale_keys.g.dart';
import 'package:hpyat_mal/core/theme/app_color.dart';
import 'package:hpyat_mal/core/theme/app_text_style.dart';
import 'package:hpyat_mal/core/ui/widgets/wd_text_field.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class FeedbackScreen extends HookWidget {
  const FeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    EasyLocalization.of(context);
    final selectedRating = useState<int>(5);
    final selectedCategoryIndex = useState<int>(0);
    final messageController = useTextEditingController();
    useListenable(messageController);

    final categories = [
      LocaleKeys.settings_feedbackCatGeneral.tr(),
      LocaleKeys.settings_feedbackCatFeature.tr(),
      LocaleKeys.settings_feedbackCatBug.tr(),
      LocaleKeys.settings_feedbackCatAppreciation.tr(),
    ];

    final canSubmit = messageController.text.trim().isNotEmpty;

    void submitFeedback() {
      FocusScope.of(context).unfocus();
      HapticFeedback.mediumImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                LucideIcons.circleCheck,
                color: AppColors.baseWhite,
                size: context.w(18),
              ),
              SizedBox(width: context.w(10)),
              Expanded(
                child: Text(
                  LocaleKeys.settings_feedbackSubmittedToast.tr(),
                  style: AppTextStyle.captionMedium(context).copyWith(
                    color: AppColors.baseWhite,
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.forestPrimary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: context.borderRadius(all: 14),
          ),
        ),
      );
      context.pop();
    }

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
          LocaleKeys.settings_feedbackTitle.tr(),
          style: AppTextStyle.headingSmall(context).copyWith(
            color: AppColors.forestDeep,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: context.w(22),
                  vertical: context.h(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Star Rating Card
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(context.w(18)),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceCard,
                        borderRadius: context.borderRadius(all: 18),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        children: [
                          Text(
                            LocaleKeys.settings_feedbackRateQuestion.tr(),
                            textAlign: TextAlign.center,
                            style: AppTextStyle.bodySemiBold(context).copyWith(
                              color: AppColors.forestDeep,
                              fontSize: 15,
                              height: 1.6,
                            ),
                          ),
                          SizedBox(height: context.h(12)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(5, (index) {
                              final starNumber = index + 1;
                              final isFilled =
                                  starNumber <= selectedRating.value;
                              return GestureDetector(
                                onTap: () {
                                  HapticFeedback.selectionClick();
                                  selectedRating.value = starNumber;
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: context.w(6),
                                  ),
                                  child: Icon(
                                    LucideIcons.star,
                                    size: context.w(30),
                                    color: isFilled
                                        ? AppColors.amberWarm
                                        : AppColors.border,
                                  ),
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: context.h(18)),

                    // 2. Category Selector
                    Text(
                      LocaleKeys.settings_feedbackCategoryLabel.tr(),
                      style: AppTextStyle.bodySemiBold(context).copyWith(
                        color: AppColors.forestDeep,
                        height: 1.6,
                      ),
                    ),
                    SizedBox(height: context.h(10)),
                    Wrap(
                      spacing: context.w(8),
                      runSpacing: context.h(8),
                      children: List.generate(categories.length, (index) {
                        final isSelected = selectedCategoryIndex.value == index;
                        return GestureDetector(
                          onTap: () {
                            HapticFeedback.selectionClick();
                            selectedCategoryIndex.value = index;
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 160),
                            padding: EdgeInsets.symmetric(
                              horizontal: context.w(14),
                              vertical: context.h(8),
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.forestPrimary
                                  : AppColors.surfaceCard,
                              borderRadius: context.borderRadius(all: 20),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.forestPrimary
                                    : AppColors.border,
                              ),
                            ),
                            child: Text(
                              categories[index],
                              style:
                                  AppTextStyle.captionMedium(context).copyWith(
                                color: isSelected
                                    ? AppColors.baseWhite
                                    : AppColors.textSecondary,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w600,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),

                    SizedBox(height: context.h(18)),

                    // 3. Feedback Message Box
                    AppTextFieldWidget(
                      label: LocaleKeys.settings_feedbackMessageLabel.tr(),
                      controller: messageController,
                      maxLines: 5,
                      hintText: LocaleKeys.settings_feedbackMessageHint.tr(),
                      borderRadius: 16,
                      contentPadding: EdgeInsets.all(context.w(16)),
                      style: AppTextStyle.bodyMedium(context).copyWith(
                        color: AppColors.forestDeep,
                        height: 1.6,
                      ),
                      hintStyle: AppTextStyle.bodyMedium(context).copyWith(
                        color: AppColors.textMuted,
                        height: 1.6,
                      ),
                    ),

                    SizedBox(height: context.h(16)),
                  ],
                ),
              ),
            ),

            // Fixed Bottom Submit Button
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(
                context.w(22),
                context.h(12),
                context.w(22),
                context.h(16),
              ),
              decoration: BoxDecoration(
                color: AppColors.surface,
                border: Border(
                  top: BorderSide(
                    color: AppColors.border.withValues(alpha: 0.7),
                  ),
                ),
              ),
              child: SizedBox(
                width: double.infinity,
                height: context.h(52),
                child: ElevatedButton.icon(
                  onPressed: canSubmit ? submitFeedback : null,
                  icon: Icon(LucideIcons.send, size: context.w(17)),
                  label: Text(
                    LocaleKeys.settings_feedbackSubmitBtn.tr(),
                    style: AppTextStyle.bodySemiBold(context).copyWith(
                      color:
                          canSubmit ? AppColors.baseWhite : AppColors.textMuted,
                      fontSize: 16,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.forestPrimary,
                    foregroundColor: AppColors.baseWhite,
                    disabledBackgroundColor: AppColors.border,
                    disabledForegroundColor: AppColors.textMuted,
                    shape: RoundedRectangleBorder(
                      borderRadius: context.borderRadius(all: 16),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
