import 'package:flutter/material.dart';
import 'package:listen_it/listen_it.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../common/view/build_context_x.dart';
import '../../common/view/theme.dart';
import '../../common/view/ui_constants.dart';
import '../player_manager.dart';
import 'player_album_art.dart';
import 'player_control_mixin.dart';
import 'player_explorer.dart';
import 'player_track.dart';
import 'player_view.dart';

class PlayerFullView extends StatelessWidget
    with WatchItMixin, PlayerControlMixin {
  const PlayerFullView({super.key});

  @override
  Widget build(BuildContext context) {
    final showPlayerExplorer = watchValue(
      (PlayerManager m) =>
          m.playerViewState.select((e) => e.showPlayerExplorer),
    );

    final isVideo =
        watchStream(
          (PlayerManager p) => p.isVideoStream,
          initialValue: di<PlayerManager>().isVideo,
          preserveState: false,
        ).data ??
        false;

    final media = watchStream(
      (PlayerManager p) => p.currentMediaStream,
      initialValue: di<PlayerManager>().currentMedia,
      preserveState: false,
    ).data;

    final color =
        watchValue(
          (PlayerManager p) => p.playerViewState.select((e) => e.color),
        ) ??
        context.colorScheme.primary;

    final isPortrait = !context.showSideBar;

    final bool showQueueFinal = context.showSideBar
        ? showPlayerExplorer
        : false;

    final theme = context.theme;
    final colorScheme = context.colorScheme;

    final iconColor = getPlayerIconColor(theme);

    return Theme(
      data: theme.copyWith(
        colorScheme: theme.colorScheme.copyWith(
          primary: color,
          outline: iconColor,
        ),
        inputDecorationTheme: theme.inputDecorationTheme.copyWith(
          fillColor: Colors.transparent,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: color),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: iconColor.withAlpha(150)),
          ),
          border: OutlineInputBorder(borderSide: BorderSide(color: iconColor)),
        ),
        dialogTheme: context.theme.dialogTheme.copyWith(
          backgroundColor: getPlayerBg(
            theme,
            color,
            saturation: colorScheme.isLight ? -0.8 : -0.6,
          ),
        ),
      ),

      child: Dialog.fullscreen(
        child: Column(
          children: [
            YaruDialogTitleBar(
              title: Text('Media Player', style: TextStyle(color: iconColor)),
              backgroundColor: Colors.transparent,
              border: BorderSide.none,
              isClosable: false,
              actions: [
                if (!isPortrait)
                  IconButton(
                    isSelected: showQueueFinal,
                    icon: Icon(
                      showQueueFinal
                          ? YaruIcons.sidebar_hide_right
                          : YaruIcons.sidebar_hide_filled,
                      color: iconColor,
                    ),
                    onPressed: () => di<PlayerManager>().updateViewMode(
                      showPlayerExplorer: !showQueueFinal,
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(kSmallPadding),
                  child: IconButton(
                    icon: Icon(YaruIcons.pan_down, color: iconColor),
                    onPressed: () => togglePlayerFullMode(context),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Row(
                children: [
                  if (isVideo)
                    Expanded(
                      flex: 2,
                      child: Video(
                        controller: di<PlayerManager>().videoController,
                      ),
                    )
                  else
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          PlayerAlbumArt(
                            media: media,
                            dimension: 300,
                            fit: BoxFit.fitHeight,
                          ),
                          if (isPortrait) ...[
                            const SizedBox(height: kBigPadding),
                            PlayerTrackInfo(
                              textColor: iconColor,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              artistStyle: context.textTheme.bodySmall,
                              titleStyle: context.textTheme.bodyLarge,
                              durationStyle: context.textTheme.bodyMedium,
                            ),
                          ],
                        ],
                      ),
                    ),
                  if (showQueueFinal) const Expanded(child: PlayerExplorer()),
                ],
              ),
            ),
            if (!isVideo) const PlayerView(),
          ],
        ),
      ),
    );
  }
}
