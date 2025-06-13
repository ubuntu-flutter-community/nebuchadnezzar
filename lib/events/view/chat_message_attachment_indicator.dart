import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../common/view/build_context_x.dart';
import '../chat_download_model.dart';

class ChatMessageAttachmentIndicator extends StatelessWidget with WatchItMixin {
  const ChatMessageAttachmentIndicator({
    super.key,
    required this.event,
    this.iconSize = 15.0,
    this.color,
  });

  final Event event;
  final double iconSize;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final isEventDownload = watchPropertyValue(
      (ChatDownloadModel m) => m.isEventDownloaded(event),
    );

    // TODO: open with native file manager
    return isEventDownload != null
        ? Tooltip(
            message: isEventDownload,
            child: Icon(
              YaruIcons.download_filled,
              color: context.colorScheme.primary,
              size: iconSize,
            ),
          )
        : Icon(YaruIcons.download, size: iconSize, color: color);
  }
}
