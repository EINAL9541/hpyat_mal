import 'package:flutter/material.dart';
import 'package:hpyat_mal/core/extensions/context_extensions.dart';
import 'package:hpyat_mal/core/theme/app_color.dart';

/// Single bottom-sheet style used across the app:
/// white card surface, 24px top radius, drag handle, opens above the navbar.
Future<T?> showAppBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool isScrollControlled = false,
}) {
  return showModalBottomSheet<T>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: isScrollControlled,
    backgroundColor: AppColors.surfaceCard,
    clipBehavior: Clip.antiAlias,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(context.r(24))),
    ),
    builder: builder,
  );
}

class AppSheetHandle extends StatelessWidget {
  const AppSheetHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: context.w(36),
        height: context.h(4),
        decoration: BoxDecoration(
          color: AppColors.border,
          borderRadius: context.borderRadius(all: 4),
        ),
      ),
    );
  }
}
