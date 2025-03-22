import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';

import '../../common/view/build_context_x.dart';
import '../../common/view/ui_constants.dart';
import 'chat_room_info_media_grid.dart';
import 'chat_room_media_grid_headline.dart';

class ChatRoomInfoDrawerDirectChatContent extends StatelessWidget {
  const ChatRoomInfoDrawerDirectChatContent({
    super.key,
    required this.room,
  });

  final Room room;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: kBigPadding,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: kBigPadding,
            ),
            title: ChatRoomMediaGridHeadline(room: room),
          ),
          SizedBox(
            height: context.mediaQuerySize.height - 425,
            child: ChatRoomInfoMediaGrid(
              key: ValueKey('${room.id}_media'),
              room: room,
            ),
          ),
        ],
      ),
    );
  }
}
