import 'package:flutter_it/flutter_it.dart';
import 'package:safe_change_notifier/safe_change_notifier.dart';

import 'authentication_capsule.dart';
import 'authentication_service.dart';

class AuthenticationManager {
  AuthenticationManager({required AuthenticationService authenticationService})
    : _authenticationService = authenticationService {
    loginCommand = Command.createAsync(
      (capsule) => _authenticationService.login(
        loginMethod: capsule.loginMethod,
        homeServer: capsule.homeServer,
        username: capsule.username,
        password: capsule.password,
      ),
      initialValue: null,
    );
    logoutCommand = Command.createAsyncNoParamNoResult(
      _authenticationService.logout,
    );
    supportedLoginTypeCommand = Command.createAsync(
      (capsule) => _authenticationService.checkIfLoginTypeIsSupported(
        capsule.loginMethod,
        capsule.homeServer,
      ),
      initialValue: false,
    );
  }

  final AuthenticationService _authenticationService;
  late Command<LoginCapsule, String?> loginCommand;
  late Command<void, void> logoutCommand;
  late Command<LoginTypeCheckCapsule, bool> supportedLoginTypeCommand;
  final showPassword = SafeValueNotifier(false);

  void toggleShowPassword() => showPassword.value = !showPassword.value;
}
