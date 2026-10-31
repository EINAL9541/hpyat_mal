import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hpyat_mal/core/extensions/context_extensions.dart';
import 'package:hpyat_mal/core/generate/locale_keys.g.dart';
import 'package:hpyat_mal/core/services/storage_service.dart';
import 'package:hpyat_mal/core/theme/app_color.dart';
import 'package:hpyat_mal/core/theme/app_text_style.dart';
import 'package:hpyat_mal/core/ui/widgets/wd_bottom_sheet.dart';
import 'package:hpyat_mal/features/journal/_widget/wd_add_craving_bottom_sheet.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class CravingLogCardWidget extends StatelessWidget {
  final CravingLog log;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const CravingLogCardWidget({
    super.key,
    required this.log,
    this.onEdit,
    this.onDelete,
  });

  void _showMenu(BuildContext context) {
    if (onEdit == null && onDelete == null) return;
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
                      label: LocaleKeys.journal_editEntry.tr(),
                      onTap: onEdit,
                    ),
                    action(
                      icon: LucideIcons.trash2,
                      label: LocaleKeys.journal_deleteEntry.tr(),
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
    final dateFormat = DateFormat('d MMM, h:mm a');
    final isResisted = log.resisted;
    final accentColor = isResisted ? AppColors.emerald : AppColors.amberWarm;
    final tile = context.w(44);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _showMenu(context),
      onLongPress: () => _showMenu(context),
      child: Container(
        margin: EdgeInsets.only(bottom: context.h(12)),
        padding: EdgeInsets.all(context.w(16)),
        decoration: BoxDecoration(
          color: isResisted ? AppColors.surfaceCard : AppColors.amberLight,
          borderRadius: context.borderRadius(all: 14),
          border: Border.all(
            color: isResisted ? AppColors.borderSubtle : AppColors.skySoft,
          ),
          boxShadow: isResisted ? AppColors.cardShadow : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Trigger Icon Tile
                Container(
                  width: tile,
                  height: tile,
                  decoration: BoxDecoration(
                    color: isResisted
                        ? AppColors.leafSoft
                        : AppColors.surfaceCard,
                    borderRadius: context.borderRadius(all: 12),
                    border: isResisted
                        ? null
                        : Border.all(color: AppColors.skySoft),
                  ),
                  child: Icon(
                    CravingTriggerOption.resolveIcon(log.trigger),
                    size: context.w(19),
                    color: isResisted
                        ? AppColors.forestPrimary
                        : AppColors.amberWarm,
                  ),
                ),
                SizedBox(width: context.w(12)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              CravingTriggerOption.localize(log.trigger),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyle.headingSmall(context)
                                  .copyWith(
                                    color: AppColors.forestDeep,
                                    fontSize: 15.5,
                                  ),
                            ),
                          ),
                          SizedBox(width: context.w(8)),
                          Row(
                            children: List.generate(5, (index) {
                              return Container(
                                width: context.w(5),
                                height: context.w(5),
                                margin: EdgeInsets.only(right: context.w(3)),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: index < log.intensity
                                      ? accentColor
                                      : AppColors.border,
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                      SizedBox(height: context.h(3)),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: isResisted
                                  ? LocaleKeys.journal_statusResisted.tr()
                                  : LocaleKeys.journal_statusSlip.tr(),
                              style: TextStyle(
                                color: isResisted
                                    ? AppColors.forestPrimary
                                    : AppColors.barkBrown,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            TextSpan(
                              text: " · ",
                              style: TextStyle(color: AppColors.textMuted),
                            ),
                            TextSpan(
                              text: dateFormat.format(log.timestamp),
                              style: TextStyle(
                                color: AppColors.textMuted,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyle.captionSmall(context).copyWith(
                          fontSize: 12.5,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: context.w(8)),
                InkWell(
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
                ),
              ],
            ),
            if (log.note.isNotEmpty) ...[
              SizedBox(height: context.h(10)),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: context.w(12),
                  vertical: context.h(9),
                ),
                decoration: BoxDecoration(
                  color: isResisted
                      ? AppColors.surfaceCardMuted.withValues(alpha: 0.65)
                      : AppColors.surfaceCard,
                  borderRadius: context.borderRadius(all: 10),
                ),
                child: Text(
                  log.note,
                  style: AppTextStyle.captionMedium(context).copyWith(
                    color: AppColors.textSecondary,
                    height: 1.45,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
