import 'package:flutter/material.dart';
import 'package:hpyat_mal/core/extensions/context_extensions.dart';
import 'package:hpyat_mal/core/theme/app_color.dart';
import 'package:hpyat_mal/core/theme/app_text_style.dart';

class AppMetricCardWidget extends StatelessWidget {
  final IconData? icon;
  final Color? iconColor;
  final String value;
  final String unit;
  final Color? backgroundColor;
  final Color? borderColor;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final VoidCallback? onTap;

  const AppMetricCardWidget({
    super.key,
    this.icon,
    this.iconColor,
    required this.value,
    required this.unit,
    this.backgroundColor,
    this.borderColor,
    this.padding,
    this.borderRadius = 16,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      padding: padding ??
          EdgeInsets.symmetric(
            horizontal: context.w(10),
            vertical: context.h(12),
          ),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.surfaceCard,
        borderRadius: context.borderRadius(all: borderRadius),
        border: Border.all(color: borderColor ?? AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.forestDeep.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: context.w(18),
              color: iconColor ?? AppColors.forestPrimary,
            ),
            SizedBox(height: context.h(6)),
          ],
          Text(
            value,
            style: AppTextStyle.headingSmall(context).copyWith(
              color: AppColors.forestDeep,
              fontWeight: FontWeight.w700,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: context.h(2)),
          Text(
            unit,
            style: AppTextStyle.captionSmall(context),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
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
