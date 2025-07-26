import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:yaru/yaru.dart';

import '../../common/view/build_context_x.dart';
import '../../common/view/ui_constants.dart';
import '../../l10n/l10n.dart';
import '../common/view/chat_room_users_list.dart';
import 'chat_room_info_drawer_topic.dart';
import 'chat_room_info_drawer_media_grid.dart';
import 'chat_room_info_drawer_media_grid_headline.dart';

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
      headers:
          [
                Row(
                  spacing: kSmallPadding,
                  children: [
                    const Icon(YaruIcons.chat_text),
                    Text(
                      l10n.chatDescription,
                      style: theme.textTheme.titleSmall,
                    ),
                  ],
                ),
                Row(
                  spacing: kSmallPadding,
                  children: [
                    const Icon(YaruIcons.users),
                    Text(l10n.users, style: theme.textTheme.titleSmall),
                  ],
                ),
                ChatRoomInfoDrawerMediaGridHeadline(room: room),
              ]
              .map(
                (e) => MouseRegion(cursor: SystemMouseCursors.click, child: e),
              )
              .toList(),
      children: [
        ChatRoomInfoDrawerTopic(key: ValueKey('${room.id}_topic'), room: room),
        SizedBox(
          height: context.mediaQuerySize.height - 340,
          child: ChatRoomUsersList(room: room, sliver: false),
        ),
        SizedBox(
          height: context.mediaQuerySize.height - 340,
          child: ChatRoomInfoDrawerMediaGridTabs(
            key: ValueKey('${room.id}_media_'),
            room: room,
          ),
        ),
      ],
    );
  }
}
