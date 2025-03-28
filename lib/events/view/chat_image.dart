import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../common/event_x.dart';
import '../../common/local_image_model.dart';
import '../../common/view/common_widgets.dart';
import '../../common/view/ui_constants.dart';

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
  static const borderRadius = BorderRadius.all(kBubbleRadius);

  @override
  Widget build(BuildContext context) {
    final theHeight = dimension ?? height ?? imageHeight;
    final theWidth = dimension ?? width;
    final theFit = fit ?? BoxFit.cover;
    final maybeImage =
        watchPropertyValue((LocalImageModel m) => m.get(event.eventId));

    if (event.status == EventStatus.error) {
      return const Center(
        child: Icon(
          YaruIcons.image_missing,
          size: 45,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kSmallPadding),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: InkWell(
          borderRadius: borderRadius,
          onTap: onTap,
          child: SizedBox(
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
                    getThumbnail: onlyThumbnail,
                  ),
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
    final localImageModel = di<LocalImageModel>();
    final image = localImageModel.get(widget.event.eventId);
    _future = image != null
        ? Future.value(image)
        : localImageModel.downloadImage(
            event: widget.event,
            getThumbnail: widget.getThumbnail,
          );
  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
        future: _future,
        builder: (context, snapshot) => snapshot.hasData
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
            : const Center(
                child: Progress(),
              ),
      );
}
