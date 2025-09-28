import 'package:flutter/material.dart';
import 'package:listen_it/listen_it.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../common/view/build_context_x.dart';
import '../../common/view/theme.dart';
import '../../common/view/ui_constants.dart';
import '../../extensions/media_x.dart';
import '../player_manager.dart';
import 'player_album_art.dart';
import 'player_control_mixin.dart';
import 'player_view.dart';

class PlayerFullView extends StatefulWidget with WatchItStatefulWidgetMixin {
  const PlayerFullView({super.key});

  @override
  State<PlayerFullView> createState() => _PlayerFullViewState();
}

class _PlayerFullViewState extends State<PlayerFullView>
    with PlayerControlMixin {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final showQueue = watchValue(
      (PlayerManager m) => m.playerViewState.select((e) => e.showQueue),
    );

    final playlist = watchStream(
      (PlayerManager p) => p.playlistStream,
      initialValue: di<PlayerManager>().playlist,
      preserveState: false,
    ).data;

    final playlistIndex = watchStream(
      (PlayerManager p) => p.playlistIndexStream,
      initialValue: di<PlayerManager>().playlistIndex,
      preserveState: false,
    ).data;

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

    final color = watchValue(
      (PlayerManager p) => p.playerViewState.select((e) => e.color),
    )!;

    return DialogTheme(
      backgroundColor: blendColor(Colors.black, color, 0.15),
      child: Dialog.fullscreen(
        child: playlist == null || playlist.medias.isEmpty
            ? Text(
                'No media in queue',
                style: context.theme.textTheme.bodyMedium,
              )
            : Column(
                children: [
                  YaruDialogTitleBar(
                    title: const Text(
                      'Media Player',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.transparent,
                    border: BorderSide.none,
                    isClosable: false,
                    actions: [
                      IconButton(
                        isSelected: showQueue,
                        icon: Icon(
                          showQueue
                              ? YaruIcons.sidebar_hide_right
                              : YaruIcons.sidebar_hide_filled,
                          color: Colors.white,
                        ),
                        onPressed: () => di<PlayerManager>().updateViewMode(
                          showQueue: !showQueue,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(kSmallPadding),
                        child: IconButton(
                          icon: const Icon(
                            YaruIcons.pan_down,
                            color: Colors.white,
                          ),
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
                            child: PlayerAlbumArt(
                              media: media,
                              dimension: 300,
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                        if (showQueue)
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(kBigPadding),
                              child: Column(
                                spacing: kBigPadding,
                                children: [
                                  Text(
                                    'Queue: ${playlist.medias.length} items',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  Expanded(
                                    child: ListTileTheme(
                                      textColor: Colors.white,
                                      iconColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: ReorderableListView.builder(
                                        buildDefaultDragHandles: false,
                                        proxyDecorator:
                                            (child, index, animation) =>
                                                Material(
                                                  color: Colors.white.withAlpha(
                                                    30,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  child: child,
                                                ),
                                        onReorder: (oldIndex, newIndex) {
                                          if (newIndex > oldIndex) {
                                            newIndex -= 1;
                                          }
                                          di<PlayerManager>().move(
                                            oldIndex,
                                            newIndex,
                                          );
                                        },
                                        scrollController: _scrollController,
                                        itemCount: playlist.medias.length,
                                        itemBuilder: (context, index) {
                                          final media = playlist.medias[index];
                                          return Padding(
                                            key: ValueKey(
                                              media.uri + index.toString(),
                                            ),
                                            padding: const EdgeInsets.only(
                                              bottom: kSmallPadding,
                                            ),
                                            child: ListTile(
                                              onTap: () => di<PlayerManager>()
                                                  .jump(index),
                                              leading: Text('${index + 1}'),
                                              title: Text(media.title),
                                              subtitle: Text(
                                                media.artist,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              selected: playlistIndex == index,
                                              selectedColor: context
                                                  .theme
                                                  .colorScheme
                                                  .primary,
                                              trailing:
                                                  playlist.medias.length > 1
                                                  ? Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets.symmetric(
                                                                horizontal:
                                                                    kSmallPadding,
                                                              ),
                                                          child: IconButton(
                                                            onPressed: () =>
                                                                di<
                                                                      PlayerManager
                                                                    >()
                                                                    .removeFromPlaylist(
                                                                      index,
                                                                    ),
                                                            icon: const Icon(
                                                              Icons.delete,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                        ReorderableDragStartListener(
                                                          key: ValueKey(index),
                                                          index: index,
                                                          child: const Icon(
                                                            YaruIcons
                                                                .drag_handle,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  : null,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
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
