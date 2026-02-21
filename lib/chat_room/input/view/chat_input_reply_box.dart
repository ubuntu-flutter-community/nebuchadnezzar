import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:matrix/matrix.dart';
import 'package:yaru/yaru.dart';
import '../../../common/view/ui_constants.dart';
import '../../../l10n/l10n.dart';
import '../draft_manager.dart';

class ChatInputReplyBox extends StatefulWidget with WatchItStatefulWidgetMixin {
  const ChatInputReplyBox({super.key, required this.room});

  final Room room;

  @override
  State<ChatInputReplyBox> createState() => _ChatInputReplyBoxState();
}

class _ChatInputReplyBoxState extends State<ChatInputReplyBox> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final editEvent = watchPropertyValue(
      (DraftManager m) => m.getEditEvent(widget.room.id),
    );

    final replyEvent = watchPropertyValue((DraftManager m) => m.replyEvent);
    final threadRootEventId = watchPropertyValue(
      (DraftManager m) => m.threadRootEventId,
    );

    if (!(replyEvent != null || editEvent != null)) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(
        left: kMediumPadding,
        right: kMediumPadding,
        top: kMediumPadding,
      ),
      child: YaruInfoBox(
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: kMediumPadding,
          children: [
            IconButton(
              onPressed: () => di<DraftManager>()
                ..setReplyEvent(null)
                ..resetThreadIds()
                ..setEditEvent(roomId: widget.room.id, event: null)
                ..setTextDraft(roomId: widget.room.id, draft: '', notify: true),
              icon: const Icon(YaruIcons.trash),
            ),

            YaruCheckbox(
              onChanged: replyEvent == null
                  ? null
                  : (v) {
                      di<DraftManager>().setThreadRootEventId(
                        v == false ? null : replyEvent.eventId,
                      );
                    },
              value: threadRootEventId != null,
            ),
            const Text('Create Thread'),
          ],
        ),
        yaruInfoType: editEvent != null
            ? YaruInfoType.warning
            : YaruInfoType.information,
        icon: Icon(editEvent != null ? YaruIcons.pen : YaruIcons.reply),
        subtitle: Text(
          (editEvent ?? replyEvent)!.plaintextBody,
          overflow: TextOverflow.ellipsis,
          maxLines: 3,
        ),
        title: Text(
          '${l10n.reply} (${(editEvent ?? replyEvent)!.senderFromMemoryOrFallback.displayName}):',
        ),
      ),
    );
  }
}
