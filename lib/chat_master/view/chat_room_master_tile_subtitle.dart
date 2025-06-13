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
      return _LastEvent(
        key: ValueKey(
          '${lastEvent?.eventId}_${lastEvent?.type}_${lastEvent?.redacted}',
        ),
        lastEvent: room.lastEvent,
        fallbackText: room.membership == Membership.invite ? room.name : null,
      );
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

class _LastEvent extends StatefulWidget with WatchItStatefulWidgetMixin {
  const _LastEvent({required this.lastEvent, super.key, this.fallbackText});

  final Event? lastEvent;
  final String? fallbackText;

  @override
  State<_LastEvent> createState() => _LastEventState();
}

class _LastEventState extends State<_LastEvent> {
  late Future<String> _future;

  static final Map<String, String> _cache = {};

  @override
  void initState() {
    super.initState();
    _future =
        widget.lastEvent != null &&
            !widget.lastEvent!.redacted &&
            _cache.containsKey(widget.lastEvent!.eventId) &&
            widget.lastEvent?.type != EventTypes.Encrypted
        ? Future.value(_cache[widget.lastEvent!.eventId]!)
        : widget.lastEvent?.calcLocalizedBody(
                const MatrixDefaultLocalizations(),
                hideReply: true,
                hideEdit: false,
                plaintextBody: true,
              ) ??
              Future.value(widget.lastEvent?.body ?? '');
  }

  @override
  Widget build(BuildContext context) {
    if (widget.lastEvent != null &&
        _cache.containsKey(widget.lastEvent!.eventId) &&
        widget.lastEvent!.redacted == false) {
      return Text(_cache[widget.lastEvent!.eventId]!, maxLines: 1);
    }

    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.hasData && widget.lastEvent != null) {
          _cache[widget.lastEvent!.eventId] = snapshot.data!;
          return Text(snapshot.data!, maxLines: 1);
        }

        return Text(widget.fallbackText ?? ' ', maxLines: 1);
      },
    );
  }
}
