import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_vodozemac/flutter_vodozemac.dart' as vod;
import 'package:matrix/encryption/utils/key_verification.dart';
import 'package:matrix/matrix.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:universal_html/html.dart' as html;

import '../app/app_config.dart';
import '../common/logging.dart';
import '../common/platforms.dart';
import '../settings/settings_service.dart';

extension ClientX on Client {
  static Future<Client> registerAsync({
    required SettingsService settingsService,
    required FlutterSecureStorage flutterSecureStorage,
  }) async {
    await vod.init(wasmPath: './assets/assets/vodozemac/');
    final client = Client(
      AppConfig.appId,
      nativeImplementations: Platforms.isWeb
          ? const NativeImplementationsDummy()
          : NativeImplementationsIsolate(
              compute,
              vodozemacInit: () =>
                  vod.init(wasmPath: './assets/assets/vodozemac/'),
            ),
      verificationMethods: {KeyVerificationMethod.numbers},
      enableDehydratedDevices: true,
      shareKeysWith: ShareKeysWith.values[settingsService.shareKeysWithIndex],
      database: await flutterMatrixSdkDatabaseBuilder(
        AppConfig.appId,
        flutterSecureStorage,
      ),
    );
    // This reads potential credentials that might exist from previous sessions
    // to determine whether the user is logged in or not.
    await client.init().timeout(const Duration(seconds: 55));

    return client;
  }

  static Future<DatabaseApi> flutterMatrixSdkDatabaseBuilder(
    String clientName,
    FlutterSecureStorage flutterSecureStorage,
  ) async {
    MatrixSdkDatabase? database;

    try {
      database = await _constructDatabase(
        clientName: clientName,
        secureStorage: flutterSecureStorage,
      );
      await database.open();
      return database;
    } catch (e, s) {
      Logs().wtf('Unable to construct database!', e, s);
      await database?.delete().catchError(
        (e, s) => Logs().wtf(
          'Unable to delete database, after failed construction',
          e,
          s,
        ),
      );

      if (database == null && !Platforms.isWeb) {
        final dbFile = File(await _getDatabasePath(clientName));
        if (await dbFile.exists()) await dbFile.delete();
      }

      try {
        printMessageInDebugMode(
          'Unable to construct database for client "$clientName". '
          'Please report this issue on GitHub.',
        );
      } catch (e, s) {
        Logs().e('Unable to send error notification', e, s);
      }

      rethrow;
    }
  }

  static Future<String> _getDatabasePath(String clientName) async {
    final databaseDirectory = Platforms.isIOS || Platforms.isMacOS
        ? await getLibraryDirectory()
        : await getApplicationSupportDirectory();

    return p.join(databaseDirectory.path, '$clientName.sqlite');
  }

  static Future<void> _migrateLegacyLocation(
    String sqlFilePath,
    String clientName,
  ) async {
    final oldPath = Platforms.isDesktop
        ? (await getApplicationSupportDirectory()).path
        : await getDatabasesPath();

    final oldFilePath = p.join(oldPath, clientName);
    if (oldFilePath == sqlFilePath) return;

    final maybeOldFile = File(oldFilePath);
    if (await maybeOldFile.exists()) {
      Logs().i(
        'Migrate legacy location for database from "$oldFilePath" to "$sqlFilePath"',
      );
      await maybeOldFile.copy(sqlFilePath);
      await maybeOldFile.delete();
    }
  }

  static Future<MatrixSdkDatabase> _constructDatabase({
    required String clientName,
    required FlutterSecureStorage secureStorage,
  }) async {
    if (Platforms.isWeb) {
      await html.window.navigator.storage?.persist();
      return MatrixSdkDatabase.init(clientName);
    }

    final cipher = await getDatabaseCipher();

    Directory? fileStorageLocation;
    try {
      fileStorageLocation = await getTemporaryDirectory();
    } on MissingPlatformDirectoryException catch (_) {
      Logs().w(
        'No temporary directory for file cache available on this platform.',
      );
    }

    final path = await _getDatabasePath(clientName);

    // fix dlopen for old Android
    await applyWorkaroundToOpenSqlCipherOnOldAndroidVersions();
    // import the SQLite / SQLCipher shared objects / dynamic libraries
    final factory = createDatabaseFactoryFfi(
      ffiInit: SQfLiteEncryptionHelper.ffiInit,
    );

    // migrate from potential previous SQLite database path to current one
    await _migrateLegacyLocation(path, clientName);

    // required for [getDatabasesPath]
    databaseFactory = factory;

    // in case we got a cipher, we use the encryption helper
    // to manage SQLite encryption
    final helper = cipher == null
        ? null
        : SQfLiteEncryptionHelper(factory: factory, path: path, cipher: cipher);

    // check whether the DB is already encrypted and otherwise do so
    await helper?.ensureDatabaseFileEncrypted();

    final database = await factory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: 1,
        // most important : apply encryption when opening the DB
        onConfigure: helper?.applyPragmaKey,
      ),
    );

    return MatrixSdkDatabase.init(
      clientName,
      database: database,
      maxFileSize: 1000 * 1000 * 10,
      fileStorageLocation: fileStorageLocation?.uri,
      deleteFilesAfterDuration: const Duration(days: 30),
    );
  }

  static Future<String?> getDatabaseCipher() async {
    const passwordStorageKey = 'database_password';

    String? password;

    try {
      const secureStorage = FlutterSecureStorage();
      final containsEncryptionKey =
          await secureStorage.read(key: passwordStorageKey) != null;
      if (!containsEncryptionKey) {
        final rng = Random.secure();
        final list = Uint8List(32);
        list.setAll(0, Iterable.generate(list.length, (i) => rng.nextInt(256)));
        final newPassword = base64UrlEncode(list);
        await secureStorage.write(key: passwordStorageKey, value: newPassword);
      }
      // workaround for if we just wrote to the key and it still doesn't exist
      password = await secureStorage.read(key: passwordStorageKey);
      if (password == null) throw MissingPluginException();
    } on MissingPluginException catch (e) {
      await const FlutterSecureStorage()
          .delete(key: passwordStorageKey)
          .catchError((_) {});
      Logs().w('Database encryption is not supported on this platform', e);
    } catch (e, s) {
      await const FlutterSecureStorage()
          .delete(key: passwordStorageKey)
          .catchError((_) {});
      Logs().w('Unable to init database encryption', e, s);
    }

    return password;
  }
}

Future<void> applyWorkaroundToOpenSqlCipherOnOldAndroidVersions() async {}
