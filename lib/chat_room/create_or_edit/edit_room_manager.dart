import 'package:flutter_it/flutter_it.dart';
import 'package:matrix/matrix.dart';

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
  }

  final EditRoomService _editRoomService;

  late final Command<Room, Room?> joinRoomCommand;
  late final Command<PublishedRoomsChunk, Room?> knockOrJoinCommand;

  final Map<String, Command<void, void>> _leaveRoomCommands = {};
  Command<void, void> getLeaveRoomCommand(Room room) =>
      _leaveRoomCommands.putIfAbsent(
        room.id,
        () => Command.createAsync(
          (_) => _editRoomService.leaveRoom(room),
          initialValue: null,
        ),
      );
}
