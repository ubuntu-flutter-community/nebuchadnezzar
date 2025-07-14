import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:yaru/yaru.dart';

import '../../common/view/build_context_x.dart';
import '../../common/view/ui_constants.dart';

class ChatMessageReplyHeader extends StatefulWidget {
  const ChatMessageReplyHeader({
    super.key,
    required this.event,
    required this.timeline,
    required this.onReplyOriginClick,
  });

  final Event event;
  final Timeline timeline;
  final Future<void> Function(Event event) onReplyOriginClick;

  @override
  State<ChatMessageReplyHeader> createState() => _ChatMessageReplyHeaderState();
}

class _ChatMessageReplyHeaderState extends State<ChatMessageReplyHeader> {
  late final Future<Event?> _future;

  static final Map<String, Event> _cache = {};

  @override
  void initState() {
    super.initState();
    _future = widget.event.getReplyEvent(widget.timeline);
  }

  @override
  Widget build(BuildContext context) {
    final fromCache = _cache[widget.event.eventId];

    if (fromCache != null) {
      return fromCache.redacted
          ? Container()
          : _Message(
              replyEvent: fromCache,
              onReplyOriginClick: widget.onReplyOriginClick,
              timeline: widget.timeline,
            );
    }

    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        if (snapshot.hasData) {
          final replyEvent = snapshot.data;

          _cache.update(
            widget.event.eventId,
            (value) => replyEvent!,
            ifAbsent: () => replyEvent!,
          );

          if (replyEvent!.redacted) {
            return Container();
          }

          return _Message(
            replyEvent: replyEvent,
            onReplyOriginClick: widget.onReplyOriginClick,
            timeline: widget.timeline,
          );
        }

        return Container();
      },
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({
    required this.onReplyOriginClick,
    required this.replyEvent,
    required this.timeline,
  });

  final Future<void> Function(Event) onReplyOriginClick;
  final Event? replyEvent;
  final Timeline timeline;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: context.colorScheme.link, width: 2),
        ),
      ),
      padding: const EdgeInsets.only(left: kSmallPadding),
      margin: const EdgeInsets.only(top: kSmallPadding, bottom: kSmallPadding),
      child: InkWell(
        onTap: replyEvent == null
            ? null
            : () => onReplyOriginClick(replyEvent!),
        child: Text(
          '${replyEvent?.senderFromMemoryOrFallback.calcDisplayname()}: ${replyEvent?.getDisplayEvent(timeline).body}',
          style: context.textTheme.labelSmall?.copyWith(
            fontStyle: FontStyle.italic,
            overflow: TextOverflow.ellipsis,
            color: context.colorScheme.link,
          ),
        ),
      ),
    );
  }
}
