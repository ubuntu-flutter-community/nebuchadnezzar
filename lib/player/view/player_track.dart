import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../../common/view/build_context_x.dart';
import '../../extensions/media_x.dart';
import '../player_manager.dart';

class PlayerTrack extends StatelessWidget with WatchItMixin {
  const PlayerTrack({super.key});

  @override
  Widget build(BuildContext context) {
    final duration = watchStream(
      (PlayerManager p) => p.durationStream,
      initialValue: di<PlayerManager>().duration,
    ).data;

    final position = watchStream(
      (PlayerManager p) => p.positionStream,
      initialValue: Duration.zero,
    ).data;

    final bufferedPosition = watchStream(
      (PlayerManager p) => p.bufferedPositionStream,
      initialValue: Duration.zero,
    ).data;

    final sliderActive =
        duration != null &&
        position != null &&
        duration.inSeconds > position.inSeconds;

    final bufferActive =
        bufferedPosition != null &&
        position != null &&
        duration != null &&
        bufferedPosition.inSeconds >= 0 &&
        bufferedPosition.inSeconds <=
            (sliderActive ? duration.inSeconds.toDouble() : 1.0);

    const thumbShape = RoundSliderThumbShape(
      elevation: 0,
      enabledThumbRadius: 0,
      disabledThumbRadius: 0,
    );

    return SliderTheme(
      data: context.theme.sliderTheme.copyWith(
        thumbColor: Colors.white,
        minThumbSeparation: 0,
        thumbShape: thumbShape,
        overlayShape: thumbShape,
        trackShape: const RectangularSliderTrackShape() as SliderTrackShape,
        trackHeight: 4.0,
        activeTrackColor: Colors.white,
        inactiveTrackColor: Colors.white24,
        secondaryActiveTrackColor: Colors.white38,
      ),
      child: Slider(
        max: sliderActive ? duration.inSeconds.toDouble() : 1.0,
        value: sliderActive ? position.inSeconds.toDouble() : 0,
        secondaryTrackValue: bufferActive
            ? bufferedPosition.inSeconds.toDouble()
            : null,
        onChanged: (value) {
          di<PlayerManager>().seek(Duration(seconds: value.toInt()));
        },
      ),
    );
  }
}

class PlayerTrackInfo extends StatelessWidget with WatchItMixin {
  const PlayerTrackInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final duration = watchStream(
      (PlayerManager p) => p.durationStream,
      initialValue: di<PlayerManager>().duration,
      preserveState: false,
    ).data;

    final position = watchStream(
      (PlayerManager p) => p.positionStream,
      initialValue: Duration.zero,
      preserveState: false,
    ).data;

    final media = watchStream(
      (PlayerManager p) => p.currentMediaStream,
      initialValue: di<PlayerManager>().currentMedia,
      preserveState: false,
    ).data;

    if (media == null) {
      return const SizedBox.shrink();
    }

    return Row(
      children: [
        SizedBox(
          width: 120,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                media.artist,
                maxLines: 2,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Colors.white,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                media.title,
                maxLines: 1,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Colors.white,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                '${position?.toString().split('.').first ?? '0:00:00'} / ${duration?.toString().split('.').first ?? '0:00:00'}',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Colors.white70,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isDiscrete = false,
    bool isEnabled = false,
    double additionalActiveTrackHeight = 0,
  }) {
    super.paint(
      context,
      offset,
      parentBox: parentBox,
      sliderTheme: sliderTheme,
      enableAnimation: enableAnimation,
      textDirection: textDirection,
      thumbCenter: thumbCenter,
      isDiscrete: isDiscrete,
      isEnabled: isEnabled,
      additionalActiveTrackHeight: 0,
    );
  }
}
