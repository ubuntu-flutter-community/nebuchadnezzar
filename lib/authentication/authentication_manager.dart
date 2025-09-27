import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:safe_change_notifier/safe_change_notifier.dart';

import 'authentication_service.dart';

class AuthenticationManager {
  AuthenticationManager({required AuthenticationService authenticationService})
    : _authenticationService = authenticationService;

  final AuthenticationService _authenticationService;

  final processingAccess = SafeValueNotifier(false);
  final showPassword = SafeValueNotifier(false);

  Future<void> login({
    required String loginMethod,
    required String homeServer,
    String? username,
    String? password,
  }) async {
    try {
      await _authenticationService.login(
        loginMethod: loginMethod,
        homeServer: homeServer,
        username: username,
        password: password,
      );
    } on Exception {
      rethrow;
    }
  }

  Future<Result<void>> logout(BuildContext context) async {
    try {
      await _authenticationService.logout();
    } on Exception catch (_) {
      return Result.error(Exception('Logout failed'));
    }

    return Result.value(null);
  }
}
