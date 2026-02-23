import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:matrix/matrix.dart';

import '../../../common/view/build_context_x.dart';
import '../../../events/chat_download_manager.dart';
import '../../../player/data/local_media.dart';
import '../../../player/player_manager.dart';
import '../../input/record_service.dart';

class AudioVisualizer extends StatelessWidget with WatchItMixin {
  const AudioVisualizer({
    super.key,
    this.height = 40,
    required this.recording,
    this.event,
  });

  final double height;
  final AudioRecording recording;
  final Event? event;

  @override
  Widget build(BuildContext context) {
    final playerPosition = watchValue(
      (PlayerManager m) =>
          m.position.select((p) => p.inMilliseconds.toDouble()),
    );

    final maxPosition = watchValue(
      (PlayerManager m) =>
          m.duration.select((p) => p.inMilliseconds.toDouble()),
    );
    var currentPosition = playerPosition;

    if (currentPosition > maxPosition) {
      currentPosition = maxPosition;
    }

    final wavePosition =
        (currentPosition / maxPosition) * AudioRecording.waveCount;

    final media = watchStream(
      (PlayerManager p) => p.currentMediaStream,
      initialValue: di<PlayerManager>().currentMedia,
      preserveState: false,
      allowStreamChange: true,
    ).data;

    final cap = event == null
        ? null
        : watchValue((ChatDownloadManager m) => m.getDownloadCommand(event!));

    final isAudioPlaying = media is LocalMedia && media.uri == cap?.file?.path;

    final waveform = recording.normalizedWaveform;
    return Stack(
      children: [
        if (waveform != null)
          Row(
            children: [
              for (var i = 0; i < AudioRecording.waveCount; i++)
                Expanded(
                  child: Container(
                    height: height,
                    alignment: Alignment.center,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 1),
                      decoration: BoxDecoration(
                        color: isAudioPlaying && i < wavePosition
                            ? context.colorScheme.primary
                            : context.colorScheme.primary.withAlpha(128),
                        borderRadius: BorderRadius.circular(64),
                      ),
                      height: height * (waveform[i] / 1024),
                    ),
                  ),
                ),
            ],
          ),
        if (isAudioPlaying && maxPosition > 0 && currentPosition >= 0)
          SizedBox(
            height: height,
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                thumbShape: const RoundSliderThumbShape(
                  enabledThumbRadius: 0,
                  disabledThumbRadius: 0,
                ),
              ),
              child: Slider(
                secondaryActiveColor: Colors.transparent,
                overlayColor: WidgetStateProperty.all(Colors.transparent),
                thumbColor: Colors.transparent,
                activeColor: Colors.transparent,
                inactiveColor: Colors.transparent,
                max: maxPosition,
                value: currentPosition,
                onChanged: isAudioPlaying
                    ? (value) => di<PlayerManager>().seek(
                        Duration(milliseconds: value.round()),
                      )
                    : null,
              ),
            ),
          ),
      ],
    );
  }
}
