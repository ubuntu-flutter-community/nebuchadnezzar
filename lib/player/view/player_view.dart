import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../common/view/build_context_x.dart';
import '../../common/view/ui_constants.dart';
import '../player_manager.dart';
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

    const firstChild = SizedBox.shrink();
    final secondChild = InkWell(
      hoverColor: context.colorScheme.primary.withAlpha(80),
      onTap: () => togglePlayerFullMode(context),
      child: SizedBox(
        height: 80,
        child: Material(
          color: Colors.black.withAlpha(200),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
          child: Column(
            children: [
              const PlayerTrack(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: kMediumPadding,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: kMediumPadding,
                    children: [
                      const Icon(
                        YaruIcons.music_note,
                        color: Colors.white,
                        size: 55,
                      ),
                      const PlayerTrackInfo(),
                      const Expanded(child: PlayerMainControls()),
                      IconButton(
                        style: playerButtonStyle,
                        icon: const Icon(Icons.stop, color: Colors.white),
                        onPressed: di<PlayerManager>().stop,
                      ),
                    ],
                  ),
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
