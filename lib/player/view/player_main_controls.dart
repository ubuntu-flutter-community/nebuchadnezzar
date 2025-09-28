import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../common/view/build_context_x.dart';
import '../../common/view/ui_constants.dart';
import '../player_manager.dart';

class PlayerMainControls extends StatelessWidget {
  const PlayerMainControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: kMediumPadding,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const PlayerShuffleButton(),
        IconButton(
          style: playerButtonStyle,
          icon: const Icon(YaruIcons.skip_backward, color: Colors.white),
          onPressed: di<PlayerManager>().previous,
        ),
        const PlayerIsPlayingButton(),
        IconButton(
          style: playerButtonStyle,
          icon: const Icon(YaruIcons.skip_forward, color: Colors.white),
          onPressed: di<PlayerManager>().next,
        ),
        const PlayerPlaylistModeButton(),
      ],
    );
  }
}

class PlayerShuffleButton extends StatelessWidget with WatchItMixin {
  const PlayerShuffleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final shuffle =
        watchStream(
          (PlayerManager p) => p.shuffleStream,
          initialValue: di<PlayerManager>().shuffle,
          preserveState: false,
        ).data ==
        true;
    return IconButton(
      style: playerButtonStyle,
      icon: Icon(
        YaruIcons.shuffle,
        color: shuffle ? context.colorScheme.primary : Colors.white,
      ),
      onPressed: () => di<PlayerManager>().toggleShuffle(),
    );
  }
}

class PlayerPlaylistModeButton extends StatelessWidget with WatchItMixin {
  const PlayerPlaylistModeButton({super.key});

  @override
  Widget build(BuildContext context) {
    final playlistMode = watchStream(
      (PlayerManager p) => p.playlistModeStream,
      initialValue: di<PlayerManager>().playlistMode,
      preserveState: false,
    ).data;

    return IconButton(
      style: playerButtonStyle,
      icon: Icon(
        switch (playlistMode) {
          PlaylistMode.single => YaruIcons.repeat_single,
          _ => YaruIcons.repeat,
        },
        color: switch (playlistMode) {
          PlaylistMode.single ||
          PlaylistMode.loop => context.colorScheme.primary,
          _ => Colors.white,
        },
      ),
      onPressed: () => di<PlayerManager>().changePlaylistMode(),
    );
  }
}

class PlayerIsPlayingButton extends StatelessWidget with WatchItMixin {
  const PlayerIsPlayingButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isPlaying = watchStream(
      (PlayerManager p) => p.isPlayingStream,
      initialValue: di<PlayerManager>().isPlaying,
      preserveState: false,
    ).data;

    return IconButton(
      style: playerButtonStyle,
      icon: Icon(
        isPlaying == true ? YaruIcons.media_pause : YaruIcons.media_play,
        color: Colors.white,
      ),
      onPressed: di<PlayerManager>().playOrPause,
    );
  }
}
