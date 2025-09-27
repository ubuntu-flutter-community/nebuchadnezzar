import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../common/view/build_context_x.dart';
import '../../common/view/confirm.dart';
import '../../common/view/theme.dart';
import '../../common/view/ui_constants.dart';
import '../../l10n/l10n.dart';
import '../chat_download_manager.dart';

class ChatMessageMediaAvatar extends StatelessWidget {
  const ChatMessageMediaAvatar({super.key, required this.event});

  final Event event;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Material(
      borderRadius: BorderRadius.circular(38 / 2),
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(38 / 2),
        onTap: event.messageType == MessageTypes.Notice
            ? null
            : () => showDialog(
                context: context,
                builder: (context) => ConfirmationDialog(
                  title: switch (event.messageType) {
                    MessageTypes.File ||
                    MessageTypes.Audio ||
                    MessageTypes.Video => Text(context.l10n.saveFile),
                    _ => const Text(''),
                  },
                  onConfirm: switch (event.messageType) {
                    MessageTypes.File ||
                    MessageTypes.Audio ||
                    MessageTypes.Video =>
                      () => di<ChatDownloadManager>().safeFile(
                        event: event,
                        dialogTitle: l10n.saveFile,
                        confirmButtonText: l10n.saveFile,
                      ),
                    _ => () async {},
                  },
                ),
              ),
        child: CircleAvatar(
          backgroundColor: avatarFallbackColor(context.colorScheme),
          radius: kAvatarDefaultSize / 2,
          child: switch (event.messageType) {
            MessageTypes.Audio => const Icon(YaruIcons.media_play),
            MessageTypes.Video => const Icon(YaruIcons.video_filled),
            MessageTypes.File => const Icon(YaruIcons.document_filled),
            _ => const Icon(YaruIcons.document_filled),
          },
        ),
      ),
    );
  }
}
