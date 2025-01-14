import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';

import '../../../../common/view/confirm.dart';
import '../../../../common/view/snackbars.dart';
import '../../../common/chat_model.dart';

class ChatInvitationDialog extends StatelessWidget with WatchItMixin {
  const ChatInvitationDialog({super.key, required this.room});

  final Room room;

  @override
  Widget build(BuildContext context) => ConfirmationDialog(
        title: Text(room.getLocalizedDisplayname()),
        onCancel: () => room.leave(),
        onConfirm: () => di<ChatModel>().joinRoom(
          room,
          onFail: (error) => showSnackBar(
            context,
            content: Text(
              error,
            ),
          ),
        ),
      );
}
