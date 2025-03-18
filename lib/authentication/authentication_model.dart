import 'dart:io';

import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:matrix/matrix.dart';
import 'package:safe_change_notifier/safe_change_notifier.dart';

import '../app/app_config.dart';
import '../common/logging.dart';

class AuthenticationModel extends SafeChangeNotifier {
  AuthenticationModel({
    required Client client,
  }) : _client = client;

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

      await _client.login(
        LoginType.mLoginPassword,
        password: password,
        identifier: AuthenticationUserIdentifier(user: username),
        initialDeviceDisplayName:
            '${AppConfig.kAppTitle} ${Platform.operatingSystem}',
      );
      await _client.firstSyncReceived;
      await _client.roomsLoading;
      await _loadMediaConfig();
      await onSuccess();
    } on Exception catch (e, s) {
      await onFail(e.toString());
      printMessageInDebugMode(e, s);
    } finally {
      _setProcessingAccess(false);
    }
  }

  Future logout({
    required Function(String error) onFail,
  }) async {
    _setProcessingAccess(true);
    try {
      await _client.logout();
    } on Exception catch (e) {
      onFail(e.toString());
    } finally {
      _setProcessingAccess(false);
    }
  }

  Future<LoginResponse?> singleSingOnLogin({
    required String homeServer,
    required Function(String error) onFail,
    required Future Function() onSuccess,
  }) async {
    final redirectUrl = Platform.isMacOS
        ? '${AppConfig.appOpenUrlScheme.toLowerCase()}://login'
        : 'http://localhost:3001//login';

    await _client.checkHomeserver(Uri.https(homeServer, ''));
    final url = _client.homeserver!.replace(
      path: '/_matrix/client/v3/login/sso/redirect',
      queryParameters: {'redirectUrl': redirectUrl},
    );

    final urlScheme = Platform.isMacOS
        ? Uri.parse(redirectUrl).scheme
        : 'http://localhost:3001';
    final result = await FlutterWebAuth2.authenticate(
      url: url.toString(),
      callbackUrlScheme: urlScheme,
      options: const FlutterWebAuth2Options(),
    );
    final token = Uri.parse(result).queryParameters['loginToken'];
    if (token?.isEmpty ?? false) return null;

    _setProcessingAccess(true);
    LoginResponse? response;
    try {
      response = await _client.login(
        LoginType.mLoginToken,
        token: token,
        initialDeviceDisplayName:
            '${AppConfig.kAppTitle} ${Platform.operatingSystem}',
      );
      await _loadMediaConfig();
      await onSuccess();
    } catch (e) {
      onFail(e.toString());
    } finally {
      _setProcessingAccess(false);
    }

    return response;
  }

  int get maxUploadSize => _mediaConfig?.mUploadSize ?? 100 * 1000 * 1000;
  MediaConfig? _mediaConfig;

  Future<void> _loadMediaConfig() async {
    _mediaConfig = await _client.getConfig();
  }
}
