import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:yaru/yaru.dart';

import '../../common/view/build_context_x.dart';
import '../chat_download_manager.dart';

class ChatMessageAttachmentIndicator extends StatelessWidget with WatchItMixin {
  const ChatMessageAttachmentIndicator({
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
          m.getSaveFileCommand(event).results.select((data) => data.data),
    );

    // TODO: open with native file manager
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
