import 'package:flutter/material.dart';
import 'package:listen_it/listen_it.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../common/view/build_context_x.dart';
import '../../common/view/theme.dart';
import '../../extensions/duration_x.dart';
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

    final color = watchValue(
      (PlayerManager p) => p.playerViewState.select((e) => e.color),
    );

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

    final trackColor = context.colorScheme.isDark
        ? Colors.white
        : blendColor(color ?? context.colorScheme.primary, Colors.white, 0.2);
    return SliderTheme(
      data: context.theme.sliderTheme.copyWith(
        thumbColor: Colors.white,
        minThumbSeparation: 0,
        thumbShape: thumbShape,
        overlayShape: thumbShape,
        trackShape: const RectangularSliderTrackShape() as SliderTrackShape,
        trackHeight: playerTrackHeight,
        activeTrackColor: trackColor.scale(saturation: 0.2),
        inactiveTrackColor: trackColor.withAlpha(80),
        secondaryActiveTrackColor: trackColor.withAlpha(120),
      ),
      child: Slider(
        min: 0,
        max: sliderActive ? duration.inSeconds.toDouble() : 1.0,
        value: sliderActive ? position.inSeconds.toDouble() : 0.0,
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
  const PlayerTrackInfo({
    super.key,
    required this.textColor,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.artistStyle,
    this.titleStyle,
    this.durationStyle,
  });

  final Color textColor;
  final CrossAxisAlignment crossAxisAlignment;
  final TextStyle? artistStyle;
  final TextStyle? titleStyle;
  final TextStyle? durationStyle;

  @override
  Widget build(BuildContext context) {
    final duration = watchStream(
      (PlayerManager p) => p.durationStream,
      initialValue: di<PlayerManager>().duration,
      preserveState: false,
    ).data;

    final position = watchStream(
      (PlayerManager p) => p.positionStream,
      initialValue: di<PlayerManager>().position,
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

    final textTheme = context.textTheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Text(
          media.artist,
          maxLines: 2,
          style: (artistStyle ?? textTheme.labelSmall)?.copyWith(
            color: textColor,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(
          media.title,
          maxLines: 1,
          style: (titleStyle ?? textTheme.labelSmall)?.copyWith(
            color: textColor,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(
          '${(position ?? Duration.zero).formattedTime} / ${(duration ?? Duration.zero).formattedTime}',
          style: (durationStyle ?? textTheme.labelSmall)?.copyWith(
            color: textColor,
            overflow: TextOverflow.ellipsis,
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
