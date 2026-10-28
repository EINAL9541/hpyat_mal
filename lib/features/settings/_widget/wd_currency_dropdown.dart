import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hpyat_mal/core/models/app_currency.dart';
import 'package:hpyat_mal/core/theme/app_color.dart';
import 'package:hpyat_mal/core/theme/app_text_style.dart';
import 'package:hpyat_mal/features/forest/_provider/forest_provider.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class CurrencyDropdownWidget extends ConsumerWidget {
  final ForestState forest;
  const CurrencyDropdownWidget({super.key, required this.forest});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final langCode = context.locale.languageCode;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.w(10),
        vertical: context.h(4),
      ),
      decoration: BoxDecoration(
        color: AppColors.leafBackground,
        borderRadius: context.borderRadius(all: 10),
        border: Border.all(color: AppColors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: forest.currency.code,
          icon: Padding(
            padding: EdgeInsets.only(left: context.w(4)),
            child: Icon(
              LucideIcons.chevronDown,
              size: context.w(15),
              color: AppColors.forestPrimary,
            ),
          ),
          isDense: true,
          dropdownColor: AppColors.surfaceCard,
          borderRadius: context.borderRadius(all: 14),
          menuMaxHeight: context.h(360),
          items: AppCurrency.allCurrencies.map((c) {
            final isSelected = c.code == forest.currency.code;
            return DropdownMenuItem<String>(
              value: c.code,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    c.dropdownLabel(langCode),
                    style: AppTextStyle.bodySemiBold(context).copyWith(
                      color: isSelected
                          ? AppColors.forestPrimary
                          : AppColors.forestDeep,
                      fontSize: 13,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          selectedItemBuilder: (context) {
            return AppCurrency.allCurrencies.map((c) {
              return Text(
                c.dropdownLabel(langCode),
                style: AppTextStyle.captionSmall(context).copyWith(
                  color: AppColors.forestPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              );
            }).toList();
          },
          onChanged: (val) {
            if (val != null) {
              HapticFeedback.selectionClick();
              ref
                  .read(forestProvider.notifier)
                  .setCurrency(AppCurrency.fromCode(val));
            }
          },
        ),
      ),
    );
  }
}
