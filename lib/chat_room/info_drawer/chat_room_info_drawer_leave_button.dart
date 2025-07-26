import 'package:flutter/material.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../common/chat_model.dart';
import '../../common/view/build_context_x.dart';
import '../../common/view/confirm.dart';
import '../../common/view/theme.dart';
import '../../common/view/ui_constants.dart';
import '../../l10n/l10n.dart';
import '../create_or_edit/create_or_edit_room_model.dart';

class ChatRoomInfoDrawerLeaveButton extends StatelessWidget {
  const ChatRoomInfoDrawerLeaveButton({super.key, required this.room});

  final Room room;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      padding: const EdgeInsets.all(kBigPadding),
      width: double.infinity,
      child: OutlinedButton.icon(
        label: Text(l10n.leave),
        onPressed: () => ConfirmationDialog.show(
          context: context,
          title: Text('${l10n.leave} ${room.getLocalizedDisplayname()}'),
          onConfirm: () =>
              showFutureLoadingDialog(
                context: context,
                future: () => di<CreateOrEditRoomModel>().leaveRoom(
                  room: room,
                  forget: false,
                ),
              ).then((_) {
                di<ChatModel>().setSelectedRoom(null);
                if (context.mounted && Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                }
              }),
        ),
        icon: room.isArchived
            ? const Icon(YaruIcons.log_in)
            : Icon(
                YaruIcons.log_out,
                color: yaru
                    ? context.colorScheme.error
                    : context.colorScheme.primary,
              ),
      ),
    );
  }
}
