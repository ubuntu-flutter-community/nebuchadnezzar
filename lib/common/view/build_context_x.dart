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
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> toast(
    Widget content, {
    Duration duration = const Duration(seconds: 2),
    SnackBarAction? action,
    bool clear = true,
    bool showCloseIcon = false,
    double? actionOverflowThreshold,
  }) {
    final messenger = ScaffoldMessenger.of(this);
    if (clear) {
      messenger.clearSnackBars();
    }
    return messenger.showSnackBar(
      SnackBar(
        content: content,
        duration: duration,
        action: action,
        showCloseIcon: showCloseIcon,
        actionOverflowThreshold: actionOverflowThreshold ?? 0.65,
      ),
    );
  }

  void clearToasts() => ScaffoldMessenger.of(this).clearSnackBars();
}
