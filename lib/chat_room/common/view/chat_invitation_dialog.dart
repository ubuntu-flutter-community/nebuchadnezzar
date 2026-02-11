import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:matrix/matrix.dart';

import '../../../common/chat_manager.dart';
import '../../../common/view/confirm.dart';
import '../../../l10n/l10n.dart';
import '../../create_or_edit/edit_room_manager.dart';
import '../../create_or_edit/edit_room_service.dart';

class ChatInvitationDialog extends StatelessWidget with WatchItMixin {
  const ChatInvitationDialog({super.key, required this.room});

  final Room room;

  @override
  Widget build(BuildContext context) => ConfirmationDialog(
    title: Text('${context.l10n.invite}: ${room.getLocalizedDisplayname()}'),
    cancelLabel: context.l10n.reject,
    onCancel: () {
      di<ChatManager>().setSelectedRoom(null);
      di<EditRoomManager>().getLeaveRoomCommand(room).run();
    },
    confirmLabel: context.l10n.accept,
    onConfirm: () =>
        showFutureLoadingDialog(
          context: context,
          future: () => di<EditRoomService>().joinRoom(room),
        ).then((result) {
          if (result.asValue?.value != null) {
            di<ChatManager>().setSelectedRoom(result.asValue!.value);
          }
        }),
  );
}
