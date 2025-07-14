import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../../authentication/authentication_model.dart';
import '../../authentication/view/chat_login_page.dart';
import '../../encryption/view/check_encryption_setup_page.dart';
import 'app.dart';
import 'error_page.dart';
import 'splash_page.dart';

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
    _registrationReady = di.allReady();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
    future: _registrationReady,
    builder: (context, snapshot) => snapshot.hasError
        ? App(
            themeMode: ThemeMode.system,
            lightTheme: widget.lightTheme,
            darkTheme: widget.darkTheme,
            highContrastDarkTheme: widget.highContrastDarkTheme,
            highContrastTheme: widget.highContrastTheme,
            child: ErrorPage(error: snapshot.error.toString()),
          )
        : snapshot.hasData
        ? App(
            lightTheme: widget.lightTheme,
            darkTheme: widget.darkTheme,
            highContrastDarkTheme: widget.highContrastDarkTheme,
            highContrastTheme: widget.highContrastTheme,
            child: (!di<AuthenticationModel>().isLogged)
                ? const ChatLoginPage()
                : const CheckEncryptionSetupPage(),
          )
        : App(
            themeMode: ThemeMode.system,
            lightTheme: widget.lightTheme,
            darkTheme: widget.darkTheme,
            highContrastDarkTheme: widget.highContrastDarkTheme,
            highContrastTheme: widget.highContrastTheme,
            child: const SplashPage(),
          ),
  );
}
