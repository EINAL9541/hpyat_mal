import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:hpyat_mal/core/extensions/context_extensions.dart';
import 'package:hpyat_mal/core/theme/app_color.dart';
import 'package:hpyat_mal/core/theme/app_text_style.dart';
import 'package:hpyat_mal/core/ui/widgets/wd_dialog_shell.dart';
import 'package:hpyat_mal/core/ui/widgets/wd_text_field.dart';

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

  void _showEditReasonDialog(BuildContext context) {
    final controller = TextEditingController(text: quitReason);
    showDialog(
      context: context,
      builder: (dialogContext) => AppDialogShellWidget(
        title: "Your Anchor Reason",
        subtitle: "Remind yourself why you chose to stay smoke-free.",
        content: AppTextFieldWidget(
          controller: controller,
          maxLines: 2,
          autofocus: true,
          hintText: "Why are you quitting?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              "Cancel",
              style: AppTextStyle.bodySemiBold(context).copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          SizedBox(width: context.w(8)),
          ElevatedButton(
            onPressed: () {
              final updated = controller.text.trim();
              if (updated.isNotEmpty) {
                onUpdateReason(updated);
              }
              Navigator.pop(dialogContext);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.emerald,
              shape: const StadiumBorder(),
            ),
            child: Text(
              "Save",
              style: AppTextStyle.bodySemiBold(context).copyWith(
                color: AppColors.baseWhite,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showEditReasonDialog(context),
      borderRadius: context.borderRadius(all: 12),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: context.w(16),
          vertical: context.h(14),
        ),
        decoration: BoxDecoration(
          color: AppColors.amberLight,
          borderRadius: context.borderRadius(all: 12),
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
                      children: [
                        Text(
                          "★ MY PROMISE",
                          style: AppTextStyle.captionSmall(context).copyWith(
                            color: AppColors.forestDeep,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                            fontSize: 10.5,
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          LucideIcons.penLine,
                          size: context.w(12),
                          color: AppColors.textMuted,
                        ),
                      ],
                    ),
                    SizedBox(height: context.h(4)),
                    Text(
                      quitReason,
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
