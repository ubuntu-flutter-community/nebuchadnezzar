import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

import '../../chat/view/chat_start_page.dart';
import '../../constants.dart';
import '../../l10n/l10n.dart';

class NebuchadnezzarApp extends StatelessWidget {
  const NebuchadnezzarApp({super.key});

  @override
  Widget build(BuildContext context) {
    if (Platform.isLinux) {
      return YaruTheme(
        builder: (context, yaru, child) => _App(
          lightTheme: yaru.theme,
          darkTheme: yaru.darkTheme,
          highContrastTheme: yaruHighContrastLight,
          highContrastDarkTheme: yaruHighContrastDark,
        ),
      );
    }

    return _App(
      lightTheme: yaruLight,
      darkTheme: yaruDark,
    );
  }
}

class _App extends StatelessWidget {
  const _App({
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
        title: kAppTitle,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: supportedLocales,
        scrollBehavior: const MaterialScrollBehavior().copyWith(
          dragDevices: {
            PointerDeviceKind.mouse,
            PointerDeviceKind.touch,
            PointerDeviceKind.stylus,
            PointerDeviceKind.unknown,
            PointerDeviceKind.trackpad,
          },
        ),
        home: const ChatStartPage(),
      );
}
