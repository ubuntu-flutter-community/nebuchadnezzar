import 'package:flutter_it/flutter_it.dart';
import 'package:matrix/matrix.dart';
import 'package:safe_change_notifier/safe_change_notifier.dart';

import '../../common/logging.dart';
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

  late final Command<
    ({List<Room> rooms, LeaveOrForget action}),
    ({List<Room> successful, List<Room> failed})?
  >
  globalLeaveOrForgetRoomsCommand = Command.createAsyncWithProgress((
    param,
    handle,
  ) async {
    if (param.rooms.isEmpty) {
      return (successful: <Room>[], failed: <Room>[]);
    }
    final failedRooms = <Room>{};
    final successful = <Room>{};
    for (final (index, room) in param.rooms.indexed) {
      try {
        if (param.action == LeaveOrForget.leave) {
          await getLeaveRoomCommand(room).runAsync();
        } else if (param.action == LeaveOrForget.forget) {
          await getForgetRoomCommand(room).runAsync();
        }
        await Future.delayed(const Duration(seconds: 1));
        successful.add(room);
      } on Exception catch (e, s) {
        failedRooms.add(room);
        printMessageInDebugMode(e, s);
      }
      handle.updateProgress((index + 1) / param.rooms.length);
    }

    if (param.action == LeaveOrForget.forget) {
      await oneShotSyncCommand.runAsync();
    }

    clearMarkedRooms();

    return (successful: successful.toList(), failed: failedRooms.toList());
  }, initialValue: null);

  late final Command<void, void> oneShotSyncCommand =
      Command.createAsyncNoParamNoResult(_editRoomService.oneShotSync);

  final Map<String, Command<void, Room?>> _leaveRoomCommands = {};
  Command<void, Room?> getLeaveRoomCommand(Room room) =>
      _leaveRoomCommands.putIfAbsent(
        room.id,
        () => Command.createAsync(
          (_) async {
            await _editRoomService.leaveRoom(room);
            _leaveRoomCommands.remove(room.id);
            return room;
          },
          initialValue: null,
          errorFilter: LeaveRoomErrorFilter(),
        ),
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
  void toggleOrSetShowMarkRooms({bool? show}) =>
      showRoomMarkers.value = show ?? !showRoomMarkers.value;
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

class LeaveRoomErrorFilter extends ErrorFilter {
  @override
  ErrorReaction filter(Object error, StackTrace stackTrace) =>
      ErrorReaction.throwException;
}

enum LeaveOrForget { leave, forget }
