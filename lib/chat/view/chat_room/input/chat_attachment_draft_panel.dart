import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../../../../common/view/ui_constants.dart';
import '../../../draft_model.dart';
import 'chat_pending_attachment.dart';

class ChatAttachmentDraftPanel extends StatelessWidget with WatchItMixin {
  const ChatAttachmentDraftPanel({super.key, required this.roomId});

  final String roomId;

  @override
  Widget build(BuildContext context) {
    final draftFiles =
        watchPropertyValue((DraftModel m) => m.getFilesDraft(roomId));

    final attaching = watchPropertyValue((DraftModel m) => m.attaching);

    final draftFilesL = watchPropertyValue(
      (DraftModel m) => m.getFilesDraft(roomId).length,
    );
    final sending = watchPropertyValue((DraftModel m) => m.sending);

    if (!attaching && draftFilesL == 0) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kSmallPadding),
      child: SizedBox(
        height: ChatPendingAttachment.dimension,
        child: Opacity(
          opacity: sending ? 0.5 : 1,
          child: Align(
            alignment: Alignment.centerLeft,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: ChatPendingAttachment.dimension,
                mainAxisExtent: ChatPendingAttachment.dimension,
              ),
              reverse: true,
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(
                horizontal: kSmallPadding,
              ),
              scrollDirection: Axis.horizontal,
              itemCount: draftFilesL,
              itemBuilder: (context, index) {
                final file = draftFiles.elementAt(index);
                return AnimatedContainer(
                  duration: const Duration(seconds: 1),
                  child: ChatPendingAttachment(
                    onTap: sending
                        ? null
                        : () => di<DraftModel>().removeFileFromDraft(
                              roomId: roomId,
                              file: file,
                            ),
                    file: file,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
