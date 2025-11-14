import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';

import '../../../common/view/ui_constants.dart';
import '../draft_manager.dart';
import 'chat_pending_attachment.dart';

class ChatAttachmentDraftPanel extends StatelessWidget with WatchItMixin {
  const ChatAttachmentDraftPanel({super.key, required this.roomId});

  final String roomId;

  @override
  Widget build(BuildContext context) {
    final draftFiles = watchPropertyValue(
      (DraftManager m) => m.getFilesDraft(roomId),
    );

    final attaching = watchPropertyValue((DraftManager m) => m.attaching);

    final draftFilesL = watchPropertyValue(
      (DraftManager m) => m.getFilesDraft(roomId).length,
    );

    if (!attaching && draftFilesL == 0) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kSmallPadding),
      child: SizedBox(
        height: ChatPendingAttachment.dimension,
        child: Align(
          alignment: Alignment.centerLeft,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: ChatPendingAttachment.dimension,
              mainAxisExtent: ChatPendingAttachment.dimension,
            ),
            reverse: true,
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: kSmallPadding),
            scrollDirection: Axis.horizontal,
            itemCount: draftFilesL,
            itemBuilder: (context, index) {
              final file = draftFiles.elementAt(index);
              return AnimatedContainer(
                duration: const Duration(seconds: 1),
                child: ChatPendingAttachment(
                  roomId: roomId,
                  onToggleCompress: () => di<DraftManager>().toggleCompress(
                    roomId: roomId,
                    file: file,
                  ),
                  onTap: () => di<DraftManager>().removeFileFromDraft(
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
    );
  }
}
