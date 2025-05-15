import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../../l10n/l10n.dart';
import '../../settings/settings_model.dart';
import '../app_config.dart';

class App extends StatelessWidget with WatchItMixin {
  const App({
    super.key,
    this.lightTheme,
    this.darkTheme,
    this.highContrastTheme,
    this.highContrastDarkTheme,
    required this.child,
    this.themeMode,
  });

  final ThemeData? lightTheme,
      darkTheme,
      highContrastTheme,
      highContrastDarkTheme;

  final Widget child;
  final ThemeMode? themeMode;

  @override
  Widget build(BuildContext context) => MaterialApp(
        themeMode: themeMode ??
            watchPropertyValue(
              (SettingsModel m) => ThemeMode.values[m.themModeIndex],
            ),
        theme: lightTheme,
        darkTheme: darkTheme,
        highContrastTheme: highContrastTheme,
        highContrastDarkTheme: highContrastDarkTheme,
        debugShowCheckedModeBanner: false,
        title: AppConfig.kAppTitle,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        scrollBehavior: const MaterialScrollBehavior().copyWith(
          dragDevices: {
            PointerDeviceKind.mouse,
            PointerDeviceKind.touch,
            PointerDeviceKind.stylus,
            PointerDeviceKind.unknown,
            PointerDeviceKind.trackpad,
          },
        ),
        home: child,
      );
}
