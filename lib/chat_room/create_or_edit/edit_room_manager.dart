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
  }

  final EditRoomService _editRoomService;

  late final Command<Room, Room?> joinRoomCommand;
  late final Command<PublishedRoomsChunk, Room?> knockOrJoinCommand;

  final Map<String, Command<Set<Event>, void>> _leaveRoomCommands = {};
  Command<Set<Event>, void> getLeaveRoomCommand(Room room) =>
      _leaveRoomCommands.putIfAbsent(
        room.id,
        () => Command.createAsync((_) async {
          await _editRoomService.leaveRoom(room);
          _leaveRoomCommands.remove(room.id);
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
