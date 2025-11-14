import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:yaru/yaru.dart';

import '../../common/view/build_context_x.dart';
import '../player_manager.dart';
import 'player_track.dart';

class PlayerVolumePopup extends StatelessWidget with WatchItMixin {
  const PlayerVolumePopup({super.key, required this.iconColor});

  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final volume = watchStream(
      (PlayerManager p) => p.volumeStream,
      initialValue: di<PlayerManager>().volume,
      preserveState: false,
    ).data;

    return PopupMenuButton(
      padding: EdgeInsets.zero,
      itemBuilder: (context) {
        return [
          const PopupMenuItem(enabled: false, child: PlayerVolumeSlider()),
        ];
      },
      icon: Icon(switch (volume?.round() ?? 0) {
        0 => YaruIcons.speaker_muted,
        final v when v >= 1 && v <= 50 => YaruIcons.speaker_low,
        _ => YaruIcons.speaker,
      }, color: iconColor),
    );
  }
}

class PlayerVolumeSlider extends StatelessWidget with WatchItMixin {
  const PlayerVolumeSlider({super.key});

  @override
  Widget build(BuildContext context) {
    final volume = watchStream(
      (PlayerManager p) => p.volumeStream,
      initialValue: di<PlayerManager>().volume,
      preserveState: false,
    ).data;
    return RotatedBox(
      quarterTurns: 3,
      child: SliderTheme(
        data: context.theme.sliderTheme.copyWith(
          trackShape: CustomTrackShape(),
        ),
        child: Slider(
          value: volume?.clamp(0, 100) ?? 0,
          max: 100,
          onChanged: (v) => di<PlayerManager>().setVolume(v),
        ),
      ),
    );
  }
}
