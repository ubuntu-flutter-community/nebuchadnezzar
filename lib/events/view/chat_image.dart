import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:matrix/matrix.dart';
import 'package:yaru/yaru.dart';

import '../../common/local_image_manager.dart';
import '../../common/view/common_widgets.dart';
import '../../common/view/ui_constants.dart';
import '../../extensions/event_x.dart';
import '../../player/player_manager.dart';
import '../../player/view/player_control_mixin.dart';
import '../../player/view/player_full_view.dart';
import 'chat_message_image_full_screen_dialog.dart';
import 'chat_message_reactions.dart';

class ChatImage extends StatelessWidget with WatchItMixin, PlayerControlMixin {
  const ChatImage({
    super.key,
    required this.event,
    this.dimension,
    this.height,
    this.fit = BoxFit.cover,
    this.width = imageWidth,
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
  final bool showDescription;
  final bool onlyImage;
  final bool showLabel;
  final BorderRadius? borderRadius;
  final Timeline? timeline;

  static const double imageWidth = 370.0;
  static const double imageHeight = 270.0;

  @override
  Widget build(BuildContext context) {
    if (di<LocalImageManager>().getImageFromCache(event.eventId) == null) {
      callOnceAfterThisBuild(
        (context) => di<LocalImageManager>()
            .getImageDownloadCommand(event)
            .run(
              DownloadImageCapsule(
                event: event,
                shallBeThumbnail: event.hasThumbnail,
              ),
            ),
      );
    }

    final bRadius = borderRadius ?? const BorderRadius.all(kBigBubbleRadius);

    final theHeight = dimension ?? height ?? imageHeight;
    final theWidth = dimension ?? width;

    final maybeImageResults = watchValue(
      (LocalImageManager m) => m.getImageDownloadCommand(event).results,
    );

    if (event.status == EventStatus.error) {
      return const _ErrorImage();
    }

    final image = SizedBox(
      height: theHeight,
      width: theWidth,
      child: maybeImageResults.toWidget(
        onError: (error, lastResult, param) => const _ErrorImage(),
        whileRunning: (lastResult, param) =>
            _ChatImageLoadingIndicator(blurHash: event.blurHash, fit: fit),
        onData: (result, param) => result == null
            ? const _ErrorImage()
            : Image.memory(
                result,
                fit: fit,
                width: theWidth,
                height: theHeight,
                frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                  if (wasSynchronouslyLoaded) {
                    return child;
                  }
                  return AnimatedOpacity(
                    opacity: frame == null ? 0 : 1,
                    duration: const Duration(seconds: 1),
                    curve: Curves.easeOut,
                    child: child,
                  );
                },
              ),
      ),
    );

    if (onlyImage) {
      return image;
    }

    return ClipRRect(
      borderRadius: bRadius,
      child: InkWell(
        borderRadius: bRadius,
        onTap: () {
          if (event.isVideo) {
            playMatrixMedia(context, event: event);
            showDialog(
              context: context,
              builder: (context) => const PlayerFullView(),
            );
            di<PlayerManager>().updateState(fullMode: true);
          } else {
            showDialog(
              context: context,
              builder: (context) =>
                  ChatMessageImageFullScreenDialog(event: event),
            );
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                image,
                if (event.isVideo)
                  const CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.black45,
                    child: Icon(
                      YaruIcons.media_play,
                      size: 55,
                      color: Colors.white70,
                    ),
                  ),
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
                    left: kSmallPadding,
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

class _ErrorImage extends StatelessWidget {
  const _ErrorImage();

  @override
  Widget build(BuildContext context) =>
      const Center(child: Icon(YaruIcons.image_missing, size: 45));
}

class _ChatImageLoadingIndicator extends StatelessWidget {
  const _ChatImageLoadingIndicator({required this.blurHash, required this.fit});

  final String? blurHash;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: ChatImage.imageHeight,
    width: ChatImage.imageWidth,
    child: blurHash != null
        ? BlurHash(
            hash: blurHash!,
            imageFit: fit,
            errorBuilder: (context, error, stackTrace) => const _ErrorImage(),
          )
        : const Center(child: Progress()),
  );
}
