import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:matrix/encryption/utils/key_verification.dart';
import 'package:matrix/matrix.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart' as sqlite;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:watch_it/watch_it.dart';

import '../constants.dart';
import 'chat/authentication/authentication_model.dart';
import 'chat/bootstrap/bootstrap_model.dart';
import 'chat/chat_download_model.dart';
import 'chat/chat_download_service.dart';
import 'chat/chat_model.dart';
import 'chat/draft_model.dart';
import 'chat/local_image_model.dart';
import 'chat/local_image_service.dart';
import 'chat/remote_image_model.dart';
import 'chat/remote_image_service.dart';
import 'chat/search_model.dart';
import 'chat/settings/settings_model.dart';

void registerDependencies() => di
  ..registerSingletonAsync<Client>(
    _ClientX.registerAsync,
    dispose: (s) => s.dispose(),
  )
  ..registerSingletonWithDependencies<AuthenticationModel>(
    () => AuthenticationModel(
      client: di<Client>(),
    ),
    dispose: (s) => s.dispose(),
    dependsOn: [Client],
  )
  ..registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
    ),
  )
  ..registerSingletonAsync<SharedPreferences>(
    () async => SharedPreferences.getInstance(),
  )
  ..registerSingletonWithDependencies<LocalImageService>(
    () => LocalImageService(client: di<Client>()),
    dependsOn: [Client],
    dispose: (s) => s.dispose(),
  )
  ..registerSingletonWithDependencies<ChatModel>(
    () => ChatModel(client: di<Client>()),
    dispose: (s) => s.dispose(),
    dependsOn: [Client],
  )
  ..registerSingletonWithDependencies<SettingsModel>(
    () => SettingsModel(client: di<Client>()),
    dispose: (s) => s.dispose(),
    dependsOn: [Client],
  )
  ..registerSingletonWithDependencies<DraftModel>(
    () => DraftModel(
      client: di<Client>(),
      localImageService: di<LocalImageService>(),
    ),
    dispose: (s) => s.dispose(),
    dependsOn: [Client],
  )
  ..registerSingletonAsync<ChatDownloadService>(
    () async {
      final service = ChatDownloadService(
        client: di<Client>(),
        preferences: di<SharedPreferences>(),
      );
      await service.init();
      return service;
    },
    dispose: (s) => s.dispose(),
    dependsOn: [Client, SharedPreferences],
  )
  ..registerSingletonWithDependencies<ChatDownloadModel>(
    () => ChatDownloadModel(service: di<ChatDownloadService>())..init(),
    dispose: (s) => s.dispose(),
    dependsOn: [ChatDownloadService],
  )
  ..registerSingletonWithDependencies<BootstrapModel>(
    () => BootstrapModel(
      client: di<Client>(),
      secureStorage: di<FlutterSecureStorage>(),
    ),
    dispose: (s) => s.dispose(),
    dependsOn: [Client],
  )
  ..registerSingletonWithDependencies<LocalImageModel>(
    () => LocalImageModel(
      service: di<LocalImageService>(),
    )..init(),
    dispose: (s) => s.dispose(),
    dependsOn: [LocalImageService],
  )
  ..registerSingletonWithDependencies<RemoteImageService>(
    () => RemoteImageService(client: di<Client>()),
    dispose: (s) => s.dispose(),
    dependsOn: [Client],
  )
  ..registerSingletonWithDependencies<RemoteImageModel>(
    () => RemoteImageModel(
      service: di<RemoteImageService>(),
    )..init(),
    dependsOn: [RemoteImageService],
    dispose: (s) => s.dispose(),
  )
  ..registerSingletonWithDependencies<SearchModel>(
    () => SearchModel(client: di<Client>()),
    dispose: (s) => s.dispose(),
    dependsOn: [Client],
  );

extension _ClientX on Client {
  static Future<Client> registerAsync() async {
    if (Platform.isLinux) {
      sqlite.Sqflite();
      sqlite.databaseFactoryOrNull = databaseFactoryFfi;
    }
    final client = Client(
      kAppId,
      nativeImplementations: kIsWeb
          ? const NativeImplementationsDummy()
          : NativeImplementationsIsolate(compute),
      verificationMethods: {
        KeyVerificationMethod.numbers,
        if (kIsWeb || Platform.isAndroid || Platform.isIOS || Platform.isLinux)
          KeyVerificationMethod.emoji,
      },
      databaseBuilder: kIsWeb
          ? null
          : (_) async {
              final dir = await getApplicationSupportDirectory();
              final db = MatrixSdkDatabase(
                kAppId,
                database: await sqlite
                    .openDatabase(p.join(dir.path, 'database.sqlite')),
              );
              await db.open();
              return db;
            },
    );
    // This reads potential credentials that might exist from previous sessions.
    await client.init(waitForFirstSync: client.isLogged());
    await client.firstSyncReceived;
    await client.roomsLoading;

    return client;
  }
}
