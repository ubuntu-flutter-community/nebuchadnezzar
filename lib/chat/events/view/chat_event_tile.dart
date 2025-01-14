import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';

import '../../../common/view/ui_constants.dart';
import '../../common/event_x.dart';
import '../../common/view/chat_avatar.dart';
import '../../common/view/chat_profile_dialog.dart';
import 'chat_image.dart';
import 'chat_message_badge.dart';
import 'chat_message_bubble.dart';
import 'chat_message_image_full_screen_dialog.dart';

class ChatEventTile extends StatelessWidget {
  const ChatEventTile({
    super.key,
    required this.event,
    required this.timeline,
    required this.onReplyOriginClick,
    this.partOfMessageCohort = false,
  });

  final Event event;
  final bool partOfMessageCohort;
  final Timeline timeline;
  final Future<void> Function(Event) onReplyOriginClick;

  @override
  Widget build(BuildContext context) {
    if (event.type == EventTypes.RoomMember) {
      return ChatMessageBadge(
        displayEvent: event.getDisplayEvent(timeline),
        leading: Padding(
          padding: const EdgeInsets.only(right: kSmallPadding),
          child: ChatAvatar(
            fallBackIconSize: 10,
            dimension: 15,
            avatarUri: event.senderFromMemoryOrFallback.avatarUrl,
            onTap: () => showDialog(
              context: context,
              builder: (context) => ChatProfileDialog(userId: event.senderId),
            ),
          ),
        ),
      );
    }
    if (event.showAsBadge) {
      return ChatMessageBadge(displayEvent: event.getDisplayEvent(timeline));
    }
    return switch (event.messageType) {
      MessageTypes.Image => event.isSvgImage
          ? ChatMessageBubble(
              event: event,
              timeline: timeline,
              onReplyOriginClick: onReplyOriginClick,
            )
          : ChatImage(
              timeline: timeline,
              event: event,
              onTap: () => showDialog(
                context: context,
                builder: (context) =>
                    ChatMessageImageFullScreenDialog(event: event),
              ),
            ),
      MessageTypes.Location ||
      MessageTypes.File ||
      MessageTypes.Video ||
      MessageTypes.Audio ||
      MessageTypes.Text ||
      MessageTypes.Notice ||
      MessageTypes.Emote ||
      MessageTypes.BadEncrypted =>
        ChatMessageBubble(
          event: event,
          timeline: timeline,
          onReplyOriginClick: onReplyOriginClick,
          partOfMessageCohort: partOfMessageCohort,
        ),
      _ => ChatMessageBadge(displayEvent: event.getDisplayEvent(timeline))
    };
  }
}
