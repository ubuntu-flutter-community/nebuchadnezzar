import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';

import '../../common/event_x.dart';
import '../../common/view/chat_avatar.dart';
import '../../common/view/chat_profile_dialog.dart';
import '../../common/view/ui_constants.dart';
import 'chat_message_badge.dart';
import 'chat_message_bubble.dart';

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
    if (event.showAsBadge) {
      return ChatMessageBadge(
        displayEvent: event.getDisplayEvent(timeline),
        leading: event.type == EventTypes.RoomMember
            ? Padding(
                padding: const EdgeInsets.only(right: kSmallPadding),
                child: ChatAvatar(
                  fallBackIconSize: 10,
                  dimension: 15,
                  avatarUri: event.senderFromMemoryOrFallback.avatarUrl,
                  onTap: () => showDialog(
                    context: context,
                    builder: (context) =>
                        ChatProfileDialog(userId: event.senderId),
                  ),
                ),
              )
            : null,
      );
    }

    return ChatMessageBubble(
      event: event,
      timeline: timeline,
      onReplyOriginClick: onReplyOriginClick,
      partOfMessageCohort: partOfMessageCohort,
    );
  }
}
