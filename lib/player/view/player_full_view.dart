import 'package:flutter/material.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:path/path.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../common/view/build_context_x.dart';
import '../../common/view/ui_constants.dart';
import '../player_manager.dart';
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

    return Dialog.fullscreen(
      child: playlist == null || playlist.medias.isEmpty
          ? Text('No media in queue', style: context.theme.textTheme.bodyMedium)
          : SizedBox(
              height: 500,
              width: 500,
              child: Column(
                children: [
                  YaruDialogTitleBar(
                    title: Text('Queue: ${playlist.medias.length} items'),
                    backgroundColor: context.theme.dialogTheme.backgroundColor,
                    border: BorderSide.none,
                    isClosable: false,
                    actions: [
                      Padding(
                        padding: const EdgeInsets.all(kSmallPadding),
                        child: IconButton(
                          icon: const Icon(YaruIcons.pan_down),
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
                          ),
                        Expanded(
                          child: Padding(
                            padding: isVideo
                                ? EdgeInsets.zero
                                : const EdgeInsets.all(kMediumPadding),
                            child: ReorderableListView.builder(
                              onReorder: (oldIndex, newIndex) {
                                if (newIndex > oldIndex) {
                                  newIndex -= 1;
                                }
                                di<PlayerManager>().move(oldIndex, newIndex);
                              },
                              scrollController: _scrollController,
                              itemCount: playlist.medias.length,
                              itemBuilder: (context, index) {
                                final media = playlist.medias[index];
                                return Padding(
                                  key: ValueKey(media.uri),
                                  padding: isVideo
                                      ? EdgeInsets.zero
                                      : const EdgeInsets.only(
                                          bottom: kSmallPadding,
                                        ),
                                  child: ListTile(
                                    shape: isVideo
                                        ? const RoundedRectangleBorder()
                                        : null,
                                    onTap: () =>
                                        di<PlayerManager>().jump(index),
                                    leading: Text('${index + 1}'),
                                    title: Text(basename(media.uri.toString())),
                                    selected: playlistIndex == index,
                                    selectedColor:
                                        context.theme.colorScheme.primary,
                                    trailing: playlist.medias.length > 1
                                        ? Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: kSmallPadding,
                                            ),
                                            child: IconButton(
                                              onPressed: () =>
                                                  di<PlayerManager>()
                                                      .removeFromPlaylist(
                                                        index,
                                                      ),
                                              icon: const Icon(Icons.delete),
                                            ),
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

                  if (!isVideo) const PlayerView(),
                ],
              ),
            ),
    );
  }
}
