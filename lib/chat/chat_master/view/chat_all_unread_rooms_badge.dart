import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../../../common/view/build_context_x.dart';
import '../../common/chat_model.dart';

// TODO: move this to a registerStreamHandler -> send to operating system
class ChatAllUnreadRoomsBadge extends StatelessWidget {
  const ChatAllUnreadRoomsBadge({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final count = di<ChatModel>().rooms.where((r) => r.isUnread).length;

    return Badge(
      label: Text(
        count.toString(),
        style: TextStyle(
          color: context.theme.colorScheme.onPrimary,
          fontSize: 12,
        ),
      ),
      isLabelVisible: count != 0,
    );
  }
}
