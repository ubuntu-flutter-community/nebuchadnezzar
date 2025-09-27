import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';

import '../../../common/chat_manager.dart';

class ChatRoomDisplayName extends StatelessWidget with WatchItMixin {
  const ChatRoomDisplayName({super.key, required this.room});

  final Room room;

  @override
  Widget build(BuildContext context) {
    final displayName =
        watchStream(
          (ChatManager m) => m
              .getJoinedRoomUpdate(room.id)
              .map((_) => room.getLocalizedDisplayname()),
          initialValue: room.getLocalizedDisplayname(),
        ).data ??
        room.getLocalizedDisplayname();

    return Text(displayName);
  }
}
