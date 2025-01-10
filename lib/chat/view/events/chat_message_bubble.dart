import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';

import '../../../app_config.dart';
import '../../../common/view/build_context_x.dart';
import '../../../common/view/theme.dart';
import '../../../common/view/ui_constants.dart';
import '../../chat_download_model.dart';
import '../../chat_model.dart';
import '../chat_avatar.dart';
import '../chat_profile_dialog.dart';
import 'chat_event_status_icon.dart';
import 'chat_message_attachment_indicator.dart';
import 'chat_message_bubble_shape.dart';
import 'chat_message_media_avatar.dart';
import 'chat_message_menu.dart';
import 'chat_message_reactions.dart';
import 'chat_message_reply_header.dart';
import 'localized_display_event_text.dart';

class ChatMessageBubble extends StatelessWidget with WatchItMixin {
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
    final theme = context.theme;
    final isUserMessage = di<ChatModel>().isUserEvent(event);

    return Stack(
      children: [
        Align(
          alignment:
              isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
          child: Stack(
            children: [
              ChatMessageMenu(
                event: event,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: ChatMessageBubble.width,
                    minWidth: 205,
                  ),
                  child: Container(
                    margin: tilePadding(partOfMessageCohort),
                    padding: const EdgeInsets.all(kSmallPadding),
                    decoration: BoxDecoration(
                      color: getTileColor(
                        di<ChatModel>().isUserEvent(event),
                        theme,
                      ),
                      borderRadius: messageBubbleShape
                          .getBorderRadius(partOfMessageCohort),
                    ),
                    child: _ChatMessageBubbleContent(
                      event: event,
                      timeline: timeline,
                      onReplyOriginClick: onReplyOriginClick,
                      hideAvatar: partOfMessageCohort,
                    ),
                  ),
                ),
              ),
              if (!event.redacted)
                Positioned(
                  key: ValueKey('${event.eventId}reactions'),
                  left: kSmallPadding,
                  bottom: kSmallPadding,
                  child: ChatMessageReactions(
                    event: event,
                    timeline: timeline,
                  ),
                ),
              Positioned(
                bottom: kSmallPadding,
                right: kSmallPadding,
                child: ChatEventStatusIcon(
                  event: event,
                  timeline: timeline,
                ),
              ),
              Positioned(
                top: kBigPadding,
                right: kBigPadding,
                child: event.attachmentMxcUrl == null
                    ? const SizedBox.shrink()
                    : InkWell(
                        onTap: () => di<ChatDownloadModel>().safeFile(event),
                        child: ChatMessageAttachmentIndicator(event: event),
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ChatMessageBubbleContent extends StatelessWidget {
  const _ChatMessageBubbleContent({
    required this.event,
    required this.timeline,
    required this.onReplyOriginClick,
    required this.hideAvatar,
  });

  final Event event;
  final Timeline timeline;
  final Future<void> Function(Event event) onReplyOriginClick;
  final bool hideAvatar;

  @override
  Widget build(BuildContext context) {
    var html = event.formattedText;
    if (event.messageType == MessageTypes.Emote) {
      html = '* $html';
    }
    final textTheme = context.textTheme;
    final messageStyle = textTheme.bodyMedium;
    final displayEvent = event.getDisplayEvent(timeline);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: kSmallPadding,
      children: [
        Padding(
          padding: const EdgeInsets.all(kSmallPadding),
          child: hideAvatar || event.messageType == MessageTypes.BadEncrypted
              ? const SizedBox.shrink()
              : event.messageType == MessageTypes.Text
                  ? ChatAvatar(
                      avatarUri: event.senderFromMemoryOrFallback.avatarUrl,
                      onTap: () => showDialog(
                        context: context,
                        builder: (context) =>
                            ChatProfileDialog(userId: event.senderId),
                      ),
                      fallBackColor: getMonochromeBg(
                        theme: context.theme,
                        factor: 10,
                        darkFactor: yaru ? 1 : null,
                      ),
                    )
                  : ChatMessageMediaAvatar(event: event),
        ),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: kSmallPadding,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      event.senderFromMemoryOrFallback.calcDisplayname(),
                      style: textTheme.labelSmall,
                    ),
                  ),
                  if (!event.redacted)
                    Flexible(
                      child: ChatMessageReplyHeader(
                        event: event,
                        timeline: timeline,
                        onReplyOriginClick: onReplyOriginClick,
                      ),
                    ),
                ],
              ),
              Opacity(
                opacity: event.redacted ? 0.5 : 1,
                child: event.redacted
                    ? LocalizedDisplayEventText(
                        displayEvent: displayEvent,
                        style: messageStyle?.copyWith(
                          decoration: TextDecoration.lineThrough,
                        ),
                      )
                    : SelectableText.rich(
                        TextSpan(
                          style: messageStyle,
                          text: displayEvent.body,
                        ),
                        style: messageStyle,
                      ),
              ),
              const SizedBox(
                height: kBigPadding,
              ),
            ],
          ),
        ),
        const SizedBox(
          height: kSmallPadding,
        ),
      ],
    );
  }
}
