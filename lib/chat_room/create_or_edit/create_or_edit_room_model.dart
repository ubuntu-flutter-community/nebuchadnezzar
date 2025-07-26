import 'package:collection/collection.dart';
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

  void init({required Room? room, required bool isSpace}) {
    _nameDraft = '';
    _topicDraft = '';
    _enableEncryptionDraft = false;
    _groupCallDraft = false;
    _visibilityDraft = Visibility.public;
    _createRoomPresetDraft = CreateRoomPreset.publicChat;
    _historyVisibilityDraft = HistoryVisibility.shared;
    _profilesDraft = {};
    _avatarDraftFile = null;
  }

  Stream<SyncUpdate> get _joinedUpdateStream =>
      _client.onSync.stream.where((e) => e.rooms?.join?.isNotEmpty ?? false);

  Stream<JoinedRoomUpdate?> _getJoinedRoomUpdate(String? roomId) =>
      _joinedUpdateStream.map((e) => e.rooms?.join?[roomId]);

  // ROOM NAME

  String _nameDraft = '';
  String get nameDraft => _nameDraft;
  void setNameDraft(String name) {
    if (name == _nameDraft) return;
    _nameDraft = name;
    notifyListeners();
  }

  Stream<String> getJoinedRoomNameStream(Room room) =>
      _getJoinedRoomUpdate(room.id).map((_) => room.name).distinct();

  Stream<bool> getJoinedRoomCanChangeNameStream(Room room) =>
      _getJoinedRoomUpdate(room.id).map((_) => room.canChangeName).distinct();

  Future<void> changeRoomName(Room room, String name) async {
    try {
      await room.setName(name);
    } catch (e, s) {
      printMessageInDebugMode(e, s);
      rethrow;
    }
  }

  // ROOM TOPIC

  String _topicDraft = '';
  String get topicDraft => _topicDraft;
  void setTopicDraft(String topic) {
    if (topic == _topicDraft) return;
    _topicDraft = topic;
    notifyListeners();
  }

  Stream<String> getJoinedRoomTopicStream(Room room) =>
      _getJoinedRoomUpdate(room.id).map((_) => room.topic).distinct();

  Stream<bool> getJoinedRoomCanChangeTopicStream(Room room) =>
      _getJoinedRoomUpdate(room.id).map((_) => room.canChangeTopic).distinct();

  Future<void> changeRoomTopic(Room room, String topic) async {
    try {
      await room.setDescription(topic);
    } catch (e, s) {
      printMessageInDebugMode(e, s);
      rethrow;
    }
  }

  // ROOM CANONICAL ALIAS

  Stream<String> getJoinedRoomCanonicalAliasStream(Room room) =>
      _getJoinedRoomUpdate(room.id).map((_) => room.canonicalAlias).distinct();

  Stream<bool> getCanChangeCanonicalAliasStream(Room room) =>
      _getJoinedRoomUpdate(
        room.id,
      ).map((_) => room.canChangeCanonicalAlias).distinct();

  Future<void> changeRoomCanonicalAlias(Room room, String text) async {
    try {
      await room.setCanonicalAlias(text);
    } on Exception catch (e, s) {
      printMessageInDebugMode(e, s);
      rethrow;
    }
  }

  // ROOM ENCRYPTION

  bool _enableEncryptionDraft = false;
  bool get enableEncryptionDraft => _enableEncryptionDraft;
  void setEnableEncryptionDraft(bool enableEncryption) {
    if (enableEncryption == _enableEncryptionDraft) return;
    _enableEncryptionDraft = enableEncryption;
    notifyListeners();
  }

  Stream<bool?> getIsRoomEncryptedStream(Room? room) =>
      _getJoinedRoomUpdate(room?.id)
          .map(
            (e) => e?.ephemeral?.firstWhereOrNull(
              (e) => e.type == EventTypes.Encrypted,
            ),
          )
          .map((e) => room?.encrypted);

  Stream<bool> getCanChangeEncryptionStream(Room? room) => _getJoinedRoomUpdate(
    room?.id,
  ).map((_) => room!.canChangeStateEvent(EventTypes.Encryption));

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

  // ROOM JOIN RULES

  Visibility _visibilityDraft = Visibility.public;
  Visibility get visibilityDraft => _visibilityDraft;
  void setVisibilityDraft(Visibility visibility) {
    if (visibility == _visibilityDraft) return;
    _visibilityDraft = visibility;
    notifyListeners();
  }

  CreateRoomPreset _createRoomPresetDraft = CreateRoomPreset.publicChat;
  CreateRoomPreset get createRoomPresetDraft => _createRoomPresetDraft;
  void setCreateRoomPresetDraft(CreateRoomPreset preset) {
    if (preset == _createRoomPresetDraft) return;
    _createRoomPresetDraft = preset;
    notifyListeners();
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

  Stream<bool> getCanChangeJoinRulesStream(Room room) =>
      _getJoinedRoomUpdate(room.id).map((_) => room.canChangeJoinRules);

  Stream<JoinRules?> getJoinedRoomJoinRulesStream(Room room) =>
      _getJoinedRoomUpdate(room.id).map((_) => room.joinRules);

  // ROOM HISTORY VISIBILITY

  HistoryVisibility _historyVisibilityDraft = HistoryVisibility.shared;
  HistoryVisibility get historyVisibilityDraft => _historyVisibilityDraft;
  void setHistoryVisibilityDraft(HistoryVisibility historyVisibility) {
    if (historyVisibility == _historyVisibilityDraft) return;
    _historyVisibilityDraft = historyVisibility;
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

  Stream<bool> getCanChangeHistoryVisibilityStream(Room room) =>
      _getJoinedRoomUpdate(room.id).map((_) => room.canChangeHistoryVisibility);

  Stream<HistoryVisibility?> getJoinedRoomHistoryVisibilityStream(Room room) =>
      _getJoinedRoomUpdate(room.id).map((_) => room.historyVisibility);

  // ROOM PROFILES DRAFT AND INVITES

  Set<Profile> _profilesDraft = {};
  Set<Profile> get profilesDraft => _profilesDraft;

  void addProfileToDraft(Profile profile) {
    if (_profilesDraft.contains(profile)) return;
    _profilesDraft.add(profile);
    notifyListeners();
  }

  void removeProfileFromDraft(Profile profile) {
    if (!_profilesDraft.contains(profile)) return;
    _profilesDraft.remove(profile);
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

  Stream<List<User>> getUsersStreamOfJoinedRoom(
    Room room, {
    List<Membership> membershipFilter = const [
      Membership.join,
      Membership.invite,
      Membership.knock,
    ],
  }) => _client.onSync.stream.asyncMap(
    (_) => room.requestParticipants(membershipFilter),
  );

  // ROOM POWER LEVELS

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

  Stream<bool> canChangePowerLevels(Room room) =>
      _getJoinedRoomUpdate(room.id).map((_) => room.canChangePowerLevel);

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

  // ROOM PUSH RULES

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

  Stream<PushRuleState> getPushRuleStateStream(Room room) =>
      _client.onSync.stream.map((_) => room.pushRuleState);

  // ROOM AVATAR DRAFT OR UPLOAD

  MatrixFile? _avatarDraftFile;
  MatrixFile? get avatarDraftFile => _avatarDraftFile;

  Stream<Uri?> getJoinedRoomAvatarStream(Room? room) =>
      _getJoinedRoomUpdate(room?.id)
          .map(
            (e) => e?.ephemeral?.firstWhereOrNull(
              (e) => e.type == EventTypes.RoomAvatar,
            ),
          )
          .map((e) => room?.avatar);

  Future<void> setRoomAvatar({
    required Room? room,
    required String wrongFormatString,
  }) async {
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
        return;
      }

      final mime = lookupMimeType(xFile.path);
      final bytes = await xFile.readAsBytes();

      if (mime?.startsWith('image') != true) {
        throw Exception(wrongFormatString);
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
      printMessageInDebugMode(e, s);
      rethrow;
    }
  }

  // GROUP CALL DRAFT

  bool _groupCallDraft = false;
  bool get groupCallDraft => _groupCallDraft;
  void setGroupCallDraft(bool groupCall) {
    if (groupCall == _groupCallDraft) return;
    _groupCallDraft = groupCall;
    notifyListeners();
  }

  // CREATE ROOM, SPACE OR DIRECT CHAT

  Future<Room?> createRoomOrSpace({
    required bool space,
    bool waitForSync = true,
    List<StateEvent>? initialState,
    bool federated = true,
    Map<String, dynamic>? powerLevelContentOverride,
  }) async {
    String? roomId;
    try {
      roomId = space
          ? await _client.createSpace(
              name: _nameDraft,
              visibility: _visibilityDraft,
              invite: _profilesDraft
                  .map((p) => p.userId)
                  .toList(growable: false),
              invite3pid: null,
              roomVersion: null,
              topic: _topicDraft,
              waitForSync: waitForSync,
              spaceAliasName: _nameDraft,
            )
          : await _client.createGroupChat(
              groupName: _nameDraft,
              enableEncryption: _enableEncryptionDraft,
              invite: _profilesDraft
                  .map((p) => p.userId)
                  .toList(growable: false),
              initialState: initialState,
              visibility: _visibilityDraft,
              preset: _createRoomPresetDraft,
              historyVisibility: _historyVisibilityDraft,
              waitForSync: waitForSync,
              groupCall: _groupCallDraft,
              federated: federated,
              powerLevelContentOverride: powerLevelContentOverride,
            );
    } catch (e, s) {
      printMessageInDebugMode(e, s);
      rethrow;
    }

    final maybeRoom = _client.getRoomById(roomId);
    if (maybeRoom != null) {
      if (maybeRoom.canChangeStateEvent(EventTypes.RoomAvatar) &&
          _avatarDraftFile?.bytes != null) {
        try {
          await maybeRoom.setAvatar(_avatarDraftFile);
        } on Exception catch (e, s) {
          printMessageInDebugMode(e, s);
        }
      }
      if (maybeRoom.isDirectChat && !maybeRoom.encrypted) {
        try {
          await maybeRoom.enableEncryption();
          printMessageInDebugMode('Room encrypted: ${maybeRoom.encrypted}');
        } on Exception catch (e, s) {
          printMessageInDebugMode(e, s);
          rethrow;
        }
      }
    }

    return maybeRoom;
  }

  Future<Room?> startOrGetDirectChat(String userId) async {
    final maybeDirectChatId = _client.getDirectChatFromUserId(userId);
    Room? maybeRoom;
    if (maybeDirectChatId != null) {
      maybeRoom = _client.getRoomById(maybeDirectChatId);
    }

    if (maybeRoom == null) {
      String? maybeId;
      try {
        maybeId = await _client.startDirectChat(
          userId,
          preset: CreateRoomPreset.privateChat,
        );
      } on Exception catch (e) {
        printMessageInDebugMode(e);
        rethrow;
      }

      maybeRoom = _client.getRoomById(maybeId);
    }

    return maybeRoom;
  }

  // JOIN, LEAVE OR KNOCK ROOM

  Future<Room> joinRoom(Room room) async {
    if (room.membership != Membership.join) {
      try {
        await room.join();
        if (room.isDirectChat && !room.encrypted) {
          await room.enableEncryption();
          printMessageInDebugMode('Room encrypted: ${room.encrypted}');
        }
      } on Exception catch (e, s) {
        printMessageInDebugMode(e, s);
        rethrow;
      }
    }

    return room;
  }

  Future<void> leaveRoom({required Room room, required bool forget}) async {
    try {
      await Future.wait([
        if (forget) room.forget() else room.leave(),
        if (forget) _client.oneShotSync(),
      ]);
    } on Exception catch (e, s) {
      printMessageInDebugMode(e, s);
      rethrow;
    }
  }

  Future<Room?> knockOrJoinRoomChunk(PublicRoomsChunk chunk) async {
    final knock = chunk.joinRule == 'knock';

    String? roomId;
    try {
      if (_client.getRoomById(chunk.roomId) != null) {
        roomId = chunk.roomId;
      }
      roomId = knock
          ? await _client.knockRoom(chunk.roomId)
          : await _client.joinRoom(chunk.roomId);

      if (!knock && _client.getRoomById(roomId) == null) {
        await _client.waitForRoomInSync(roomId);
      }
    } on Exception catch (e, s) {
      printMessageInDebugMode(e, s);
      rethrow;
    }

    return _client.getRoomById(roomId);
  }

  // ADD OR REMOVE ROOM TO SPACE

  Future<void> addToSpace(Room room, Room space) async {
    if (room.isSpace) {
      throw Exception('Cannot add a space to itself.');
    }

    try {
      await space.setSpaceChild(room.id);
      notifyListeners();
    } on Exception catch (e, s) {
      printMessageInDebugMode(e, s);
      rethrow;
    }
  }

  Future<void> removeFromSpace(Room room, Room space) async {
    if (room.isSpace) {
      throw Exception('Cannot remove a space from itself.');
    }

    try {
      await space.removeSpaceChild(room.id);
      notifyListeners();
    } on Exception catch (e, s) {
      printMessageInDebugMode(e, s);
      rethrow;
    }
  }
}
