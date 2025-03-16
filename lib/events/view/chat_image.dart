import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../common/view/image_shimmer.dart';
import '../../common/view/ui_constants.dart';
import '../../common/event_x.dart';
import '../../common/local_image_model.dart';
import '../chat_download_model.dart';
import 'chat_message_attachment_indicator.dart';

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
    final maybeImage =
        watchPropertyValue((LocalImageModel m) => m.get(event.eventId));

    if (event.status == EventStatus.error) {
      return const Padding(
        padding: EdgeInsets.all(kSmallPadding),
        child: Icon(
          YaruIcons.image_missing,
          size: 30,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kSmallPadding),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(kBigBubbleRadius),
        child: Stack(
          children: [
            SizedBox(
              height: theHeight,
              width: theWidth,
              child: maybeImage != null
                  ? event.isSvgImage
                      ? SvgPicture.memory(
                          maybeImage,
                          fit: theFit,
                          height: theHeight,
                          width: theWidth,
                        )
                      : Image.memory(
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
            Positioned(
              top: kSmallPadding,
              right: onTap != null ? 10 * kSmallPadding : kSmallPadding,
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
            if (onTap != null)
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
            if (widget.event.isSvgImage) {
              SvgPicture.memory(
                snapshot.data!,
                fit: widget.fit ?? BoxFit.contain,
                height: widget.height,
                width: widget.width,
              );
            }

            return Image.memory(
              snapshot.data!,
              fit: widget.fit,
              height: widget.height,
              width: widget.width,
            );
          }

          return const ImageShimmer();
        },
      );
}
