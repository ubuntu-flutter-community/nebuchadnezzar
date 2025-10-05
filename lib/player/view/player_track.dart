import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../common/view/build_context_x.dart';
import '../../common/view/common_widgets.dart';
import '../../common/view/theme.dart';
import '../../common/view/ui_constants.dart';
import '../player_manager.dart';

class PlayerTrack extends StatelessWidget with WatchItMixin {
  const PlayerTrack({super.key});

  @override
  Widget build(BuildContext context) {
    final duration = watchValue((PlayerManager p) => p.duration);

    final position = watchValue((PlayerManager p) => p.position);

    final buffer = watchValue((PlayerManager p) => p.buffer);

    final sliderActive = duration.inSeconds > position.inSeconds;

    final bufferActive =
        buffer.inSeconds >= 0 &&
        buffer.inSeconds <=
            (sliderActive ? duration.inSeconds.toDouble() : 1.0);

    const thumbShape = RoundSliderThumbShape(
      elevation: 0,
      enabledThumbRadius: 0,
      disabledThumbRadius: 0,
    );

    final trackColor = getPlayerIconColor(context.theme);

    final isPlaying =
        watchStream(
          (PlayerManager p) => p.isPlayingStream,
          initialValue: di<PlayerManager>().isPlaying,
        ).data ??
        false;

    return RepaintBoundary(
      child: (duration.inSeconds < 10) && isPlaying
          ? LinearProgress(
              value: null,
              trackHeight: kPlayerTrackHeight,
              color: trackColor.withValues(alpha: 0.8),
              backgroundColor: trackColor.withValues(alpha: 0.4),
            )
          : SliderTheme(
              data: context.theme.sliderTheme.copyWith(
                thumbColor: Colors.white,
                minThumbSeparation: 0,
                thumbShape: thumbShape,
                overlayShape: thumbShape,
                trackShape:
                    const RectangularSliderTrackShape() as SliderTrackShape,
                trackHeight: kPlayerTrackHeight,
                activeTrackColor: trackColor.scale(saturation: 0.2),
                inactiveTrackColor: trackColor.withAlpha(50),
                secondaryActiveTrackColor: trackColor.withAlpha(80),
              ),
              child: Slider(
                min: 0,
                max: sliderActive ? duration.inSeconds.toDouble() : 1.0,
                value: sliderActive ? position.inSeconds.toDouble() : 0.0,
                secondaryTrackValue: bufferActive
                    ? buffer.inSeconds.toDouble()
                    : null,
                onChanged: (value) {
                  di<PlayerManager>().seek(Duration(seconds: value.toInt()));
                },
              ),
            ),
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
