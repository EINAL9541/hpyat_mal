import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hpyat_mal/core/extensions/context_extensions.dart';
import 'package:hpyat_mal/core/theme/app_color.dart';
import 'package:hpyat_mal/core/theme/app_text_style.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class AppPageAppBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;

  const AppPageAppBarWidget({super.key, required this.title});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      scrolledUnderElevation: 0.5,
      shadowColor: AppColors.border,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        onPressed: () => context.pop(),
        icon: Icon(
          LucideIcons.chevronLeft,
          color: AppColors.forestPrimary,
          size: context.w(24),
        ),
      ),
      title: Text(
        title,
        style: AppTextStyle.headingSmall(context)
            .copyWith(color: AppColors.forestDeep),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Divider(height: 1, thickness: 1, color: AppColors.borderSubtle),
      ),
    );
  }
}
