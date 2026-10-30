import 'package:flutter/material.dart';
import 'package:hpyat_mal/core/extensions/context_extensions.dart';
import 'package:hpyat_mal/core/theme/app_color.dart';
import 'package:hpyat_mal/core/theme/app_text_style.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class SettingsGroupItemWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final IconData? trailingIcon;
  final Widget? trailingWidget;
  final VoidCallback? onTap;

  const SettingsGroupItemWidget({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,

    this.trailingIcon,
    this.trailingWidget,
  });

  @override
  Widget build(BuildContext context) {
    final content = ConstrainedBox(
      constraints: BoxConstraints(minHeight: context.h(52)),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: context.w(16),
          vertical: context.h(12),
        ),
        child: Row(
          children: [
            Container(
              width: context.w(40),
              height: context.h(40),
              decoration: BoxDecoration(
                color: AppColors.leafSoft,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: context.w(18),
                color: AppColors.forestPrimary,
              ),
            ),
            SizedBox(width: context.w(14)),
            Expanded(
              child: Text(
                title,
                style: AppTextStyle.bodySemiBold(context).copyWith(
                  color: AppColors.forestDeep,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  height: 1.6,
                ),
              ),
            ),
            if (trailingWidget != null) ...[
              SizedBox(width: context.w(6)),
              trailingWidget!,
            ] else ...[
              SizedBox(width: context.w(6)),
              Icon(
                trailingIcon ?? LucideIcons.chevronRight,
                size: context.w(18),
                color: AppColors.textMuted,
              ),
            ],
          ],
        ),
      ),
    );

    return Material(
      color: Colors.transparent,
      child: onTap != null ? InkWell(onTap: onTap, child: content) : content,
    );
  }
}

/// Subtle dividing line between settings rows.
