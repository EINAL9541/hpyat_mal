import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hpyat_mal/core/theme/app_color.dart';
import 'package:hpyat_mal/core/ui/navbar/wd_bottom_navbar.dart';
import 'package:hpyat_mal/features/forest/_provider/forest_provider.dart';

class MainShellScaffoldWidget extends ConsumerWidget {
  final Widget child;

  const MainShellScaffoldWidget({super.key, required this.child});

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/health')) return 1;
    if (location.startsWith('/journal')) return 2;
    if (location.startsWith('/savings')) return 3;
    if (location.startsWith('/breathing')) return 4;
    return 0; // Forest
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/health');
        break;
      case 2:
        context.go('/journal');
        break;
      case 3:
        context.go('/savings');
        break;
      case 4:
        context.go('/breathing');
        break;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(forestProvider.select((s) => s.plantTheme));
    final currentIndex = _calculateSelectedIndex(context);

    return PopScope(
      canPop: currentIndex == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (currentIndex != 0) {
          context.go('/');
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.surface,
        body: child,
        bottomNavigationBar: BottomNavbarWidget(
          selectedIndex: currentIndex,
          onTap: (index) => _onItemTapped(index, context),
        ),
      ),
    );
  }
}
