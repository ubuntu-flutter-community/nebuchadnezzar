import 'package:flutter_it/flutter_it.dart';
import 'package:matrix/matrix.dart';

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

  late final Command<PublishedRoomsChunk, Room?> knockOrJoinCommand =
      Command.createAsync(
        _editRoomService.knockOrJoinRoomChunk,
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
          await getForgetRoomCommand(entry.room, sync: false).runAsync();

          handle.updateProgress(
            ((list.indexOf(entry) + 1) / total).clamp(0, 1),
          );
        }

        await _editRoomService.getOneShotSync();
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

  final Map<String, Command<void, void>> _forgetRoomCommands = {};
  Command<void, void> getForgetRoomCommand(Room room, {bool sync = true}) =>
      _forgetRoomCommands.putIfAbsent(
        room.id,
        () => Command.createAsync((_) async {
          await _editRoomService.forgetRoom(room, sync: sync);
          _forgetRoomCommands.remove(room.id);
        }, initialValue: null),
      );

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
