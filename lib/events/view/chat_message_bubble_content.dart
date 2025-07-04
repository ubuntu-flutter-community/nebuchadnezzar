import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../common/event_x.dart';
import '../../common/view/build_context_x.dart';
import '../../common/view/chat_avatar.dart';
import '../../common/view/chat_profile_dialog.dart';
import '../../common/view/theme.dart';
import '../../common/view/ui_constants.dart';
import '../../l10n/l10n.dart';
import '../chat_download_model.dart';
import 'chat_event_status_icon.dart';
import 'chat_image.dart';
import 'chat_map.dart';
import 'chat_message_bubble_shape.dart';
import 'chat_message_image_full_screen_dialog.dart';
import 'chat_message_media_avatar.dart';
import 'chat_message_menu.dart';
import 'chat_message_reply_header.dart';
import 'chat_text_message.dart';
import 'localized_display_event_text.dart';

class ChatMessageBubbleContent extends StatelessWidget {
  const ChatMessageBubbleContent({
    super.key,
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
    final l10n = context.l10n;
    final textTheme = context.textTheme;
    final messageStyle = textTheme.bodyMedium;
    final displayEvent = event.getDisplayEvent(timeline);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: kSmallPadding,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kSmallPadding),
          child: hideAvatar && event.messageType == MessageTypes.Text
              ? const SizedBox.square(dimension: kAvatarDefaultSize)
              : ChatAvatar(
                  avatarUri: event.senderFromMemoryOrFallback.avatarUrl,
                  onTap: () => showDialog(
                    context: context,
                    builder: (context) =>
                        ChatProfileDialog(userId: event.senderId),
                  ),
                  fallBackColor: avatarFallbackColor(
                    context.colorScheme,
                  ).scale(saturation: -1),
                ),
        ),
        Flexible(
          child: ChatMessageMenu(
            event: event,
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: kMediumPadding,
                  ),
                  decoration: BoxDecoration(
                    color: getTileColor(event.isUserEvent, context.theme),
                    borderRadius: messageBubbleShape.getBorderRadius(
                      partOfMessageCohort,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: kSmallPadding),
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
                      event.redacted
                          ? AnimatedOpacity(
                              opacity: event.redacted ? 0.5 : 1.0,
                              duration: const Duration(milliseconds: 500),

                              child: LocalizedDisplayEventText(
                                displayEvent: displayEvent,
                                style: messageStyle?.copyWith(
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            )
                          : switch ((event.messageType, event.hasThumbnail)) {
                              (MessageTypes.Image, _) => ChatImage(
                                fit: BoxFit.contain,
                                event: event,
                                onTap: event.isSvgImage
                                    ? null
                                    : () => showDialog(
                                        context: context,
                                        builder: (context) =>
                                            ChatMessageImageFullScreenDialog(
                                              event: event,
                                            ),
                                      ),
                              ),
                              // TODO: #5
                              (MessageTypes.Video, true) => ChatImage(
                                fit: BoxFit.contain,
                                event: event,
                                onTap: () => showDialog(
                                  context: context,
                                  builder: (context) =>
                                      ChatMessageImageFullScreenDialog(
                                        event: event,
                                        getThumbnail: true,
                                      ),
                                ),
                              ),
                              (MessageTypes.Location, _) => ChatMap(
                                event: event,
                                partOfMessageCohort: partOfMessageCohort,
                                timeline: timeline,
                                onReplyOriginClick: onReplyOriginClick,
                              ),
                              // TODO: #5
                              (
                                MessageTypes.Audio ||
                                    MessageTypes.File ||
                                    MessageTypes.Video,
                                _,
                              ) =>
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: kSmallPadding,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    spacing: kMediumPadding,
                                    children: [
                                      Row(
                                        spacing: kMediumPadding,
                                        children: [
                                          ChatMessageMediaAvatar(event: event),
                                          Text(displayEvent.attachmentMimetype),
                                        ],
                                      ),
                                      IconButton(
                                        tooltip: l10n.downloadFile,
                                        onPressed: () =>
                                            di<ChatDownloadModel>().safeFile(
                                              event: event,
                                              dialogTitle: l10n.saveFile,
                                              confirmButtonText: l10n.saveFile,
                                            ),
                                        icon: const Icon(YaruIcons.download),
                                      ),
                                    ],
                                  ),
                                ),
                              _ => ChatTextMessage(
                                event: event,
                                displayEvent: displayEvent,
                                messageStyle: messageStyle,
                              ),
                            },
                      const SizedBox(height: kBigPadding),
                    ],
                  ),
                ),
                if (event.pinned)
                  Positioned(
                    top: kSmallPadding,
                    right: kSmallPadding,
                    child: GestureDetector(
                      onTap: () => event.togglePinned(),
                      child: const Icon(YaruIcons.pin, size: 15),
                    ),
                  ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: ChatEventStatusIcon(event: event, timeline: timeline),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
