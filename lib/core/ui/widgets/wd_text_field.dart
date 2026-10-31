import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hpyat_mal/core/extensions/context_extensions.dart';
import 'package:hpyat_mal/core/theme/app_color.dart';
import 'package:hpyat_mal/core/theme/app_text_style.dart';

class AppTextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String? label;
  final TextStyle? labelStyle;
  final String? labelText;
  final String? hintText;
  final TextStyle? hintStyle;
  final TextStyle? style;
  final FocusNode? focusNode;
  final int maxLines;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;
  final TextInputAction? textInputAction;
  final bool autofocus;
  final bool isNumber;
  final bool allowDecimal;
  final String? unit;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Color? fillColor;
  final EdgeInsetsGeometry? contentPadding;
  final double borderRadius;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  const AppTextFieldWidget({
    super.key,
    required this.controller,
    this.label,
    this.labelStyle,
    this.labelText,
    this.hintText,
    this.hintStyle,
    this.style,
    this.focusNode,
    this.maxLines = 1,
    this.keyboardType,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction,
    this.autofocus = false,
    this.isNumber = false,
    this.allowDecimal = false,
    this.unit,
    this.suffixIcon,
    this.prefixIcon,
    this.fillColor,
    this.contentPadding,
    this.borderRadius = 12,
    this.onChanged,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveKeyboardType =
        keyboardType ??
        (isNumber
            ? TextInputType.numberWithOptions(decimal: allowDecimal)
            : TextInputType.text);

    final effectiveFormatters =
        inputFormatters ??
        (isNumber && !allowDecimal
            ? [FilteringTextInputFormatter.digitsOnly]
            : null);

    final Widget? effectiveSuffixIcon =
        suffixIcon ??
        (unit != null
            ? Padding(
                padding: EdgeInsets.only(
                  left: context.w(8),
                  right: context.w(16),
                ),
                child: Text(
                  unit!,
                  style: AppTextStyle.bodySemiBold(context).copyWith(
                    color: AppColors.forestPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              )
            : null);

    final field = TextField(
      controller: controller,
      focusNode: focusNode,
      maxLines: maxLines,
      keyboardType: effectiveKeyboardType,
      inputFormatters: effectiveFormatters,
      textCapitalization: textCapitalization,
      textInputAction: textInputAction,
      autofocus: autofocus,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      style:
          style ??
          AppTextStyle.bodySemiBold(context)
              .copyWith(color: AppColors.textPrimary, fontSize: 16),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: labelText != null
            ? AppTextStyle.captionMedium(context)
            : null,
        hintText: hintText,
        hintStyle:
            hintStyle ??
            AppTextStyle.bodyMedium(context)
                .copyWith(color: AppColors.textMuted.withValues(alpha: 0.7)),
        prefixIcon: prefixIcon,
        suffixIconConstraints: unit != null
            ? const BoxConstraints(minWidth: 0, minHeight: 0)
            : null,
        suffixIcon: effectiveSuffixIcon,
        filled: true,
        fillColor: fillColor ?? AppColors.surfaceCard,
        contentPadding:
            contentPadding ??
            EdgeInsets.symmetric(
              horizontal: context.w(16),
              vertical: context.h(14),
            ),
        border: OutlineInputBorder(
          borderRadius: context.borderRadius(all: borderRadius),
          borderSide: BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: context.borderRadius(all: borderRadius),
          borderSide: BorderSide(color: AppColors.border, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: context.borderRadius(all: borderRadius),
          borderSide: BorderSide(color: AppColors.emerald, width: 1.6),
        ),
      ),
    );

    if (label == null) {
      return field;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label!,
          style:
              labelStyle ??
              AppTextStyle.bodySemiBold(context)
                  .copyWith(color: AppColors.forestDeep, fontSize: 14.5),
        ),
        SizedBox(height: context.h(8)),
        field,
      ],
    );
  }
}
