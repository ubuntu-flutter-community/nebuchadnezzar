import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:yaru/yaru.dart';

import '../../common/view/build_context_x.dart';
import '../../common/view/confirm.dart';
import '../../common/view/theme.dart';
import '../../common/view/ui_constants.dart';
import '../../extensions/event_x.dart';
import '../../l10n/l10n.dart';
import '../../player/data/local_media.dart';
import '../../player/player_manager.dart';
import '../../player/view/player_control_mixin.dart';
import '../chat_download_manager.dart';

class ChatMessageMediaAvatar extends StatelessWidget
    with PlayerControlMixin, WatchItMixin {
  const ChatMessageMediaAvatar({super.key, required this.event});

  final Event event;

  @override
  Widget build(BuildContext context) {
    final isDownloading = watchValue(
      (ChatDownloadManager m) => m.getDownloadCommand(event).isRunning,
    );

    final progress = watchValue(
      (ChatDownloadManager m) => m.getDownloadCommand(event).progress,
    );

    final media = watchStream(
      (PlayerManager p) => p.currentMediaStream,
      initialValue: di<PlayerManager>().currentMedia,
      preserveState: false,
      allowStreamChange: true,
    ).data;

    final isAudioSelected = event.fileName?.toLowerCase() == null
        ? false
        : media is LocalMedia &&
              media.uri.toLowerCase().contains(event.fileName!.toLowerCase());

    final isPlayerPlaying =
        watchStream(
          (PlayerManager p) => p.isPlayingStream,
          initialValue: di<PlayerManager>().isPlaying,
          preserveState: true,
        ).data ??
        false;

    final l10n = context.l10n;
    return Material(
      borderRadius: BorderRadius.circular(38 / 2),
      color: Colors.transparent,
      child: isDownloading
          ? SizedBox.square(
              dimension: kAvatarDefaultSize,
              child: Center(
                child: SizedBox.square(
                  dimension: kAvatarDefaultSize / 2,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    value: progress,
                  ),
                ),
              ),
            )
          : InkWell(
              borderRadius: BorderRadius.circular(38 / 2),
              onTap: isDownloading || event.messageType == MessageTypes.Notice
                  ? null
                  : switch (event.messageType) {
                      MessageTypes.Notice => null,
                      MessageTypes.Audio || MessageTypes.Video =>
                        event.attachmentMxcUrl == null
                            ? null
                            : () => !isAudioSelected
                                  ? playMatrixMedia(context, event: event)
                                  : di<PlayerManager>().playOrPause(),
                      _ => () => showDialog(
                        context: context,
                        builder: (context) => ConfirmationDialog(
                          title: switch (event.messageType) {
                            MessageTypes.File ||
                            MessageTypes.Video => Text(context.l10n.saveFile),
                            _ => const Text(''),
                          },
                          onConfirm: () => di<ChatDownloadManager>()
                              .getExportFileCommand(event)
                              .run((
                                confirmButtonText: l10n.saveFile,
                                dialogTitle: l10n.saveFile,
                              )),
                        ),
                      ),
                    },
              child: Tooltip(
                message: switch (event.messageType) {
                  MessageTypes.Audio => l10n.playMedia,
                  MessageTypes.Video => l10n.playMedia,
                  MessageTypes.File => l10n.saveFile,
                  _ => '',
                },
                child: CircleAvatar(
                  backgroundColor: avatarFallbackColor(context.colorScheme),
                  radius: kAvatarDefaultSize / 2,
                  child: switch (event.messageType) {
                    MessageTypes.Audio =>
                      isAudioSelected && isPlayerPlaying
                          ? const Icon(YaruIcons.media_pause)
                          : const Icon(YaruIcons.media_play),
                    MessageTypes.Video => const Icon(YaruIcons.video_filled),
                    MessageTypes.File => const Icon(YaruIcons.document_filled),
                    _ => const Icon(YaruIcons.document_filled),
                  },
                ),
              ),
            ),
    );
  }
}
