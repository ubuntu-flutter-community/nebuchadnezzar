// ignore_for_file: unused_field

import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:matrix/matrix.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  SettingsService({
    required SharedPreferences sharedPreferences,
    required FlutterSecureStorage secureStorage,
  }) : _sharedPreferences = sharedPreferences,
       _secureStorage = secureStorage;

  final FlutterSecureStorage _secureStorage;
  final SharedPreferences _sharedPreferences;

  String? getString(String key) => _sharedPreferences.getString(key);

  List<String>? getStringList(String key) =>
      _sharedPreferences.getStringList(key);

  bool? getBool(String key) => _sharedPreferences.getBool(key);

  double? getDouble(String key) => _sharedPreferences.getDouble(key);

  int? getInt(String key) => _sharedPreferences.getInt(key);

  Future<bool> setValue(String key, dynamic value) => switch (value) {
    (bool _) => _sharedPreferences.setBool(key, value),
    (String _) => _sharedPreferences.setString(key, value),
    (int _) => _sharedPreferences.setInt(key, value),
    (double _) => _sharedPreferences.setDouble(key, value),
    (List<String> _) => _sharedPreferences.setStringList(key, value),
    _ => Future.error('Unsupported value type: ${value.runtimeType}'),
  };

  // TODO: Convert to commands in SettingsManager and remove _propertiesChangedController

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
    final stringList = _sharedPreferences.getStringList(
      SettingKeys.defaultReactions,
    );
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

  int get themModeIndex =>
      _sharedPreferences.getInt(SettingKeys.themeModeIndex) ?? 0;
  void setThemModeIndex(int i) =>
      _sharedPreferences.setInt(SettingKeys.themeModeIndex, i).then(notify);

  void setShowChatDisplaynameChanges(bool value) => _sharedPreferences
      .setBool(SettingKeys.showChatDisplaynameChanges, value)
      .then(notify);

  int get shareKeysWithIndex =>
      _sharedPreferences.getInt(SettingKeys.shareKeysWith) ??
      ShareKeysWith.all.index;
  void setShareKeysWithIndex(int value) {
    if (value < 0 || value > ShareKeysWith.values.length - 1) {
      return;
    }
    _sharedPreferences.setInt(SettingKeys.shareKeysWith, value).then(notify);
  }

  List<String> get favoriteStations =>
      _sharedPreferences.getStringList(SettingKeys.favoriteStations) ?? [];
  bool isFavoriteStation(String stationUuid) =>
      favoriteStations.contains(stationUuid);
  Future<void> setFavoriteStations(List<String> value) async =>
      _sharedPreferences
          .setStringList(SettingKeys.favoriteStations, value)
          .then(notify);
  Future<void> addFavoriteStation(String stationUuid) async {
    if (favoriteStations.contains(stationUuid)) return;
    final stations = List<String>.from(favoriteStations)..add(stationUuid);
    await setFavoriteStations(stations);
  }

  Future<void> removeFavoriteStation(String stationUuid) async {
    if (!favoriteStations.contains(stationUuid)) return;
    final stations = List<String>.from(favoriteStations)..remove(stationUuid);
    await setFavoriteStations(stations);
  }

  Future<void> dispose() async => _propertiesChangedController.close();
}

class SettingKeys {
  static const showChatAvatarChanges = 'showChatAvatarChanges';
  static const showChatDisplaynameChanges = 'showChatDisplaynameChanges';
  static const String defaultReactions = 'defaultReactions';
  static const String themeModeIndex = 'themeModeIndex';
  static const String shareKeysWith = 'shareKeysWith';
  static const String favoriteStations = 'favoriteStations';
}
