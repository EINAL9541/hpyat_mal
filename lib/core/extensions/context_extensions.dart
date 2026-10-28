export 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter/material.dart';

extension ContextMediaExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  double get screenWidth => mediaQuery.size.width;
  double get screenHeight => mediaQuery.size.height;
}
