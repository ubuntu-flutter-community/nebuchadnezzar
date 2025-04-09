import 'dart:io'; // Still needed for non-web checks

import 'package:flutter/foundation.dart'; // Added for kIsWeb
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
        initialDeviceDisplayName: kIsWeb
            ? '${AppConfig.kAppTitle} Web Browser'
            : '${AppConfig.kAppTitle} ${Platform.operatingSystem}',
      );
      await _init();
      await onSuccess();
    } on Exception catch (e, s) {
      await onFail(e.toString());
      printMessageInDebugMode(e, s);
    } finally {
      _setProcessingAccess(false);
    }
  }

  Future<LoginResponse?> singleSingOnLogin({
    required String homeServer,
    required Function(String error) onFail,
    required Future Function() onSuccess,
  }) async {
    // Use custom scheme only on non-web macOS.
    // For web, redirect to the auth.html page on the same origin.
    final isDesktopMacOS = !kIsWeb && Platform.isMacOS;
    final redirectUrl = isDesktopMacOS
        ? '${AppConfig.appOpenUrlScheme.toLowerCase()}://login'
        // IMPORTANT: Path must point to auth.html for web callback mechanism
        : 'http://localhost:7331/auth.html'; // Assuming 7331 is the correct dev server port

    await _client.checkHomeserver(Uri.https(homeServer, ''));
    final url = _client.homeserver!.replace(
      path: '/_matrix/client/v3/login/sso/redirect',
      queryParameters: {'redirectUrl': redirectUrl},
    );

    // Use custom scheme only on non-web macOS, otherwise use http scheme for localhost
    final urlScheme = isDesktopMacOS
        ? Uri.parse(redirectUrl).scheme
        : 'http'; // Scheme for localhost URL

    String result;
    try {
      result = await FlutterWebAuth2.authenticate(
        url: url.toString(),
        callbackUrlScheme: urlScheme,
        options: const FlutterWebAuth2Options(
            // preferEphemeral: kIsWeb // Consider using ephemeral session for web
            ),
      );
      // Log the raw result from the authentication package (now expected to be posted from auth.html)
      print('SSO Auth Result (from postMessage): $result');
    } catch (e, s) {
      // Handle potential errors during authentication itself
      printMessageInDebugMode('Error during FlutterWebAuth2.authenticate: $e', s);
      onFail('SSO authentication failed or was cancelled.');
      return null;
    }

    Uri parsedResult;
    try {
      // The result should now be the full URL posted from auth.html
      parsedResult = Uri.parse(result);
    } catch (e, s) {
      // Handle potential errors during URI parsing
      printMessageInDebugMode('Error parsing SSO result URI: "$result" - $e', s);
      onFail('Failed to parse SSO response.');
      return null;
    }

    final token = parsedResult.queryParameters['loginToken'];
    if (token == null || token.isEmpty) { // Simplified null/empty check
      print('Login token not found in SSO result query parameters: ${parsedResult.queryParameters}');
      onFail('Login token not received from SSO.');
      return null;
    }

    _setProcessingAccess(true);
    LoginResponse? response;
    try {
      response = await _client.login(
        LoginType.mLoginToken,
        token: token,
        initialDeviceDisplayName: kIsWeb
            ? '${AppConfig.kAppTitle} Web Browser'
            : '${AppConfig.kAppTitle} ${Platform.operatingSystem}',
      );
      await _init();
      await onSuccess();
    } catch (e, s) { // Catch specific login errors
      printMessageInDebugMode('Error during client.login with token: $e', s);
      onFail('Failed to login with SSO token: ${e.toString()}');
    } finally {
      _setProcessingAccess(false);
    }

    return response;
  }

  Future<void> _init() async {
    await _client.firstSyncReceived;
    await _client.roomsLoading;
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
}
