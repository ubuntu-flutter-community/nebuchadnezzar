import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../settings/settings_service.dart';

@module
abstract class SecureStorageModule {
  @singleton
  @preResolve
  Future<FlutterSecureStorage> getFlutterSecureStorage(
    SharedPreferences sharedPreferences,
  ) async {
    const flutterSecureStorage = FlutterSecureStorage(
      iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
    );

    if (!sharedPreferences.containsKey(SettingKeys.firstInstall)) {
      await flutterSecureStorage.deleteAll();

      await sharedPreferences.setBool(SettingKeys.firstInstall, false);
    }

    return flutterSecureStorage;
  }
}
