import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:matrix/matrix.dart';
import 'package:yaru/yaru.dart';

import '../../chat_room/timeline/chat_thread_dialog.dart';
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
    this.allowNormalReply = true,
    this.color,
  });

  final Event event;
  final Timeline timeline;
  final bool allowNormalReply;
  final Future<void> Function(Event event) onReplyOriginClick;
  final EventPosition eventPosition;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = context.textTheme;
    final messageStyle = textTheme.bodyMedium;
    final displayEvent = event.getDisplayEvent(timeline);

    final borderRadius = switch ((eventPosition, event.isUserEvent)) {
      (EventPosition.single, true) => BorderRadius.circular(12),
      (EventPosition.single, false) => BorderRadius.circular(12),
      (EventPosition.top, true) => const BorderRadius.only(
        topLeft: Radius.circular(kBigBubbleRadiusValue),
        topRight: Radius.circular(kBigBubbleRadiusValue),
        bottomLeft: Radius.circular(kBigBubbleRadiusValue),
      ),
      (EventPosition.top, false) => const BorderRadius.only(
        topLeft: Radius.circular(kBigBubbleRadiusValue),
        topRight: Radius.circular(kBigBubbleRadiusValue),
        bottomRight: Radius.circular(kBigBubbleRadiusValue),
      ),
      (EventPosition.middle, true) => const BorderRadius.only(
        topLeft: Radius.circular(kBigBubbleRadiusValue),
        bottomLeft: Radius.circular(kBigBubbleRadiusValue),
        bottomRight: Radius.circular(kTinyPadding),
        topRight: Radius.circular(kTinyPadding),
      ),
      (EventPosition.middle, false) => const BorderRadius.only(
        topRight: Radius.circular(kBigBubbleRadiusValue),
        bottomRight: Radius.circular(kBigBubbleRadiusValue),
        topLeft: Radius.circular(kTinyPadding),
        bottomLeft: Radius.circular(kTinyPadding),
      ),
      (EventPosition.bottom, true) => const BorderRadius.only(
        topLeft: Radius.circular(kBigBubbleRadiusValue),
        bottomLeft: Radius.circular(kBigBubbleRadiusValue),
        bottomRight: Radius.circular(kBigBubbleRadiusValue),
        topRight: Radius.circular(kTinyPadding),
      ),
      (EventPosition.bottom, false) => const BorderRadius.only(
        topRight: Radius.circular(kBigBubbleRadiusValue),
        bottomLeft: Radius.circular(kBigBubbleRadiusValue),
        bottomRight: Radius.circular(kBigBubbleRadiusValue),
        topLeft: Radius.circular(kTinyPadding),
      ),
    };

    final baseColor = color ?? getTileColor(event.isUserEvent, context.theme);
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
              !event.isUserEvent &&
                  (eventPosition == EventPosition.top ||
                      eventPosition == EventPosition.single)
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
                      timeline: timeline,
                      allowNormalReply: allowNormalReply,
                      child: Stack(
                        children: [
                          Container(
                            padding: event.isImage
                                ? null
                                : const EdgeInsets.symmetric(
                                    horizontal: kMediumPadding,
                                  ),
                            decoration: BoxDecoration(
                              gradient: event.isImage
                                  ? null
                                  : LinearGradient(
                                      colors: [
                                        baseColor,
                                        baseColor.scale(lightness: 0.05),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),

                              borderRadius: borderRadius,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (!event.hasThumbnail || !event.isImage)
                                  const SizedBox(height: kSmallPadding),

                                if (!event.isUserEvent &&
                                    eventPosition != EventPosition.bottom &&
                                    eventPosition != EventPosition.middle)
                                  Text(
                                    event.senderFromMemoryOrFallback
                                        .calcDisplayname(),
                                    style: textTheme.labelSmall,
                                  ),

                                if (event.inReplyToEventId(
                                      includingFallback: false,
                                    ) !=
                                    null)
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
                                          borderRadius: borderRadius,
                                          timeline: timeline,
                                          showLabel: true,
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
                                          showLabel: true,
                                          timeline: timeline,
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
                                                          .getSaveFileCommand(
                                                            event,
                                                          )
                                                          .run((
                                                            confirmButtonText:
                                                                l10n.saveFile,
                                                            dialogTitle:
                                                                l10n.saveFile,
                                                          )),
                                                  icon:
                                                      ChatMessageAttachmentIndicator(
                                                        event: event,
                                                      ),
                                                ),
                                                if (event.messageType ==
                                                        MessageTypes.Audio ||
                                                    event.messageType ==
                                                        MessageTypes.Video)
                                                  AppendToQueueButton(
                                                    event: event,
                                                  ),
                                              ],
                                            ),
                                          ),
                                        _ => ChatTextMessage(
                                          displayEvent: displayEvent,
                                          messageStyle: messageStyle,
                                        ),
                                      },
                                if (!event.hasThumbnail)
                                  const SizedBox(height: kSmallPadding),
                                if (event
                                    .aggregatedEvents(
                                      timeline,
                                      RelationshipTypes.thread,
                                    )
                                    .isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.all(kTinyPadding),
                                    child: InkWell(
                                      onTap: () => showDialog(
                                        context: context,
                                        builder: (context) => ChatThreadDialog(
                                          event: event,
                                          timeline: timeline,
                                          onReplyOriginClick:
                                              onReplyOriginClick,
                                        ),
                                      ),
                                      child: const Badge(
                                        label: Text('Thread >'),
                                      ),
                                    ),
                                  ),
                                if (event.status == EventStatus.synced &&
                                    !event.redacted &&
                                    !(event.hasThumbnail || event.isImage))
                                  ChatMessageReactions(
                                    event: event,
                                    timeline: timeline,
                                  ),
                                if (!event.hasThumbnail && !event.isImage)
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
                      (eventPosition == EventPosition.bottom ||
                          eventPosition == EventPosition.single))
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

class AppendToQueueButton extends StatelessWidget
    with WatchItMixin, PlayerControlMixin {
  const AppendToQueueButton({super.key, required this.event});

  final Event event;

  @override
  Widget build(BuildContext context) {
    final isDownloading = watchValue(
      (ChatDownloadManager m) => m.getDownloadCommand(event).isRunning,
    );

    return IconButton(
      tooltip: context.l10n.appendToQueue,
      onPressed: isDownloading
          ? null
          : () => playMatrixMedia(context, event: event, newPlaylist: false),
      icon: const Icon(YaruIcons.music_queue),
    );
  }
}
