import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../common/view/build_context_x.dart';
import '../../common/view/theme.dart';
import '../../common/view/ui_constants.dart';
import '../../extensions/media_x.dart';
import '../../l10n/l10n.dart';
import '../player_manager.dart';

class PlayerQueue extends StatefulWidget with WatchItStatefulWidgetMixin {
  const PlayerQueue({super.key});

  @override
  State<PlayerQueue> createState() => _PlayerQueueState();
}

class _PlayerQueueState extends State<PlayerQueue> {
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

    final iconColor = getPlayerIconColor(context.theme);
    return Padding(
      padding: const EdgeInsets.all(kBigPadding),
      child: Column(
        spacing: kBigPadding,
        children: playlist?.medias == null || playlist!.medias.isEmpty
            ? []
            : [
                Text(
                  'Queue: ${playlist.medias.length} items',
                  style: TextStyle(color: iconColor),
                ),
                Expanded(
                  child: ListTileTheme(
                    textColor: iconColor,
                    iconColor: iconColor,
                    selectedColor: iconColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: ReorderableListView.builder(
                      buildDefaultDragHandles: false,
                      proxyDecorator: (child, index, animation) => Material(
                        color: iconColor.withAlpha(30),
                        borderRadius: BorderRadius.circular(6),
                        child: child,
                      ),
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
                          key: ValueKey(media.uri + index.toString()),
                          padding: const EdgeInsets.only(bottom: kSmallPadding),
                          child: ListTile(
                            onTap: () => di<PlayerManager>().jump(index),
                            leading: Text('${index + 1}'),
                            title: Text(media.title),
                            subtitle: Text(
                              media.isLocal
                                  ? media.artist
                                  : media.getRemoteTags(5) ??
                                        context.l10n.radioStation,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            selected: playlistIndex == index,
                            trailing: playlist.medias.length > 1
                                ? Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: kSmallPadding,
                                        ),
                                        child: IconButton(
                                          onPressed: () => di<PlayerManager>()
                                              .removeFromPlaylist(index),
                                          icon: Icon(
                                            Icons.delete,
                                            color: iconColor,
                                          ),
                                        ),
                                      ),
                                      ReorderableDragStartListener(
                                        key: ValueKey(index),
                                        index: index,
                                        child: Icon(
                                          YaruIcons.drag_handle,
                                          color: iconColor,
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
    );
  }
}
