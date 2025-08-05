import 'package:collection/collection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:file_selector/file_selector.dart';
import 'package:matrix/matrix.dart';
// import 'package:mime/mime.dart';
import 'package:safe_change_notifier/safe_change_notifier.dart';

import '../../common/logging.dart';
import '../../common/platforms.dart';
import '../../common/room_x.dart';
import '../../common/xtypegroup_x.dart';

const adminPowerLevel = 100;
const memberPowerLevel = 0;
const moderatorPowerLevel = 50;

class CreateOrEditRoomModel {
  CreateOrEditRoomModel({required Client client}) : _client = client;

  final Client _client;

  void init({required Room? room}) {
    nameDraft.value = '';
    topicDraft.value = '';
    enableEncryptionDraft.value = false;
    groupCallDraft.value = false;
    visibilityDraft.value = Visibility.public;
    createRoomPresetDraft.value = CreateRoomPreset.publicChat;
    historyVisibilityDraft.value = HistoryVisibility.shared;
    profilesDraft.value = {};
    avatarDraft.value = null;
  }

  Stream<SyncUpdate> get _joinedUpdateStream =>
      _client.onSync.stream.where((e) => e.rooms?.join?.isNotEmpty ?? false);

  Stream<JoinedRoomUpdate?> _getJoinedRoomUpdate(String? roomId) =>
      _joinedUpdateStream.map((e) => e.rooms?.join?[roomId]);

  // ROOM NAME

  SafeValueNotifier<String> nameDraft = SafeValueNotifier('');

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

  SafeValueNotifier<String> topicDraft = SafeValueNotifier('');

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

  SafeValueNotifier<bool> enableEncryptionDraft = SafeValueNotifier(false);

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

  SafeValueNotifier<CreateRoomPreset> createRoomPresetDraft = SafeValueNotifier(
    CreateRoomPreset.publicChat,
  );
  SafeValueNotifier<Visibility> visibilityDraft = SafeValueNotifier(
    Visibility.public,
  );

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

  SafeValueNotifier<HistoryVisibility> historyVisibilityDraft =
      SafeValueNotifier(HistoryVisibility.shared);

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

  SafeValueNotifier<Set<Profile>> profilesDraft = SafeValueNotifier({});

  void addProfileToDraft(Profile profile) {
    if (profilesDraft.value.contains(profile)) return;
    profilesDraft.value = {...profilesDraft.value, profile};
  }

  void removeProfileFromDraft(Profile profile) {
    if (!profilesDraft.value.contains(profile)) return;
    profilesDraft.value = {...profilesDraft.value..remove(profile)};
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

  Future<void> removeUserFromRoom(User user) async {
    try {
      await user.room.kick(user.id);
    } catch (e, s) {
      printMessageInDebugMode(e, s);
      rethrow;
    }
  }

  Future<void> banUserFromRoom(User user) async {
    try {
      await user.room.ban(user.id);
    } catch (e, s) {
      printMessageInDebugMode(e, s);
      rethrow;
    }
  }

  Future<void> changePowerLevel({
    required User user,
    required int powerLevel,
  }) async {
    try {
      final room = user.room;
      final currentPowerLevel = user.powerLevel;
      await room.setPower(user.id, powerLevel);
      printMessageInDebugMode(
        'User ${currentPowerLevel < powerLevel ? 'promoted' : 'demoted'} to ${powerLevel == adminPowerLevel
            ? 'admin'
            : powerLevel == moderatorPowerLevel
            ? 'moderator'
            : 'user'}.',
      );
    } catch (e, s) {
      printMessageInDebugMode(e, s);
      rethrow;
    }
  }

  Stream<SyncUpdate> get joinedUpdateStream =>
      _client.onSync.stream.where((e) => e.rooms?.join?.isNotEmpty ?? false);

  Stream<JoinedRoomUpdate?> getJoinedRoomUpdate(String? roomId) =>
      joinedUpdateStream.map((e) => e.rooms?.join?[roomId]);

  Stream<List<User>> getUsersStreamOfJoinedRoom(
    Room room, {
    List<Membership> membershipFilter = const [
      Membership.join,
      Membership.invite,
      Membership.knock,
    ],
  }) => getJoinedRoomUpdate(
    room.id,
  ).asyncMap((_) => room.requestParticipants(membershipFilter));

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

  SafeValueNotifier<MatrixImageFile?> avatarDraft = SafeValueNotifier(null);

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
        xFile = await openFile(
          acceptedTypeGroups: <XTypeGroup>[
            XTypeGroupX.jpgsTypeGroup,
            XTypeGroupX.pngTypeGroup,
          ],
        );
      } else {
        final result = await FilePicker.platform.pickFiles(
          type: FileType.image,
        );
        xFile = result?.files.firstOrNull?.xFile;
      }

      if (xFile == null) {
        return;
      }

      final bytes = await xFile.readAsBytes();

      avatarDraft.value = await MatrixImageFile.shrink(
        bytes: bytes,
        name: xFile.name,
        mimeType: xFile.mimeType,
        maxDimension: 1000,
        nativeImplementations: _client.nativeImplementations,
      );

      if (room != null) {
        await room.setAvatar(avatarDraft.value);
        avatarDraft.value = null;
      }
    } on Exception catch (e, s) {
      printMessageInDebugMode(e, s);
      rethrow;
    }
  }

  // GROUP CALL DRAFT

  SafeValueNotifier<bool> groupCallDraft = SafeValueNotifier(false);

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
              name: nameDraft.value,
              visibility: visibilityDraft.value,
              invite: profilesDraft.value
                  .map((p) => p.userId)
                  .toList(growable: false),
              invite3pid: null,
              roomVersion: null,
              topic: topicDraft.value,
              waitForSync: waitForSync,
              spaceAliasName: nameDraft.value,
            )
          : await _client.createGroupChat(
              groupName: nameDraft.value,
              enableEncryption: enableEncryptionDraft.value,
              invite: profilesDraft.value
                  .map((p) => p.userId)
                  .toList(growable: false),
              initialState: initialState,
              visibility: visibilityDraft.value,
              preset: createRoomPresetDraft.value,
              historyVisibility: historyVisibilityDraft.value,
              waitForSync: waitForSync,
              groupCall: groupCallDraft.value,
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
          avatarDraft.value?.bytes != null) {
        try {
          await maybeRoom.setAvatar(avatarDraft.value);
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

  Future<void> leaveRoom(Room room) async {
    try {
      await room.leave();
    } on Exception catch (e, s) {
      printMessageInDebugMode(e, s);
      rethrow;
    }
  }

  Future<void> leaveAllRooms() async {
    if (_client.rooms.isEmpty) return;
    try {
      await Future.wait(_client.rooms.map((e) => e.leave()));
      await _client.oneShotSync();
    } on Exception catch (e, s) {
      printMessageInDebugMode(e, s);
      rethrow;
    }
  }

  Future<void> forgetRoom(Room room) async {
    try {
      await room.forget();
      await _client.oneShotSync();
    } on Exception catch (e, s) {
      printMessageInDebugMode(e, s);
      rethrow;
    }
  }

  Future<void> forgetAllArchivedRooms() async {
    final archivedRooms = _client.archivedRooms;
    if (archivedRooms.isEmpty) return;

    try {
      await Future.wait(archivedRooms.map((e) => e.room.forget()));
      await _client.oneShotSync();
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
    } on Exception catch (e, s) {
      printMessageInDebugMode(e, s);
      rethrow;
    }
  }
}
