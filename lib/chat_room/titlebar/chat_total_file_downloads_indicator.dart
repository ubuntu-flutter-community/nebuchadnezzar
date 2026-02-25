import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:yaru/yaru.dart';

import '../../common/view/build_context_x.dart';
import '../../common/view/common_widgets.dart';
import '../../common/view/ui_constants.dart';
import '../../events/chat_download_manager.dart';
import '../../events/view/chat_message_media_avatar.dart';
import '../../extensions/event_x.dart';
import '../../l10n/l10n.dart';
import '../../player/data/local_media.dart';
import '../../player/player_manager.dart';

class ChatTotalFileDownloadsIndicator extends StatelessWidget
    with WatchItMixin {
  const ChatTotalFileDownloadsIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final activeDownloads = watchValue(
      (ChatDownloadManager m) => m.activeDownloads,
    );

    final recentDownloads = watchValue(
      (ChatDownloadManager m) => m.recentDownloads,
    );

    const nothing = SizedBox.shrink();

    final recentDownloadsButton = IconButton(
      onPressed: () => showDialog(
        context: context,
        builder: (context) => const ChatDownloadsDialog(),
      ),
      icon: Icon(
        YaruIcons.download_history_filled,
        color: context.colorScheme.primary,
      ),
    );

    if (activeDownloads.isNotEmpty) {
      return SizedBox(
        width: 16,
        height: 16,
        child: Progress(
          strokeWidth: 2,
          value:
              // if there are active downloads
              // calculate the progress as the ratio of completed downloads to total downloads
              (recentDownloads.length) /
              (activeDownloads.length + recentDownloads.length),
        ),
      );
    } else if (recentDownloads.isNotEmpty) {
      return recentDownloadsButton;
    } else {
      return nothing;
    }
  }
}

class ChatDownloadsDialog extends StatelessWidget with WatchItMixin {
  const ChatDownloadsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final activeDownloads = watchValue(
      (ChatDownloadManager m) => m.activeDownloads,
    );
    final downloads = watchValue((ChatDownloadManager m) => m.recentDownloads);

    final currentMedia = watchStream(
      (PlayerManager p) => p.currentMediaStream,
      initialValue: di<PlayerManager>().currentMedia,
      preserveState: false,
      allowStreamChange: true,
    ).data;

    return SimpleDialog(
      titlePadding: EdgeInsets.zero,
      constraints: const BoxConstraints(maxWidth: 500),
      title: YaruDialogTitleBar(
        border: BorderSide.none,
        backgroundColor: Colors.transparent,
        title: const Text('Downloads'),
        leading: (downloads.isNotEmpty)
            ? Center(
                child: IconButton(
                  tooltip: context.l10n.playMedia,
                  onPressed: () {
                    Navigator.of(context).pop();
                    di<PlayerManager>().setPlaylist(
                      downloads.entries
                          .where(
                            (c) =>
                                c.value.file != null &&
                                (c.value.event.isAudio ||
                                    c.value.event.isVideo),
                          )
                          .map((c) => LocalMedia(c.value.file!.path))
                          .toList(),
                    );
                  },
                  icon: const Icon(YaruIcons.playlist_play),
                ),
              )
            : null,
      ),
      children: [
        if (activeDownloads.isEmpty && downloads.isEmpty)
          Padding(
            padding: const EdgeInsets.all(kMediumPadding),
            child: Text(context.l10n.downloadFile),
          )
        else
          ...downloads.entries.map((entry) {
            final capsule = entry.value;
            return ListTile(
              shape: const RoundedRectangleBorder(),
              selectedColor: context.colorScheme.primary,
              selected: currentMedia?.uri == capsule.file?.path,
              leading: ChatMessageMediaAvatar(event: capsule.event),
              title: YaruExpandable(
                header: Text(capsule.event.fileName ?? ''),
                child: Text(capsule.file?.path ?? ''),
              ),
            );
          }),
      ],
    );
  }
}
