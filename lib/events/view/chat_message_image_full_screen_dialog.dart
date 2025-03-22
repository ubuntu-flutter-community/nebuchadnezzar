import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../common/date_time_x.dart';
import '../../common/view/build_context_x.dart';
import '../../common/view/ui_constants.dart';
import '../../l10n/l10n.dart';
import '../chat_download_model.dart';
import 'chat_image.dart';

class ChatMessageImageFullScreenDialog extends StatelessWidget {
  const ChatMessageImageFullScreenDialog({super.key, required this.event});

  final Event event;

  @override
  Widget build(BuildContext context) => AlertDialog(
        scrollable: true,
        titlePadding: EdgeInsets.zero,
        title: YaruDialogTitleBar(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: kSmallPadding,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 100),
                child: Text(
                  '${event.senderFromMemoryOrFallback.calcDisplayname()}, ',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                event.originServerTs.toLocal().formatAndLocalize(context.l10n),
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
              ),
              const AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
              ),
            ],
          ),
          border: BorderSide.none,
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(
              tooltip: context.l10n.downloadFile,
              onPressed: () => di<ChatDownloadModel>().safeFile(event),
              icon: const Icon(YaruIcons.download),
            ),
          ],
        ),
        content: Builder(
          builder: (context) {
            return SizedBox(
              width: context.mediaQuerySize.width,
              height: context.mediaQuerySize.height - 150,
              child: ChatImageFuture(
                width: context.mediaQuerySize.width,
                height: context.mediaQuerySize.height - 150,
                fit: BoxFit.contain,
                event: event,
                getThumbnail: false,
              ),
            );
          },
        ),
      );
}
