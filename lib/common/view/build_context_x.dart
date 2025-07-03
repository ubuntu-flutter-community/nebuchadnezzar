import 'package:flutter/material.dart';

import 'ui_constants.dart';

extension BuildContextX on BuildContext {
  MediaQueryData get mq => MediaQuery.of(this);
  Size get mediaQuerySize => MediaQuery.sizeOf(this);
  bool get showSideBar => mediaQuerySize.width > kShowSideBarThreshHold;
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => theme.colorScheme;
  TextTheme get textTheme => theme.textTheme;
}
