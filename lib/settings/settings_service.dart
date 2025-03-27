import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  SettingsService({
    required SharedPreferences sharedPreferences,
    required FlutterSecureStorage secureStorage,
  })  : _sharedPreferences = sharedPreferences,
        _secureStorage = secureStorage;

  final FlutterSecureStorage _secureStorage;
  final SharedPreferences _sharedPreferences;
  final _propertiesChangedController = StreamController<bool>.broadcast();
  Stream<bool> get propertiesChanged => _propertiesChangedController.stream;
  void notify(bool saved) {
    if (saved) _propertiesChangedController.add(true);
  }

  bool get showAvatarChanges =>
      _sharedPreferences.getBool(SettingKeys.showChatAvatarChanges) ?? false;
  void setShowAvatarChanges(bool value) => _sharedPreferences
      .setBool(SettingKeys.showChatAvatarChanges, value)
      .then(notify);

  bool get showChatDisplaynameChanges =>
      _sharedPreferences.getBool(SettingKeys.showChatDisplaynameChanges) ??
      false;

  List<String> get defaultReactions {
    final stringList =
        _sharedPreferences.getStringList(SettingKeys.defaultReactions);
    return (stringList == null || stringList.isEmpty
            ? _fallbackReactions
            : stringList)
        .take(6)
        .toList();
  }

  List<String> get _fallbackReactions => ['👍', '😃', '❤️', '👀', '🎸', '👌'];
  void setDefaultReactions(List<String> value) => _sharedPreferences
      .setStringList(SettingKeys.defaultReactions, value)
      .then(notify);

  void setShowChatDisplaynameChanges(bool value) => _sharedPreferences
      .setBool(SettingKeys.showChatDisplaynameChanges, value)
      .then(notify);

  Object? get<T>(String key) => switch (T) {
        const (String) => _sharedPreferences.getString(key),
        const (bool) => _sharedPreferences.getBool(key),
        const (double) => _sharedPreferences.getDouble(key),
        const (int) => _sharedPreferences.getInt(key),
        const (List<String>) => _sharedPreferences.getStringList(key),
        _ => throw Exception('Invalid type'),
      };

  void set({required String key, required Object value}) => switch (value) {
        const (String) =>
          _sharedPreferences.setString(key, value as String).then(notify),
        const (bool) =>
          _sharedPreferences.setBool(key, value as bool).then(notify),
        const (double) =>
          _sharedPreferences.setDouble(key, value as double).then(notify),
        const (int) =>
          _sharedPreferences.setInt(key, value as int).then(notify),
        const (List<String>) => _sharedPreferences
            .setStringList(key, value as List<String>)
            .then(notify),
        _ => throw Exception('Invalid type'),
      };

  Future<String?> getSecure<T>(String key) => _secureStorage.read(key: key);

  void setSecure({required String key, required String value}) =>
      _secureStorage.write(key: key, value: value).then((_) => notify(true));

  Future<void> dispose() async => _propertiesChangedController.close();
}

class SettingKeys {
  static const showChatAvatarChanges = 'showChatAvatarChanges';
  static const showChatDisplaynameChanges = 'showChatDisplaynameChanges';
  static String defaultReactions = 'defaultReactions';
}
