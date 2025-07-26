import 'package:flutter/material.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../common/chat_model.dart';
import '../../common/view/build_context_x.dart';
import '../../common/view/confirm.dart';
import '../../common/view/snackbars.dart';
import '../../common/view/theme.dart';
import '../../common/view/ui_constants.dart';
import '../../l10n/l10n.dart';

class ChatRoomJoinOrLeaveButton extends StatelessWidget {
  const ChatRoomJoinOrLeaveButton({super.key, required this.room});

  final Room room;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final chatModel = di<ChatModel>();

    final joinedRoom = room.membership == Membership.join;

    final roomName = room.getLocalizedDisplayname();

    final notReJoinable = room.isAbandonedDMRoom;

    final message = joinedRoom
        ? '${l10n.leave} $roomName'
        : notReJoinable
        ? roomName
        : '${l10n.joinRoom} $roomName';

    return Container(
      padding: const EdgeInsets.all(kBigPadding),
      width: double.infinity,
      child: OutlinedButton.icon(
        label: Text(room.isArchived ? l10n.joinRoom : l10n.leave),
        style: !room.isArchived
            ? OutlinedButton.styleFrom(
                foregroundColor: yaru
                    ? context.colorScheme.error
                    : context.colorScheme.primary,
              )
            : null,
        onPressed: () => ConfirmationDialog.show(
          context: context,
          title: Text(message),
          onConfirm: () async {
            if (joinedRoom) {
              await showFutureLoadingDialog(
                context: context,
                onError: (error) {
                  showErrorSnackBar(context, error.toString());
                  return error.toString();
                },
                future: () => chatModel.leaveRoom(room: room, forget: false),
              ).then((_) {
                di<ChatModel>().setSelectedRoom(null);
              });
            } else {
              await showFutureLoadingDialog(
                context: context,
                onError: (error) {
                  showErrorSnackBar(context, error.toString());
                  return error.toString();
                },
                future: () => chatModel.joinRoom(room),
              ).then((result) {
                if (result.asValue?.value != null) {
                  di<ChatModel>().setSelectedRoom(result.asValue!.value);
                }
              });
            }

            if (context.mounted) {
              Navigator.of(context).pop();
            }
          },
        ),
        icon: !room.isArchived
            ? Icon(
                YaruIcons.log_out,
                color: yaru
                    ? context.colorScheme.error
                    : context.colorScheme.primary,
              )
            : const Icon(YaruIcons.log_in),
      ),
    );
  }
}
