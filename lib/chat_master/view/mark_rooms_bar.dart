import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';

import '../../chat_room/create_or_edit/edit_room_manager.dart';
import '../../common/chat_manager.dart';
import '../../common/view/confirm.dart';
import '../../common/view/ui_constants.dart';
import '../../l10n/l10n.dart';

class MarkRoomsBar extends StatelessWidget with WatchItMixin {
  const MarkRoomsBar({super.key});

  @override
  Widget build(BuildContext context) {
    final archiveActive = watchPropertyValue(
      (ChatManager m) => m.archiveActive,
    );
    final markedRooms = watchValue((EditRoomManager m) => m.markedRooms);
    var cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: kMediumPadding,
        vertical: kSmallPadding,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: TextButton(
              style: TextButton.styleFrom(foregroundColor: cs.onSurface),
              onPressed: () =>
                  di<EditRoomManager>().toggleOrSetShowMarkRooms(show: false),
              child: Text(context.l10n.cancel),
            ),
          ),
          Expanded(
            child: TextButton(
              style: archiveActive
                  ? TextButton.styleFrom(foregroundColor: cs.error)
                  : null,
              onPressed: markedRooms.isEmpty
                  ? null
                  : () {
                      final editRoomManager = di<EditRoomManager>();
                      final chatManager = di<ChatManager>();
                      ConfirmationDialog.show(
                        context: context,
                        isDestructive: archiveActive,
                        title: Text(
                          chatManager.archiveActive
                              ? context.l10n.forgetSelectedXRooms(
                                  markedRooms.length,
                                )
                              : context.l10n.leaveSelectedXRooms(
                                  markedRooms.length,
                                ),
                        ),
                        onConfirm: () {
                          chatManager.setSelectedRoom(null);
                          editRoomManager.globalLeaveOrForgetRoomsCommand.run((
                            rooms: markedRooms.toList(),
                            action: chatManager.archiveActive
                                ? LeaveOrForget.forget
                                : LeaveOrForget.leave,
                          ));
                        },
                      );
                    },

              child: Text(
                archiveActive
                    ? context.l10n.forgetXRooms(markedRooms.length)
                    : context.l10n.leaveXRooms(markedRooms.length),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
