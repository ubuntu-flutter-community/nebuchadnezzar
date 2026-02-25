import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:yaru/yaru.dart';

import '../../common/view/build_context_x.dart';
import '../../l10n/l10n.dart';
import '../chat_download_manager.dart';

class ChatMessageExportIndicator extends StatelessWidget with WatchItMixin {
  const ChatMessageExportIndicator({
    super.key,
    required this.event,
    this.color,
  });

  final Event event;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final path = watchValue(
      (ChatDownloadManager m) =>
          m.getExportFileCommand(event).results.select((data) => data.data),
    );

    // TODO: open with native file manager
    return Tooltip(
      message: path != null
          ? context.l10n.fileExported(path)
          : context.l10n.exportFileAs,
      child: Icon(
        path != null ? YaruIcons.save_as_filled : YaruIcons.save_as,
        color: path != null ? context.colorScheme.primary : null,
      ),
    );
  }
}

class ChatMessageDownloadIndicator extends StatelessWidget with WatchItMixin {
  const ChatMessageDownloadIndicator({
    super.key,
    required this.event,
    this.color,
  });

  final Event event;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final downloadCommand = watchValue(
      (ChatDownloadManager m) => m.getDownloadCommand(event),
    );

    final path = downloadCommand?.file?.path;

    return path != null
        ? Tooltip(
            message: path,
            child: Icon(
              YaruIcons.download_filled,
              color: context.colorScheme.primary,
            ),
          )
        : Icon(YaruIcons.download, color: color);
  }
}
