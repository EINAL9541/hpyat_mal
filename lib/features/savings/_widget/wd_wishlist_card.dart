import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hpyat_mal/core/extensions/context_extensions.dart';
import 'package:hpyat_mal/core/services/storage_service.dart';
import 'package:hpyat_mal/core/theme/app_color.dart';
import 'package:hpyat_mal/core/theme/app_text_style.dart';
import 'package:hpyat_mal/features/savings/_widget/wd_add_wishlist_dialog.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class WishlistCardWidget extends StatelessWidget {
  final WishlistItem item;
  final double currentSavings;
  final double dailySavingsRate;
  final VoidCallback onToggle;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final String Function(num amount)? formatMoney;

  const WishlistCardWidget({
    super.key,
    required this.item,
    required this.currentSavings,
    this.dailySavingsRate = 0,
    required this.onToggle,
    this.onEdit,
    this.onDelete,
    this.formatMoney,
  });

  String _format(num amount) {
    if (formatMoney != null) {
      return formatMoney!(amount);
    }
    return "${NumberFormat('#,###').format(amount.round())} MMK";
  }

  String _buildEstimateLabel(double remaining) {
    if (remaining <= 0) return "Ready to claim";
    if (dailySavingsRate <= 0) return "${_format(remaining)} to go";
    final daysLeft = (remaining / dailySavingsRate).ceil();
    if (daysLeft <= 1) return "~1 day left";
    return "~$daysLeft days left";
  }

  void _showActionsSheet(BuildContext context) {
    HapticFeedback.selectionClick();
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(context.r(16)),
        ),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.w(16),
            vertical: context.h(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: context.w(36),
                height: context.h(4),
                margin: EdgeInsets.only(bottom: context.h(12)),
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: context.borderRadius(all: 4),
                ),
              ),
              ListTile(
                leading: Container(
                  padding: EdgeInsets.all(context.w(8)),
                  decoration: BoxDecoration(
                    color: AppColors.leafSoft,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    item.isCompleted
                        ? LucideIcons.rotateCcw
                        : LucideIcons.check,
                    size: context.w(18),
                    color: AppColors.forestPrimary,
                  ),
                ),
                title: Text(
                  item.isCompleted
                      ? "Move Back to Active Goals"
                      : "Mark as Claimed",
                  style: AppTextStyle.bodySemiBold(context).copyWith(
                    color: AppColors.forestDeep,
                  ),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  onToggle();
                },
              ),
              if (onEdit != null)
                ListTile(
                  leading: Container(
                    padding: EdgeInsets.all(context.w(8)),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceCardMuted,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      LucideIcons.pencil,
                      size: context.w(18),
                      color: AppColors.forestDeep,
                    ),
                  ),
                  title: Text(
                    "Edit Goal",
                    style: AppTextStyle.bodySemiBold(context).copyWith(
                      color: AppColors.forestDeep,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    onEdit!();
                  },
                ),
              if (onDelete != null)
                ListTile(
                  leading: Container(
                    padding: EdgeInsets.all(context.w(8)),
                    decoration: const BoxDecoration(
                      color: AppColors.dangerSoft,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      LucideIcons.trash2,
                      size: context.w(18),
                      color: AppColors.danger,
                    ),
                  ),
                  title: Text(
                    "Delete Goal",
                    style: AppTextStyle.bodySemiBold(context).copyWith(
                      color: AppColors.danger,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    onDelete!();
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final safeTarget = item.targetAmount <= 0 ? 1.0 : item.targetAmount;
    final progress = (currentSavings / safeTarget).clamp(0.0, 1.0);
    final isFunded = currentSavings >= item.targetAmount;
    final remaining =
        (item.targetAmount - currentSavings).clamp(0.0, double.infinity);
    final percent = (progress * 100).toInt();

    final hasImage =
        item.imagePath != null && File(item.imagePath!).existsSync();

    return Container(
      margin: EdgeInsets.only(bottom: context.h(12)),
      padding: EdgeInsets.all(context.w(16)),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: context.borderRadius(all: 14),
        border: Border.all(
          color: item.isCompleted
              ? AppColors.skySoft
              : isFunded
                  ? AppColors.emerald
                  : AppColors.borderSubtle,
          width: isFunded && !item.isCompleted ? 1.5 : 1.0,
        ),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Visual + Title/Target + Options Menu
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 1:1 Photo or Category Icon Badge
              if (hasImage)
                ClipRRect(
                  borderRadius: context.borderRadius(all: 12),
                  child: SizedBox(
                    width: context.w(52),
                    height: context.w(52),
                    child: Image.file(
                      File(item.imagePath!),
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              else
                Container(
                  width: context.w(48),
                  height: context.w(48),
                  decoration: BoxDecoration(
                    color: item.isCompleted
                        ? AppColors.amberLight
                        : isFunded
                            ? AppColors.leafSoft
                            : AppColors.surfaceCardMuted,
                    borderRadius: context.borderRadius(all: 12),
                    border: item.isCompleted
                        ? Border.all(color: AppColors.skySoft)
                        : null,
                  ),
                  child: Icon(
                    item.isCompleted
                        ? LucideIcons.award
                        : GoalIconOption.resolve(item.iconKey),
                    size: context.w(20),
                    color: item.isCompleted
                        ? AppColors.amberWarm
                        : isFunded
                            ? AppColors.forestPrimary
                            : AppColors.forestDeep,
                  ),
                ),

              SizedBox(width: context.w(12)),

              // Title & Target Amount
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.headingSmall(context).copyWith(
                        color: AppColors.forestDeep,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: context.h(3)),
                    Row(
                      children: [
                        Text(
                          _format(item.targetAmount),
                          style: AppTextStyle.bodySemiBold(context).copyWith(
                            color: AppColors.forestPrimary,
                            fontSize: 14,
                            fontFeatures: const [
                              FontFeature.tabularFigures(),
                            ],
                          ),
                        ),
                        if (!item.isCompleted) ...[
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: context.w(6),
                            ),
                            child: Text(
                              "•",
                              style: AppTextStyle.captionSmall(context),
                            ),
                          ),
                          Flexible(
                            child: Text(
                              _buildEstimateLabel(remaining),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style:
                                  AppTextStyle.captionSmall(context).copyWith(
                                color: isFunded
                                    ? AppColors.emerald
                                    : AppColors.textMuted,
                                fontWeight: isFunded
                                    ? FontWeight.w700
                                    : FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              // More Actions Button
              InkWell(
                onTap: () => _showActionsSheet(context),
                borderRadius: context.borderRadius(all: 50),
                child: Padding(
                  padding: EdgeInsets.all(context.w(6)),
                  child: Icon(
                    LucideIcons.ellipsis,
                    size: context.w(18),
                    color: AppColors.textMuted,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: context.h(14)),

          // Progress or Claimed Status Footer
          if (item.isCompleted)
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: context.w(12),
                vertical: context.h(8),
              ),
              decoration: BoxDecoration(
                color: AppColors.amberLight,
                borderRadius: context.borderRadius(all: 10),
                border: Border.all(color: AppColors.skySoft),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Icon(
                          LucideIcons.sparkles,
                          size: context.w(14),
                          color: AppColors.amberWarm,
                        ),
                        SizedBox(width: context.w(6)),
                        Flexible(
                          child: Text(
                            "Claimed with smoke-free savings",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyle.captionSmall(context).copyWith(
                              color: AppColors.forestDeep,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: context.w(8)),
                  InkWell(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      onToggle();
                    },
                    borderRadius: context.borderRadius(all: 50),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.w(8),
                        vertical: context.h(2),
                      ),
                      child: Text(
                        "Undo",
                        style: AppTextStyle.captionSmall(context).copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          else ...[
            // Progress Bar
            ClipRRect(
              borderRadius: context.borderRadius(all: 50),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: context.h(7),
                backgroundColor: AppColors.surfaceCardMuted,
                valueColor: AlwaysStoppedAnimation<Color>(
                  isFunded ? AppColors.emerald : AppColors.amberWarm,
                ),
              ),
            ),
            SizedBox(height: context.h(8)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    isFunded
                        ? "★ Enough saved to unlock this reward!"
                        : "${_format(remaining)} more needed",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.captionSmall(context).copyWith(
                      color: isFunded
                          ? AppColors.emerald
                          : AppColors.textSecondary,
                      fontWeight:
                          isFunded ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(width: context.w(8)),
                if (isFunded)
                  InkWell(
                    onTap: () {
                      HapticFeedback.mediumImpact();
                      onToggle();
                    },
                    borderRadius: context.borderRadius(all: 50),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.w(12),
                        vertical: context.h(5),
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.emerald,
                        borderRadius: context.borderRadius(all: 50),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            LucideIcons.check,
                            size: context.w(12),
                            color: AppColors.baseWhite,
                          ),
                          SizedBox(width: context.w(4)),
                          Text(
                            "Claim Reward",
                            style: AppTextStyle.captionSmall(context).copyWith(
                              color: AppColors.baseWhite,
                              fontWeight: FontWeight.w700,
                              fontSize: 11.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  Text(
                    "$percent%",
                    style: AppTextStyle.captionSmall(context).copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.forestDeep,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
