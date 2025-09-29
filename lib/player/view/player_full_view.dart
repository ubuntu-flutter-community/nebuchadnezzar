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
import 'player_queue.dart';
import 'player_track.dart';
import 'player_view.dart';

class PlayerFullView extends StatefulWidget with WatchItStatefulWidgetMixin {
  const PlayerFullView({super.key});

  @override
  State<PlayerFullView> createState() => _PlayerFullViewState();
}

class _PlayerFullViewState extends State<PlayerFullView>
    with PlayerControlMixin {
  @override
  Widget build(BuildContext context) {
    final showQueue = watchValue(
      (PlayerManager m) => m.playerViewState.select((e) => e.showQueue),
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

    final bool showQueueFinal = context.showSideBar ? showQueue : false;

    final iconColor = getPlayerIconColor(context.theme, color);

    return DialogTheme(
      backgroundColor: getPlayerBg(context.theme, color),
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
                      showQueue: !showQueueFinal,
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
                  if (showQueueFinal) const Expanded(child: PlayerQueue()),
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
