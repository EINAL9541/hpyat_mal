import 'package:flutter/material.dart';
import 'package:hpyat_mal/core/extensions/context_extensions.dart';
import 'package:hpyat_mal/core/theme/app_color.dart';
import 'package:hpyat_mal/core/theme/app_text_style.dart';

class AppSectionHeaderWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final EdgeInsetsGeometry? padding;

  const AppSectionHeaderWidget({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
    this.titleStyle,
    this.subtitleStyle,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final content = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: titleStyle ??
                    AppTextStyle.headingMedium(context).copyWith(
                      color: AppColors.forestPrimary,
                    ),
              ),
              if (subtitle != null) ...[
                SizedBox(height: context.h(2)),
                Text(
                  subtitle!,
                  style: subtitleStyle ?? AppTextStyle.captionMedium(context),
                ),
              ],
            ],
          ),
        ),
        if (trailing != null) ...[
          SizedBox(width: context.w(12)),
          trailing!,
        ],
      ],
    );

    if (padding != null) {
      return Padding(padding: padding!, child: content);
    }

    return content;
  }
}
