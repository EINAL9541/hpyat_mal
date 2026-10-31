import 'package:flutter/material.dart';
import 'package:hpyat_mal/core/extensions/context_extensions.dart';
import 'package:hpyat_mal/core/theme/app_color.dart';
import 'package:hpyat_mal/core/theme/app_text_style.dart';

class AppStatusBadgeWidget extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Widget? iconWidget;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final TextStyle? textStyle;
  final VoidCallback? onTap;

  const AppStatusBadgeWidget({
    super.key,
    required this.label,
    this.icon,
    this.iconWidget,
    this.backgroundColor,
    this.foregroundColor,
    this.padding,
    this.borderRadius = 50,
    this.textStyle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final fgColor = foregroundColor ?? AppColors.forestPrimary;
    final bg = backgroundColor ?? AppColors.leafSoft;

    final badge = Container(
      padding:
          padding ??
          EdgeInsets.symmetric(
            horizontal: context.w(10),
            vertical: context.h(4),
          ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: context.borderRadius(all: borderRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (iconWidget != null) ...[
            iconWidget!,
            SizedBox(width: context.w(4)),
          ] else if (icon != null) ...[
            Icon(icon, size: context.w(12), color: fgColor),
            SizedBox(width: context.w(4)),
          ],
          Text(
            label,
            style:
                textStyle ??
                AppTextStyle.captionSmall(context)
                    .copyWith(color: fgColor, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: badge);
    }

    return badge;
  }
}
