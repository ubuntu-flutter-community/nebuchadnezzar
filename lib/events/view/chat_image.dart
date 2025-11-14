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

class ChatImage extends StatelessWidget with WatchItMixin {
  const ChatImage({
    super.key,
    required this.event,
    this.dimension,
    this.height,
    this.fit,
    this.width = imageWidth,
    this.onTap,
    this.showDescription = true,
    this.onlyImage = false,
  });

  final Event event;
  final double? dimension;
  final double? height;
  final double width;
  final BoxFit? fit;
  final VoidCallback? onTap;
  final bool showDescription;
  final bool onlyImage;

  static const double imageWidth = 370.0;
  static const double imageHeight = 270.0;
  static const borderRadius = BorderRadius.all(kBubbleRadius);

  @override
  Widget build(BuildContext context) {
    final theHeight = dimension ?? height ?? imageHeight;
    final theWidth = dimension ?? width;
    final theFit = fit ?? BoxFit.cover;
    final maybeImage = watchPropertyValue(
      (LocalImageManager m) => m.get(event.eventId),
    );

    if (event.status == EventStatus.error) {
      return const Center(child: Icon(YaruIcons.image_missing, size: 45));
    }

    final image = SizedBox(
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
              getThumbnail: event.hasThumbnail,
            ),
    );

    if (onlyImage) {
      return image;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kSmallPadding),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: InkWell(
          borderRadius: borderRadius,
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
                    const Icon(
                      YaruIcons.video,
                      size: 55,
                      color: Colors.white70,
                    ),
                ],
              ),
              if (showDescription &&
                  event.fileDescription != null &&
                  event.fileDescription!.isNotEmpty)
                Text(event.fileDescription!),
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
