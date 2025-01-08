import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';

import '../../../common/view/build_context_x.dart';
import '../../../l10n/l10n.dart';
import '../../chat_model.dart';

class ChatRoomMasterTileSubTitle extends StatelessWidget with WatchItMixin {
  const ChatRoomMasterTileSubTitle({super.key, required this.room});

  final Room room;

  @override
  Widget build(BuildContext context) {
    final typingUsers = watchStream(
          (ChatModel m) => m.getTypingUsersStream(room),
          initialValue: room.typingUsers,
        ).data ??
        [];

    final lastEvent = watchStream(
      (ChatModel m) => m.getLastEventStream(room),
      initialValue: room.lastEvent,
    ).data;

    return typingUsers.isEmpty
        ? _LastEvent(
            key: ObjectKey(lastEvent),
            lastEvent: lastEvent ?? room.lastEvent,
          )
        : Text(
            typingUsers.length > 1
                ? context.l10n.numUsersTyping(typingUsers.length)
                : context.l10n
                    .userIsTyping(typingUsers.first.displayName ?? ''),
            style: context.textTheme.bodyMedium
                ?.copyWith(color: context.colorScheme.primary),
            maxLines: 1,
          );
  }
}

class _LastEvent extends StatefulWidget with WatchItStatefulWidgetMixin {
  const _LastEvent({
    required this.lastEvent,
    super.key,
  });

  final Event? lastEvent;

  @override
  State<_LastEvent> createState() => _LastEventState();
}

class _LastEventState extends State<_LastEvent> {
  late final Future<String> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.lastEvent
            ?.calcLocalizedBody(const MatrixDefaultLocalizations()) ??
        Future.value(widget.lastEvent?.body ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        return Text(
          snapshot.hasData ? snapshot.data! : ' ',
          maxLines: 1,
        );
      },
    );
  }
}
