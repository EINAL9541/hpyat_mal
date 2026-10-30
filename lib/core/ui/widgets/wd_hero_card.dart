import 'package:flutter/material.dart';
import 'package:hpyat_mal/core/extensions/context_extensions.dart';
import 'package:hpyat_mal/core/theme/app_color.dart';
import 'package:hpyat_mal/core/theme/app_text_style.dart';

/// Solid color-block House Feature Band Card (Starbucks #1E3932 / Sakura #381824)
/// following DESIGN.md ("No gradient system — surfaces are solid color-block").
class AppHeroCardWidget extends StatelessWidget {
  final List<Color>? gradientColors;
  final Widget? leading;
  final String? title;
  final TextStyle? titleStyle;
  final String? subtitle;
  final TextStyle? subtitleStyle;
  final Widget? trailing;
  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final VoidCallback? onTap;

  const AppHeroCardWidget({
    super.key,
    this.gradientColors,
    this.leading,
    this.title,
    this.titleStyle,
    this.subtitle,
    this.subtitleStyle,
    this.trailing,
    this.child,
    this.padding,
    this.borderRadius = 16,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = (gradientColors != null && gradientColors!.isNotEmpty)
        ? gradientColors!.first
        : AppColors.forestDeep;

    final card = Container(
      width: double.infinity,
      padding: padding ?? EdgeInsets.all(context.w(18)),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: context.borderRadius(all: borderRadius),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (leading != null || title != null || trailing != null)
            Row(
              children: [
                if (leading != null) ...[
                  leading!,
                  SizedBox(width: context.w(10)),
                ],
                if (title != null)
                  Expanded(
                    child: Text(
                      title!,
                      style: titleStyle ??
                          AppTextStyle.headingSmall(context).copyWith(
                            color: AppColors.baseWhite,
                          ),
                    ),
                  ),
                ?trailing,
              ],
            ),
          if (subtitle != null) ...[
            SizedBox(height: context.h(8)),
            Text(
              subtitle!,
              style: subtitleStyle ??
                  AppTextStyle.bodyMedium(context).copyWith(
                    color: AppColors.baseWhite.withValues(alpha: 0.72),
                    fontSize: 13.5,
                    height: 1.5,
                  ),
            ),
          ],
          if (child != null) ...[
            if (title != null || subtitle != null) SizedBox(height: context.h(14)),
            child!,
          ],
        ],
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: context.borderRadius(all: borderRadius),
        child: card,
      );
    }

    return card;
  }
}
