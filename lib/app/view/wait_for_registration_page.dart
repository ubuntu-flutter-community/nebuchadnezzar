import 'package:flutter/material.dart';

import '../../dependencies.dart';
import '../app_config.dart';
import 'app.dart';
import 'error_page.dart';
import 'splash_page.dart';

final _registrationRestartNotifier = ValueNotifier(UniqueKey());

class WaitForRegistrationPage extends StatefulWidget {
  const WaitForRegistrationPage({
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
  State<WaitForRegistrationPage> createState() =>
      _WaitForRegistrationPageState();
}

class _WaitForRegistrationPageState extends State<WaitForRegistrationPage> {
  late final Future<void> _registrationReady;

  @override
  void initState() {
    super.initState();
    _registrationReady = configureDependencies();
  }

  @override
  Widget build(BuildContext context) => ValueListenableBuilder(
    valueListenable: _registrationRestartNotifier,
    builder: (context, value, child) {
      return FutureBuilder(
        future: _registrationReady,
        builder: (context, snapshot) => snapshot.hasError
            ? App(
                themeMode: ThemeMode.system,
                lightTheme: widget.lightTheme,
                darkTheme: widget.darkTheme,
                highContrastDarkTheme: widget.highContrastDarkTheme,
                highContrastTheme: widget.highContrastTheme,
                child: ErrorPage(
                  error: snapshot.error,
                  addQuitButton: true,
                  onRetry: () =>
                      _registrationRestartNotifier.value = UniqueKey(),
                ),
              )
            : snapshot.hasData
            ? App(
                lightTheme: widget.lightTheme,
                darkTheme: widget.darkTheme,
                highContrastDarkTheme: widget.highContrastDarkTheme,
                highContrastTheme: widget.highContrastTheme,
              )
            : App(
                themeMode: ThemeMode.system,
                lightTheme: widget.lightTheme,
                darkTheme: widget.darkTheme,
                highContrastDarkTheme: widget.highContrastDarkTheme,
                highContrastTheme: widget.highContrastTheme,
                child: const SplashPage(title: Text(AppConfig.appName)),
              ),
      );
    },
  );
}
