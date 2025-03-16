import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:matrix/encryption/utils/bootstrap.dart';
import 'package:matrix/encryption/utils/key_verification.dart';
import 'package:matrix/matrix.dart';
import 'package:safe_change_notifier/safe_change_notifier.dart';

import '../common/logging.dart';
import '../app/app_config.dart';

class AuthenticationModel extends SafeChangeNotifier {
  AuthenticationModel({
    required Client client,
    required FlutterSecureStorage secureStorage,
  })  : _client = client,
        _secureStorage = secureStorage;

  final Client _client;
  final FlutterSecureStorage _secureStorage;

  Future<bool> checkBootstrap({bool startBootstrappingIfNeeded = false}) async {
    if (!_client.encryptionEnabled) {
      return true;
    }

    await _client.accountDataLoading;
    await _client.userDeviceKeysLoading;
    if (_client.prevBatch == null) {
      await _client.onSync.stream.first;
    }
    final crossSigning =
        await _client.encryption?.crossSigning.isCached() ?? false;
    final needsBootstrap =
        await _client.encryption?.keyManager.isCached() == false ||
            _client.encryption?.crossSigning.enabled == false ||
            crossSigning == false;
    final isUnknownSession = _client.isUnknownSession;

    final requireBootstrap = needsBootstrap || isUnknownSession;

    if (requireBootstrap && startBootstrappingIfNeeded) {
      startBootstrap(wipe: false);
    }

    return requireBootstrap;
  }

  String get secureStorageKey => 'ssss_recovery_key_${_client.userID}';

  bool _storeInSecureStorage = false;
  bool get storeInSecureStorage => _storeInSecureStorage;
  void setStoreInSecureStorage(bool value) {
    if (_storeInSecureStorage == value) return;
    _storeInSecureStorage = value;
    notifyListeners();
  }

  String? _recoveryKeyInputError;
  String? get recoveryKeyInputError => _recoveryKeyInputError;
  void setRecoveryKeyInputError(String? value) {
    if (_recoveryKeyInputError == value) return;
    _recoveryKeyInputError = value;
    notifyListeners();
  }

  bool _recoveryKeyInputLoading = false;
  bool get recoveryKeyInputLoading => _recoveryKeyInputLoading;
  void setRecoveryKeyInputLoading(bool value) {
    if (_recoveryKeyInputLoading == value) return;
    _recoveryKeyInputLoading = value;
    notifyListeners();
  }

  bool _recoveryKeyStored = false;
  bool get recoveryKeyStored => _recoveryKeyStored;
  void setRecoveryKeyStored(bool value) {
    if (_recoveryKeyStored == value) return;
    _recoveryKeyStored = value;
    notifyListeners();
  }

  bool _recoveryKeyCopied = false;
  bool get recoveryKeyCopied => _recoveryKeyCopied;
  void setRecoveryKeyCopied(bool value) {
    if (_recoveryKeyCopied == value) return;
    _recoveryKeyCopied = value;
    notifyListeners();
  }

  void storeRecoveryKey() {
    if (storeInSecureStorage) {
      _secureStorage.write(
        key: secureStorageKey,
        value: key,
      );
    }
    setRecoveryKeyStored(true);
  }

  Future<String?> _loadKeyFromSecureStorage() async =>
      _secureStorage.read(key: secureStorageKey);

  String? _key;
  String? get key => _key;
  Bootstrap? _bootstrap;
  Bootstrap? get bootstrap => _bootstrap;
  void _setBootsTrap(Bootstrap bootstrap) {
    _bootstrap = bootstrap;
    _key = bootstrap.newSsssKey?.recoveryKey;
    notifyListeners();
  }

  bool _wipe = false;
  bool get wipe => _wipe;
  Future<void> startBootstrap({required bool wipe}) async {
    _wipe = wipe;
    _recoveryKeyStored = false;
    _bootstrap =
        _client.encryption?.bootstrap(onUpdate: (v) => _setBootsTrap(v));
    final theKey = await _loadKeyFromSecureStorage();
    if (key != null) {
      _key = theKey;
    }

    notifyListeners();
  }

  Future<KeyVerification> startKeyVerification() async {
    if (_client.userID != null &&
        _client.userDeviceKeys[_client.userID!] != null) {
      await _client.updateUserDeviceKeys();
      return _client.userDeviceKeys[_client.userID!]!.startVerification();
    } else {
      return Future<KeyVerification>.error('Unknown userID');
    }
  }

  RequestTokenResponse? currentThreepidCreds;
  String currentClientSecret = '';

  Stream<LoginState> get loginStateStream => _client.onLoginStateChanged.stream;
  bool get isLogged => _client.isLogged();
  Stream<KeyVerification> get onKeyVerificationRequest =>
      _client.onKeyVerificationRequest.stream;
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

  Future<LoginResponse?> ssoLogin({
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
