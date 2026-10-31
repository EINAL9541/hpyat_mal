import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hpyat_mal/core/extensions/context_extensions.dart';
import 'package:hpyat_mal/core/generate/locale_keys.g.dart';
import 'package:hpyat_mal/core/theme/app_color.dart';
import 'package:hpyat_mal/core/theme/app_text_style.dart';
import 'package:hpyat_mal/core/ui/widgets/wd_bottom_sheet.dart';
import 'package:hpyat_mal/core/ui/widgets/wd_text_field.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Starbucks Gold Ceremony Card (#FAF6EE Gold Lightest wash + #CBA258 Gold accent)
class MotivationAnchorCardWidget extends StatelessWidget {
  final String userName;
  final String quitReason;
  final Function(String newReason) onUpdateReason;

  const MotivationAnchorCardWidget({
    super.key,
    required this.userName,
    required this.quitReason,
    required this.onUpdateReason,
  });

  void _openEditReasonSheet(BuildContext context) {
    HapticFeedback.selectionClick();
    showAppBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => _EditPromiseSheet(
        initialReason: quitReason,
        onSave: onUpdateReason,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _openEditReasonSheet(context),
      borderRadius: context.borderRadius(all: 14),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: context.w(16),
          vertical: context.h(14),
        ),
        decoration: BoxDecoration(
          color: AppColors.amberLight,
          borderRadius: context.borderRadius(all: 14),
          border: Border.all(color: AppColors.skySoft, width: 1),
          boxShadow: AppColors.cardShadow,
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: context.w(3.5),
                decoration: BoxDecoration(
                  color: AppColors.amberWarm,
                  borderRadius: context.borderRadius(all: 4),
                ),
              ),
              SizedBox(width: context.w(12)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '★  ',
                                style: AppTextStyle.captionSmall(context)
                                    .copyWith(
                                      color: AppColors.amberWarm,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 10.5,
                                      height: 1.2,
                                    ),
                              ),
                              TextSpan(
                                text: LocaleKeys.forest_myPromise.tr(),
                                style: AppTextStyle.captionSmall(context)
                                    .copyWith(
                                      color: AppColors.forestDeep,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.8,
                                      fontSize: 10.5,
                                      height: 1.2,
                                    ),
                              ),
                            ],
                          ),
                          textHeightBehavior: const TextHeightBehavior(
                            applyHeightToFirstAscent: false,
                            applyHeightToLastDescent: false,
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          LucideIcons.penLine,
                          size: context.w(13),
                          color: AppColors.textMuted,
                        ),
                      ],
                    ),
                    SizedBox(height: context.h(5)),
                    Text(
                      quitReason,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.bodySemiBold(context).copyWith(
                        color: AppColors.forestDeep,
                        fontSize: 15,
                        height: 1.45,
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

class _EditPromiseSheet extends StatefulWidget {
  final String initialReason;
  final ValueChanged<String> onSave;

  const _EditPromiseSheet({
    required this.initialReason,
    required this.onSave,
  });

  @override
  State<_EditPromiseSheet> createState() => _EditPromiseSheetState();
}

class _EditPromiseSheetState extends State<_EditPromiseSheet> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialReason);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        context.w(20),
        context.h(12),
        context.w(20),
        bottomInset + context.h(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppSheetHandle(),
          SizedBox(height: context.h(16)),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocaleKeys.forest_editPromiseTitle.tr(),
                      style: AppTextStyle.headingMedium(context)
                          .copyWith(color: AppColors.forestDeep),
                    ),
                    SizedBox(height: context.h(2)),
                    Text(
                      LocaleKeys.forest_editPromiseSubtitle.tr(),
                      style: AppTextStyle.captionMedium(context),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(
                  LucideIcons.x,
                  size: context.w(18),
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
          SizedBox(height: context.h(16)),
          AppTextFieldWidget(
            controller: _controller,
            maxLines: 3,
            autofocus: true,
            hintText: LocaleKeys.forest_editPromiseHint.tr(),
          ),
          SizedBox(height: context.h(20)),
          SizedBox(
            width: double.infinity,
            height: context.h(48),
            child: ElevatedButton(
              onPressed: () {
                final updated = _controller.text.trim();
                if (updated.isNotEmpty) {
                  HapticFeedback.mediumImpact();
                  widget.onSave(updated);
                }
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.emerald,
                foregroundColor: AppColors.baseWhite,
                elevation: 0,
                shape: const StadiumBorder(),
              ),
              child: Text(
                LocaleKeys.forest_savePromiseBtn.tr(),
                textHeightBehavior: const TextHeightBehavior(
                  applyHeightToFirstAscent: false,
                  applyHeightToLastDescent: false,
                ),
                style: AppTextStyle.bodySemiBold(context).copyWith(
                  color: AppColors.baseWhite,
                  height: 1.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
