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
        theme: lightTheme?.copyWith(
          pageTransitionsTheme: pTT,
        ),
        darkTheme: darkTheme?.copyWith(
          pageTransitionsTheme: pTT,
        ),
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

final pTT = PageTransitionsTheme(
  builders: {
    for (final platform in TargetPlatform.values)
      platform: const _NoTransitionsBuilder(),
  },
);

class _NoTransitionsBuilder extends PageTransitionsBuilder {
  const _NoTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T>? route,
    BuildContext? context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget? child,
  ) {
    return child!;
  }
}
