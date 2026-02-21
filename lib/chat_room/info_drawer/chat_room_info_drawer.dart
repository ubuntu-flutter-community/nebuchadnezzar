import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:matrix/matrix.dart';

import '../../common/chat_manager.dart';
import '../../common/view/ui_constants.dart';
import '../../extensions/room_x.dart';
import '../create_or_edit/edit_room_service.dart';
import 'chat_room_info_drawer_direct_chat_content.dart';
import 'chat_room_info_drawer_direct_chat_header.dart';
import 'chat_room_info_drawer_forget_button.dart';
import 'chat_room_info_drawer_group_content.dart';
import 'chat_room_info_drawer_group_header.dart';
import 'chat_room_info_drawer_leave_button.dart';

class ChatRoomInfoDrawer extends StatelessWidget with WatchItMixin {
  const ChatRoomInfoDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final room = watchPropertyValue((ChatManager m) => m.selectedRoom);

    if (room == null) {
      return const SizedBox.shrink();
    }

    final unAcceptedDirectChat = watchStream(
      (EditRoomService m) => m
          .getUsersStreamOfJoinedRoom(
            room,
            membershipFilter: [Membership.invite],
          )
          .map((invitedUsers) => room.isDirectChat && invitedUsers.isNotEmpty),
      initialValue: room.isUnacceptedDirectChat,
      preserveState: false,
    ).data;

    return Drawer(
      key: ValueKey('drawer_${room.id}'),
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
            else if (unAcceptedDirectChat != true)
              ChatRoomInfoDrawerDirectChatHeader(
                key: ValueKey('${room.id}_header_'),
                room: room,
              ),
            if (room.isArchived)
              const Expanded(child: Text(''))
            else
              Expanded(
                child: room.isDirectChat
                    ? unAcceptedDirectChat != true
                          ? ChatRoomInfoDrawerDirectChatContent(room: room)
                          : const SizedBox.shrink()
                    : ChatRoomInfoDrawerGroupContent(room: room),
              ),

            Align(
              alignment: Alignment.bottomCenter,
              child: room.isArchived
                  ? ChatRoomInfoDrawerForgetButton(room: room)
                  : ChatRoomInfoDrawerLeaveButton(room: room),
            ),
            if (room.isArchived) const SizedBox(height: kBigPadding),
          ],
        ),
      ),
    );
  }
}
