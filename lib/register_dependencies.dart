import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_notifier/local_notifier.dart';
import 'package:matrix/matrix.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch_it/watch_it.dart';
import 'package:window_manager/window_manager.dart';

import 'app/app_config.dart';
import 'authentication/authentication_model.dart';
import 'chat_room/create_or_edit/create_or_edit_room_model.dart';
import 'chat_room/input/draft_model.dart';
import 'chat_room/timeline/timeline_model.dart';
import 'common/chat_model.dart';
import 'common/client_x.dart';
import 'common/local_image_model.dart';
import 'common/local_image_service.dart';
import 'common/platforms.dart';
import 'common/remote_image_model.dart';
import 'common/remote_image_service.dart';
import 'common/search_model.dart';
import 'encryption/encryption_model.dart';
import 'events/chat_download_model.dart';
import 'events/chat_download_service.dart';
import 'settings/settings_model.dart';
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
    ..registerSingletonAsync<Client>(
      ClientX.registerAsync,
      dispose: (s) => s.dispose(),
    )
    ..registerSingletonWithDependencies<AuthenticationModel>(
      () => AuthenticationModel(client: di<Client>()),
      dispose: (s) => s.dispose(),
      dependsOn: [Client],
    )
    ..registerSingletonWithDependencies<EncryptionModel>(
      () => EncryptionModel(
        client: di<Client>(),
        secureStorage: di<FlutterSecureStorage>(),
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
    ..registerSingletonWithDependencies<SettingsService>(
      () => SettingsService(
        sharedPreferences: di<SharedPreferences>(),
        secureStorage: di<FlutterSecureStorage>(),
      ),
      dispose: (s) => s.dispose(),
      dependsOn: [SharedPreferences],
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
    ..registerSingletonAsync<SettingsModel>(
      () async {
        final settingsModel = SettingsModel(
          client: di<Client>(),
          settingsService: di<SettingsService>(),
        );
        await settingsModel.init();
        return settingsModel;
      },
      dispose: (s) => s.dispose(),
      dependsOn: [Client, SettingsService],
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
      () => ChatDownloadModel(service: di<ChatDownloadService>()),
      dispose: (s) => s.dispose(),
      dependsOn: [ChatDownloadService],
    )
    ..registerSingletonWithDependencies<LocalImageModel>(
      () => LocalImageModel(service: di<LocalImageService>()),
      dispose: (s) => s.dispose(),
      dependsOn: [LocalImageService],
    )
    ..registerSingletonWithDependencies<RemoteImageService>(
      () => RemoteImageService(client: di<Client>()),
      dispose: (s) => s.dispose(),
      dependsOn: [Client],
    )
    ..registerSingletonWithDependencies<RemoteImageModel>(
      () => RemoteImageModel(service: di<RemoteImageService>()),
      dependsOn: [RemoteImageService],
      dispose: (s) => s.dispose(),
    )
    ..registerSingletonWithDependencies<SearchModel>(
      () => SearchModel(client: di<Client>()),
      dispose: (s) => s.dispose(),
      dependsOn: [Client],
    )
    ..registerLazySingleton<TimelineModel>(
      () => TimelineModel(),
      dispose: (s) => s.dispose(),
    )
    ..registerSingletonAsync<LocalNotifier>(() async {
      if (!kIsWeb) {
        await localNotifier.setup(appName: AppConfig.appId);
      }

      return localNotifier;
    })
    ..registerLazySingleton<CreateOrEditRoomModel>(CreateOrEditRoomModel.new);
}
