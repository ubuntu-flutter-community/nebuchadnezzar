import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:matrix/encryption/utils/bootstrap.dart';
import 'package:matrix/encryption/utils/key_verification.dart';
import 'package:matrix/matrix.dart';
import 'package:safe_change_notifier/safe_change_notifier.dart';

class EncryptionModel extends SafeChangeNotifier {
  EncryptionModel({
    required Client client,
    required FlutterSecureStorage secureStorage,
  }) : _client = client,
       _secureStorage = secureStorage;

  final Client _client;
  final FlutterSecureStorage _secureStorage;

  Stream<KeyVerification> get onKeyVerificationRequest =>
      _client.onKeyVerificationRequest.stream;

  Future<bool> checkIfEncryptionSetupIsNeeded() async {
    if (!_client.encryptionEnabled) return true;

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

    return needsBootstrap || _client.isUnknownSession;
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
      _secureStorage.write(key: secureStorageKey, value: key);
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
    switch (bootstrap.state) {
      case BootstrapState.loading ||
          BootstrapState.done ||
          BootstrapState.error:
        return;
      case BootstrapState.openExistingSsss:
        setRecoveryKeyStored(true);
      case BootstrapState.askWipeSsss:
        bootstrap.wipeSsss(wipe);
      case BootstrapState.askBadSsss:
        bootstrap.ignoreBadSecrets(true);
      case BootstrapState.askUseExistingSsss:
        bootstrap.useExistingSsss(!wipe);
      case BootstrapState.askUnlockSsss:
        bootstrap.unlockedSsss();
      case BootstrapState.askNewSsss:
        bootstrap.newSsss();
      case BootstrapState.askWipeCrossSigning:
        bootstrap.wipeCrossSigning(wipe);
      case BootstrapState.askSetupCrossSigning:
        bootstrap.askSetupCrossSigning(
          setupMasterKey: true,
          setupSelfSigningKey: true,
          setupUserSigningKey: true,
        );
      case BootstrapState.askWipeOnlineKeyBackup:
        bootstrap.wipeOnlineKeyBackup(wipe);

      case BootstrapState.askSetupOnlineKeyBackup:
        bootstrap.askSetupOnlineKeyBackup(true);
    }

    _bootstrap = bootstrap;
    _key = bootstrap.newSsssKey?.recoveryKey;

    notifyListeners();
  }

  bool _wipe = false;
  bool get wipe => _wipe;
  Future<void> startBootstrap({required bool wipe}) async {
    _wipe = wipe;
    _recoveryKeyStored = false;
    _bootstrap = _client.encryption?.bootstrap(
      onUpdate: (v) => _setBootsTrap(v),
    );
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
}
