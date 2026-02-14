import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';

import '../../common/view/ui_constants.dart';
import '../../extensions/event_x.dart';
import 'chat_message_bubble_content.dart';

class ChatMessageBubble extends StatelessWidget {
  const ChatMessageBubble({
    super.key,
    required this.event,
    required this.timeline,
    required this.onReplyOriginClick,
    required this.eventPosition,
    this.allowNormalReply = true,
    this.color,
  });

  final Event event;
  final Timeline timeline;
  final Future<void> Function(Event event) onReplyOriginClick;
  final EventPosition eventPosition;

  static const maxWidth = 450.0;
  static const minWidth = 205.0;

  final Color? color;
  final bool allowNormalReply;

  @override
  Widget build(BuildContext context) => Align(
    alignment: event.isUserEvent ? Alignment.centerRight : Alignment.centerLeft,
    child: ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: ChatMessageBubble.maxWidth,
        minWidth: ChatMessageBubble.minWidth,
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: kTinyPadding).copyWith(
          top: event.isImage
              ? null
              : eventPosition == EventPosition.top
              ? kMediumPadding
              : null,
        ),
        padding: switch (eventPosition) {
          EventPosition.single => const EdgeInsets.symmetric(
            vertical: kSmallPadding,
          ),
          EventPosition.top => const EdgeInsets.only(top: kMediumPadding),
          EventPosition.middle => const EdgeInsets.symmetric(
            vertical: kTinyPadding,
          ),
          EventPosition.bottom => const EdgeInsets.only(bottom: kMediumPadding),
        },
        child: ChatMessageBubbleContent(
          color: color,
          eventPosition: eventPosition,
          event: event,
          timeline: timeline,
          onReplyOriginClick: onReplyOriginClick,
          allowNormalReply: allowNormalReply,
        ),
      ),
    ),
  );
}
