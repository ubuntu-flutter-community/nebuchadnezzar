import 'package:flutter/material.dart';

import '../../extensions/navigator_x.dart';
import 'ui_constants.dart';

extension BuildContextX on BuildContext {
  MediaQueryData get mq => MediaQuery.of(this);
  Size get mediaQuerySize => MediaQuery.sizeOf(this);
  bool get showSideBar => mediaQuerySize.width > kShowSideBarThreshHold;
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => theme.colorScheme;
  TextTheme get textTheme => theme.textTheme;
  NavigatorState get navigator => Navigator.of(this);
  Future<T?> teleport<T extends Object?>(
    Widget Function(BuildContext) builder,
  ) => navigator.teleport(builder);
  void pop<T extends Object?>([T? result]) => navigator.pop(result);
}
