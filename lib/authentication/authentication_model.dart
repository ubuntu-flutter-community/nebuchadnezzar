import 'dart:io';

import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:matrix/matrix.dart';
import 'package:safe_change_notifier/safe_change_notifier.dart';
import 'package:universal_html/html.dart' as html;

import '../app/app_config.dart';
import '../common/logging.dart';
import '../common/platforms.dart';

class AuthenticationModel extends SafeChangeNotifier {
  AuthenticationModel({required Client client}) : _client = client;

  final Client _client;

  RequestTokenResponse? currentThreepidCreds;
  String currentClientSecret = '';

  Stream<LoginState> get loginStateStream => _client.onLoginStateChanged.stream;
  bool get isLogged => _client.isLogged();

  Stream<UiaRequest<dynamic>> get onUiaRequestStream =>
      _client.onUiaRequest.stream;

  bool _processingAccess = false;
  bool get processingAccess => _processingAccess;
  void _setProcessingAccess(bool value) {
    if (value == _processingAccess) return;
    _processingAccess = value;
    notifyListeners();
  }

  bool _showPassword = false;
  bool get showPassword => _showPassword;
  void toggleShowPassword({bool? forceValue}) {
    _showPassword = forceValue ?? !_showPassword;
    notifyListeners();
  }

  Future<void> login({
    required String homeServer,
    required String username,
    required String password,
    required Function(String error) onFail,
    required Future Function() onSuccess,
  }) async {
    _setProcessingAccess(true);
    try {
      await _client.checkHomeserver(Uri.https(homeServer, ''));

      await _client
          .login(
            LoginType.mLoginPassword,
            password: password,
            identifier: AuthenticationUserIdentifier(user: username),
            initialDeviceDisplayName: Platforms.isWeb
                ? '${AppConfig.kAppTitle} Web Browser'
                : '${AppConfig.kAppTitle} ${Platform.operatingSystem}',
          )
          .timeout(const Duration(seconds: 30));
      await onSuccess();
    } on Exception catch (e, s) {
      await onFail(e.toString());
      printMessageInDebugMode(e, s);
    } finally {
      _setProcessingAccess(false);
    }
  }

  Future<void> singleSingOnLogin({
    required String homeServer,
    required Function(String error) onFail,
    required Future Function() onSuccess,
  }) async {
    _setProcessingAccess(true);
    try {
      final redirectUrl = Platforms.isWeb
          ? Uri.parse(
              html.window.location.href,
            ).resolveUri(Uri(pathSegments: ['auth.html'])).toString()
          : (Platforms.isMobile || Platforms.isMacOS)
          ? '${AppConfig.appOpenUrlScheme.toLowerCase()}://login'
          : 'http://localhost:3001/login';

      await _client.checkHomeserver(Uri.https(homeServer, ''));
      final url = _client.homeserver!.replace(
        path: '/_matrix/client/v3/login/sso/redirect',
        queryParameters: {'redirectUrl': redirectUrl},
      );
      final urlScheme =
          (Platforms.isWeb || Platforms.isMobile || Platforms.isMacOS)
          ? Uri.parse(redirectUrl).scheme
          : 'http://localhost:3001';

      final result = await FlutterWebAuth2.authenticate(
        url: url.toString(),
        callbackUrlScheme: urlScheme,
        options: FlutterWebAuth2Options(
          useWebview: Platforms.isMobile || Platforms.isMacOS,
        ),
      );

      final parsedResult = Uri.parse(result);
      final token = parsedResult.queryParameters['loginToken'];
      if (token?.isEmpty ?? false) {
        printMessageInDebugMode('Login token is empty or null: $token');
        onFail('Login token not received from SSO.');
        return;
      }

      await _client
          .login(
            LoginType.mLoginToken,
            token: token,
            initialDeviceDisplayName: Platforms.isWeb
                ? '${AppConfig.kAppTitle} Web Browser'
                : '${AppConfig.kAppTitle} ${Platform.operatingSystem}',
          )
          .timeout(const Duration(seconds: 55));
      await onSuccess();
    } catch (e, s) {
      printMessageInDebugMode('Error during client.login with token: $e', s);
      onFail('Failed to login with SSO token: ${e.toString()}');
    } finally {
      _setProcessingAccess(false);
    }
  }

  Future logout({required Function(String error) onFail}) async {
    _setProcessingAccess(true);
    try {
      await _client.logout();
    } on Exception catch (e) {
      onFail(e.toString());
    } finally {
      _setProcessingAccess(false);
    }
  }
}
