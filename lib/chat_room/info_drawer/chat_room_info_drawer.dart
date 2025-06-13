import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';

import '../../common/view/ui_constants.dart';
import 'chat_room_info_drawer_direct_chat_content.dart';
import 'chat_room_info_drawer_direct_chat_header.dart';
import 'chat_room_info_drawer_group_content.dart';
import 'chat_room_info_drawer_group_header.dart';
import 'chat_room_info_drawer_leave_button.dart';
import 'chat_room_join_or_leave_button.dart';

class ChatRoomInfoDrawer extends StatelessWidget {
  const ChatRoomInfoDrawer({super.key, required this.room});

  final Room room;

  @override
  Widget build(BuildContext context) => Drawer(
    child: SizedBox(
      width: kSideBarWith,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (!room.isDirectChat)
            ChatRoomInfoDrawerGroupHeader(
              key: ValueKey('${room.id}_header'),
              room: room,
            )
          else
            ChatRoomInfoDrawerDirectChatHeader(
              key: ValueKey('${room.id}_header_'),
              room: room,
            ),
          if (room.isArchived)
            const Expanded(child: Text(''))
          else
            Expanded(
              child: room.isDirectChat
                  ? ChatRoomInfoDrawerDirectChatContent(room: room)
                  : ChatRoomInfoDrawerGroupContent(room: room),
            ),
          if (room.isArchived) ChatRoomInfoDrawerLeaveButton(room: room),
          Align(
            alignment: Alignment.bottomCenter,
            child: ChatRoomJoinOrLeaveButton(room: room),
          ),
        ],
      ),
    ),
  );
}
