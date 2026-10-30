import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:hpyat_mal/core/extensions/context_extensions.dart';
import 'package:hpyat_mal/core/services/storage_service.dart';
import 'package:hpyat_mal/core/theme/app_color.dart';
import 'package:hpyat_mal/core/theme/app_text_style.dart';

class CravingLogCardWidget extends StatelessWidget {
  final CravingLog log;

  const CravingLogCardWidget({super.key, required this.log});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM d, h:mm a');
    final accentColor = log.resisted ? AppColors.emerald : AppColors.amberWarm;

    return Container(
      margin: EdgeInsets.only(bottom: context.h(12)),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: context.borderRadius(all: 12),
        border: Border.all(color: AppColors.borderSubtle),
        boxShadow: AppColors.cardShadow,
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: context.w(4),
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(context.r(12)),
                  bottomLeft: Radius.circular(context.r(12)),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.w(14),
                  vertical: context.h(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Flexible(
                                child: Text(
                                  log.trigger,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyle.bodySemiBold(context)
                                      .copyWith(
                                    color: AppColors.forestDeep,
                                    fontSize: 14.5,
                                  ),
                                ),
                              ),
                              SizedBox(width: context.w(8)),
                              Row(
                                children: List.generate(5, (index) {
                                  return Container(
                                    width: context.w(5),
                                    height: context.w(5),
                                    margin:
                                        EdgeInsets.only(right: context.w(3)),
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
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: context.w(8),
                            vertical: context.h(3),
                          ),
                          decoration: BoxDecoration(
                            color: log.resisted
                                ? AppColors.leafSoft
                                : AppColors.amberLight,
                            borderRadius: context.borderRadius(all: 50),
                            border: log.resisted
                                ? null
                                : Border.all(color: AppColors.skySoft),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                log.resisted
                                    ? LucideIcons.check
                                    : LucideIcons.rotateCcw,
                                size: context.w(11),
                                color: log.resisted
                                    ? AppColors.forestPrimary
                                    : AppColors.forestDeep,
                              ),
                              SizedBox(width: context.w(4)),
                              Text(
                                log.resisted ? "Resisted" : "Slip",
                                style:
                                    AppTextStyle.captionSmall(context).copyWith(
                                  color: log.resisted
                                      ? AppColors.forestPrimary
                                      : AppColors.forestDeep,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (log.note.isNotEmpty) ...[
                      SizedBox(height: context.h(6)),
                      Text(
                        log.note,
                        style: AppTextStyle.bodyMedium(context).copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 13.5,
                          height: 1.45,
                        ),
                      ),
                    ],
                    SizedBox(height: context.h(6)),
                    Text(
                      dateFormat.format(log.timestamp),
                      style: AppTextStyle.captionSmall(context).copyWith(
                        color: AppColors.textMuted,
                        fontSize: 11.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
