import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:safe_change_notifier/safe_change_notifier.dart';

import '../encryption/view/check_encryption_setup_page.dart';
import '../l10n/l10n.dart';
import 'authentication_service.dart';

class AuthenticationManager {
  AuthenticationManager({required AuthenticationService authenticationService})
    : _authenticationService = authenticationService;

  final AuthenticationService _authenticationService;

  final processingAccess = SafeValueNotifier(false);
  final showPassword = SafeValueNotifier(false);

  Future<void> login(
    BuildContext context, {
    required String loginMethod,
    required String homeServer,
    String? username,
    String? password,
  }) async {
    processingAccess.value = true;

    final result = await showFutureLoadingDialog(
      context: context,
      title: context.l10n.loginInPleaseWait,
      future: () => _authenticationService.login(
        loginMethod: loginMethod,
        homeServer: homeServer,
        username: username,
        password: password,
      ),
    );

    if (result.isValue && context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const CheckEncryptionSetupPage()),
        (route) => false,
      );
    }

    processingAccess.value = false;
  }

  Future<Result<void>> logout(BuildContext context) async {
    if (_authenticationService.isLogged == false) {
      return Result.value(null);
    }
    processingAccess.value = true;
    final result = await showFutureLoadingDialog(
      context: context,
      future: () => _authenticationService.logout(),
    );
    processingAccess.value = false;
    return result;
  }
}
