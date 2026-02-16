import 'package:flutter_it/flutter_it.dart';
import 'package:matrix/matrix.dart';

import '../../events/chat_message_reaction_capsule.dart';
import 'edit_room_service.dart';

class EditRoomManager {
  EditRoomManager({required EditRoomService editRoomService})
    : _editRoomService = editRoomService {
    joinRoomCommand = Command.createAsync(
      editRoomService.joinRoom,
      initialValue: null,
    );
    knockOrJoinCommand = Command.createAsync(
      editRoomService.knockOrJoinRoomChunk,
      initialValue: null,
    );
    globalLeaveRoomCommand = Command.createAsync((room) async {
      await getLeaveRoomCommand(room).runAsync();
      return room;
    }, initialValue: null);

    globalForgetRoomCommand = Command.createAsync((room) async {
      await getForgetRoomCommand(room).runAsync();
      return room;
    }, initialValue: null);
  }

  final EditRoomService _editRoomService;

  late final Command<Room, Room?> joinRoomCommand;
  late final Command<PublishedRoomsChunk, Room?> knockOrJoinCommand;
  late final Command<Room, Room?> globalLeaveRoomCommand;
  late final Command<Room, Room?> globalForgetRoomCommand;
  late final Command<void, void> leaveAllRoomsCommand =
      Command.createAsyncNoParamNoResultWithProgress((handle) async {
        final rooms = _editRoomService.rooms;
        for (final room in rooms) {
          await getLeaveRoomCommand(room).runAsync();
        }
      });
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
          await getForgetRoomCommand(entry.room).runAsync();

          handle.updateProgress(
            ((list.indexOf(entry) + 1) / total).clamp(0, 1),
          );
        }
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
  Command<void, void> getForgetRoomCommand(Room room) =>
      _forgetRoomCommands.putIfAbsent(
        room.id,
        () => Command.createAsync((_) async {
          await _editRoomService.forgetRoom(room);
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
