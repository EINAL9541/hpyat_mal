import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
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
    final dateFormat = DateFormat('MMM d • h:mm a');

    return Container(
      margin: EdgeInsets.only(bottom: context.h(10)),
      padding: EdgeInsets.all(context.w(14)),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: context.borderRadius(all: 16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.w(8),
                      vertical: context.h(4),
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.leafBackground,
                      borderRadius: context.borderRadius(all: 8),
                      border: Border.all(color: AppColors.borderSubtle),
                    ),
                    child: Text(
                      log.trigger,
                      style: AppTextStyle.captionSmall(context).copyWith(
                        color: AppColors.forestDeep,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(width: context.w(8)),
                  Row(
                    children: List.generate(5, (index) {
                      return Icon(
                        Icons.circle,
                        size: context.w(7),
                        color: index < log.intensity
                            ? AppColors.amberWarm
                            : AppColors.border,
                      );
                    }),
                  ),
                ],
              ),

              // Resisted Badge
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: context.w(8),
                  vertical: context.h(3),
                ),
                decoration: BoxDecoration(
                  color: log.resisted
                      ? AppColors.leafSoft
                      : AppColors.warningSoft,
                  borderRadius: context.borderRadius(all: 8),
                ),
                child: Row(
                  children: [
                    Icon(
                      log.resisted ? LucideIcons.shieldCheck : LucideIcons.leaf,
                      size: context.w(12),
                      color: log.resisted
                          ? AppColors.forestPrimary
                          : AppColors.amberWarm,
                    ),
                    SizedBox(width: context.w(4)),
                    Text(
                      log.resisted ? "Resisted" : "Slip",
                      style: AppTextStyle.captionSmall(context).copyWith(
                        color: log.resisted
                            ? AppColors.forestPrimary
                            : AppColors.amberWarm,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          if (log.note.isNotEmpty) ...[
            SizedBox(height: context.h(8)),
            Text(
              log.note,
              style: AppTextStyle.bodyMedium(context).copyWith(
                color: AppColors.textPrimary,
                fontSize: 13,
              ),
            ),
          ],

          SizedBox(height: context.h(8)),

          Text(
            dateFormat.format(log.timestamp),
            style: AppTextStyle.captionSmall(context).copyWith(
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
