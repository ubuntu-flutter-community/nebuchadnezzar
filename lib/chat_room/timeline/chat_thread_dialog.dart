import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:matrix/matrix.dart';
import 'package:yaru/yaru.dart';

import '../../common/chat_manager.dart';
import '../../common/view/ui_constants.dart';
import '../../events/view/chat_message_bubble.dart';
import '../../extensions/event_x.dart';
import '../input/draft_manager.dart';
import '../input/view/chat_input.dart';
import 'timeline_manager.dart';

class ChatThreadDialog extends StatefulWidget with WatchItStatefulWidgetMixin {
  const ChatThreadDialog({
    super.key,
    required this.event,
    required this.timeline,
    required this.onReplyOriginClick,
  });

  final Event event;
  final Timeline timeline;
  final Future<void> Function(Event event) onReplyOriginClick;

  @override
  State<ChatThreadDialog> createState() => _ChatThreadDialogState();
}

class _ChatThreadDialogState extends State<ChatThreadDialog> {
  @override
  void initState() {
    super.initState();
    di<DraftManager>()
      ..setReplyEvent(null, notify: false)
      ..setEditEvent(roomId: widget.event.room.id, event: null, notify: false)
      ..setThreadRootEventId(widget.event.eventId, notify: false)
      ..setThreadLastEventId(
        widget.event
            .aggregatedEvents(widget.timeline, RelationshipTypes.thread)
            .last
            .eventId,
        notify: false,
      );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      di<DraftManager>().setThreadMode(true);
    });
  }

  @override
  void dispose() {
    super.dispose();
    di<DraftManager>().resetThreadIds();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      di<DraftManager>().setThreadMode(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final room = widget.timeline.room;
    watchStream((ChatManager m) => m.getEventStream(room), initialValue: null);
    watchStream(
      (ChatManager m) => m.getHistoryStream(room),
      initialValue: null,
    );

    watchPropertyValue((TimelineManager m) => m.getTimeline(room.id));

    var events = {
      ...widget.event.aggregatedEvents(
        widget.timeline,
        RelationshipTypes.thread,
      ),
      widget.event,
    };
    return AlertDialog(
      constraints: const BoxConstraints(maxWidth: 500, maxHeight: 800),
      titlePadding: EdgeInsets.zero,
      title: const YaruDialogTitleBar(title: Text('Thread')),
      contentPadding: EdgeInsets.zero,
      actionsPadding: const EdgeInsets.all(kSmallPadding),
      content: SizedBox(
        width: 500,
        height: 600,
        child: ListView.builder(
          reverse: true,
          padding: const EdgeInsets.all(kMediumPadding),
          itemCount: events.length,
          itemBuilder: (context, index) {
            final threadChild = events.elementAtOrNull(index);

            if (threadChild == null) return const SizedBox.shrink();

            return ChatMessageBubble(
              showThreadButton: false,
              event: threadChild,
              timeline: widget.timeline,
              onReplyOriginClick: widget.onReplyOriginClick,
              eventPosition: EventPosition.single,
              allowNormalReply: false,
            );
          },
        ),
      ),
      actions: [
        ChatInput(key: const ValueKey('THREAD'), room: widget.timeline.room),
      ],
    );
  }
}
