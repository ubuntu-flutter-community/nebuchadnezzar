import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:matrix/matrix.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch_it/watch_it.dart';

import 'chat/authentication/authentication_model.dart';
import 'chat/bootstrap/bootstrap_model.dart';
import 'chat/chat_room/common/timeline_model.dart';
import 'chat/chat_room/input/draft_model.dart';
import 'chat/common/chat_model.dart';
import 'chat/common/client_x.dart';
import 'chat/common/local_image_model.dart';
import 'chat/common/local_image_service.dart';
import 'chat/common/remote_image_model.dart';
import 'chat/common/remote_image_service.dart';
import 'chat/common/search_model.dart';
import 'chat/events/chat_download_model.dart';
import 'chat/events/chat_download_service.dart';
import 'chat/settings/settings_model.dart';
import 'chat/settings/settings_service.dart';

void registerDependencies() => di
  ..registerSingletonAsync<Client>(
    ClientX.registerAsync,
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
  ..registerSingletonWithDependencies<SettingsService>(
    () => SettingsService(
      sharedPreferences: di<SharedPreferences>(),
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
  ..registerSingletonWithDependencies<SettingsModel>(
    () => SettingsModel(
      client: di<Client>(),
      settingsService: di<SettingsService>(),
    )..init(),
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
  )
  ..registerLazySingleton<TimelineModel>(
    () => TimelineModel(),
    dispose: (s) => s.dispose(),
  );
