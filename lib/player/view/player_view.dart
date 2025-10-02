import 'package:flutter/material.dart';
import 'package:listen_it/listen_it.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../common/view/build_context_x.dart';
import '../../common/view/theme.dart';
import '../../common/view/ui_constants.dart';
import '../player_manager.dart';
import 'player_bottom_album_art.dart';
import 'player_control_mixin.dart';
import 'player_main_controls.dart';
import 'player_track.dart';
import 'player_track_info.dart';
import 'player_volume_popup.dart';

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

    final colorScheme = context.colorScheme;

    const firstChild = SizedBox.shrink();

    final theme = context.theme;
    final iconColor = getPlayerIconColor(theme);

    final bgColor = getPlayerBg(
      theme,
      color,
      blendAmount: 0.4,
      saturation: colorScheme.isLight ? -0.7 : -0.5,
    );

    final secondChild = InkWell(
      hoverColor: colorScheme.primary.withAlpha(80),
      onTap: () => togglePlayerFullMode(context),
      child: SizedBox(
        height: kBottomPlayerHeight,
        child: Material(
          color: bgColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
          child: Column(
            children: [
              const PlayerTrack(),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: kMediumPadding,
                  children: [
                    if (isFullMode)
                      SizedBox.square(
                        dimension: kBottomPlayerHeight - kPlayerTrackHeight,
                        child: Center(
                          child: IconButton(
                            onPressed: () => togglePlayerFullMode(context),
                            icon: Icon(
                              YaruIcons.fullscreen_exit,
                              color: iconColor,
                            ),
                          ),
                        ),
                      )
                    else
                      PlayerBottomAlbumArt(media: media),
                    if (context.showSideBar)
                      SizedBox(
                        width: kPlayerInfoWidth,
                        child: PlayerTrackInfo(textColor: iconColor),
                      ),
                    Expanded(
                      flex: 5,
                      child: PlayerMainControls(
                        iconColor: iconColor,
                        selectedColor:
                            color?.scale(
                              saturation: 1,
                              lightness: colorScheme.isDark ? 0.3 : 0.1,
                            ) ??
                            colorScheme.primary,
                      ),
                    ),
                    PlayerVolumePopup(iconColor: iconColor),
                    IconButton(
                      style: playerButtonStyle,
                      icon: Icon(Icons.stop, color: iconColor),
                      onPressed: () {
                        di<PlayerManager>().stop();
                        di<PlayerManager>().updateState(fullMode: false);
                        Navigator.of(context).maybePop();
                      },
                    ),
                    const SizedBox(width: kMediumPadding),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return RepaintBoundary(
      child: AnimatedCrossFade(
        firstChild: firstChild,
        secondChild: secondChild,
        crossFadeState: media == null
            ? CrossFadeState.showFirst
            : CrossFadeState.showSecond,
        duration: const Duration(milliseconds: 300),
      ),
    );
  }
}
