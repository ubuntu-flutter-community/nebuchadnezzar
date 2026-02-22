import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';

import '../../../common/chat_manager.dart';
import '../../../common/logging.dart';
import '../../create_or_edit/create_room_manager.dart';
import '../../create_or_edit/edit_room_manager.dart';

mixin ChatJoinMixin {
  void registerJoinHandlers(BuildContext context) {
    registerHandler(
      select: (CreateRoomManager m) => m.createOrGetDirectChatCommand.results,
      handler: (_, newValue, _) {
        if (newValue.error != null) {
          printMessageInDebugMode(
            'Error creating direct chat: ${newValue.error}',
          );
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(newValue.error.toString())));
          return;
        }

        final room = newValue.data;

        if (room != null) {
          printMessageInDebugMode('Joining room ${room.id}');
          di<ChatManager>().setSelectedRoom(room);
        }
      },
    );

    registerHandler(
      select: (EditRoomManager m) => m.knockOrJoinCommand,
      handler: (context, room, cancel) {
        if (room != null) {
          di<ChatManager>().setSelectedRoom(room);
          if (room.isSpace) {
            di<ChatManager>().setActiveSpace(room);
          }
        }
      },
    );

    registerHandler(
      select: (EditRoomManager m) => m.joinRoomCommand,
      handler: (context, room, cancel) {
        if (room != null) {
          di<ChatManager>().setSelectedRoom(room);
          if (room.isSpace) {
            di<ChatManager>().setActiveSpace(room);
          }
        }
      },
    );
  }
}
