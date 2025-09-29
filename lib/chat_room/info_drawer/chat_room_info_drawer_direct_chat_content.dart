import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';

import '../../common/view/ui_constants.dart';
import 'chat_room_info_drawer_media_grid.dart';

class ChatRoomInfoDrawerDirectChatContent extends StatelessWidget {
  const ChatRoomInfoDrawerDirectChatContent({super.key, required this.room});

  final Room room;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kBigPadding),
      child: ChatRoomInfoDrawerMediaGridTabs(
        key: ValueKey('${room.id}_media'),
        room: room,
      ),
    );
  }
}
