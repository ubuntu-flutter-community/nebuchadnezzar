import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import 'ui_constants.dart';

extension BuildContextX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
  MediaQueryData get mq => MediaQuery.of(this);
  Size get mediaQuerySize => mq.size;
  bool get showSideBar => mediaQuerySize.width > kShowSideBarThreshHold;
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => theme.colorScheme;
  TextTheme get textTheme => theme.textTheme;
}
