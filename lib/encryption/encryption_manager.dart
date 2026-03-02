import 'package:flutter/services.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:matrix/encryption/utils/crypto_setup_extension.dart';
import 'package:matrix/encryption/utils/key_verification.dart';
import 'package:matrix/matrix.dart';

class EncryptionManager {
  EncryptionManager({
    required Client client,
    required FlutterSecureStorage secureStorage,
  }) : _client = client,
       _secureStorage = secureStorage;

  final Client _client;
  final FlutterSecureStorage _secureStorage;

  Stream<KeyVerification> get onKeyVerificationRequest =>
      _client.onKeyVerificationRequest.stream;

  late final Command<void, CryptoIdentityState?>
  checkIfEncryptionSetupIsNeededCommand = Command.createAsyncNoParam(
    _checkIfEncryptionSetupIsNeeded,
    initialValue: null,
  );

  Future<CryptoIdentityState> _checkIfEncryptionSetupIsNeeded() async {
    if (!_client.encryptionEnabled) {
      return const CryptoIdentityState(connected: false, initialized: false);
    }

    await _client.accountDataLoading;
    await _client.userDeviceKeysLoading;
    if (_client.prevBatch == null) {
      await _client.onSync.stream.first;
    }
    final cryptoIdentityState = await _client.getCryptoIdentityState();

    return CryptoIdentityState(
      connected: cryptoIdentityState.connected,
      initialized: cryptoIdentityState.initialized,
    );
  }

  late final Command<
    ({String keyOrPassphrase, String? keyIdentifier, bool selfSign}),
    CryptoIdentityState
  >
  restoreCryptoIdentityCommand = Command.createAsync(
    (params) async {
      if (params.keyOrPassphrase.isEmpty) {
        throw Exception('Recovery key or passphrase cannot be empty!');
      }
      await _client.restoreCryptoIdentity(
        params.keyOrPassphrase,
        keyIdentifier: params.keyIdentifier,
        selfSign: params.selfSign,
      );

      final cryptoIdentityState = await _client.getCryptoIdentityState();
      return CryptoIdentityState(
        connected: cryptoIdentityState.connected,
        initialized: cryptoIdentityState.initialized,
      );
    },

    initialValue: const CryptoIdentityState(
      connected: false,
      initialized: false,
    ),
  );

  late final Command<NewCryptoIdentityCapsule, String?>
  initCryptoIdentityCommand = Command.createAsync(
    (capsule) => _client
        .initCryptoIdentity(
          passphrase: capsule.passphrase,
          wipeSecureStorage: capsule.wipeSecureStorage,
          wipeKeyBackup: capsule.wipeKeyBackup,
          wipeCrossSigning: capsule.wipeCrossSigning,
          setupMasterKey: capsule.setupMasterKey,
          setupSelfSigningKey: capsule.setupSelfSigningKey,
          setupUserSigningKey: capsule.setupUserSigningKey,
          setupOnlineKeyBackup: capsule.setupOnlineKeyBackup,
          keyName: capsule.keyName,
        )
        .timeout(
          const Duration(minutes: 1),
          onTimeout: () {
            throw Exception(
              'Initializing crypto identity timed out. Please try again.',
            );
          },
        ),
    initialValue: null,
  );

  late final Command<String, String?> copyRecoveryKeyCommand =
      Command.createAsync((recoveryKey) async {
        await Clipboard.setData(ClipboardData(text: recoveryKey));
        return recoveryKey;
      }, initialValue: null);

  late final Command<String, String?> storeRecoveryKeyCommand =
      Command.createAsync((recoveryKey) async {
        await _secureStorage.write(key: secureStorageKey, value: recoveryKey);

        return _secureStorage.read(key: secureStorageKey);
      }, initialValue: null);

  late final Command<void, String?> loadRecoveryKeyFromSecureStorageCommand =
      Command.createAsyncNoParam(
        () => _secureStorage.read(key: secureStorageKey),
        initialValue: null,
      );

  String get secureStorageKey => 'ssss_recovery_key_${_client.userID}';

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

class NewCryptoIdentityCapsule {
  const NewCryptoIdentityCapsule({
    this.passphrase,
    this.wipeSecureStorage = true,
    this.wipeKeyBackup = true,
    this.wipeCrossSigning = true,
    this.setupMasterKey = true,
    this.setupSelfSigningKey = true,
    this.setupUserSigningKey = true,
    this.setupOnlineKeyBackup = true,
    this.keyName,
  });

  final String? passphrase;
  final bool wipeSecureStorage;
  final bool wipeKeyBackup;
  final bool wipeCrossSigning;
  final bool setupMasterKey;
  final bool setupSelfSigningKey;
  final bool setupUserSigningKey;
  final bool setupOnlineKeyBackup;
  final String? keyName;
}

class CryptoIdentityState {
  final bool connected;
  final bool initialized;

  const CryptoIdentityState({
    required this.connected,
    required this.initialized,
  });
}
