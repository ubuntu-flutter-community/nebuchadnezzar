import 'package:flutter/material.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';

import '../../../common/chat_manager.dart';
import '../../../common/view/confirm.dart';
import '../../../l10n/l10n.dart';
import '../../create_or_edit/edit_room_service.dart';

class ChatInvitationDialog extends StatelessWidget with WatchItMixin {
  const ChatInvitationDialog({super.key, required this.room});

  final Room room;

  @override
  Widget build(BuildContext context) => ConfirmationDialog(
    title: Text('${context.l10n.invite}: ${room.getLocalizedDisplayname()}'),
    cancelLabel: context.l10n.reject,
    onCancel: () async =>
        showFutureLoadingDialog(
          context: context,
          future: () => di<EditRoomService>().leaveRoom(room),
        ).then((_) {
          if (context.mounted) {
            di<ChatManager>().setSelectedRoom(null);
          }
        }),
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
