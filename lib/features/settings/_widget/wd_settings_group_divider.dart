import 'package:flutter/material.dart';
import 'package:hpyat_mal/core/theme/app_color.dart';

class SettingsGroupDividerWidget extends StatelessWidget {
  const SettingsGroupDividerWidget({super.key});

  @override
  Widget build(BuildContext context) {

    return Divider(
      height: 1,
      thickness: 1,
      color: AppColors.border.withValues(alpha: 0.6),
    );
  }
}
