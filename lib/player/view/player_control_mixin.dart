import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:matrix/matrix.dart';

import '../../common/view/confirm.dart';
import '../../events/chat_download_manager.dart';
import '../../l10n/l10n.dart';
import '../data/local_media.dart';
import '../player_manager.dart';
import 'player_full_view.dart';

mixin PlayerControlMixin {
  Future<void> togglePlayerFullMode(BuildContext context) async {
    if (di<PlayerManager>().playerViewState.value.fullMode) {
      di<PlayerManager>().updateState(fullMode: false);
      await Navigator.of(context).maybePop();
    } else {
      di<PlayerManager>().updateState(fullMode: true);
      await showDialog(
        context: context,
        builder: (context) => const PlayerFullView(),
      );
    }
  }

  Future<void> playAudioRecording(String path) async {
    final media = LocalMedia(path);
    await di<PlayerManager>().setPlaylist([media]);
  }

  Future<void> playMatrixMedia(
    BuildContext context, {
    required Event event,
    bool newPlaylist = true,
  }) async {
    final result = await di<ChatDownloadManager>().globalDownloadCommand
        .runAsync(event);

    final file = result?.file;

    if (file != null) {
      final media = LocalMedia(file.path);

      if (newPlaylist) {
        await di<PlayerManager>().setPlaylist([media]);
      } else if (!di<PlayerManager>().medias.contains(media)) {
        await di<PlayerManager>().addToPlaylist(media);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                context.l10n.appendedToQueue(
                  media.artist == null
                      ? media.title
                      : '${media.artist} - ${media.title}',
                ),
              ),
            ),
          );
        }
      } else {
        if (context.mounted) {
          await ConfirmationDialog.show(
            context: context,
            title: Text(context.l10n.appendMediaToQueueTitle),
            content: Text(
              context.l10n.appendMediaToQueueDescription(
                media.artist == null
                    ? media.title
                    : '${media.artist} - ${media.title}',
              ),
            ),
            onConfirm: () async {
              await di<PlayerManager>().addToPlaylist(media);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      context.l10n.appendedToQueue(
                        media.artist == null
                            ? media.title
                            : '${media.artist} - ${media.title}',
                      ),
                    ),
                  ),
                );
              }
            },
          );
        }
      }
    }
  }
}
