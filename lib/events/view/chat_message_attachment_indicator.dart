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
    final isEventDownload = watchPropertyValue(
      (ChatDownloadManager m) => m.isEventDownloaded(event),
    );

    // TODO: open with native file manager
    return isEventDownload != null
        ? Tooltip(
            message: isEventDownload,
            child: Icon(
              YaruIcons.download_filled,
              color: context.colorScheme.primary,
            ),
          )
        : Icon(YaruIcons.download, color: color);
  }
}
