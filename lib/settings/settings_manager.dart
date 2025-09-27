import 'dart:async';

import 'package:safe_change_notifier/safe_change_notifier.dart';

import 'settings_service.dart';

class SettingsManager extends SafeChangeNotifier {
  SettingsManager({required SettingsService settingsService})
    : _settingsService = settingsService {
    _propertiesChangedSub ??= _settingsService.propertiesChanged.listen(
      (_) => notifyListeners(),
    );
  }

  final SettingsService _settingsService;
  StreamSubscription<bool>? _propertiesChangedSub;

  @override
  Future<void> dispose() async {
    super.dispose();
    return _propertiesChangedSub?.cancel();
  }

  bool get showChatAvatarChanges => _settingsService.showAvatarChanges;
  void setShowAvatarChanges(bool value) =>
      _settingsService.setShowAvatarChanges(value);

  bool get showChatDisplaynameChanges =>
      _settingsService.showChatDisplaynameChanges;
  void setShowChatDisplaynameChanges(bool value) =>
      _settingsService.setShowChatDisplaynameChanges(value);

  List<String> get defaultReactions => _settingsService.defaultReactions;
  void setDefaultReactions(List<String> value) =>
      _settingsService.setDefaultReactions(value);

  int get themModeIndex => _settingsService.themModeIndex;
  void setThemModeIndex(int i) => _settingsService.setThemModeIndex(i);

  int get shareKeysWithIndex => _settingsService.shareKeysWithIndex;
  void setShareKeysWithIndex(int value) =>
      _settingsService.setShareKeysWithIndex(value);
}
