import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../../common/view/image_shimmer.dart';
import '../../../common/view/ui_constants.dart';
import '../../common/chat_model.dart';
import '../../common/local_image_model.dart';
import '../chat_download_model.dart';
import 'chat_event_status_icon.dart';
import 'chat_message_attachment_indicator.dart';
import 'chat_message_menu.dart';
import 'chat_message_reactions.dart';

class ChatImage extends StatelessWidget with WatchItMixin {
  const ChatImage({
    super.key,
    required this.event,
    required this.timeline,
    this.dimension,
    this.height,
    this.fit,
    this.width = imageWidth,
    this.onlyThumbnail = true,
    this.onTap,
  });

  final Event event;
  final Timeline timeline;
  final double? dimension;
  final double? height;
  final double width;
  final BoxFit? fit;
  final bool onlyThumbnail;
  final VoidCallback? onTap;

  static const double imageWidth = 370.0;
  static const double imageHeight = 270.0;

  @override
  Widget build(BuildContext context) {
    final theHeight = dimension ?? height ?? imageHeight;
    final theWidth = dimension ?? width;
    final theFit = fit ?? BoxFit.cover;
    final isUserMessage = di<ChatModel>().isUserEvent(event);
    final maybeImage =
        watchPropertyValue((LocalImageModel m) => m.get(event.eventId));

    return Padding(
      padding: EdgeInsets.only(
        top: kBigPadding,
        bottom: kBigPadding,
        right: kSmallPadding,
        left: (isUserMessage ? 0 : kAvatarDefaultSize + kBigPadding),
      ),
      child: Align(
        alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(kBigBubbleRadius),
          child: Stack(
            children: [
              ChatMessageMenu(
                event: event,
                child: SizedBox(
                  height: theHeight,
                  width: theWidth,
                  child: maybeImage != null
                      ? Image.memory(
                          maybeImage,
                          fit: theFit,
                          height: theHeight,
                          width: theWidth,
                        )
                      : ChatImageFuture(
                          event: event,
                          width: theWidth,
                          height: theHeight,
                          fit: theFit,
                        ),
                ),
              ),
              if (!event.redacted)
                Positioned(
                  left: kSmallPadding,
                  bottom: kSmallPadding,
                  child: ChatMessageReactions(
                    key: ValueKey('${event.eventId}reactions'),
                    event: event,
                    timeline: timeline,
                  ),
                ),
              Positioned(
                top: kSmallPadding,
                right: 10 * kSmallPadding,
                child: IconButton(
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.black.withValues(alpha: 0.5),
                    shape: const CircleBorder(),
                  ),
                  onPressed: () => di<ChatDownloadModel>().safeFile(event),
                  icon: ChatMessageAttachmentIndicator(
                    event: event,
                    iconSize: 22,
                    color: Colors.white,
                  ),
                ),
              ),
              if (isUserMessage)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: kSmallPadding),
                    margin: const EdgeInsets.all(kMediumPadding),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(kBigPadding),
                      color: Colors.black.withValues(alpha: 0.5),
                    ),
                    child: ChatEventStatusIcon(
                      timeline: timeline,
                      padding: const EdgeInsets.all(kTinyPadding),
                      event: event,
                      foregroundColor: Colors.white,
                    ),
                  ),
                )
              else
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: kSmallPadding),
                    margin: const EdgeInsets.all(kMediumPadding),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(kBigPadding),
                      color: Colors.black.withValues(alpha: 0.5),
                    ),
                    child: ChatEventStatusIcon(
                      timeline: timeline,
                      padding: const EdgeInsets.all(kTinyPadding),
                      event: event,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              Positioned(
                top: kSmallPadding,
                right: kSmallPadding,
                child: IconButton(
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.black.withValues(alpha: 0.5),
                    shape: const CircleBorder(),
                  ),
                  onPressed: onTap,
                  icon: const Icon(
                    YaruIcons.fullscreen,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChatImageFuture extends StatefulWidget {
  const ChatImageFuture({
    super.key,
    required this.event,
    this.height,
    required this.width,
    this.fit,
    this.getThumbnail = true,
  });

  final Event event;
  final double? height;
  final double width;
  final BoxFit? fit;
  final bool getThumbnail;

  @override
  State<ChatImageFuture> createState() => _ChatImageFutureState();
}

class _ChatImageFutureState extends State<ChatImageFuture> {
  late final Future<Uint8List?> _future;

  @override
  void initState() {
    super.initState();
    _future = di<LocalImageModel>()
        .downloadImage(event: widget.event, getThumbnail: widget.getThumbnail);
  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data;
            return Image.memory(
              data!,
              fit: widget.fit,
              height: widget.height,
              width: widget.width,
            );
          }

          return const ImageShimmer();
        },
      );
}
