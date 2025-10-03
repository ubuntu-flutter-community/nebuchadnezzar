import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../common/view/build_context_x.dart';
import '../../common/view/chat_avatar.dart';
import '../../common/view/chat_profile_dialog.dart';
import '../../common/view/theme.dart';
import '../../common/view/ui_constants.dart';
import '../../extensions/event_x.dart';
import '../../l10n/l10n.dart';
import '../../player/player_manager.dart';
import '../../player/view/player_control_mixin.dart';
import '../../player/view/player_full_view.dart';
import '../chat_download_manager.dart';
import 'chat_event_status_icon.dart';
import 'chat_image.dart';
import 'chat_map.dart';
import 'chat_message_attachment_indicator.dart';
import 'chat_message_image_full_screen_dialog.dart';
import 'chat_message_media_avatar.dart';
import 'chat_message_menu.dart';
import 'chat_message_reactions.dart';
import 'chat_message_reply_header.dart';
import 'chat_text_message.dart';
import 'localized_display_event_text.dart';

class ChatMessageBubbleContent extends StatelessWidget with PlayerControlMixin {
  const ChatMessageBubbleContent({
    super.key,
    required this.event,
    required this.timeline,
    required this.onReplyOriginClick,
    required this.eventPosition,
  });

  final Event event;
  final Timeline timeline;
  final Future<void> Function(Event event) onReplyOriginClick;
  final EventPosition eventPosition;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = context.textTheme;
    final messageStyle = textTheme.bodyMedium;
    final displayEvent = event.getDisplayEvent(timeline);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: event.isUserEvent
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: kSmallPadding,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kSmallPadding),
          child:
              eventPosition == EventPosition.top ||
                  eventPosition == EventPosition.semanticSingle
              ? ChatAvatar(
                  avatarUri: event.senderFromMemoryOrFallback.avatarUrl,
                  onTap: () => showDialog(
                    context: context,
                    builder: (context) =>
                        ChatProfileDialog(userId: event.senderId),
                  ),
                  fallBackColor: avatarFallbackColor(
                    context.colorScheme,
                  ).scale(saturation: -1),
                )
              : const SizedBox.square(dimension: kAvatarDefaultSize),
        ),
        Flexible(
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: event.isUserEvent
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,

                children: [
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
                              color: getTileColor(
                                event.isUserEvent,
                                context.theme,
                              ),
                              borderRadius: switch (eventPosition) {
                                EventPosition.middle => BorderRadius.circular(
                                  kBubbleRadiusValue,
                                ),
                                EventPosition.top => const BorderRadius.only(
                                  topLeft: kBubbleRadius,
                                  topRight: kBigBubbleRadius,
                                  bottomLeft: kBubbleRadius,
                                  bottomRight: kBubbleRadius,
                                ),
                                EventPosition.bottom => const BorderRadius.only(
                                  topLeft: kBubbleRadius,
                                  topRight: kBubbleRadius,
                                  bottomLeft: kBigBubbleRadius,
                                  bottomRight: kBigBubbleRadius,
                                ),
                                EventPosition.semanticSingle =>
                                  const BorderRadius.all(
                                    kBigBubbleRadius,
                                  ).copyWith(topLeft: kBubbleRadius),
                              },
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(height: kSmallPadding),
                                Text(
                                  event.senderFromMemoryOrFallback
                                      .calcDisplayname(),
                                  style: textTheme.labelSmall,
                                ),
                                if ({
                                  RelationshipTypes.reply,
                                  RelationshipTypes.thread,
                                }.contains(event.relationshipType))
                                  ChatMessageReplyHeader(
                                    event: event,
                                    timeline: timeline,
                                    onReplyOriginClick: onReplyOriginClick,
                                  ),

                                event.redacted
                                    ? AnimatedOpacity(
                                        opacity: event.redacted ? 0.5 : 1.0,
                                        duration: const Duration(
                                          milliseconds: 500,
                                        ),

                                        child: LocalizedDisplayEventText(
                                          displayEvent: displayEvent,
                                          style: messageStyle?.copyWith(
                                            decoration:
                                                TextDecoration.lineThrough,
                                          ),
                                        ),
                                      )
                                    : switch ((
                                        event.messageType,
                                        event.hasThumbnail,
                                      )) {
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
                                        (MessageTypes.Video, true) => ChatImage(
                                          fit: BoxFit.contain,
                                          event: event,
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  const PlayerFullView(),
                                            );
                                            di<PlayerManager>().updateState(
                                              fullMode: true,
                                            );
                                            playMatrixMedia(
                                              context,
                                              event: event,
                                            );
                                          },
                                        ),
                                        (MessageTypes.Location, _) => ChatMap(
                                          event: event,
                                          eventPosition: eventPosition,
                                          timeline: timeline,
                                          onReplyOriginClick:
                                              onReplyOriginClick,
                                        ),
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              spacing: kMediumPadding,
                                              children: [
                                                ChatMessageMediaAvatar(
                                                  event: event,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    event.fileName ??
                                                        event
                                                            .attachmentMimetype,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 3,
                                                  ),
                                                ),
                                                IconButton(
                                                  tooltip: l10n.downloadFile,
                                                  onPressed: () =>
                                                      di<ChatDownloadManager>()
                                                          .safeFile(
                                                            event: event,
                                                            dialogTitle:
                                                                l10n.saveFile,
                                                            confirmButtonText:
                                                                l10n.saveFile,
                                                          ),
                                                  icon:
                                                      ChatMessageAttachmentIndicator(
                                                        event: event,
                                                      ),
                                                ),
                                                if (event.messageType ==
                                                        MessageTypes.Audio ||
                                                    event.messageType ==
                                                        MessageTypes.Video)
                                                  IconButton(
                                                    tooltip: l10n.appendToQueue,
                                                    onPressed: () =>
                                                        playMatrixMedia(
                                                          context,
                                                          event: event,
                                                          newPlaylist: false,
                                                        ),
                                                    icon: const Icon(
                                                      YaruIcons.music_queue,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        _ => ChatTextMessage(
                                          displayEvent: displayEvent,
                                          messageStyle: messageStyle,
                                        ),
                                      },
                                if (!event.redacted)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: kSmallPadding,
                                    ),
                                    child: ChatMessageReactions(
                                      event: event,
                                      timeline: timeline,
                                    ),
                                  ),
                                const SizedBox(height: kSmallPadding),
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
                        ],
                      ),
                    ),
                  ),
                  if ((event.isUserEvent ||
                          event.status == EventStatus.error) &&
                      eventPosition == EventPosition.bottom)
                    ChatEventStatusIcon(event: event, timeline: timeline),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
