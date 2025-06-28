import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';

import '../../common/chat_model.dart';
import '../../common/view/build_context_x.dart';
import '../../l10n/l10n.dart';

class ChatRoomMasterTileSubTitle extends StatelessWidget with WatchItMixin {
  const ChatRoomMasterTileSubTitle({super.key, required this.room});

  final Room room;

  @override
  Widget build(BuildContext context) {
    final typingUsers =
        watchStream(
          (ChatModel m) => m.getTypingUsersStream(room),
          initialValue: room.typingUsers,
        ).data ??
        [];

    final lastEvent = watchStream(
      (ChatModel m) => m.getLastEventStream(room),
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

class ChatRoomLastEvent extends StatelessWidget {
  const ChatRoomLastEvent({required this.lastEvent, super.key});

  final Event? lastEvent;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      key: ValueKey(
        '${lastEvent?.eventId}_${lastEvent?.type}_${lastEvent?.redacted}}',
      ),
      future: lastEvent?.calcLocalizedBody(
        const MatrixDefaultLocalizations(),
        hideReply: true,
        plaintextBody: true,
        withSenderNamePrefix: true,
      ),
      initialData: lastEvent?.calcLocalizedBodyFallback(
        const MatrixDefaultLocalizations(),
        hideReply: true,
        plaintextBody: true,
        withSenderNamePrefix: true,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasData && lastEvent != null) {
          return Text(snapshot.data!, maxLines: 1);
        }

        return Text(context.l10n.emptyChat, maxLines: 1);
      },
    );
  }
}
