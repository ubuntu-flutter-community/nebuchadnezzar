import 'package:collection/collection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:file_selector/file_selector.dart';
import 'package:matrix/matrix.dart';
// import 'package:mime/mime.dart';
import 'package:safe_change_notifier/safe_change_notifier.dart';

import '../../common/logging.dart';
import '../../common/platforms.dart';
import '../../extensions/xtypegroup_x.dart';

const adminPowerLevel = 100;
const memberPowerLevel = 0;
const moderatorPowerLevel = 50;

class CreateRoomManager {
  CreateRoomManager({required Client client}) : _client = client;

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

  SafeValueNotifier<String> nameDraft = SafeValueNotifier('');
  SafeValueNotifier<String> topicDraft = SafeValueNotifier('');
  SafeValueNotifier<bool> enableEncryptionDraft = SafeValueNotifier(false);
  SafeValueNotifier<CreateRoomPreset> createRoomPresetDraft = SafeValueNotifier(
    CreateRoomPreset.publicChat,
  );
  SafeValueNotifier<Visibility> visibilityDraft = SafeValueNotifier(
    Visibility.public,
  );
  SafeValueNotifier<HistoryVisibility> historyVisibilityDraft =
      SafeValueNotifier(HistoryVisibility.shared);

  SafeValueNotifier<Set<Profile>> profilesDraft = SafeValueNotifier({});
  void addProfileToDraft(Profile profile) {
    if (profilesDraft.value.contains(profile)) return;
    profilesDraft.value = {...profilesDraft.value, profile};
  }

  void removeProfileFromDraft(Profile profile) {
    if (!profilesDraft.value.contains(profile)) return;
    profilesDraft.value = {...profilesDraft.value..remove(profile)};
  }

  SafeValueNotifier<MatrixImageFile?> avatarDraft = SafeValueNotifier(null);
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
    } on Exception catch (e, s) {
      printMessageInDebugMode(e, s);
      rethrow;
    }
  }

  SafeValueNotifier<bool> groupCallDraft = SafeValueNotifier(false);

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
          avatarDraft.value = null;
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

  Future<Room?> createOrGetDirectChat(String userId) async {
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
}
