import 'package:collection/collection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:file_selector/file_selector.dart';
import 'package:matrix/matrix.dart';
// import 'package:mime/mime.dart';
import 'package:safe_change_notifier/safe_change_notifier.dart';

import '../../common/logging.dart';
import '../../common/platforms.dart';
import '../../extensions/xtypegroup_x.dart';
import 'create_room_draft.dart';

class CreateRoomManager {
  CreateRoomManager({required Client client}) : _client = client;

  final Client _client;

  SafeValueNotifier<CreateRoomDraft> draft = SafeValueNotifier(
    CreateRoomDraft.empty(),
  );

  void init({required Room? room}) => draft.value = CreateRoomDraft.empty();

  void updateDraft({
    String? name,
    String? topic,
    bool? enableEncryption,
    CreateRoomPreset? createRoomPreset,
    Visibility? visibility,
    HistoryVisibility? historyVisibility,
    Set<Profile>? profiles,
    MatrixImageFile? avatar,
    bool? groupCall,
  }) {
    draft.value = draft.value.copyWith(
      name: name,
      topic: topic,
      enableEncryption: enableEncryption,
      createRoomPreset: createRoomPreset,
      visibility: visibility,
      historyVisibility: historyVisibility,
      profiles: profiles,
      avatar: avatar,
      groupCall: groupCall,
    );
  }

  void addProfileToDraft(Profile profile) {
    if (draft.value.profiles.contains(profile)) return;
    updateDraft(profiles: {...draft.value.profiles, profile});
  }

  void removeProfileFromDraft(Profile profile) {
    if (!draft.value.profiles.contains(profile)) return;
    updateDraft(profiles: {...draft.value.profiles..remove(profile)});
  }

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

      updateDraft(
        avatar: await MatrixImageFile.shrink(
          bytes: bytes,
          name: xFile.name,
          mimeType: xFile.mimeType,
          maxDimension: 1000,
          nativeImplementations: _client.nativeImplementations,
        ),
      );
    } on Exception catch (e, s) {
      printMessageInDebugMode(e, s);
      rethrow;
    }
  }

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
              name: draft.value.name,
              visibility: draft.value.visibility,
              invite: draft.value.profiles
                  .map((p) => p.userId)
                  .toList(growable: false),
              invite3pid: null,
              roomVersion: null,
              topic: draft.value.topic,
              waitForSync: waitForSync,
              spaceAliasName: draft.value.name,
            )
          : await _client.createGroupChat(
              groupName: draft.value.name,
              enableEncryption: draft.value.enableEncryption,
              invite: draft.value.profiles
                  .map((p) => p.userId)
                  .toList(growable: false),
              initialState: initialState,
              visibility: draft.value.visibility,
              preset: draft.value.createRoomPreset,
              historyVisibility: draft.value.historyVisibility,
              waitForSync: waitForSync,
              groupCall: draft.value.groupCall,
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
          draft.value.avatar?.bytes != null) {
        try {
          await maybeRoom.setAvatar(draft.value.avatar);
          updateDraft(avatar: null);
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
