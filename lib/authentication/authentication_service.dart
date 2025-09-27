import 'dart:async';
import 'dart:io';

import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:matrix/matrix.dart';
import 'package:universal_html/html.dart' as html;

import '../app/app_config.dart';
import '../common/constants.dart';
import '../common/logging.dart';
import '../common/platforms.dart';

class AuthenticationService {
  AuthenticationService({required Client client}) : _client = client;

  final Client _client;

  RequestTokenResponse? currentThreepidCreds;
  String currentClientSecret = '';

  Stream<LoginState> get loginStateStream => _client.onLoginStateChanged.stream;
  bool get isLogged => _client.isLogged();
  String? get loggedInUserId => !_client.isLogged() ? null : _client.userID;
  String? get homeServerId => _client.homeserver?.host;
  String? get homeServerName =>
      _client.homeserver?.host.replaceAll('matrix-client.', '');

  Stream<UiaRequest<dynamic>> get onUiaRequestStream =>
      _client.onUiaRequest.stream;

  final int _timeoutSeconds = 65;

  Future<void> login({
    required String loginMethod,
    String homeServer = defaultHomeServer,
    String? username,
    String? password,
  }) async {
    if (loginMethod == LoginType.mLoginPassword &&
        ((username?.isEmpty ?? true) || (password?.isEmpty ?? true))) {
      throw ArgumentError(
        'homeServer, username and password must be provided for matrixId login method',
      );
    } else if (loginMethod == LoginType.mLoginToken && homeServer.isEmpty) {
      throw ArgumentError(
        'homeServer must be provided for singleSignOn login method',
      );
    }

    return switch (loginMethod) {
      LoginType.mLoginToken => _singleSingOnLogin(homeServer: homeServer),
      LoginType.mLoginPassword => _userNamePasswordLogin(
        homeServer: homeServer,
        username: username!,
        password: password!,
      ),
      _ => throw UnimplementedError(
        'Login method $loginMethod is not implemented',
      ),
    };
  }

  Future<void> _userNamePasswordLogin({
    required String homeServer,
    required String username,
    required String password,
  }) async {
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
    } on Exception {
      rethrow;
    }
  }

  Future<void> _singleSingOnLogin({required String homeServer}) async {
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
        throw Exception('Login token not received from SSO.');
      }

      await _client
          .login(
            LoginType.mLoginToken,
            token: token,
            initialDeviceDisplayName: Platforms.isWeb
                ? '${AppConfig.kAppTitle} Web Browser'
                : '${AppConfig.kAppTitle} ${Platform.operatingSystem}',
          )
          .timeout(Duration(seconds: _timeoutSeconds));
    } on Exception {
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      if (_client.isLogged()) {
        await _client.logout();
      }
    } on Exception {
      rethrow;
    }
  }
}
