import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';

import '../../../common/view/theme.dart';
import '../../../common/view/ui_constants.dart';
import '../../common/chat_model.dart';
import 'chat_message_bubble_content.dart';
import 'chat_message_bubble_shape.dart';
import 'chat_message_reactions.dart';

class ChatMessageBubble extends StatelessWidget {
  const ChatMessageBubble({
    super.key,
    required this.event,
    required this.timeline,
    this.messageBubbleShape = ChatMessageBubbleShape.allRound,
    required this.onReplyOriginClick,
    this.partOfMessageCohort = false,
  });

  final Event event;
  final Timeline timeline;
  final ChatMessageBubbleShape messageBubbleShape;
  final Future<void> Function(Event event) onReplyOriginClick;
  final bool partOfMessageCohort;

  static const width = 450.0;

  @override
  Widget build(BuildContext context) {
    final isUserMessage = di<ChatModel>().isUserEvent(event);

    return Align(
      alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Stack(
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: ChatMessageBubble.width,
              minWidth: 205,
            ),
            child: Container(
              margin: tilePadding(partOfMessageCohort),
              padding: const EdgeInsets.only(
                top: kSmallPadding,
                bottom: kSmallPadding,
              ),
              child: ChatMessageBubbleContent(
                partOfMessageCohort: partOfMessageCohort,
                messageBubbleShape: messageBubbleShape,
                event: event,
                timeline: timeline,
                onReplyOriginClick: onReplyOriginClick,
                hideAvatar: partOfMessageCohort,
              ),
            ),
          ),
          if (!event.redacted)
            Positioned(
              key: ValueKey('${event.eventId}reactions'),
              left: kMediumPlusPadding + 38,
              bottom: kTinyPadding,
              child: ChatMessageReactions(
                event: event,
                timeline: timeline,
              ),
            ),
        ],
      ),
    );
  }
}
