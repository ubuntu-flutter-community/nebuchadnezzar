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
    final stations = List<String>.from(favoriteStations);
    stations.add(stationUuid);
    await setFavoriteStations(stations);
  }

  Future<void> removeFavoriteStation(String stationUuid) async {
    if (!favoriteStations.contains(stationUuid)) return;
    final stations = List<String>.from(favoriteStations);
    stations.remove(stationUuid);
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
