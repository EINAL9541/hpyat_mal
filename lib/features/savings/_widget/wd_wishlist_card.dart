import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hpyat_mal/core/extensions/context_extensions.dart';
import 'package:hpyat_mal/core/generate/locale_keys.g.dart';
import 'package:hpyat_mal/core/services/storage_service.dart';
import 'package:hpyat_mal/core/theme/app_color.dart';
import 'package:hpyat_mal/core/theme/app_text_style.dart';
import 'package:hpyat_mal/core/ui/widgets/wd_bottom_sheet.dart';
import 'package:hpyat_mal/features/savings/_widget/wd_add_wishlist_dialog.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class WishlistCardWidget extends StatelessWidget {
  final WishlistItem item;
  final double currentSavings;
  final double dailySavingsRate;
  final VoidCallback onToggle;
  final VoidCallback? onEdit;
  final VoidCallback? onChangePhoto;
  final VoidCallback? onDelete;
  final String Function(num amount)? formatMoney;

  const WishlistCardWidget({
    super.key,
    required this.item,
    required this.currentSavings,
    this.dailySavingsRate = 0,
    required this.onToggle,
    this.onEdit,
    this.onChangePhoto,
    this.onDelete,
    this.formatMoney,
  });

  String _format(num amount) {
    if (formatMoney != null) {
      return formatMoney!(amount);
    }
    return "${NumberFormat('#,###').format(amount.round())} MMK";
  }

  void _showMenu(BuildContext context) {
    HapticFeedback.selectionClick();
    showAppBottomSheet(
      context: context,
      builder: (ctx) {
        Widget action({
          required IconData icon,
          required String label,
          required VoidCallback? onTap,
          bool destructive = false,
        }) {
          if (onTap == null) return const SizedBox.shrink();
          final fg = destructive ? AppColors.danger : AppColors.forestPrimary;
          return InkWell(
            borderRadius: context.borderRadius(all: 14),
            onTap: () {
              Navigator.pop(ctx);
              onTap();
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.w(12),
                vertical: context.h(12),
              ),
              child: Row(
                children: [
                  Container(
                    width: context.w(36),
                    height: context.w(36),
                    decoration: BoxDecoration(
                      color: destructive
                          ? AppColors.dangerSoft
                          : AppColors.leafSoft,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, size: context.w(17), color: fg),
                  ),
                  SizedBox(width: context.w(14)),
                  Expanded(
                    child: Text(
                      label,
                      style: AppTextStyle.bodySemiBold(context).copyWith(
                        color: destructive
                            ? AppColors.danger
                            : AppColors.forestDeep,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              context.w(16),
              context.h(10),
              context.w(16),
              context.h(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppSheetHandle(),
                SizedBox(height: context.h(14)),
                Column(
                  children: [
                    action(
                      icon: LucideIcons.pencil,
                      label: LocaleKeys.savings_editGoal.tr(),
                      onTap: onEdit,
                    ),
                    action(
                      icon: LucideIcons.trash2,
                      label: LocaleKeys.savings_deleteGoal.tr(),
                      onTap: onDelete,
                      destructive: true,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final safeTarget = item.targetAmount <= 0 ? 1.0 : item.targetAmount;
    final progress = (currentSavings / safeTarget).clamp(0.0, 1.0);
    final isFunded = currentSavings >= item.targetAmount;
    final isClaimed = item.isCompleted;
    final remaining = (item.targetAmount - currentSavings).clamp(
      0.0,
      double.infinity,
    );
    final percent = (progress * 100).floor();
    final almostThere = !isFunded && !isClaimed && progress >= 0.9;
    final hasImage =
        item.imagePath != null && File(item.imagePath!).existsSync();

    final double tile = context.w(46);
    final Widget visual = hasImage
        ? ClipRRect(
            borderRadius: context.borderRadius(all: 12),
            child: SizedBox(
              width: tile,
              height: tile,
              child: Image.file(File(item.imagePath!), fit: BoxFit.cover),
            ),
          )
        : Container(
            width: tile,
            height: tile,
            decoration: BoxDecoration(
              color: isClaimed
                  ? AppColors.surfaceCard
                  : (isFunded || almostThere)
                  ? AppColors.leafSoft
                  : AppColors.surfaceCardMuted,
              borderRadius: context.borderRadius(all: 12),
              border: isClaimed ? Border.all(color: AppColors.skySoft) : null,
            ),
            child: Icon(
              isClaimed
                  ? LucideIcons.award
                  : GoalIconOption.resolve(item.iconKey),
              size: context.w(20),
              color: isClaimed
                  ? AppColors.amberWarm
                  : (isFunded || almostThere)
                  ? AppColors.forestPrimary
                  : AppColors.forestDeep,
            ),
          );

    final String? subtitleTail = isClaimed
        ? LocaleKeys.savings_cardClaimedOn.tr(
            args: [DateFormat('d MMM').format(item.claimedAt ?? DateTime.now())],
          )
        : isFunded
        ? LocaleKeys.savings_cardReady.tr()
        : null;

    // Clean single trailing widget per card state
    final Widget trailing;
    if (isClaimed) {
      trailing = _TextAction(
        label: LocaleKeys.savings_undoBtn.tr(),
        color: AppColors.barkBrown,
        onTap: onToggle,
      );
    } else if (isFunded) {
      trailing = _ClaimButton(
        label: LocaleKeys.savings_claimBtn.tr(),
        onTap: () {
          HapticFeedback.mediumImpact();
          onToggle();
        },
      );
    } else if (almostThere) {
      trailing = Container(
        padding: EdgeInsets.symmetric(
          horizontal: context.w(10),
          vertical: context.h(4),
        ),
        decoration: BoxDecoration(
          color: AppColors.leafSoft,
          borderRadius: context.borderRadius(all: 50),
        ),
        child: Text(
          "$percent%",
          style: AppTextStyle.captionSmall(context).copyWith(
            color: AppColors.forestPrimary,
            fontWeight: FontWeight.w700,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      );
    } else {
      trailing = InkWell(
        onTap: () => _showMenu(context),
        borderRadius: context.borderRadius(all: 50),
        child: Padding(
          padding: EdgeInsets.all(context.w(6)),
          child: Icon(
            LucideIcons.ellipsis,
            size: context.w(18),
            color: AppColors.textMuted,
          ),
        ),
      );
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _showMenu(context),
      onLongPress: () => _showMenu(context),
      child: Container(
        margin: EdgeInsets.only(bottom: context.h(12)),
        padding: EdgeInsets.all(context.w(16)),
        decoration: BoxDecoration(
          color: isClaimed ? AppColors.amberLight : AppColors.surfaceCard,
          borderRadius: context.borderRadius(all: 14),
          border: Border.all(
            color: isClaimed
                ? AppColors.skySoft
                : isFunded
                ? AppColors.emerald
                : AppColors.borderSubtle,
            width: isFunded && !isClaimed ? 1.5 : 1.0,
          ),
          boxShadow: isClaimed ? null : AppColors.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                visual,
                SizedBox(width: context.w(12)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyle.headingSmall(context).copyWith(
                          color: isClaimed
                              ? AppColors.textPrimary
                              : AppColors.forestDeep,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: context.h(3)),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: _format(item.targetAmount),
                              style: TextStyle(
                                color: isClaimed
                                    ? AppColors.textSecondary
                                    : AppColors.forestPrimary,
                                fontWeight: isClaimed
                                    ? FontWeight.w500
                                    : FontWeight.w700,
                              ),
                            ),
                            if (subtitleTail != null) ...[
                              TextSpan(
                                text: " · ",
                                style: TextStyle(color: AppColors.textMuted),
                              ),
                              TextSpan(
                                text: subtitleTail,
                                style: TextStyle(
                                  color: isClaimed
                                      ? AppColors.barkBrown
                                      : AppColors.forestPrimary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyle.captionMedium(context).copyWith(
                          fontSize: 13.5,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: context.w(8)),
                trailing,
              ],
            ),
            if (!isClaimed) ...[
              SizedBox(height: context.h(12)),
              ClipRRect(
                borderRadius: context.borderRadius(all: 50),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: context.h(6),
                  backgroundColor: AppColors.surfaceCardMuted,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.emerald),
                ),
              ),
              SizedBox(height: context.h(8)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      isFunded
                          ? LocaleKeys.savings_cardReadyToClaim.tr()
                          : LocaleKeys.savings_cardToGo.tr(
                              args: [_format(remaining)],
                            ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.captionSmall(context).copyWith(
                        color: isFunded
                            ? AppColors.forestPrimary
                            : AppColors.textSecondary,
                        fontWeight: isFunded
                            ? FontWeight.w700
                            : FontWeight.w500,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                  ),
                  if (!isFunded && !almostThere)
                    Text(
                      "$percent%",
                      style: AppTextStyle.captionSmall(context).copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ClaimButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _ClaimButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: context.borderRadius(all: 50),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: context.w(18),
          vertical: context.h(9),
        ),
        decoration: BoxDecoration(
          color: AppColors.emerald,
          borderRadius: context.borderRadius(all: 50),
        ),
        child: Text(
          label,
          textHeightBehavior: const TextHeightBehavior(
            applyHeightToFirstAscent: false,
            applyHeightToLastDescent: false,
          ),
          style: AppTextStyle.bodySemiBold(context).copyWith(
            color: AppColors.baseWhite,
            fontWeight: FontWeight.w700,
            height: 1.0,
          ),
        ),
      ),
    );
  }
}

class _TextAction extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _TextAction({
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      borderRadius: context.borderRadius(all: 50),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: context.w(8),
          vertical: context.h(6),
        ),
        child: Text(
          label,
          style: AppTextStyle.bodySemiBold(
            context,
          ).copyWith(color: color, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
