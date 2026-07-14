import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';

import '../../authentication/authentication_service.dart';
import '../../authentication/view/chat_login_page.dart';
import '../../encryption/view/check_encryption_setup_page.dart';
import '../../l10n/app_localizations.dart';
import '../../settings/settings_manager.dart';
import '../app_config.dart';

class App extends StatelessWidget with WatchItMixin {
  const App({
    super.key,
    this.lightTheme,
    this.darkTheme,
    this.highContrastTheme,
    this.highContrastDarkTheme,
    this.child,
    this.themeMode,
  });

  final ThemeData? lightTheme,
      darkTheme,
      highContrastTheme,
      highContrastDarkTheme;

  final Widget? child;
  final ThemeMode? themeMode;

  @override
  Widget build(BuildContext context) => MaterialApp(
    themeMode:
        themeMode ??
        watchPropertyValue(
          (SettingsManager m) => ThemeMode.values[m.themModeIndex],
        ),
    theme: lightTheme?.copyWith(pageTransitionsTheme: pTT),
    darkTheme: darkTheme?.copyWith(pageTransitionsTheme: pTT),
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
    home:
        child ??
        ((!di<AuthenticationService>().isLogged)
            ? const ChatLoginPage()
            : const CheckEncryptionSetupPage()),
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
