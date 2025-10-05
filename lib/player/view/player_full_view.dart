import 'package:flutter/material.dart';
import 'package:listen_it/listen_it.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../common/platforms.dart';
import '../../common/view/build_context_x.dart';
import '../../common/view/theme.dart';
import '../../common/view/ui_constants.dart';
import '../player_manager.dart';
import 'player_album_art.dart';
import 'player_control_mixin.dart';
import 'player_explorer.dart';
import 'player_track_info.dart';
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

    final theme = context.theme;
    final colorScheme = context.colorScheme;

    final iconColor = getPlayerIconColor(theme);

    return Theme(
      data: theme.copyWith(
        colorScheme: theme.colorScheme.copyWith(
          primary: color,
          outline: iconColor,
        ),
        textSelectionTheme: theme.textSelectionTheme.copyWith(
          cursorColor: color,
          selectionColor: color.withAlpha(100),
          selectionHandleColor: color,
        ),
        inputDecorationTheme: theme.inputDecorationTheme.copyWith(
          fillColor: Colors.transparent,

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(kYaruButtonRadius),
            borderSide: BorderSide(color: color),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(kYaruButtonRadius),
            borderSide: BorderSide(color: iconColor.withAlpha(150)),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: iconColor),
            borderRadius: BorderRadius.circular(kYaruButtonRadius),
          ),
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
              isClosable: !Platforms.isMacOS,
              actions: [
                IconButton(
                  isSelected: showPlayerExplorer,
                  icon: Icon(
                    showPlayerExplorer
                        ? YaruIcons.music_queue_filled
                        : YaruIcons.music_queue,
                    color: iconColor,
                  ),
                  onPressed: () => di<PlayerManager>().updateState(
                    showPlayerExplorer: !showPlayerExplorer,
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
                  if (!isPortrait || (isPortrait && !showPlayerExplorer))
                    if (isVideo)
                      Expanded(
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
                            if (isPortrait ||
                                (!isPortrait && !showPlayerExplorer)) ...[
                              const SizedBox(height: kBigPadding),
                              PlayerTrackInfo(
                                textColor: iconColor,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                artistStyle: context.textTheme.bodyMedium,
                                titleStyle: context.textTheme.bodyLarge,
                                durationStyle: context.textTheme.bodySmall,
                              ),
                            ],
                          ],
                        ),
                      ),
                  if (showPlayerExplorer)
                    const Expanded(child: PlayerExplorer()),
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
