import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_notifier/local_notifier.dart';
import 'package:matrix/matrix.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch_it/watch_it.dart';
import 'package:window_manager/window_manager.dart';

import 'app/app_config.dart';
import 'authentication/authentication_manager.dart';
import 'authentication/authentication_service.dart';
import 'chat_room/create_or_edit/create_room_manager.dart';
import 'chat_room/create_or_edit/edit_room_service.dart';
import 'chat_room/input/draft_manager.dart';
import 'chat_room/timeline/timeline_manager.dart';
import 'common/chat_manager.dart';
import 'common/local_image_manager.dart';
import 'common/local_image_service.dart';
import 'common/platforms.dart';
import 'common/remote_image_manager.dart';
import 'common/remote_image_service.dart';
import 'common/search_manager.dart';
import 'encryption/encryption_manager.dart';
import 'events/chat_download_manager.dart';
import 'events/chat_download_service.dart';
import 'extensions/client_x.dart';
import 'settings/account_manager.dart';
import 'settings/settings_manager.dart';
import 'settings/settings_service.dart';

void registerDependencies() {
  if (Platforms.isDesktop) {
    di.registerSingletonAsync<WindowManager>(() async {
      final wm = WindowManager.instance;
      await wm.ensureInitialized();
      wm
        ..setMinimumSize(const Size(500, 700))
        ..setSize(const Size(950, 820));
      return wm;
    });
  }

  di
    ..registerSingletonAsync<SharedPreferences>(
      () async => SharedPreferences.getInstance(),
    )
    ..registerLazySingleton<FlutterSecureStorage>(
      () => const FlutterSecureStorage(
        aOptions: AndroidOptions(encryptedSharedPreferences: true),
      ),
    )
    ..registerSingletonWithDependencies<SettingsService>(
      () => SettingsService(
        sharedPreferences: di<SharedPreferences>(),
        secureStorage: di<FlutterSecureStorage>(),
      ),
      dispose: (s) => s.dispose(),
      dependsOn: [SharedPreferences],
    )
    ..registerSingletonAsync<Client>(
      () async => ClientX.registerAsync(
        settingsService: di<SettingsService>(),
        flutterSecureStorage: di<FlutterSecureStorage>(),
      ),
      dispose: (s) => s.dispose(),
      dependsOn: [SettingsService],
    )
    ..registerSingletonWithDependencies<AuthenticationService>(
      () => AuthenticationService(client: di<Client>()),
      dependsOn: [Client],
    )
    ..registerLazySingleton<AuthenticationManager>(
      () => AuthenticationManager(
        authenticationService: di<AuthenticationService>(),
      ),
    )
    ..registerSingletonWithDependencies<EncryptionManager>(
      () => EncryptionManager(
        client: di<Client>(),
        secureStorage: di<FlutterSecureStorage>(),
      ),
      dispose: (s) => s.dispose(),
      dependsOn: [Client],
    )
    ..registerSingletonWithDependencies<LocalImageService>(
      () => LocalImageService(client: di<Client>()),
      dependsOn: [Client],
      dispose: (s) => s.dispose(),
    )
    ..registerSingletonWithDependencies<ChatManager>(
      () => ChatManager(client: di<Client>()),
      dispose: (s) => s.dispose(),
      dependsOn: [Client],
    )
    ..registerSingletonWithDependencies<AccountManager>(
      () => AccountManager(client: di<Client>()),
      dependsOn: [Client],
    )
    ..registerSingletonWithDependencies<SettingsManager>(
      () => SettingsManager(settingsService: di<SettingsService>()),
      dispose: (s) => s.dispose(),
      dependsOn: [SettingsService],
    )
    ..registerSingletonWithDependencies<DraftManager>(
      () => DraftManager(
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
    ..registerSingletonWithDependencies<ChatDownloadManager>(
      () => ChatDownloadManager(service: di<ChatDownloadService>()),
      dispose: (s) => s.dispose(),
      dependsOn: [ChatDownloadService],
    )
    ..registerSingletonWithDependencies<LocalImageManager>(
      () => LocalImageManager(service: di<LocalImageService>()),
      dispose: (s) => s.dispose(),
      dependsOn: [LocalImageService],
    )
    ..registerSingletonWithDependencies<RemoteImageService>(
      () => RemoteImageService(client: di<Client>()),
      dispose: (s) => s.dispose(),
      dependsOn: [Client],
    )
    ..registerSingletonWithDependencies<RemoteImageManager>(
      () => RemoteImageManager(service: di<RemoteImageService>()),
      dependsOn: [RemoteImageService],
      dispose: (s) => s.dispose(),
    )
    ..registerSingletonWithDependencies<SearchManager>(
      () => SearchManager(client: di<Client>()),
      dispose: (s) => s.dispose(),
      dependsOn: [Client],
    )
    ..registerLazySingleton<TimelineManager>(
      () => TimelineManager(),
      dispose: (s) => s.dispose(),
    )
    ..registerSingletonAsync<LocalNotifier>(() async {
      if (!kIsWeb) {
        await localNotifier.setup(appName: AppConfig.appId);
      }

      return localNotifier;
    })
    ..registerLazySingleton<EditRoomService>(
      () => EditRoomService(client: di<Client>()),
    )
    ..registerLazySingleton<CreateRoomManager>(
      () => CreateRoomManager(client: di<Client>()),
    );
}
