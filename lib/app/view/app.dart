import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:system_theme/system_theme_builder.dart';
import 'package:yaru/yaru.dart';

import 'home_page.dart';
import '../app_config.dart';
import '../../l10n/l10n.dart';

class NebuchadnezzarApp extends StatelessWidget {
  const NebuchadnezzarApp({super.key, required this.yaruApp});

  final bool yaruApp;

  @override
  Widget build(BuildContext context) => yaruApp
      ? YaruTheme(
          builder: (context, yaru, child) => App(
            lightTheme: yaru.theme,
            darkTheme: yaru.darkTheme,
            highContrastTheme: yaruHighContrastLight,
            highContrastDarkTheme: yaruHighContrastDark,
          ),
        )
      : SystemThemeBuilder(
          builder: (context, systemColor) => App(
            lightTheme: createYaruLightTheme(primaryColor: systemColor.accent),
            darkTheme: createYaruDarkTheme(primaryColor: systemColor.accent),
          ),
        );
}

class App extends StatelessWidget {
  const App({
    super.key,
    this.lightTheme,
    this.darkTheme,
    this.highContrastTheme,
    this.highContrastDarkTheme,
  });

  final ThemeData? lightTheme,
      darkTheme,
      highContrastTheme,
      highContrastDarkTheme;

  @override
  Widget build(BuildContext context) => MaterialApp(
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
        home: const HomePage(),
      );
}
