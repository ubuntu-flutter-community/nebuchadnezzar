import 'package:matrix/matrix.dart';
import 'package:safe_change_notifier/safe_change_notifier.dart';

import '../../common/logging.dart';
import '../../common/room_x.dart';

class CreateOrEditRoomModel extends SafeChangeNotifier {
  CreateOrEditRoomModel loadFromDialog({
    required Room? room,
    required bool isSpace,
  }) {
    if (room == null) {
      _name = '';
      _topic = '';
      _isSpace = isSpace;
      _enableEncryption = false;
      _federated = false;
      _groupCall = false;
      _joinRules = JoinRules.public;
      _historyVisibility = HistoryVisibility.shared;
      _profiles = {};
    } else {
      _name = room.name;
      _topic = room.topic;
      _isSpace = room.isSpace;
      _enableEncryption = room.encrypted;
      _federated = room.isFederated;
      _groupCall = room.groupCallsEnabledForEveryone;
      _joinRules = room.joinRules ?? JoinRules.public;
      _historyVisibility = room.historyVisibility ?? HistoryVisibility.shared;
      _profiles = room.getProfiles();
    }

    return this;
  }

  String _name = '';
  String get name => _name;
  void setName(String name) {
    if (name == _name) return;
    _name = name;
    notifyListeners();
  }

  Future<void> changeRoomName(Room room) async {
    try {
      await room.setName(_name);
    } catch (e, s) {
      printMessageInDebugMode(e, s);
      rethrow;
    }
  }

  String _topic = '';
  String get topic => _topic;
  void setTopic(String topic) {
    if (topic == _topic) return;
    _topic = topic;
    notifyListeners();
  }

  Future<void> changeRoomTopic(Room room) async {
    try {
      await room.setDescription(_topic);
    } catch (e, s) {
      printMessageInDebugMode(e, s);
      rethrow;
    }
  }

  bool _isSpace = false;
  bool get isSpace => _isSpace;

  bool _enableEncryption = false;
  bool get enableEncryption => _enableEncryption;
  void setEnableEncryption(bool enableEncryption) {
    if (enableEncryption == _enableEncryption) return;
    _enableEncryption = enableEncryption;
    notifyListeners();
  }

  Future<void> enableEncryptionForRoom(Room room) async {
    try {
      if (room.encrypted) {
        return;
      } else {
        await room.enableEncryption();
      }
    } catch (e, s) {
      printMessageInDebugMode(e, s);
      rethrow;
    }
  }

  bool _federated = false;
  bool get federated => _federated;
  void setFederated(bool federated) {
    if (federated == _federated) return;
    _federated = federated;
    notifyListeners();
  }

  bool _groupCall = false;
  bool get groupCall => _groupCall;
  void setGroupCall(bool groupCall) {
    if (groupCall == _groupCall) return;
    _groupCall = groupCall;
    notifyListeners();
  }

  JoinRules _joinRules = JoinRules.public;
  JoinRules get joinRules => _joinRules;
  void setJoinRules(JoinRules joinRule) {
    if (joinRule == _joinRules) return;
    _joinRules = joinRule;
    notifyListeners();
  }

  HistoryVisibility _historyVisibility = HistoryVisibility.shared;
  HistoryVisibility get historyVisibility => _historyVisibility;
  void setHistoryVisibility(HistoryVisibility historyVisibility) {
    if (historyVisibility == _historyVisibility) return;
    _historyVisibility = historyVisibility;
    notifyListeners();
  }

  Future<void> setHistoryVisibilityForRoom({
    required Room room,
    required HistoryVisibility value,
  }) async {
    try {
      await room.setHistoryVisibility(value);
    } catch (e, s) {
      printMessageInDebugMode(e, s);
      rethrow;
    }
  }

  Future<void> setJoinRulesForRoom({
    required Room room,
    required JoinRules value,
  }) async {
    try {
      await room.setJoinRules(value);
    } catch (e, s) {
      printMessageInDebugMode(e, s);
      rethrow;
    }
  }

  Set<Profile> _profiles = {};
  Set<Profile> get profiles => _profiles;
  void setProfiles(Set<Profile> profiles) {
    _profiles = profiles;
    notifyListeners();
  }

  void addProfile(Profile profile) {
    if (_profiles.contains(profile)) return;
    _profiles.add(profile);
    notifyListeners();
  }

  Future<void> inviteUserToRoom({
    required Room room,
    required String userId,
  }) async {
    try {
      await room.invite(userId);
    } catch (e) {
      rethrow;
    }
  }

  void removeProfile(Profile profile) {
    if (!_profiles.contains(profile)) return;
    _profiles.remove(profile);
    notifyListeners();
  }

  Future<void> editPowerLevel({
    required Room room,
    required String key,
    int? newLevel,
    String? category,
  }) async {
    try {
      if (newLevel == null) return;
      final content = Map<String, dynamic>.from(
        room.getState(EventTypes.RoomPowerLevels)!.content,
      );
      if (category != null) {
        if (!content.containsKey(category)) {
          content[category] = <String, dynamic>{};
        }
        content[category][key] = newLevel;
      } else {
        content[key] = newLevel;
      }
      await room.client.setRoomStateWithKey(
        room.id,
        EventTypes.RoomPowerLevels,
        '',
        content,
      );
    } on Exception catch (e, s) {
      printMessageInDebugMode(e, s);
      rethrow;
    }
  }

  Future<void> toggleFavorite(Room room) async {
    try {
      await room.setFavourite(!room.isFavourite);
    } catch (e, s) {
      printMessageInDebugMode(e, s);
      rethrow;
    }
  }

  Future<void> setPushRuleState(
    Room room, {
    required PushRuleState value,
  }) async {
    try {
      await room.setPushRuleState(value);
    } catch (e, s) {
      printMessageInDebugMode(e, s);
      rethrow;
    }
  }
}
