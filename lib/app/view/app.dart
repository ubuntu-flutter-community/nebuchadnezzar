import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:system_theme/system_theme_builder.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../authentication/authentication_model.dart';
import '../../authentication/view/chat_login_page.dart';
import '../../common/view/common_widgets.dart';
import '../../encryption/view/setup_encrypted_chat_page.dart';
import '../../l10n/l10n.dart';
import '../../settings/settings_model.dart';
import '../app_config.dart';

class Nebuchadnezzar extends StatelessWidget {
  const Nebuchadnezzar({super.key});

  @override
  Widget build(BuildContext context) => !kIsWeb && Platform.isLinux
      ? YaruTheme(
          builder: (context, yaru, child) => _WaitForRegistrationPage(
            lightTheme: yaru.theme,
            darkTheme: yaru.darkTheme,
            highContrastTheme: yaruHighContrastLight,
            highContrastDarkTheme: yaruHighContrastDark,
          ),
        )
      : SystemThemeBuilder(
          builder: (context, systemColor) => _WaitForRegistrationPage(
            lightTheme: createYaruLightTheme(primaryColor: systemColor.accent),
            darkTheme: createYaruDarkTheme(primaryColor: systemColor.accent),
            highContrastTheme: yaruHighContrastLight,
            highContrastDarkTheme: yaruHighContrastDark,
          ),
        );
}

class _WaitForRegistrationPage extends StatefulWidget {
  const _WaitForRegistrationPage({
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
  State<_WaitForRegistrationPage> createState() =>
      _WaitForRegistrationPageState();
}

class _WaitForRegistrationPageState extends State<_WaitForRegistrationPage> {
  late final Future<void> _registrationReady;

  @override
  void initState() {
    super.initState();
    _registrationReady = di.allReady();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
        future: _registrationReady,
        builder: (context, snapshot) => snapshot.hasData
            ? App(
                lightTheme: widget.lightTheme,
                darkTheme: widget.darkTheme,
                highContrastDarkTheme: widget.highContrastDarkTheme,
                highContrastTheme: widget.highContrastTheme,
                child: (!di<AuthenticationModel>().isLogged)
                    ? const ChatLoginPage()
                    : const CheckEncryptionSetupNeededPage(),
              )
            : App(
                themeMode: ThemeMode.system,
                lightTheme: widget.lightTheme,
                darkTheme: widget.darkTheme,
                highContrastDarkTheme: widget.highContrastDarkTheme,
                highContrastTheme: widget.highContrastTheme,
                child: const _SplashPage(),
              ),
      );
}

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

class _SplashPage extends StatelessWidget {
  const _SplashPage();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: YaruWindowTitleBar(
        border: BorderSide.none,
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Progress(),
      ),
    );
  }
}
