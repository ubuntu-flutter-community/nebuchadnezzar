import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

const _kShowChatAvatarChangesKey = 'showChatAvatarChanges';
const _kShowChatDisplaynameChangesKey = 'showChatDisplaynameChanges';

class SettingsService {
  SettingsService({required SharedPreferences sharedPreferences})
      : _sharedPreferences = sharedPreferences;

  Future<void> dispose() async => _propertiesChangedController.close();

  final SharedPreferences _sharedPreferences;
  final _propertiesChangedController = StreamController<bool>.broadcast();
  Stream<bool> get propertiesChanged => _propertiesChangedController.stream;
  void notify(bool saved) {
    if (saved) _propertiesChangedController.add(true);
  }

  bool get showAvatarChanges =>
      _sharedPreferences.getBool(_kShowChatAvatarChangesKey) ?? false;
  void setShowAvatarChanges(bool value) => _sharedPreferences
      .setBool(_kShowChatAvatarChangesKey, value)
      .then(notify);

  bool get showChatDisplaynameChanges =>
      _sharedPreferences.getBool(_kShowChatDisplaynameChangesKey) ?? false;
  void setShowChatDisplaynameChanges(bool value) => _sharedPreferences
      .setBool(_kShowChatDisplaynameChangesKey, value)
      .then(notify);
}
