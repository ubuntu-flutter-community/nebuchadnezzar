import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:matrix/matrix.dart';
import 'package:yaru/yaru.dart';

import '../../common/view/build_context_x.dart';
import '../../l10n/l10n.dart';
import '../chat_download_manager.dart';

class ChatMessageExportButton extends StatelessWidget with WatchItMixin {
  const ChatMessageExportButton({super.key, required this.event, this.color});

  final Event event;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final path = watchValue(
      (ChatDownloadManager m) =>
          m.getExportFileCommand(event).results.select((data) => data.data),
    );

    return IconButton(
      tooltip: path ?? context.l10n.exportFileAs,
      onPressed: () {
        if (path == null) {
          di<ChatDownloadManager>().getExportFileCommand(event).run((
            confirmButtonText: context.l10n.saveFile,
            dialogTitle: context.l10n.saveFile,
          ));
        } else {
          di<ChatDownloadManager>().openParentDirectoryCommand.run((
            path: path,
            fileDoesNotExistMessage: context.l10n.directoryDoesNotExist,
          ));
        }
      },
      icon: Icon(
        path != null ? YaruIcons.save_as_filled : YaruIcons.save_as,
        color: path != null ? context.colorScheme.primary : null,
      ),
    );
  }
}
