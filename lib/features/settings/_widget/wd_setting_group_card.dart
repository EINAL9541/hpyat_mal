import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:hpyat_mal/core/theme/app_color.dart';

class SettingsGroupCardWidget extends StatelessWidget {
  final List<Widget> children;

  const SettingsGroupCardWidget({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      clipBehavior: .antiAlias,
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: context.borderRadius(all: 12),
        border: Border.all(color: AppColors.borderSubtle, width: 1),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        mainAxisSize: .min,
        children: children,
      ),
    );
  }
}