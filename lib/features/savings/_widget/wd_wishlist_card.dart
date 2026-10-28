import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:hpyat_mal/core/extensions/context_extensions.dart';
import 'package:hpyat_mal/core/services/storage_service.dart';
import 'package:hpyat_mal/core/theme/app_color.dart';
import 'package:hpyat_mal/core/theme/app_text_style.dart';

class WishlistCardWidget extends StatelessWidget {
  final WishlistItem item;
  final double currentSavings;
  final VoidCallback onToggle;
  final String Function(num amount)? formatMoney;

  const WishlistCardWidget({
    super.key,
    required this.item,
    required this.currentSavings,
    required this.onToggle,
    this.formatMoney,
  });

  String _format(num amount) {
    if (formatMoney != null) {
      return formatMoney!(amount);
    }
    return "${NumberFormat('#,###').format(amount.round())} MMK";
  }

  @override
  Widget build(BuildContext context) {
    final progress = (currentSavings / item.targetAmount).clamp(0.0, 1.0);
    final isFunded = currentSavings >= item.targetAmount;
    final percent = (progress * 100).toInt();

    return Container(
      margin: EdgeInsets.only(bottom: context.h(12)),
      padding: EdgeInsets.all(context.w(16)),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: context.borderRadius(all: 18),
        border: Border.all(
          color: item.isCompleted
              ? AppColors.border
              : isFunded
                  ? AppColors.mintAccent
                  : AppColors.border,
          width: isFunded && !item.isCompleted ? 1.5 : 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: context.w(38),
                height: context.h(38),
                decoration: BoxDecoration(
                  color: item.isCompleted
                      ? AppColors.surfaceCardMuted
                      : isFunded
                          ? AppColors.leafSoft
                          : AppColors.amberLight,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  item.isCompleted
                      ? LucideIcons.check
                      : _resolveIcon(item.iconKey),
                  size: context.w(18),
                  color: item.isCompleted
                      ? AppColors.textMuted
                      : isFunded
                          ? AppColors.forestPrimary
                          : AppColors.amberWarm,
                ),
              ),
              SizedBox(width: context.w(12)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: AppTextStyle.headingSmall(context).copyWith(
                        color: item.isCompleted
                            ? AppColors.textMuted
                            : AppColors.forestDeep,
                        decoration: item.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(height: context.h(2)),
                    Text(
                      item.isCompleted
                          ? "Claimed with smoke-free savings!"
                          : isFunded
                              ? "Fully funded! 🎉 Treat yourself"
                              : "${_format(item.targetAmount - currentSavings)} remaining",
                      style: AppTextStyle.captionSmall(context).copyWith(
                        color: isFunded && !item.isCompleted
                            ? AppColors.emerald
                            : AppColors.textSecondary,
                        fontWeight: isFunded ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _format(item.targetAmount),
                    style: AppTextStyle.headingSmall(context).copyWith(
                      color: AppColors.forestDeep,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: context.h(2)),
                  InkWell(
                    onTap: onToggle,
                    child: Text(
                      item.isCompleted ? "Undo" : "Mark Bought",
                      style: AppTextStyle.captionSmall(context).copyWith(
                        color: AppColors.forestPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          if (!item.isCompleted) ...[
            SizedBox(height: context.h(12)),
            ClipRRect(
              borderRadius: context.borderRadius(all: 6),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: context.h(6),
                backgroundColor: AppColors.borderSubtle,
                valueColor: AlwaysStoppedAnimation<Color>(
                  isFunded ? AppColors.emerald : AppColors.amberWarm,
                ),
              ),
            ),
            SizedBox(height: context.h(6)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${_format(currentSavings)} saved so far",
                  style: AppTextStyle.captionSmall(context),
                ),
                Text(
                  "$percent%",
                  style: AppTextStyle.captionSmall(context).copyWith(
                    fontWeight: FontWeight.w700,
                    color: isFunded ? AppColors.emerald : AppColors.amberWarm,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  IconData _resolveIcon(String key) {
    switch (key) {
      case 'footprints':
        return LucideIcons.footprints;
      case 'mountain':
        return LucideIcons.mountain;
      case 'headphones':
        return LucideIcons.headphones;
      case 'watch':
        return LucideIcons.watch;
      case 'coffee':
        return LucideIcons.coffee;
      default:
        return LucideIcons.gift;
    }
  }
}
