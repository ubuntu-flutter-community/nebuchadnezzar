// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:local_notifier/local_notifier.dart' as _i526;
import 'package:matrix/matrix.dart' as _i871;
import 'package:media_kit_video/media_kit_video.dart' as _i150;
import 'package:record/record.dart' as _i1039;
import 'package:shared_preferences/shared_preferences.dart' as _i460;
import 'package:window_manager/window_manager.dart' as _i740;

import 'authentication/authentication_manager.dart' as _i477;
import 'authentication/authentication_service.dart' as _i590;
import 'chat_room/create_or_edit/create_room_manager.dart' as _i47;
import 'chat_room/create_or_edit/edit_room_manager.dart' as _i667;
import 'chat_room/create_or_edit/edit_room_service.dart' as _i32;
import 'chat_room/input/draft_manager.dart' as _i728;
import 'chat_room/input/record_service.dart' as _i1048;
import 'chat_room/timeline/timeline_manager.dart' as _i328;
import 'common/chat_manager.dart' as _i436;
import 'common/file_system_service.dart' as _i819;
import 'common/local_image_manager.dart' as _i965;
import 'common/remote_image_manager.dart' as _i234;
import 'common/remote_image_service.dart' as _i674;
import 'common/search_manager.dart' as _i453;
import 'encryption/encryption_manager.dart' as _i934;
import 'events/chat_download_manager.dart' as _i649;
import 'events/chat_export_service.dart' as _i825;
import 'online_art/online_art_service.dart' as _i543;
import 'player/player_manager.dart' as _i444;
import 'radio/radio_manager.dart' as _i749;
import 'radio/radio_service.dart' as _i811;
import 'settings/account_manager.dart' as _i177;
import 'settings/settings_manager.dart' as _i651;
import 'settings/settings_service.dart' as _i763;
import 'third_party/audio_recorder_module.dart' as _i156;
import 'third_party/dio_module.dart' as _i1039;
import 'third_party/local_notifier_module.dart' as _i8;
import 'third_party/matrix_client_module.dart' as _i214;
import 'third_party/media_kit_module.dart' as _i94;
import 'third_party/secure_storage_module.dart' as _i416;
import 'third_party/shared_preferences_module.dart' as _i357;
import 'third_party/window_manager_module.dart' as _i271;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final dioModule = _$DioModule();
    final localNotifierModule = _$LocalNotifierModule();
    final mediaKitModule = _$MediaKitModule();
    final sharedPreferencesModule = _$SharedPreferencesModule();
    final windowManagerModule = _$WindowManagerModule();
    final audioRecorderModule = _$AudioRecorderModule();
    final secureStorageModule = _$SecureStorageModule();
    final matrixClientModule = _$MatrixClientModule();
    gh.factoryCached<_i819.FileSystemService>(
      () => const _i819.FileSystemService(),
    );
    gh.factory<_i361.Dio>(() => dioModule.create());
    await gh.factoryAsync<_i526.LocalNotifier>(
      () => localNotifierModule.create,
      preResolve: true,
    );
    gh.factory<_i150.VideoController>(() => mediaKitModule.mediaKit);
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => sharedPreferencesModule.sharedPreferences,
      preResolve: true,
    );
    await gh.factoryAsync<_i740.WindowManager>(
      () => windowManagerModule.create(),
      preResolve: true,
    );
    gh.lazySingleton<_i328.TimelineManager>(() => _i328.TimelineManager());
    gh.lazySingleton<_i965.LocalImageManager>(() => _i965.LocalImageManager());
    gh.lazySingleton<_i1039.AudioRecorder>(
      () => audioRecorderModule.audioRecorder,
    );
    gh.lazySingleton<_i1048.RecordService>(
      () => _i1048.RecordService(audioRecorder: gh<_i1039.AudioRecorder>()),
    );
    gh.lazySingleton<_i825.ChatExportService>(
      () => _i825.ChatExportService(
        preferences: gh<_i460.SharedPreferences>(),
        fileSystemService: gh<_i819.FileSystemService>(),
      ),
    );
    await gh.singletonAsync<_i558.FlutterSecureStorage>(
      () => secureStorageModule.getFlutterSecureStorage(
        gh<_i460.SharedPreferences>(),
      ),
      preResolve: true,
    );
    gh.lazySingleton<_i543.OnlineArtService>(
      () => _i543.OnlineArtService(dio: gh<_i361.Dio>()),
    );
    await gh.lazySingletonAsync<_i763.SettingsService>(
      () {
        final i = _i763.SettingsService(
          sharedPreferences: gh<_i460.SharedPreferences>(),
          secureStorage: gh<_i558.FlutterSecureStorage>(),
        );
        return i.init().then((_) => i);
      },
      preResolve: true,
      dispose: (i) => i.dispose(),
    );
    await gh.lazySingletonAsync<_i871.Client>(
      () => matrixClientModule.create(
        settingsService: gh<_i763.SettingsService>(),
        flutterSecureStorage: gh<_i558.FlutterSecureStorage>(),
      ),
      preResolve: true,
    );
    gh.lazySingleton<_i934.EncryptionManager>(
      () => _i934.EncryptionManager(
        client: gh<_i871.Client>(),
        secureStorage: gh<_i558.FlutterSecureStorage>(),
      ),
    );
    await gh.lazySingletonAsync<_i444.PlayerManager>(
      () =>
          _i444.PlayerManager(controller: gh<_i150.VideoController>()).create(),
      preResolve: true,
    );
    gh.lazySingleton<_i728.DraftManager>(
      () => _i728.DraftManager(
        client: gh<_i871.Client>(),
        recordService: gh<_i1048.RecordService>(),
      ),
    );
    gh.factoryCached<_i651.SettingsManager>(
      () => _i651.SettingsManager(settingsService: gh<_i763.SettingsService>()),
    );
    gh.lazySingleton<_i590.AuthenticationService>(
      () => _i590.AuthenticationService(client: gh<_i871.Client>()),
    );
    gh.lazySingleton<_i47.CreateRoomManager>(
      () => _i47.CreateRoomManager(client: gh<_i871.Client>()),
    );
    gh.lazySingleton<_i32.EditRoomService>(
      () => _i32.EditRoomService(client: gh<_i871.Client>()),
    );
    gh.lazySingleton<_i436.ChatManager>(
      () => _i436.ChatManager(client: gh<_i871.Client>()),
    );
    gh.lazySingleton<_i674.RemoteImageService>(
      () => _i674.RemoteImageService(client: gh<_i871.Client>()),
    );
    gh.lazySingleton<_i453.SearchManager>(
      () => _i453.SearchManager(client: gh<_i871.Client>()),
    );
    gh.lazySingleton<_i177.AccountManager>(
      () => _i177.AccountManager(client: gh<_i871.Client>()),
    );
    gh.lazySingleton<_i649.ChatDownloadManager>(
      () => _i649.ChatDownloadManager(
        chatExportService: gh<_i825.ChatExportService>(),
        fileSystemService: gh<_i819.FileSystemService>(),
        settingsService: gh<_i763.SettingsService>(),
      ),
    );
    gh.lazySingleton<_i811.RadioService>(
      () => _i811.RadioService(
        playerManager: gh<_i444.PlayerManager>(),
        onlineArtService: gh<_i543.OnlineArtService>(),
      ),
    );
    gh.lazySingleton<_i234.RemoteImageManager>(
      () => _i234.RemoteImageManager(service: gh<_i674.RemoteImageService>()),
    );
    gh.lazySingleton<_i477.AuthenticationManager>(
      () => _i477.AuthenticationManager(
        authenticationService: gh<_i590.AuthenticationService>(),
      ),
    );
    gh.lazySingleton<_i749.RadioManager>(
      () => _i749.RadioManager(
        settingsService: gh<_i763.SettingsService>(),
        radioService: gh<_i811.RadioService>(),
      ),
    );
    gh.lazySingleton<_i667.EditRoomManager>(
      () => _i667.EditRoomManager(editRoomService: gh<_i32.EditRoomService>()),
    );
    return this;
  }
}

class _$DioModule extends _i1039.DioModule {}

class _$LocalNotifierModule extends _i8.LocalNotifierModule {}

class _$MediaKitModule extends _i94.MediaKitModule {}

class _$SharedPreferencesModule extends _i357.SharedPreferencesModule {}

class _$WindowManagerModule extends _i271.WindowManagerModule {}

class _$AudioRecorderModule extends _i156.AudioRecorderModule {}

class _$SecureStorageModule extends _i416.SecureStorageModule {}

class _$MatrixClientModule extends _i214.MatrixClientModule {}
