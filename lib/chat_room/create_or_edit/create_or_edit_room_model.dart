import 'package:file_picker/file_picker.dart';
import 'package:file_selector/file_selector.dart';
import 'package:matrix/matrix.dart';
import 'package:mime/mime.dart';
import 'package:safe_change_notifier/safe_change_notifier.dart';

import '../../common/logging.dart';
import '../../common/platforms.dart';
import '../../common/room_x.dart';

class CreateOrEditRoomModel extends SafeChangeNotifier {
  CreateOrEditRoomModel({required Client client}) : _client = client;

  final Client _client;
  Stream<SyncUpdate> get joinedUpdateStream =>
      _client.onSync.stream.where((e) => e.rooms?.join?.isNotEmpty ?? false);

  Stream<JoinedRoomUpdate?> getJoinedRoomUpdate(String? roomId) =>
      joinedUpdateStream.map((e) => e.rooms?.join?[roomId]);

  void init({required Room? room, required bool isSpace}) {
    if (room == null) {
      _nameDraft = '';
      _topicDraft = '';
      _isSpace = isSpace;
      _enableEncryption = false;
      _federated = false;
      _groupCall = false;
      _joinRules = JoinRules.public;
      _historyVisibility = HistoryVisibility.shared;
      _profiles = {};
    } else {
      _nameDraft = room.name;
      _topicDraft = room.topic;
      _isSpace = room.isSpace;
      _enableEncryption = room.encrypted;
      _federated = room.isFederated;
      _groupCall = room.groupCallsEnabledForEveryone;
      _joinRules = room.joinRules ?? JoinRules.public;
      _historyVisibility = room.historyVisibility ?? HistoryVisibility.shared;
      _profiles = room.getProfiles();
    }
  }

  // ROOM NAME DRAFT

  String _nameDraft = '';
  String get nameDraft => _nameDraft;
  void setNameDraft(String name) {
    if (name == _nameDraft) return;
    _nameDraft = name;
    notifyListeners();
  }

  Stream<String> getJoinedRoomNameStream(Room room) =>
      getJoinedRoomUpdate(room.id).map((_) => room.name).distinct();

  Stream<bool> getJoinedRoomCanChangeNameStream(Room room) =>
      getJoinedRoomUpdate(room.id).map((_) => room.canChangeName).distinct();

  Future<void> changeRoomName(Room room, String name) async {
    try {
      await room.setName(name);
    } catch (e, s) {
      printMessageInDebugMode(e, s);
      rethrow;
    }
  }

  // ROOM TOPIC DRAFT

  String _topicDraft = '';
  String get topicDraft => _topicDraft;
  void setTopicDraft(String topic) {
    if (topic == _topicDraft) return;
    _topicDraft = topic;
    notifyListeners();
  }

  Stream<String> getJoinedRoomTopicStream(Room room) =>
      getJoinedRoomUpdate(room.id).map((_) => room.topic).distinct();

  Stream<bool> getJoinedRoomCanChangeTopicStream(Room room) =>
      getJoinedRoomUpdate(room.id).map((_) => room.canChangeTopic).distinct();

  Future<void> changeRoomTopic(Room room, String topic) async {
    try {
      await room.setDescription(topic);
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

  Stream<Map<String, Object?>> getPermissionsStream(Room room) => _client
      .onSync
      .stream
      .where(
        (e) =>
            (e.rooms?.join?.containsKey(room.id) ?? false) &&
            (e.rooms!.join![room.id]?.timeline?.events?.any(
                  (s) => s.type == EventTypes.RoomPowerLevels,
                ) ??
                false),
      )
      .map((event) => room.getState(EventTypes.RoomPowerLevels)?.content ?? {});

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

  bool _attachingAvatar = false;
  bool get attachingAvatar => _attachingAvatar;
  void setAttachingAvatar(bool value) {
    if (value == _attachingAvatar) return;
    _attachingAvatar = value;

    notifyListeners();
  }

  MatrixFile? _avatarDraftFile;
  MatrixFile? get avatarDraftFile => _avatarDraftFile;
  void resetAvatar() {
    _avatarDraftFile = null;
    notifyListeners();
  }

  String? _roomAvatarError;
  String? get roomAvatarError => _roomAvatarError;
  void setRoomAvatarError(String? value) {
    _roomAvatarError = value;
    notifyListeners();
  }

  Future<void> setRoomAvatar({
    required Room? room,
    required Function(String error) onFail,
    required String wrongFormatString,
  }) async {
    setRoomAvatarError(null);
    setAttachingAvatar(true);

    try {
      XFile? xFile;
      if (Platforms.isLinux) {
        xFile = await openFile();
      } else {
        final result = await FilePicker.platform.pickFiles(
          allowMultiple: false,
          type: FileType.image,
        );
        xFile = result?.files
            .map((f) => XFile(f.path!, mimeType: lookupMimeType(f.path!)))
            .toList()
            .firstOrNull;
      }

      if (xFile == null) {
        setAttachingAvatar(false);
        return;
      }

      final mime = lookupMimeType(xFile.path);
      final bytes = await xFile.readAsBytes();

      if (mime?.startsWith('image') != true) {
        setRoomAvatarError(wrongFormatString);
        setAttachingAvatar(false);
        return;
      }

      _avatarDraftFile = await MatrixImageFile.shrink(
        bytes: bytes,
        name: xFile.name,
        mimeType: mime,
        maxDimension: 1000,
        nativeImplementations: _client.nativeImplementations,
      );

      if (room != null) {
        await room.setAvatar(_avatarDraftFile);
        _avatarDraftFile = null;
      }
    } on Exception catch (e, s) {
      onFail(e.toString());
      printMessageInDebugMode(e, s);
    }

    setAttachingAvatar(false);
  }
}
