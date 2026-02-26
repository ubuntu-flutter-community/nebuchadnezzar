import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:matrix/matrix.dart';
import 'package:yaru/yaru.dart';

import '../../common/view/build_context_x.dart';
import '../../l10n/l10n.dart';
import '../chat_download_manager.dart';

class ChatMessageDownloadButton extends StatelessWidget with WatchItMixin {
  const ChatMessageDownloadButton({super.key, required this.event});

  final Event event;

  @override
  Widget build(BuildContext context) {
    callOnceAfterThisBuild((_) {
      di<ChatDownloadManager>().getDownloadCommand(event).run(false);
    });

    final downloadCommand = watchValue(
      (ChatDownloadManager m) => m.getDownloadCommand(event),
    );

    watchValue((ChatDownloadManager m) => m.getDownloadCommand(event).progress);

    final path = downloadCommand?.file?.path;

    return IconButton(
      tooltip: path ?? context.l10n.downloadFile,
      onPressed: () {
        if (path == null) {
          di<ChatDownloadManager>().getDownloadCommand(event).run(true);
        } else {
          di<ChatDownloadManager>().openParentDirectoryCommand.run((
            path: path,
            fileDoesNotExistMessage: context.l10n.directoryDoesNotExist,
          ));
        }
      },
      icon: path != null
          ? Icon(YaruIcons.download_filled, color: context.colorScheme.primary)
          : const Icon(YaruIcons.download),
    );
  }
}
