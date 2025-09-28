import 'package:flutter/material.dart';
import 'package:listen_it/listen_it.dart';
import 'package:watch_it/watch_it.dart';

import '../../common/view/build_context_x.dart';
import '../../common/view/theme.dart';
import '../../common/view/ui_constants.dart';
import '../player_manager.dart';
import 'player_album_art.dart';
import 'player_control_mixin.dart';
import 'player_main_controls.dart';
import 'player_track.dart';

class PlayerView extends StatelessWidget with WatchItMixin, PlayerControlMixin {
  const PlayerView({super.key});

  @override
  Widget build(BuildContext context) {
    final media = watchStream(
      (PlayerManager p) => p.currentMediaStream,
      initialValue: di<PlayerManager>().currentMedia,
      preserveState: false,
    ).data;

    final isFullMode = watchValue(
      (PlayerManager p) => p.playerViewState.select((e) => e.fullMode),
    );

    final color = watchValue(
      (PlayerManager p) => p.playerViewState.select((e) => e.color),
    );

    const firstChild = SizedBox.shrink();
    final secondChild = InkWell(
      hoverColor: context.colorScheme.primary.withAlpha(80),
      onTap: () => togglePlayerFullMode(context),
      child: SizedBox(
        height: 80,
        child: Material(
          color: blendColor(Colors.black, color ?? Colors.black, 0.2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
          child: Column(
            children: [
              const PlayerTrack(),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: kMediumPadding,
                  children: [
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 300),
                      opacity: isFullMode ? 0.0 : 1.0,
                      child: PlayerAlbumArt(media: media),
                    ),
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 300),
                      opacity: isFullMode ? 0.0 : 1.0,
                      child: const PlayerTrackInfo(),
                    ),
                    const Expanded(flex: 5, child: PlayerMainControls()),
                    IconButton(
                      style: playerButtonStyle,
                      icon: const Icon(Icons.stop, color: Colors.white),
                      onPressed: di<PlayerManager>().stop,
                    ),
                    const SizedBox(width: kSmallPadding),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return AnimatedCrossFade(
      firstChild: firstChild,
      secondChild: secondChild,
      crossFadeState: media == null
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
      duration: const Duration(milliseconds: 300),
    );
  }
}
