import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:matrix/matrix.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:yaru/yaru.dart';

import '../../common/local_image_manager.dart';
import '../../common/view/common_widgets.dart';
import '../../common/view/ui_constants.dart';
import '../../extensions/event_x.dart';
import 'chat_message_reactions.dart';

class ChatImage extends StatelessWidget with WatchItMixin {
  const ChatImage({
    super.key,
    required this.event,
    this.dimension,
    this.height,
    this.fit = BoxFit.cover,
    this.width = imageWidth,
    this.onTap,
    this.showDescription = true,
    this.onlyImage = false,
    this.showLabel = false,
    this.borderRadius,
    this.timeline,
  });

  final Event event;
  final double? dimension;
  final double? height;
  final double width;
  final BoxFit fit;
  final VoidCallback? onTap;
  final bool showDescription;
  final bool onlyImage;
  final bool showLabel;
  final BorderRadius? borderRadius;
  final Timeline? timeline;

  static const double imageWidth = 370.0;
  static const double imageHeight = 270.0;

  @override
  Widget build(BuildContext context) {
    final bRadius = borderRadius ?? const BorderRadius.all(kBigBubbleRadius);

    final theHeight = dimension ?? height ?? imageHeight;
    final theWidth = dimension ?? width;
    final maybeImage = watchPropertyValue(
      (LocalImageManager m) => m.get(event.eventId),
    );

    if (event.status == EventStatus.error) {
      return const Center(child: Icon(YaruIcons.image_missing, size: 45));
    } else if (event.status != EventStatus.synced) {
      return SizedBox(
        height: theHeight,
        width: theWidth,
        child: const Center(child: Progress()),
      );
    }

    final image = SizedBox(
      height: theHeight,
      width: theWidth,
      child: maybeImage != null
          ? event.isSvgImage
                ? SvgPicture.memory(
                    maybeImage,
                    fit: fit,
                    height: theHeight,
                    width: theWidth,
                  )
                : Image.memory(
                    maybeImage,
                    fit: fit,
                    height: theHeight,
                    width: theWidth,
                  )
          : ChatImageFuture(
              event: event,
              width: theWidth,
              height: theHeight,
              fit: fit,
              getThumbnail: event.hasThumbnail,
            ),
    );

    if (onlyImage) {
      return image;
    }

    return ClipRRect(
      borderRadius: bRadius,
      child: InkWell(
        borderRadius: bRadius,
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                image,
                if (event.isVideo)
                  const Icon(YaruIcons.video, size: 55, color: Colors.white70),
                if (showLabel && !event.isUserEvent)
                  Positioned(
                    top: kSmallPadding,
                    left: event.isUserEvent ? null : kSmallPadding,
                    right: event.isUserEvent ? kSmallPadding : null,
                    child: Badge(
                      backgroundColor: Colors.black87,
                      textColor: Colors.white,
                      label: Padding(
                        padding: const EdgeInsets.all(kTinyPadding),
                        child: Text(
                          event.senderFromMemoryOrFallback.calcDisplayname(),
                        ),
                      ),
                    ),
                  ),
                if (timeline != null)
                  Positioned(
                    bottom: kSmallPadding,
                    right: event.isUserEvent ? null : kSmallPadding,
                    left: event.isUserEvent ? kSmallPadding : null,
                    child: ChatMessageReactions(
                      event: event,
                      timeline: timeline!,
                    ),
                  ),
              ],
            ),
            if (showDescription &&
                event.fileDescription != null &&
                event.fileDescription!.isNotEmpty)
              SizedBox(
                width: theWidth,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: kMediumPadding,
                    vertical: kSmallPadding,
                  ),
                  child: Text(event.fileDescription!),
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
    required this.getThumbnail,
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
    final localImageManager = di<LocalImageManager>();
    final image = localImageManager.get(widget.event.eventId);
    _future = image != null
        ? Future.value(image)
        : localImageManager.downloadImage(
            event: widget.event,
            cache: widget.event.hasThumbnail && widget.getThumbnail,
          );
  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
    future: _future,
    builder: (context, snapshot) => snapshot.hasError
        ? Icon(
            YaruIcons.image_missing,
            size: widget.height == null ? 45 : widget.height! / 2,
          )
        : snapshot.hasData
        ? AnimatedOpacity(
            opacity: snapshot.hasData ? 1 : 0,
            duration: const Duration(milliseconds: 300),
            child: (widget.event.isSvgImage)
                ? SvgPicture.memory(
                    snapshot.data!,
                    fit: widget.fit ?? BoxFit.contain,
                    height: widget.height,
                    width: widget.width,
                  )
                : Image.memory(
                    snapshot.data!,
                    fit: widget.fit,
                    height: widget.height,
                    width: widget.width,
                  ),
          )
        : const Center(child: Progress()),
  );
}
