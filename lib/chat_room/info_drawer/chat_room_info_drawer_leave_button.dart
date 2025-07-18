import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../common/chat_model.dart';
import '../../common/view/build_context_x.dart';
import '../../common/view/confirm.dart';
import '../../common/view/snackbars.dart';
import '../../common/view/ui_constants.dart';
import '../../l10n/l10n.dart';

class ChatRoomInfoDrawerForgetButton extends StatelessWidget {
  const ChatRoomInfoDrawerForgetButton({super.key, required this.room});

  final Room room;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = context.theme;
    return Container(
      padding: const EdgeInsets.only(
        left: kBigPadding,
        right: kBigPadding,
        top: kBigPadding,
      ),
      width: double.infinity,
      child: OutlinedButton.icon(
        label: Text('${l10n.delete} '),
        style: room.isArchived
            ? OutlinedButton.styleFrom(
                foregroundColor: theme.colorScheme.error,
                backgroundColor: room.isArchived
                    ? theme.colorScheme.error.withValues(alpha: 0.03)
                    : null,
              )
            : null,
        onPressed: () => showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => ConfirmationDialog(
            showCloseIcon: false,
            onConfirm: () async => di<ChatModel>().leaveRoom(
              room: room,
              onFail: (error) => showSnackBar(context, content: Text(error)),
              forget: true,
            ),
            title: Text(l10n.delete),
            content: Text(
              room.getLocalizedDisplayname(),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        icon: Icon(
          YaruIcons.trash,
          color: room.isArchived ? theme.colorScheme.error : null,
        ),
      ),
    );
  }
}
