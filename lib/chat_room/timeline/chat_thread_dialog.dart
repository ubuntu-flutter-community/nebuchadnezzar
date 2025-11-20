import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:matrix/matrix.dart';

import '../../common/chat_manager.dart';
import '../../common/view/build_context_x.dart';
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
    di<DraftManager>().setThreadRootEventId(widget.event.eventId);
    di<DraftManager>().setThreadLastEventId(
      widget.event
          .aggregatedEvents(widget.timeline, RelationshipTypes.thread)
          .last
          .eventId,
    );
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

    final textTheme = context.textTheme;
    return AlertDialog(
      title: Text(
        'Thread(${widget.event.senderFromMemoryOrFallback.calcDisplayname()}): ${widget.event.getDisplayEvent(widget.timeline).plaintextBody}',
        maxLines: 3,
        style: textTheme.titleMedium,
      ),
      contentPadding: EdgeInsets.zero,
      actionsPadding: const EdgeInsets.all(kSmallPadding),
      content: SizedBox(
        width: 500,
        height: 600,
        child: ListView.builder(
          padding: const EdgeInsets.all(kMediumPadding),
          itemCount: widget.event
              .aggregatedEvents(widget.timeline, RelationshipTypes.thread)
              .length,
          itemBuilder: (context, index) {
            final threadChild = widget.event
                .aggregatedEvents(widget.timeline, RelationshipTypes.thread)
                .elementAt(index);
            return ChatMessageBubble(
              event: threadChild,
              timeline: widget.timeline,
              onReplyOriginClick: widget.onReplyOriginClick,
              eventPosition: EventPosition.middle,
            );
          },
        ),
      ),
      actions: [ChatInput(room: widget.timeline.room)],
    );
  }
}
