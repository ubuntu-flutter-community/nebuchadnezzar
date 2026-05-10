import 'package:flutter_it/flutter_it.dart';
import 'package:matrix/matrix.dart';
import 'package:safe_change_notifier/safe_change_notifier.dart';

import '../../events/chat_message_reaction_capsule.dart';
import 'edit_room_service.dart';

class EditRoomManager {
  EditRoomManager({required EditRoomService editRoomService})
    : _editRoomService = editRoomService;

  final EditRoomService _editRoomService;

  late final Command<Room, Room?> joinRoomCommand = Command.createAsync(
    _editRoomService.joinRoom,
    initialValue: null,
  );

  late final Command<({String roomId, bool knock}), Room?> knockOrJoinCommand =
      Command.createAsync(
        (param) => _editRoomService.knockOrJoinRoomById(
          roomId: param.roomId,
          knock: param.knock,
        ),
        initialValue: null,
      );

  late final Command<Room, Room?> globalLeaveRoomCommand = Command.createAsync((
    room,
  ) async {
    await getLeaveRoomCommand(room).runAsync();
    return room;
  }, initialValue: null);

  late final Command<Room, Room?> globalForgetRoomCommand = Command.createAsync(
    (room) async {
      await getForgetRoomCommand(room).runAsync();
      return room;
    },
    initialValue: null,
  );

  late final Command<void, void> oneShotSyncCommand =
      Command.createAsyncNoParamNoResult(_editRoomService.oneShotSync);

  late final Command<void, void> forgetAllRoomsCommand =
      Command.createAsyncNoParamNoResultWithProgress((handle) async {
        handle.updateProgress(0);
        final rooms = _editRoomService.archivedRooms;

        if (rooms.isEmpty) {
          handle.updateProgress(1);
          return;
        }

        handle.updateProgress(0);

        final list = List<ArchivedRoom>.from(rooms, growable: false);

        final total = list.length;

        for (final entry in list) {
          await getForgetRoomCommand(entry.room).runAsync(false);

          handle.updateProgress(
            ((list.indexOf(entry) + 1) / total).clamp(0, 1),
          );
        }

        await oneShotSyncCommand.runAsync();
      });

  final Map<String, Command<void, Room?>> _leaveRoomCommands = {};
  Command<void, Room?> getLeaveRoomCommand(Room room) =>
      _leaveRoomCommands.putIfAbsent(
        room.id,
        () => Command.createAsync((_) async {
          await _editRoomService.leaveRoom(room);
          _leaveRoomCommands.remove(room.id);
          return room;
        }, initialValue: null),
      );

  final Map<String, Command<bool?, void>> _forgetRoomCommands = {};
  Command<bool?, void> getForgetRoomCommand(Room room) =>
      _forgetRoomCommands.putIfAbsent(
        room.id,
        () => Command.createAsync((sync) async {
          await _editRoomService.forgetRoom(room);
          if (sync == true) {
            await _editRoomService.oneShotSync();
          }
          _forgetRoomCommands.remove(room.id);
        }, initialValue: null),
      );

  final showRoomMarkers = SafeValueNotifier<bool>(false);
  void toggleShowMarkRooms() => showRoomMarkers.value = !showRoomMarkers.value;
  final markedRooms = SetNotifier<Room>();
  void addMarkRooms(List<Room> rooms) {
    markedRooms.addAll(rooms);
  }

  void clearMarkedRooms() => markedRooms.clear();

  void toggleMarkedRoom(Room room) {
    if (markedRooms.contains(room)) {
      markedRooms.remove(room);
    } else {
      markedRooms.add(room);
    }
  }

  final Map<String, Command<ChatMessageReactionCapsule, String?>>
  sendReactionsCommands = {};
  Command<ChatMessageReactionCapsule, String?> getSendReactionCommand(
    String charKeyAndEventId,
  ) => sendReactionsCommands.putIfAbsent(
    charKeyAndEventId,
    () =>
        Command.createAsync(_editRoomService.sendReaction, initialValue: null),
  );
}
