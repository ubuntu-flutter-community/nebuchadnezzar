import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../common/view/common_widgets.dart';
import '../../common/view/image_shimmer.dart';
import '../../common/view/ui_constants.dart';
import '../chat_download_model.dart';
import '../chat_model.dart';
import '../local_image_model.dart';
import 'events/chat_event_status_icon.dart';
import 'events/chat_message_attachment_indicator.dart';
import 'events/chat_message_menu.dart';
import 'events/chat_message_reactions.dart';

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
      padding: const EdgeInsets.symmetric(
        vertical: kBigPadding,
        horizontal: kMediumPadding,
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
    this.fromCache = true,
  });

  final Event event;
  final double? height;
  final double width;
  final BoxFit? fit;
  final bool fromCache;

  @override
  State<ChatImageFuture> createState() => _ChatImageFutureState();
}

class _ChatImageFutureState extends State<ChatImageFuture> {
  late final Future<dynamic> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.fromCache
        ? di<LocalImageModel>().downloadImage(event: widget.event)
        : widget.event.downloadAndDecryptAttachment(getThumbnail: true);
  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = widget.fromCache
                ? snapshot.data
                : (snapshot.data as MatrixFile).bytes;
            return Image.memory(
              data!,
              fit: widget.fit,
              height: widget.height,
              width: widget.width,
            );
          }

          return widget.fromCache
              ? const ImageShimmer()
              : const Center(
                  child: Progress(),
                );
        },
      );
}
