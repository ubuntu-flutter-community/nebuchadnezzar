import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../../common/view/build_context_x.dart';
import '../../../common/view/theme.dart';
import '../../../common/view/ui_constants.dart';
import '../../common/chat_model.dart';
import '../../common/view/chat_avatar.dart';
import '../../common/view/chat_profile_dialog.dart';
import '../chat_download_model.dart';
import 'chat_event_status_icon.dart';
import 'chat_html_message.dart';
import 'chat_message_attachment_indicator.dart';
import 'chat_message_bubble_shape.dart';
import 'chat_message_media_avatar.dart';
import 'chat_message_menu.dart';
import 'chat_message_reactions.dart';
import 'chat_message_reply_header.dart';
import 'localized_display_event_text.dart';

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
              child: _ChatMessageBubbleContent(
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

class _ChatMessageBubbleContent extends StatelessWidget {
  const _ChatMessageBubbleContent({
    required this.event,
    required this.timeline,
    required this.onReplyOriginClick,
    required this.hideAvatar,
    required this.messageBubbleShape,
    required this.partOfMessageCohort,
  });

  final Event event;
  final Timeline timeline;
  final Future<void> Function(Event event) onReplyOriginClick;
  final bool hideAvatar;
  final ChatMessageBubbleShape messageBubbleShape;
  final bool partOfMessageCohort;

  @override
  Widget build(BuildContext context) {
    var html = event.formattedText;
    if (event.messageType == MessageTypes.Emote) {
      html = '* $html';
    }
    final textTheme = context.textTheme;
    final messageStyle =
        textTheme.bodyMedium?.copyWith(fontFamilyFallback: ['NotoEmoji']);
    final displayEvent = event.getDisplayEvent(timeline);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: kSmallPadding,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kSmallPadding),
          child: hideAvatar && event.messageType == MessageTypes.Text
              ? const SizedBox.square(
                  dimension: kAvatarDefaultSize,
                )
              : ChatMessageBubbleLeading(
                  event: event,
                ),
        ),
        Flexible(
          child: ChatMessageMenu(
            event: event,
            child: Stack(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: kMediumPadding),
                  decoration: BoxDecoration(
                    color: getTileColor(
                      di<ChatModel>().isUserEvent(event),
                      context.theme,
                    ),
                    borderRadius:
                        messageBubbleShape.getBorderRadius(partOfMessageCohort),
                  ),
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
                              event.senderFromMemoryOrFallback
                                  .calcDisplayname(),
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
                            : event.isRichMessage
                                ? HtmlMessage(
                                    html: html,
                                    room: timeline.room,
                                    defaultTextColor:
                                        context.colorScheme.onSurface,
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
                Positioned(
                  top: kSmallPadding,
                  right: kSmallPadding,
                  child: event.attachmentMxcUrl == null
                      ? const SizedBox.shrink()
                      : InkWell(
                          onTap: () => di<ChatDownloadModel>().safeFile(event),
                          child: ChatMessageAttachmentIndicator(event: event),
                        ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: ChatEventStatusIcon(
                    event: event,
                    timeline: timeline,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ChatMessageBubbleLeading extends StatelessWidget {
  const ChatMessageBubbleLeading({super.key, required this.event});

  final Event event;

  @override
  Widget build(BuildContext context) {
    if (event.messageType == MessageTypes.BadEncrypted) {
      return const SizedBox.square(dimension: kAvatarDefaultSize);
    } else if (event.messageType != MessageTypes.Text &&
        event.messageType != MessageTypes.Notice) {
      return ChatMessageMediaAvatar(event: event);
    }

    return ChatAvatar(
      avatarUri: event.senderFromMemoryOrFallback.avatarUrl,
      onTap: () => showDialog(
        context: context,
        builder: (context) => ChatProfileDialog(userId: event.senderId),
      ),
      fallBackColor:
          avatarFallbackColor(context.colorScheme).scale(saturation: -1),
    );
  }
}
