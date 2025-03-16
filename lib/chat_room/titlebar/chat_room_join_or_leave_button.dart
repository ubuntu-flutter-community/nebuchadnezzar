import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../common/view/build_context_x.dart';
import '../../common/view/confirm.dart';
import '../../common/view/snackbars.dart';
import '../../common/view/theme.dart';
import '../../common/view/ui_constants.dart';
import '../../l10n/l10n.dart';
import '../../common/chat_model.dart';

class ChatRoomJoinOrLeaveButton extends StatelessWidget {
  const ChatRoomJoinOrLeaveButton({
    super.key,
    required this.room,
  });

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
        onPressed: notReJoinable
            ? null
            : () => showDialog(
                  context: context,
                  builder: (context) => ConfirmationDialog(
                    title: Text(message),
                    onConfirm: () {
                      void onFail(error) =>
                          showSnackBar(context, content: Text(error));

                      if (joinedRoom) {
                        chatModel.leaveSelectedRoom(
                          onFail: onFail,
                          forget: room.isDirectChat,
                        );
                      } else {
                        chatModel.joinRoom(
                          room,
                          onFail: onFail,
                          clear: true,
                          select: false,
                        );
                      }
                    },
                  ),
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
