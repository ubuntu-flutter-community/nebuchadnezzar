import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:flutter_it/flutter_it.dart';

import '../../common/chat_manager.dart';
import '../../common/view/build_context_x.dart';
import '../../l10n/l10n.dart';
import 'chat_room_last_event.dart';

class ChatRoomMasterTileSubTitle extends StatelessWidget with WatchItMixin {
  const ChatRoomMasterTileSubTitle({super.key, required this.room});

  final Room room;

  @override
  Widget build(BuildContext context) {
    final typingUsers =
        watchStream(
          (ChatManager m) => m.getTypingUsersStream(room),
          initialValue: room.typingUsers,
        ).data ??
        [];

    final lastEvent = watchStream(
      (ChatManager m) => m.getLastEventStream(room),
      initialValue: room.lastEvent,
    ).data;

    if (typingUsers.isEmpty) {
      return ChatRoomLastEvent(lastEvent: lastEvent);
    }

    return Text(
      typingUsers.length > 1
          ? context.l10n.numUsersTyping(typingUsers.length)
          : context.l10n.userIsTyping(typingUsers.first.displayName ?? ''),
      style: context.textTheme.bodyMedium?.copyWith(
        color: context.colorScheme.primary,
      ),
      maxLines: 1,
    );
  }
}
