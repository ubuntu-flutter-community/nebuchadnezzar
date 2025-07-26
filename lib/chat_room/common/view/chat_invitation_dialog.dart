import 'package:flutter/material.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';

import '../../../common/chat_model.dart';
import '../../../common/view/confirm.dart';
import '../../create_or_edit/create_or_edit_room_model.dart';

class ChatInvitationDialog extends StatelessWidget with WatchItMixin {
  const ChatInvitationDialog({super.key, required this.room});

  final Room room;

  @override
  Widget build(BuildContext context) => ConfirmationDialog(
    title: Text(room.getLocalizedDisplayname()),
    onCancel: () =>
        showFutureLoadingDialog(
          context: context,
          future: () =>
              di<CreateOrEditRoomModel>().leaveRoom(room: room, forget: false),
        ).then((_) {
          if (context.mounted) {
            di<ChatModel>().setSelectedRoom(null);
          }
        }),
    onConfirm: () =>
        showFutureLoadingDialog(
          context: context,
          future: () => di<CreateOrEditRoomModel>().joinRoom(room),
        ).then((result) {
          if (result.asValue?.value != null) {
            di<ChatModel>().setSelectedRoom(result.asValue!.value);
          }
        }),
  );
}
