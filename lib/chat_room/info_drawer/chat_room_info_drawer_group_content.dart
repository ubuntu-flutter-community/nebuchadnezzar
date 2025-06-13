import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:yaru/yaru.dart';

import '../../common/view/build_context_x.dart';
import '../../l10n/l10n.dart';
import '../common/view/chat_room_users_list.dart';
import 'chat_room_info_drawer_topic.dart';
import 'chat_room_info_media_grid.dart';
import 'chat_room_media_grid_headline.dart';

class ChatRoomInfoDrawerGroupContent extends StatelessWidget {
  const ChatRoomInfoDrawerGroupContent({super.key, required this.room});

  final Room room;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = context.theme;
    return YaruExpansionPanel(
      border: Border.all(color: Colors.transparent),
      placeDividers: false,
      headers: [
        Text(l10n.chatDescription, style: theme.textTheme.titleSmall),
        Text(l10n.users, style: theme.textTheme.titleSmall),
        ChatRoomMediaGridHeadline(room: room),
      ],
      children: [
        ChatRoomInfoDrawerTopic(key: ValueKey('${room.id}_topic'), room: room),
        SizedBox(
          height: context.mediaQuerySize.height - 340,
          child: ChatRoomUsersList(room: room, sliver: false),
        ),
        SizedBox(
          height: context.mediaQuerySize.height - 340,
          child: ChatRoomInfoMediaGridTabs(
            key: ValueKey('${room.id}_media_'),
            room: room,
          ),
        ),
      ],
    );
  }
}
