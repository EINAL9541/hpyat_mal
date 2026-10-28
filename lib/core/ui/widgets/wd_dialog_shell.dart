import 'package:flutter/material.dart';
import 'package:hpyat_mal/core/extensions/context_extensions.dart';
import 'package:hpyat_mal/core/theme/app_color.dart';
import 'package:hpyat_mal/core/theme/app_text_style.dart';

class AppDialogShellWidget extends StatelessWidget {
  final IconData? icon;
  final String? title;
  final String? subtitle;
  final Widget content;
  final List<Widget>? actions;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;

  const AppDialogShellWidget({
    super.key,
    this.icon,
    this.title,
    this.subtitle,
    required this.content,
    this.actions,
    this.padding,
    this.borderRadius = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surfaceCard,
      shape: RoundedRectangleBorder(
        borderRadius: context.borderRadius(all: borderRadius),
      ),
      child: Padding(
        padding: padding ?? EdgeInsets.all(context.w(20)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (icon != null || title != null)
              Row(
                children: [
                  if (icon != null) ...[
                    Icon(
                      icon,
                      size: context.w(18),
                      color: AppColors.forestPrimary,
                    ),
                    SizedBox(width: context.w(8)),
                  ],
                  if (title != null)
                    Expanded(
                      child: Text(
                        title!,
                        style: AppTextStyle.headingSmall(context).copyWith(
                          color: AppColors.forestDeep,
                        ),
                      ),
                    ),
                ],
              ),
            if (subtitle != null) ...[
              SizedBox(height: context.h(6)),
              Text(
                subtitle!,
                style: AppTextStyle.captionMedium(context),
              ),
            ],
            SizedBox(height: context.h(14)),
            content,
            if (actions != null && actions!.isNotEmpty) ...[
              SizedBox(height: context.h(18)),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: actions!,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
