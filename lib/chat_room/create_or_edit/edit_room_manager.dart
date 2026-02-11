import 'package:flutter_it/flutter_it.dart';
import 'package:matrix/matrix.dart';

import 'edit_room_service.dart';

class EditRoomManager {
  EditRoomManager({required EditRoomService editRoomService})
    : _editRoomService = editRoomService;

  final EditRoomService _editRoomService;

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
